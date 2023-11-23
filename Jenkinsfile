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
                   docker build -t s4arnold/s4-pipepine-02-db:${BUILD_NUMBER} .
                   cd -
                '''
            }
        }

        stage('push DB') {
            steps {
                sh '''
                   docker push s4arnold/s4-pipepine-02-db:${BUILD_NUMBER}
                '''
            }
        }

        stage('Build UI') {
            steps {
                sh '''
                   cd UI
                   docker build -t s4arnold/s4-pipepine-02-ui:${BUILD_NUMBER} .
                   cd -
                '''
            }
        }

        stage('push UI') {
            steps {
                sh '''
                   docker push s4arnold/s4-pipepine-02-ui:${BUILD_NUMBER}
                   ls
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

    post {
        success {
            slackSend (channel: '#random', color: 'good', message: "SUCCESSFUL: Application S4-PIPELINE-02  Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
           }
   
    
        unstable {
            slackSend (channel: '#random', color: 'warning', message: "UNSTABLE: Application S4-PIPELINE-02  Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
           }
   
        failure {
            slackSend (channel: '#random', color: '#FF0000', message: "FAILURE: Application S4-PIPELINE-02 Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
           }
          
        cleanup {
            deleteDir()
        }
    }
}






    
