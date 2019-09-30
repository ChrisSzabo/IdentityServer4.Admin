pipeline {
  agent {
    docker {
      image 'registry.assertsecurity.io/dotnet-2.2-build'
    }
  }
  stages {
    stage('Build') {
      steps {
          withCredentials([string(credentialsId: 'identityserver4-endpoint-hostname', variable: 'ID4_HOSTNAME_SECRET')]){
              withEnv(['HOSTNAME_ENDPOINT=$env.ID4_HOSTNAME_SECRET']) {
                  sh'./build.sh'
              }
          }
      }
    }
  }
}