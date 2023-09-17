const modelAbstractTemplate = '''abstract class Model {
  ///constructs the model from a map with a json like structure
  factory Model.fromJson(Map<String, dynamic> json) {
    throw Error();
  }
  ///converts an object into a map with a json like structure
  Map<String, dynamic> toJson();
}''';
