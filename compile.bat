@echo off

call flutter pub get
call flutter build windows

iscc wininst.iss