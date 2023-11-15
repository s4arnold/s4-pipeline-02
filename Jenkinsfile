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
                scannerHome='/opt/sonar-scanner'
            }
            steps {
                withSonarQubeEnv('Sonar') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }

        stage('Hello') {
            steps {
                sh '''
                ls 
                pwd
                '''
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






    
