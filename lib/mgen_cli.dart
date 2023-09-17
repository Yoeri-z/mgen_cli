import 'dart:io';

import 'package:mgen_cli/src/templates/model_abstract.dart';
import 'package:yaml/yaml.dart';

import 'package:mgen_cli/src/generated_model.dart';

late final List<String> modelTypes;

Future<void> generate({String? yamlPath, String? modelFilePath}) async {
  //get the yaml file
  final yamlFile = (yamlPath != null) ? File(yamlPath) : File('./models.yaml');
  //create a new file in case it accidentally got deleted
  if (!await yamlFile.exists()) {
    await yamlFile.create(recursive: true);
    return;
  }

  final YamlMap yaml = loadYaml(await yamlFile.readAsString());
  if (yaml.isEmpty) {
    print('models.yaml is empty');
    return;
  }
  modelTypes = yaml.keys.cast<String>().toList();

  //get the path where the modelfile is to be created
  final modelFile =
      (modelFilePath != null) ? File(modelFilePath) : File('./lib/model.dart');

  //"refresh" the file (delete it and generate a new one)
  if (await modelFile.exists()) {
    await modelFile.delete();
  }
  //create  model file
  await modelFile.create(recursive: true);
  //create a stringbuffer to write the filecontents to
  final StringBuffer modelbuffer = StringBuffer();
  //write the abstract class
  modelbuffer.writeln(modelAbstractTemplate);

  //read the input file and process the YamlMap
  late final List<MapEntry> entryList;
  try {
    entryList = yaml.entries.toList();
  } catch (e) {
    print("Error: $e");
    print("Formatting issue occured in your yaml");
    throw Error();
  }

  //for loop to handle every Model in the yaml
  List<GeneratedModel> models = [];
  for (MapEntry mapEntry in entryList) {
    models.add(GeneratedModel(mapEntry, modelbuffer));
  }
  //generate each model
  for (GeneratedModel model in models) {
    model.generate(modelbuffer);
  }
  //write the buffer to the file
  modelFile.writeAsString(modelbuffer.toString());
}
