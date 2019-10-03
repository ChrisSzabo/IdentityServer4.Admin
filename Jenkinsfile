pipeline {
  parameters{
    string(name: 'DOCKER_REGISTRY', defaultValue: params.DOCKER_REGISTRY)
    string(name: 'SWARM_MANAGER_ADDR', defaultValue: params.SWARM_MANAGER_ADDR)
    string(name: 'ENDPOINT_HOSTNAME', defaultValue: params.ENDPOINT_HOSTNAME)
    string(name: 'DB_NODE_HOSTNAME',defaultValue:params.DB_NODE_HOSTNAME,description:"The swarm node's hostname where the database service will run. (must match node with label id4-db=true)")
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
        withDockerRegistry(credentialsId: 'b367c07a-2e58-49ab-ab4b-46c980764afe', url: "https://${params.DOCKER_REGISTRY}") {
          withCredentials([string(credentialsId: 'identityserver4-endpoint-hostname', variable: 'ID4_HOSTNAME_SECRET')]){
            withEnv(['HOSTNAME_ENDPOINT=$env.ID4_HOSTNAME_SECRET']) {
              //Bulid and publish
              sh './build.sh'
              //Take down the stack if its already there
              sh "docker -H ${SWARM_MANAGER_ADDR}--tlsverify stack down IdentityAdmin4"
              //Delete the data
              sh "docker -H ${SWARM_MANAGER_ADDR} --tlscacert=${TLS_CA} --tlscert=${TLS_CERT} --tlskey=${TLS_KEY} volume rm IdentityAdmin4_dbdata"              
              //Deploy stack
              sh "docker -H ${SWARM_MANAGER_ADDR}--tlsverify --tlscacert=${TLS_CA} --tlscert=${TLS_CERT} --tlskey=${TLS_KEY} stack deploy -c docker-compose.yml IdentityAdmin4 --with-registry-auth"
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