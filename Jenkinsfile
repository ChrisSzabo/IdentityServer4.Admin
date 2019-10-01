pipeline {
  agent {
    docker {
      image 'registry.assertsecurity.io/dotnet-2.2-build'
    }

  }
  stages {
    stage('Build') {
      steps {
        withDockerRegistry(credentialsId: 'b367c07a-2e58-49ab-ab4b-46c980764afe', url: 'https://registry.assertsecurity.io') {
          withCredentials([string(credentialsId: 'identityserver4-endpoint-hostname', variable: 'ID4_HOSTNAME_SECRET')]){
              withEnv(['HOSTNAME_ENDPOINT=$env.ID4_HOSTNAME_SECRET']) {
                  sh './build.sh'
              }
          }
        }
      }
    }
  }
  environment {
    DOCKER_REGISTRY = 'registry.assertsecurity.io/'
  }
}