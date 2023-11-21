pipeline {
    agent any

    stages {
        stage('SonarQube analysis') {
            agent {
                docker {
                  image 'sonarsource/sonar-scanner-cli:4.7.0'
                }
               }
               environment {
        CI = 'true'
        //  scannerHome = tool 'Sonar'
        // scannerHome='/opt/Sonar'
        }
        steps {
          script {
            def scannerHome = tool 'sonar-scanner'
            withSonarQubeEnv('Sonar') {
                sh "${scannerHome}/bin/sonar-scanner"
              }
           }
       }
    }

        stage('Build') {
            steps {
                sh ''' 
                ls
                pwd
                '''
            }
        }
    }
}







    
