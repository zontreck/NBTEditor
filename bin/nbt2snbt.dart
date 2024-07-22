import 'dart:io';

import 'package:libac_dart/argparse/Args.dart';
import 'package:libac_dart/argparse/Builder.dart';
import 'package:libac_dart/argparse/CLIHelper.dart';
import 'package:libac_dart/argparse/types/Bool.dart';
import 'package:libac_dart/argparse/types/String.dart';
import 'package:libac_dart/nbt/NbtIo.dart';
import 'package:libac_dart/nbt/SnbtIo.dart';
import 'package:libac_dart/nbt/impl/CompoundTag.dart';
import 'package:nbteditor/Consts2.dart';

const HEADER =
    "nbt2snbt\nCopyright Piccari Creations 2024 - Tara Piccari\nVersion: $VERSION\nPurpose: Converts Named Binary Tag files to a more readable Stringified version\n\n";
void main(List<String> args) async {
  Arguments usage = ArgumentsBuilder.builder()
      .withArgument(
          BoolArgument(name: "help", description: "Print this output"))
      .withArgument(StringArgument(
          name: "input", value: "%", description: "The input file to convert"))
      .withArgument(StringArgument(
          name: "out",
          value: "%",
          description:
              "The path to the output file. If not supplied, STDOUT is used."))
      .build();

  Arguments defaults = Arguments();
  Arguments vArgs = await CLIHelper.parseArgs(args, defaults);

  if (vArgs.hasArg("help") || vArgs.count == 0) {
    print(HEADER);
    print(CLIHelper.makeArgCLIHelp(usage));
  } else {
    if (!vArgs.hasArg("input")) {
      print(HEADER);
      print("Missing required argument: input");
      exit(1);
    }
    String file = vArgs.getArg("input")!.getValue() as String;

    CompoundTag ct = await NbtIo.read(file);

    if (!vArgs.hasArg("out")) {
      print(SnbtIo.writeToString(ct));
    } else {
      SnbtIo.writeToFile(vArgs.getArg("out")!.getValue() as String, ct);
      print("Wrote SNBT output to file");
    }
  }
}
