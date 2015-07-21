library force.transformer;

import 'package:barback/barback.dart';

import 'dart:async';
import 'dart:io';
import 'dart:mirrors' as mirrors;

import 'package:force/force_serverside.dart';
import 'package:barback/barback.dart';
import 'package:analyzer/analyzer.dart';
import 'package:analyzer/src/generated/ast.dart';
import 'package:analyzer/src/generated/error.dart';
import 'package:analyzer/src/generated/parser.dart';
import 'package:analyzer/src/generated/scanner.dart';
import 'package:source_maps/refactor.dart';
import 'package:source_span/source_span.dart' show SourceFile;

class AnnotationTransformer extends Transformer {
  final BarbackSettings _settings;

  AnnotationTransformer.asPlugin(this._settings);

  String get allowedExtensions => ".dart";

  Future apply(Transform transform) async {
      var id = transform.primaryInput.id;
      var url = id.path.startsWith('lib/')
      ? 'package:${id.package}/${id.path.substring(4)}'
      : id.path;

      return transform.primaryInput.readAsString().then((String content) {
        var compiler = new FileCompiler.fromString(id, content);
        var code = compiler.build(url);

        if (compiler.hasEdits) {
          transform.addOutput(new Asset.fromString(id, code));
        } else {
          transform.addOutput(transform.primaryInput);
        }
      });
  }
}

class FileCompiler {

  final CharSequenceReader reader;
  final Editor editor;

  Parser parser;
  Scanner scanner;
  CompilationUnit compilationUnit;

  bool _hasEdits;

  bool get hasEdits => _hasEdits;

  final List<ClassDeclaration> receivables = <ClassDeclaration>[];

  FileCompiler(String path)
  : this.fromString(path, new File(path).readAsStringSync());

  FileCompiler.fromString(String path, String code)
  : editor = new Editor(path, code),
  reader = new CharSequenceReader(code) {
    scanner = new Scanner(null, reader, this);
    parser = new Parser(null, this);

    compilationUnit = parser.parseCompilationUnit(scanner.tokenize());

    // _dartsonPrefix = findDartsonImportName();
    _findReceivables();
  }

  void _findReceivables() {
    receivables.addAll(compilationUnit.declarations
      .where((m) => m is ClassDeclaration &&
      m.metadata
      .any((n) =>
        n.name.name == "Receivable"
      ))
      // Erasing the type of the returned where iterable to allow checked-mode
      .map((cd) {
        return cd;
      }));

    if (receivables.length > 0) {
      _hasEdits = true;
    }
  }

  String build(String url) {
    print ( 'build this $url' );
    _addAllReceivables();

    var builder = editor.editor.commit();
    builder.build(url);
    return builder.text;
  }

  void _addAllReceivables() {
    //
    ForceClientName forceClientName =_findForceInstance();
    print( 'go and loop over all the receivables' );
    receivables.forEach((ClassDeclaration receivable) {
      print ( 'receivable ' + receivable.name.name );
      // print ( forceClientName.forceInstanceName );
        if (forceClientName!=null) {
            var classDef = _buildClassDefinition(receivable);
            var entityMap = _buildReceiverList(receivable);
            var registerMethods = _buildRegisterMethod(forceClientName.forceInstanceName, receivable.name.name.toLowerCase(), entityMap);

            Expression expression = forceClientName.expression, editPosition = expression.endToken.end + 1;
            if (!_expressionInMethod(expression)){
                expression = _findMainMethod();
                editPosition = expression.endToken.end -2;
            }
            // MethodDeclaration mainMethod = _findMainMethod();

            editor.editor.edit(editPosition, editPosition,
            '\n${classDef}\n${registerMethods}\n');
        }
    });
  }

  bool _expressionInMethod(Expression expression) {
    if (expression.parent is MethodDeclaration || expression.parent is FunctionDeclaration) {
      return true;
    } else if (expression.parent == null) {
      return false;
    } else {
      return _expressionInMethod(expression.parent);
    }
  }

  ForceClientName _findForceInstance() {
    ForceClientName forceName;
    for (var m in compilationUnit.declarations) {
      if (m is InstanceCreationExpression) {
        forceName = _findForceInstanceByExpression(m, forceName);
      } else {
        forceName = _findForceInstanceByChild(m, forceName);
      }
    }
    return forceName;
  }

  ForceClientName _findForceInstanceByChild(m, forceClientName) {
    for (var child in m.childEntities) {
      if (!(child is Token)) {
        if (child is InstanceCreationExpression) {
          forceClientName = _findForceInstanceByExpression(child, forceClientName);
        } else {
          forceClientName = _findForceInstanceByChild(child, forceClientName);
        }
      }
    }
    return forceClientName;
  }

  ForceClientName _findForceInstanceByExpression(InstanceCreationExpression ice, forceClientName) {
    if (ice.constructorName.toSource() == "ForceClient") {
      if (ice.parent is VariableDeclaration) {
        VariableDeclaration vd = ice.parent;

        forceClientName = new ForceClientName(vd.name.name, vd.parent);
      } else if (ice.parent is AssignmentExpression) {
        AssignmentExpression expression = ice.parent;

        if (expression.leftHandSide is SimpleIdentifier) {
          SimpleIdentifier si = expression.leftHandSide;

          forceClientName = new ForceClientName(si.name, expression.parent);
        } else {
          for ( var leftHandPart in expression.leftHandSide ) {
            if (leftHandPart is SimpleIdentifier) {
              SimpleIdentifier si = leftHandPart;

              forceClientName = new ForceClientName(si.name, expression.parent);
            } else {
              print("not a simpleIdentifier found!");
              print(leftHandPart);
            }
          };
        }
      }
    }
    return forceClientName;
  }

  FunctionDeclaration _findMainMethod() {
    List<FunctionDeclaration> methods = new List<FunctionDeclaration>();
    methods.addAll(compilationUnit.declarations
    .where((m) => m is FunctionDeclaration &&
      m.name.name == "main"
    )
    // Erasing the type of the returned where iterable to allow checked-mode
    .map((cd) {
      return cd;
    }));
    return methods[0];
  }

  String _buildClassDefinition(ClassDeclaration receivable) {
    String name = receivable.name.name, defName = name.toLowerCase();

    return '$name $defName = new $name();\n';
  }

  List<ForceOnProperty> _buildReceiverList(ClassDeclaration receivable) {
      List<ForceOnProperty> list = [];

      receivable.members.forEach((ClassMember member) {
        if (member is MethodDeclaration) {
          var request = "";
          MethodDeclaration md = member;
          for (var i=0;i<member.metadata.length;i++) {
            var metaData = member.metadata[i];

            if (metaData.name.name == "Receiver") {
              // metaData.childEntities
              ArgumentList argsList = metaData.arguments;
              for (var a=0;a<argsList.arguments.length;a++) {
                request = argsList.arguments[a].toString();
              }

              var methodName = md.name.name;

              list.add(new ForceOnProperty(request, methodName));
            }
          }
        }
      });

      return list;
  }

  String _buildRegisterMethod(String forceClientInstanceName, String defName, List<ForceOnProperty> fops) {
    List<String> list = [];
    for (ForceOnProperty fop in fops) {
      print( ' add ${fop.request}' );
      list.add("${forceClientInstanceName}.on(${fop.request}, ${defName}.${fop.methodName});");
    }
    return list.join("\n");
  }
}

class ForceClientName {

  String forceInstanceName;
  Expression expression;

  ForceClientName(this.forceInstanceName, this.expression);

}

class ForceOnProperty {

  String request;
  String methodName;

  ForceOnProperty(this.request, this.methodName);

}

class Editor {
  SourceFile sourceFile;
  TextEditTransaction editor;

  Editor(String path, String code) {
    sourceFile = new SourceFile(code, url: path);
    editor = new TextEditTransaction(code, sourceFile);
  }
}