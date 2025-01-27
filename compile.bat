@echo off

call flutter pub get
call flutter build windows

mkdir out

call dart compile exe -o out\nbteditor-cli.exe cli/nbtcli.dart

iscc wininst.iss