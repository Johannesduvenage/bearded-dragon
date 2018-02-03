pipeline {

  agent {
    docker "nimlang/nim:latest"
  }

  stages {

    stage("build") {
      steps {
        sh "make build"
      }
    }

  }
}
