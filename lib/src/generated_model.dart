import 'package:mgen_cli/src/templates/model.dart';
import 'package:yaml/yaml.dart';
import 'package:mgen_cli/mgen_cli.dart';

class GeneratedModel {
  ///the name of the class
  String className;

  ///the types inside the class
  final List<String> _typeList = [];

  ///the names of the fields
  final List<String> _names = [];

  ///create the pre-generated model
  GeneratedModel(MapEntry yamlEntry, StringBuffer imports)
      : className = yamlEntry.key {
    className = yamlEntry.key;
    final entries = _readYamlMap(yamlEntry.value);
    for (var entry in entries) {
      submit(entry.key, entry.value);
    }
  }

  ///submite a field with a [fieldName] and [type] to the model
  void submit(String fieldName, String type) {
    if (type.contains('?')) {
      print(
          'Warning: Nullable types are not allowed, please change the nullable type in your yaml file to something non-nullable, creating model without nullable type');
      return;
    }
    _typeList.add(type);
    _names.add(fieldName);
  }

  /// parse the string representing the variable for the data to [dataString], the String representing
  /// the type to [type] and the boolean defining wether it is from or to json to [toJson]
  String parseString(String dataString, String type, bool toJson) {
    if (modelTypes.contains(type)) {
      return (toJson)
          ? '$dataString.toJson(),'
          : '$type.fromJson($dataString),';
    } else if (type == 'DateTime') {
      return (toJson)
          ? '$dataString.toIso8601String(),'
          : 'DateTime.parse($dataString),';
    } else if (type.startsWith('List<')) {
      final subtype = type.substring(type.indexOf("<") + 1, type.length - 1);
      return (toJson)
          ? '$dataString.map((e) => ${parseString('e', subtype, toJson)}).toList(),'
          : '($dataString as List).map((e) => ${parseString('e', subtype, toJson)}).toList(),';
    } else if (type.startsWith('Map<')) {
      final mapTypes = type.substring(type.indexOf("<") + 1, type.length - 1);
      final index = mapTypes.indexOf(',');
      final mapTypeList = [
        mapTypes.substring(0, index),
        mapTypes.substring(index + 1)
      ];
      final keyType = mapTypeList[0].trim();
      final valueType = mapTypeList[1].trim();
      print(valueType);
      return (toJson)
          ? '$dataString.map((key, value) => MapEntry(${parseString('key', keyType, toJson)} ${parseString('value', valueType, toJson)})),'
          : '($dataString as Map).map((key, value) => MapEntry(${parseString('key', keyType, toJson)} ${parseString('value', valueType, toJson)})),';
    } else {
      return (toJson) ? '$dataString,' : '$dataString,';
    }
  }

  //get the values out of the yamlmap
  List<MapEntry> _readYamlMap(dynamic yaml) {
    try {
      return (yaml as YamlMap).entries.toList();
    } catch (e) {
      print("Error: $e");
      print("Formatting issue");
      throw Error();
    }
  }

  //write the base of the model
  String _base(String classTemplate, StringBuffer buffer) {
    for (int i = 0; i < _names.length; i++) {
      buffer.writeln('\tfinal ${_typeList[i]} ${_names[i]};');
    }
    classTemplate = classTemplate.replaceFirst('vars', buffer.toString());
    buffer.clear();
    for (String name in _names) {
      buffer.writeln('\t\trequired this.$name, ');
    }
    return classTemplate.replaceFirst('reqs', buffer.toString());
  }

  //write the tojson function of the model
  String _toJson(String classTemplate, StringBuffer buffer) {
    for (int i = 0; i < _names.length; i++) {
      buffer.writeln(
          '\t\t\t"${_names[i]}" : ${parseString(_names[i], _typeList[i], true)}');
    }
    return classTemplate.replaceFirst('tojson', buffer.toString());
  }

  String _copyWith(String classTemplate, StringBuffer buffer) {
    for (int i = 0; i < _names.length; i++) {
      buffer.writeln('\t\t\t${_typeList[i]}? ${_names[i]},');
    }
    classTemplate =
        classTemplate.replaceFirst('optionparams', buffer.toString());
    buffer.clear();
    for (int i = 0; i < _names.length; i++) {
      buffer.writeln('\t\t\t${_names[i]} : ${_names[i]} ?? this.${_names[i]},');
    }
    return classTemplate.replaceFirst('copywith', buffer.toString());
  }

  //write the fromJson function of the model
  String _fromJson(String classTemplate, StringBuffer buffer) {
    for (int i = 0; i < _names.length; i++) {
      buffer.writeln(
          '\t\t\t${_names[i]} : ${parseString('json["${_names[i]}"]', _typeList[i], false)}');
    }
    return classTemplate.replaceFirst('fromjson', buffer.toString());
  }

  ///convert the object to a file, the file will be created inside the function and is also returned
  void generate(StringBuffer modelbuffer) async {
    String classTemplate = modelTemplate;
    StringBuffer buffer = StringBuffer();
    classTemplate = classTemplate.replaceAll('class_name', className);
    classTemplate = _base(classTemplate, buffer);
    buffer.clear();
    classTemplate = _toJson(classTemplate, buffer);
    buffer.clear();
    classTemplate = _copyWith(classTemplate, buffer);
    buffer.clear();
    classTemplate = _fromJson(classTemplate, buffer);
    buffer.clear();
    modelbuffer.write(classTemplate);
  }
}
