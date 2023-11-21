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
            scannerHome='/opt/sonarqube'
        }
            steps {
                withSonarQubeEnv('Sonar') {
                    sh "${scannerHome}/bin/Sonarqube"
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







    
