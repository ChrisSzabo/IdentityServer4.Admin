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
  agent none
  stages {
    stage('Build') {
      agent {
        docker {
          image 'registry.assertsecurity.io/dotnet-2.2-build'
        }
      }

      steps {
        withDockerRegistry(credentialsId: 'b367c07a-2e58-49ab-ab4b-46c980764afe', url: "https://${params.DOCKER_REGISTRY}") {
          withCredentials([string(credentialsId: 'identityserver4-endpoint-hostname', variable: 'ID4_HOSTNAME_SECRET')]){
            withEnv(['HOSTNAME_ENDPOINT=$env.ID4_HOSTNAME_SECRET']) {
              //Bulid and publish to registry
              sh './build.sh'
            }
          }
        }
      }
    }
    stage('Deploy'){
      agent {
        docker {
          image 'registry.assertsecurity.io/whitesnake'
        }
      }
      steps{
        withDockerRegistry(credentialsId: 'b367c07a-2e58-49ab-ab4b-46c980764afe', url: "https://${params.DOCKER_REGISTRY}") {
          //Take down the stack if it's already there
          sh "docker -H ${SWARM_MANAGER_ADDR} --tlsverify --tlscacert=${TLS_CA} --tlscert=${TLS_CERT} --tlskey=${TLS_KEY} stack down Identity4Admin"
          //Delete the volume holding the database
          sh "python /app/whitesnake/scan.py deletevolume --host ${DB_NODE_HOSTNAME} --tlsverify --stackname Identity4Admin --volume dbdata --tls-folder /home/.docker"
          //deploy the application
          sh "python /app/whitesnake/scan.py deploy --host ${SWARM_MANAGER_ADDR} --tlsverify --stackname Identity4Admin --compose-file docker-compose.yml --env  ENDPOINT_HOSTNAME ${ENDPOINT_HOSTNAME} --env ADMIN_UI_PORT ${ADMIN_UI_PORT} --env API_PORT ${API_PORT} --env STS_PORT ${STS_PORT} --env DOCKER_REGISTRY ${DOCKER_REGISTRY} --env DB_NODE_HOSTNAME ${DB_NODE_HOSTNAME} --tls-folder /home/.docker" 
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