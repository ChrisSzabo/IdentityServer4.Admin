Task Build `
{
    exec{
        docker-compose build
    }
    
    exec{
        docker-compose push
    }

}

Task Default -Depends BUILD