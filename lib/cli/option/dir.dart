import 'dart:io';

import 'package:args/args.dart' show ArgResults;
import 'package:sign/cli/extension.dart';
import 'package:sign/cli/option.dart';

class DirOption extends Option {
  static const _name = 'dir';

  DirOption()
      : super(
          _name,
          abbr: 'd',
          help: 'set the directory where `dart analyze` will be run',
          mandatory: true,
        );

  static Directory dir(
    ArgResults argResults,
    Never Function(String message) usageException,
  ) {
    final path = argResults.requireParam<String>(_name);
    final dir = Directory(path);
    if (!dir.existsSync()) {
      usageException('Not found directory: $path');
    }
    return dir;
  }
}