pipeline {
  parameters{
    string(name: 'DOCKER_REGISTRY', defaultValue: params.DOCKER_REGISTRY)
    string(name: 'SWARM_MANAGER_ADDR', defaultValue: params.SWARM_MANAGER_ADDR)
    string(name: 'ENDPOINT_HOSTNAME', defaultValue: params.ENDPOINT_HOSTNAME)
    string(name: 'ADMIN_UI_PORT', defaultValue: params.ADMIN_UI_PORT ?: '9009' )
    string(name: 'STS_PORT', defaultValue: params.STS_PORT ?: '9011' )
    string(name: 'API_PORT',defaultValue: params.API_PORT ?: '9012')    
  }
  agent {
    docker {
      image 'registry.assertsecurity.io/dotnet-2.2-build'
    }
  }
  stages {
    stage('Build') {
      steps {
        withDockerRegistry(credentialsId: 'b367c07a-2e58-49ab-ab4b-46c980764afe', url: 'https://${env.DOCKER_REGISTRY}') {
          withCredentials([string(credentialsId: 'identityserver4-endpoint-hostname', variable: 'ID4_HOSTNAME_SECRET')]){
            withEnv(['HOSTNAME_ENDPOINT=$env.ID4_HOSTNAME_SECRET']) {
              sh './build.sh'
              sh "docker -H tcp://${SWARM_MANAGER_ADDR}:2376 --tlsverify --tlscacert=${TLS_CA} --tlscert=${TLS_CERT} --tlskey=${TLS_KEY} stack deploy -c docker-compose.yml IdentityAdmin4 --with-registry-auth"
            }
          }
        }
      }
    }
  }
  environment {
    /*These should be volume mounted into the build agents*/
    TLS_CA = '/home/.docker/ca.pem'
    TLS_CERT = '/home/.docker/cert.pem'
    TLS_KEY = '/home/.docker/key.pem'
  }
}