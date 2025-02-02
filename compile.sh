#!/bin/bash

flutter build linux
flutter build apk
flutter build web

if [ ! -d out ]
then
    mkdir out
fi

dart compile exe -o out/nbteditor-cli cli/nbtcli.dart
