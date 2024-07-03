#!/bin/bash

flutter build linux
dart compile exe -o out/nbt2snbt bin/nbt2snbt.dart

rm out/*.snbt
rm out/*.nbt