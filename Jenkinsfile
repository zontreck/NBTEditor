pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    stages {
        stage("Build on Linux") {
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

                    rm out/.placeholder

                    cd build/linux/x64/release/bundle
                    tar -cvf ../../../../../linux.tgz ./
                    cd ../../../../app/outputs/flutter-apk
                    cp app-release.apk ../../../../

                    cd ../../../../
                    appimage-builder --recipe AppImageBuilder.yml
                    '''
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: '*.tgz', fingerprint: true
                    archiveArtifacts artifacts: '*.apk', fingerprint: true
                    archiveArtifacts artifacts: 'out/*', fingerprint: true
                    archiveArtifacts artifacts: '*.AppImage', fingerprint: true

                    deleteDir()
                }
            }
        }

        stage('Build on Windows') {
            agent {
                label 'windows'
            }
            steps {
                script {
                    bat 'del out\\.placeholder'
                    bat 'flutter pub get'
                    bat 'flutter build windows'

                    bat 'dart compile exe -o out\\snbt2nbt.exe bin\\snbt2nbt.dart'
                    bat 'dart compile exe -o out\\nbt2snbt.exe bin\\nbt2snbt.dart'

                    dir("build\\windows\\x64\\runner\\Release") {
                        bat 'tar -cvf ..\\..\\..\\..\\..\\windows.tgz .'
                    }

                    bat 'iscc wininst.iss'
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'out\\*', fingerprint: true
                    archiveArtifacts artifacts: '*.tgz', fingerprint: true

                    deleteDir()
                }
            }
        }
    }
}
