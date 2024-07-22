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
    "snbt2nbt\nCopyright Piccari Creations 2024 - Tara Piccari\nVersion: $VERSION\nPurpose: Converts the more readable stringified NBT to Named Binary Tag format\n\n";
void main(List<String> args) async {
  Arguments usage = ArgumentsBuilder.builder()
      .withArgument(
          BoolArgument(name: "help", description: "Print this output"))
      .withArgument(StringArgument(
          name: "input", value: "%", description: "The input file to convert"))
      .withArgument(StringArgument(
          name: "out", value: "%", description: "The path to the output file."))
      .withArgument(BoolArgument(
          name: "compress",
          description: "If supplied, compresses the output file"))
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

    CompoundTag ct = await SnbtIo.readFromFile(file) as CompoundTag;

    if (!vArgs.hasArg("out")) {
      print("Missing required argument: out");
      exit(2);
    } else {
      if (!vArgs.hasArg("compress")) {
        NbtIo.write(vArgs.getArg("out")!.getValue() as String, ct);
      } else {
        NbtIo.writeCompressed(vArgs.getArg("out")!.getValue() as String, ct);
      }
      print("Wrote NBT output to file");
    }
  }
}
