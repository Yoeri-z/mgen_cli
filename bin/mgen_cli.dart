import 'package:mgen_cli/mgen_cli.dart' as model_generator;

extension Index<T> on List<T> {
  int indexFirstWhere(bool Function(T e) test) {
    for (int i = 0; i < length; i++) {
      if (test(this[i])) {
        return i;
      }
    }
    return -1;
  }
}

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print("Usage: mgen generate [-y yaml_path] [-m model_path]");
    return;
  }
  if (arguments.first == 'generate') {
    String? pathY;
    String? pathM;
    if (!(arguments.length == 1)) {
      int indexY = arguments.indexFirstWhere((e) => e.toLowerCase() == '-y');
      int indexM = arguments.indexFirstWhere((e) => e.toLowerCase() == '-m');
      if (indexY >= 1 &&
          (indexY < arguments.length - 1 ||
              !arguments[indexY + 1].startsWith('-'))) {
        pathY = arguments[indexY + 1];
      } else if (indexY >= 1) {
        print("Please specify the path after -y");
      }

      if (indexM >= 1 &&
          (indexM < arguments.length - 1 ||
              !arguments[indexM + 1].startsWith('-'))) {
        pathM = arguments[indexM + 1];
      } else if (indexM >= 1) {
        print("Please specify the path after -m");
      }
    }
    model_generator.generate(yamlPath: pathY, modelFilePath: pathM);
  } else {
    print("Invalid command. Use 'generate' to create models.");
  }
}
