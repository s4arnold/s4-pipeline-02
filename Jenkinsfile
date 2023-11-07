pipeline {
    agent any 

    
    stages {
        stage('SonarQube analysis') {
            agent {
                docker {
                  image 'sonarsource/sonarqube-scanner-cli:4.7.0'
                }
               }
               environment {
        CI = 'true'
        //  scannerHome = tool 'Sonar'
        scannerHome='/opt/sonar-scanner'
    }
            steps{
                withSonarQubeEnv('sonarqube') {
                    sh "${scannerHome}/bin/sonarqube-scanner"
                }
            }
        }

        
        stage('Build') {
            steps {
                sh 'ls' 
            }
        
        }
    }
}



    
