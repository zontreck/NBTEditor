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
                    // Ensure that all necessary directories exist before operations
                    sh 'flutter pub get'
                    sh 'chmod +x compile.sh'
                    sh './compile.sh'

                    // Move to the correct directories and archive artifacts
                    dir('build/linux/x64/release/bundle') {
                        archiveArtifacts artifacts: '*.tgz', fingerprint: true
                    }
                    dir('build/app/outputs/flutter-apk') {
                        archiveArtifacts artifacts: '*.apk', fingerprint: true
                    }
                    archiveArtifacts artifacts: 'out/*nb*', fingerprint: true
                }
            }
            post {
                always {
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
                    bat '''
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
