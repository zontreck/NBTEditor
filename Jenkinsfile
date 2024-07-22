pipeline {
    agent any

    options {
        buildDiscarder(
            logRotator(
                numToKeepStr: '5'
            )
        )
    }

    stages {
        stage ("Build on Linux") {
            agent {
                label 'linux'
            }
            steps {

                script {
                    sh '''
                    #!/bin/bash

                    flutter pub get
                    chmod +x compile.sh
                    ./compile.sh

                    cd build/linux/x64/release/bundle
                    tar -cvf ../../../../../linux.tgz ./
                    cd ../../../../app/outputs/flutter-apk
                    cp app-release.apk ../../../../
                    '''
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: '*.tgz', fingerprint: true
                    archiveArtifacts artifacts: '*.apk', fingerprint: true
                    archiveArtifacts artifacts: 'out/*nb*', fingerprint: true

                    deleteDir()
                }
            }
        }
        stage ('Build on Windows') {
            agent {
                label 'windows'
            }
            steps {
                script {
                    bat '''
                    @echo off

                    flutter build windows
                    dart compile exe -o out/snbt2nbt.exe bin/snbt2nbt.dart
                    dart compile exe -o out/nbt2snbt.exe bin/nbt2snbt.dart

                    cd build/windows/x64/release/bundle
                    tar -cvf ../../../../bundle/windows.tgz .
                    '''
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'out/*.exe', fingerprint: true
                    archiveArtifacts artifacts: '*.tgz', fingerprint: true
                }
            }
        }
    }
}