abstract class Model {
  ///constructs the model from a map with a json like structure
  factory Model.fromJson(Map<String, dynamic> json) {
    throw Error();
  }

  ///converts an object into a map with a json like structure
  Map<String, dynamic> toJson();
}

class User implements Model {
  final String email;
  final String username;
  final int age;

  const User({
    required this.email,
    required this.username,
    required this.age,
  });

  ///Transforms your model into a Map with a json like structure.
  @override
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "username": username,
      "age": age,
    };
  }

  ///Creates a model from a map that has a json like structure.
  @override
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json["email"],
      username: json["username"],
      age: json["age"],
    );
  }
}

extension CopyWith on User {
  User copyWith({String? newEmail, String? newusername, int? newage}) {
    return User(
        email: newEmail ?? email,
        username: newusername ?? username,
        age: newage ?? age);
  }
}
