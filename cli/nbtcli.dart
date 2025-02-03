import 'package:libac_dart/argparse/Args.dart';
import 'package:libac_dart/argparse/Builder.dart';
import 'package:libac_dart/argparse/CLIHelper.dart';
import 'package:libac_dart/argparse/Parser.dart';
import 'package:libac_dart/argparse/types/Bool.dart';
import 'package:libac_dart/argparse/types/String.dart';
import 'package:nbteditor/Consts2.dart';

Future<int> main(List<String> args) async {
  Arguments parsed = ArgumentParser.parse(args);

  if (parsed.hasArg("help") || parsed.count == 0) {
    // Print help information
    print(
        "NBT Editor Command Line Interface\nCopyright 2025 Piccari Creations\nLicensed under the GPL\nVersion: $VERSION\n\n");

    var defaults = ArgumentsBuilder.builder()
        .withArgument(BoolArgument(name: "help", value: null))
        .withArgument(StringArgument(name: "path", value: "/"))
        .withArgument(StringArgument(name: "value", value: null))
        .withArgument(BoolArgument(name: "add", value: null))
        .withArgument(BoolArgument(name: "remove", value: null))
        .withArgument(BoolArgument(name: "update", value: null))
        .withArgument(BoolArgument(name: "dryrun", value: null))
        .build();

    print(ArgumentHelpers.generateHelpMessage(
        defaults.getArgumentsList(), "nbteditor-cli"));
    return 0;
  }

  return 0;
}
