pipeline {
  parameters{
    string(name: 'DOCKER_REGISTRY')
    string(name: 'SWARM_MANAGER_ADDR')
    string(name: 'ENDPOINT_HOSTNAME')
    string(name: 'SWARM_MANAGER_ADDR')
    string(name: 'ADMIN_UI_PORT', defaultValue: '9009' )
    string(name: 'STS_PORT', defaultValue: '9011' )
  }
  agent {
    docker {
      image 'registry.assertsecurity.io/dotnet-2.2-build'
    }
  }
  stages {
    stage('Build') {
      steps {
        withDockerRegistry(credentialsId: 'b367c07a-2e58-49ab-ab4b-46c980764afe', url: 'https://${params.DOCKER_REGISTRY}') {
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
    DOCKER_REGISTRY = '${params.DOCKER_REGISTRY}'
    SWARM_MANAGER_ADDR = '${params.SWARM_MANAGER_NODE}'
    ENDPOINT_HOSTNAME='${params.ENDPOINT_HOSTNAME}'
    ADMIN_UI_PORT='${params.ADMIN_UI_PORT}'
    API_PORT='${params.API_PORT}'
    STS_PORT='${params.STS_PORT}'

    TLS_CA = '/home/.docker/ca.pem'
    TLS_CERT = '/home/.docker/cert.pem'
    TLS_KEY = '/home/.docker/key.pem'
  }
}