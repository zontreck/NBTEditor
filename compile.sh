#!/bin/bash

flutter build linux
flutter build apk
dart compile exe -o out/nbt2snbt bin/nbt2snbt.dart
dart compile exe -o out/snbt2nbt bin/snbt2nbt.dart