pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    stages {
        stage("Build on Linux") {
            agent {
                label 'flutter'
            }
            steps {
                script {
                    sh '''
                    #!/bin/bash
                    cat /key.properties >android/key.properties

                    flutter doctor
                    flutter pub get
                    chmod +x compile.sh
                    ./compile.sh

                    rm out/.placeholder

                    cd build/linux/x64/release/bundle
                    tar -cvf ../../../../../linux.tgz ./
                    cd ../../../../app/outputs/flutter-apk
                    cp app-release.apk ../../../../

                    cd ../../../../

                    cd build/web
                    tar -cvf ../../web.tgz .
                    cd ../..

                    #appimage-builder --recipe AppImageBuilder.yml

                    #appimagetool AppDir/*.desktop -u "zsync|https://ci.zontreck.com/job/Projects/job/Dart/job/NBTEditor/job/main/lastSuccessfulBuild/artifact/NBT%20Editor-latest-x86_64.AppImage.zsync"

                    mv out/nbteditor-cli nbteditor-cli-linux-x64
                    '''
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: '*.tgz', fingerprint: true
                    archiveArtifacts artifacts: '*.apk', fingerprint: true
                    archiveArtifacts artifacts: "nbteditor-cli-linux-x64", fingerprint: true
                    //archiveArtifacts artifacts: '*.AppImage', fingerprint: true
                    //archiveArtifacts artifacts: '*.zsync', fingerprint: true

                    cleanWs()
                }
            }
        }
        stage("Build on Windows") {
            agent {
                label "windows"
            }
            steps {
                script {
                    bat 'del out\\.placeholder'
                    bat 'flutter pub get'
                    bat 'flutter build windows'
                    dir("build\\windows\\x64\\runner\\Release") {
                        bat 'tar -cvf ..\\..\\..\\..\\..\\windows.tgz .'
                    }
                    bat 'dart compile exe -o out\\nbteditor-cli.exe cli\\nbtcli.dart'
                    bat 'iscc wininst.iss'

                }
            }

            post {
                always {
                    archiveArtifacts artifacts: "windows.tgz"
                    archiveArtifacts artifacts: "out\\NBTEditor-setup.exe"
                    archiveArtifacts artifacts: "out\\nbteditor-cli.exe"

                    cleanWs()
                }
            }
        }
    }
}
