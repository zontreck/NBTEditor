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

                    # appimage-builder --recipe AppImageBuilder.yml

                    #appimagetool AppDir/*.desktop -u "zsync|https://ci.zontreck.com/job/Projects/job/Dart/job/NBTEditor/job/main/lastSuccessfulBuild/artifact/NBT%20Editor-latest-x86_64.AppImage.zsync"
                    '''
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: '*.tgz', fingerprint: true
                    archiveArtifacts artifacts: '*.apk', fingerprint: true
                    //archiveArtifacts artifacts: '*.AppImage', fingerprint: true
                    //archiveArtifacts artifacts: '*.zsync', fingerprint: true

                    cleanWs()
                }
            }
        }

    }
}
