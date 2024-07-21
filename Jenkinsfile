pipeline {
    agent {
        label 'linux'
    }
    options {
        buildDiscarder(
            logRotator(
                numToKeepStr: '5'
            )
        )
    }

    stages {
        stage ("Build") {
            steps {

                script {
                    sh '''
                    #!/bin/bash

                    flutter pub get
                    flutter build linux
                    flutter build apk
                    '''
                }
            }
        }
        stage ('Package') {
            steps {
                script {
                    sh '''
                    #!/bin/bash

                    cd build/linux/x64/release/bundle
                    tar -cvf ../../../../../linux.tgz ./
                    cd ../../../../app/outputs/flutter-apk
                    cp app-release.apk ../../../../
                    '''
                }

            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '*.tgz', fingerprint: true
            archiveArtifacts artifacts: '*.apk', fingerprint: true
            deleteDir()
        }
    }
}