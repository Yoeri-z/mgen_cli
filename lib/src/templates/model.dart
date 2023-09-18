const modelTemplate = '''
class class_name implements Model<class_name> {
vars

  const class_name({
reqs
  });

  ///Transforms your model into a Map with a json like structure.
  @override
  Map<String, dynamic> toJson() {
    return {
tojson
    };
  }
  ///copy the object with altered fields, the fields entered into this function will be the ones altered
  @override
  class_name copyWith({
optionparams
    }){
    return class_name(
copywith
    );
  }
  ///Creates a model from a map that has a json like structure.
  factory class_name.fromJson(Map<String, dynamic> json) {
    return class_name(
fromjson
    );
  }
}''';
