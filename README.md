# Mgen_cli
## introduction
mgen (model generator) is an easy to use command line tool that helps with making serializable models.
Define your models in a yaml file and in one command it will generate the models for you
## usage
This is how you can set up you project:
- run ```dart pub global activate mgen_cli``` in the terminal.
- add a file named models.yaml to your project root folder and specify your models (see [defining models](#defining-models)).
- open a terminal in your project's root folder and run ```mgen generate ```.

Optionally you can use the ```-m``` flag to define an exact file in which to write the models and the ```-y``` flag to define the location of the yaml file:
- ```mgen generate [-m path/to/file/file.dart] [-y path/to/yaml/file.yaml]```

the default directory for models.yaml is the root directory, the default directory for the model.dart file is the lib directory

## defining-models
You can define a model like this
```yaml
Person:
  name: String
  age: int
```

You can give fields these types: bool, double, int, String and DateTime, aswell as Lists or maps of these types.
You can also give other models as types:
```yaml
Person:
  name: String
  age: int
  livesAt: Location
  friends: List<Person>

Location:
  hourseNr: int
  street: String
  city: String
```
If there are any errors inside the model file this is most likely because you submitted a type that is not allowed. Support to add custom types will come in the future.

## the models
All generated models will have the following features
- They are immutable take a look at [this medium article](https://medium.flutterdevs.com/explore-immutable-data-structures-in-dart-flutter-86c350b7d014) if you want to learn more about immutability
- They have a default constructor.
- They have a ```Model.fromJson(json)``` constructor which takes a serialized Map (I.E  ```Map<String, dynamic>```) and tries to parse it into the specified Model
- They have a ```toJson()``` method, which converts the object into a serialized Map
- They have a ```copyWith()``` method, which takes any of the object fields and copies it with those fields altered. This function is especially usefull because the models are immutable

Here is an example demonstrating these features:

models.yaml:
```yaml
Person:
  name: String
  age: int
  livesAt: Location
  friends: List<Person>

Location:
  hourseNr: int
  street: String
  city: String
```
main.dart:
```dart
import 'package:my_project/model.dart';

void main() {
  //define the location of ernie
  //note that it can be constant because of the immutability of Location
  const locationErnie =
      Location(hourseNr: 1, street: "Sesame Street", city: "Sesame City");
  //define the location of bert
  const locationBert =
      Location(hourseNr: 2, street: "Sesame Street", city: "Sesame City");

  //define the person Ernie
  const ernie =
      Person(name: "Ernie", age: 29, livesAt: locationErnie, friends: []);
  //define the person bert
  const bert =
      Person(name: "Bert", age: 34, livesAt: locationBert, friends: []);

  //If we want to alter the friends of ernie we can do it like this.
  final ernieWithFriends = ernie.copyWith(friends: [bert]);

  //we can convert the object into a json
  final json = ernieWithFriends.toJson();

  print(json);
  //This prints the following
  /*
      {
        name: Ernie, 
        age: 29, 
        livesAt: {
          hourseNr: 1, 
          street: Sesame Street, 
          city: Sesame City
          }, 
        friends: 
          [
            {
              name: Bert, 
              age: 34, 
              livesAt: 
                {
                  hourseNr: 2, 
                  street: Sesame Street, 
                  city: Sesame City
                } 
              friends: 
                []
            }
          ]
      }
  */

  //we can construct persons from serialized maps, 
  //if the json is correct this will not cause any errors
  //(in this script it is obviously correct 
  //but in more complex situations this might be harder to ensure)
  final ernieReconstructed = Person.fromJson(json);
  print(ernieReconstructed.name);
  //this will print: "Ernie"
}
```

If you want to add more functionality to the models you can do it like this:
```dart
extension ShowFriends on Person{
  ///print all the friends names to the console
  void showFriends(){
    for(Person friend in friends){
      print(friend.name);
    }
  }
}
```

You can take a look at the generated model file and see how the models are written for a better understanding of how they work.

The sourcecode for this package can be found on [the mgen_cli github page](https://github.com/Yoeri-z/mgen_cli)