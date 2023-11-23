pipeline {
    agent any
    options {
    buildDiscarder(logRotator(numToKeepStr: '20'))
    disableConcurrentBuilds()
    timeout (time: 60, unit: 'MINUTES')
    timestamps()
  }

    environment {
		DOCKERHUB_CREDENTIALS=credentials('Dockerhub-creds')
	}
    
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
        scannerHome='/opt/sonar-scanner'
    }
            steps{
                withSonarQubeEnv('Sonar') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }

        stage("Quality Gate") {
            steps {
              timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Dockerhub Login') {
	    	steps {
                script {
	    		    sh '''
                        echo "${DOCKERHUB_CREDENTIALS_PSW}" | docker login -u "${DOCKERHUB_CREDENTIALS_USR}" --password-stdin
                    '''
                }
	    	}
	    }

        stage('Build auth') {
            steps {
                sh '''
                   cd auth
                   docker build -t s4arnold/s4-pipepine-02-auth:${BUILD_NUMBER} .
                   cd -
                '''
            }
        }

        stage('push auth') {
            steps {
                sh '''
                   docker push s4arnold/s4-pipepine-02-auth:${BUILD_NUMBER}
                '''
            }
        }

        stage('Build DB') {
            steps {
                sh '''
                   cd DB
                   docker build -t s4arnold/s4-pipepine-02-DB:${BUILD_NUMBER} .
                   cd -
                '''
            }
        }

        stage('push DB') {
            steps {
                sh '''
                   docker push s4arnold/s4-pipepine-02-DB:${BUILD_NUMBER}
                '''
            }
        }

        stage('Build UI') {
            steps {
                sh '''
                   cd DB
                   docker build -t s4arnold/s4-pipepine-02-UI:${BUILD_NUMBER} .
                   cd -
                '''
            }
        }

        stage('push UI') {
            steps {
                sh '''
                   docker push s4arnold/s4-pipepine-02-ui:${BUILD_NUMBER}
                '''
            }
        }

        stage('Build weather') {
            steps {
                sh '''
                   cd weather
                   docker build -t s4arnold/s4-pipepine-02-weather:${BUILD_NUMBER} .
                   cd -
                '''
            }
        }

        stage('push weather') {
            steps {
                sh '''
                   docker push s4arnold/s4-pipepine-02-weather:${BUILD_NUMBER}
                   
                '''
            }
        }
    }
}







    
