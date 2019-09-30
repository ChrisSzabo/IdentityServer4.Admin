pipeline {
  agent {
    docker {
      image 'registry.assertsecurity.io/dotnet-2.2-build'
    }

  }
  stages {
    stage('Build') {
      steps {
        sh 'docker-compose build'
      }
    }
  }
}