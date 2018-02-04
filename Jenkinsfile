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

    stage("start") {
      steps {
        sh "make up"
      }
    }

    stage("compile") {
      steps {
        sh "make compile"
      }
    }

  }
}
