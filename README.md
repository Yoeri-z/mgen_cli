# Model_generator
## introduction
model generator is an easy to use command line tool that helps with making serializable models.
Define your models in a yaml file and in one command it will generate the models for you
## usage
This is how you can set up you project:
- run ```dart pub global activate mgen_cli``` in the terminal.
- add a model.yaml file to your project root folder and specify your models (see [defining models](#defining-models)).
- open a terminal in your project's root folder and run ```mgen generate ```.

Optionally you can use the ```-m``` flag to define an exact file in which to write the models and the ```-y``` flag to define the yaml file location:
- ```mgen generate -m path/to/file/file.dart```
- ```mgen generate -y path/to/yaml/file.yaml```
- ```mgen generate -m path/to/file/file.dart -y path/to/yaml/file.yaml```

## defining-models
to define a model, give the model name and give it some fields. This is done in a yaml file like this:
```yaml
User:
  email: String
  username: String
  age: Int
```

You can give fields these types: bool, double, int, String and DateTime, aswell as Lists or maps of these types.
You can also give other models as types:
```yaml
User:
  email: String
  username: String
  age: int
  livesAt: Location
Location:
  hourseNr: int
  street: String
  city: String
```
If there are any errors inside the modelfile this is most likely because you defined a not allowed type.