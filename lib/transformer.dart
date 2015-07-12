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
    print( 'go and loop over all the receivables' );
    receivables.forEach((ClassDeclaration receivable) {
      print ( 'receivable ' + receivable.name.name );
      var classDef = _buildClassDefinition(receivable);
      var entityMap = _buildReceiverList(receivable);
      var registerMethods = _buildRegisterMethod(receivable.name.name.toLowerCase(), entityMap);

      MethodDeclaration mainMethod = _findMainMethod();

      editor.editor.edit(mainMethod.endToken.end - 1, mainMethod.endToken.end - 1,
      '${classDef}\n${registerMethods}\n');
    });
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
            print (metaData);
            if (metaData.name.name == "Receiver") {
              // metaData.childEntities
              ArgumentList argsList = metaData.arguments;
              for (var a=0;a<argsList.arguments.length;a++) {
                print(argsList.arguments[a].toString());

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

  String _buildRegisterMethod(String defName, List<ForceOnProperty> fops) {
    List<String> list = [];
    for (ForceOnProperty fop in fops) {
      print( ' add to a list ' );
      list.add("registerReceiver(${fop.request}, ${defName}.${fop.methodName});");
    }
    return list.join("\n");
  }
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