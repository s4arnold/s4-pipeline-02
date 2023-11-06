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
                scannerHome = '/opt/sonar-scanner'
            }
            steps {
                withSonarQubeEnv('Sonar') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
        
       stage('Build') {
            steps {
                sh '''
                touch file
                ls
                ls -l 
                '''
            }
        }
    }
}

    
