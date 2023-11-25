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

        stage('Setup parameters') {
            steps {
                script {
                    properties([
                        parameters([
                            string(
                                name: 'WARNTIME',
                                defaultValue: '2',
                                description: '''Warning time (in minutes) before starting upgrade'''
                            ),
                            string(
                                defaultValue: 'develop',
                                name: 'Please_leave_this_section_as_it_is',
                                trim: true
                            ),
                        ])
                    ])
                }
            }
        }

        stage('warning') {
            steps {
                script { 
                    notifyUpgrade(currentBuild.currentResult, "WARNING")
                    sleep(time:env.WARNTIME, unit:"MINUTES") 
                }
            }
        }            



        
        
        
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

        stage('Update charts') {
            steps {
                sh '''

    git clone git@github.com:s4arnold/s4arnold-projects-charts.git
    cd s4arnold-projects-charts
    
    cat << EOF > charts/weatherapp-auth/dev-values.yaml
    image:
      repository: s4arnold/s4-pipepine-02-auth
      tag: "${BUILD_NUMBER}"
    EOF
    
    cat << EOF > charts/weatherapp-mysql/dev-values.yaml
    image:
      repository: s4arnold/s4-pipepine-02-db
      tag: "${BUILD_NUMBER}"
    EOF 
    
    cat << EOF > charts/weatherapp-ui/dev-values.yaml
    image:
      repository: s4arnold/s4-pipepine-02-ui
      tag: "${BUILD_NUMBER}"
    EOF
    
    cat << EOF > charts/weatherapp-weather/dev-values.yaml
    image:
      repository: s4arnold/s4-pipepine-02-weather
      tag: "${BUILD_NUMBER}"
    EOF
    
    git config --global user.name "s4arnold"
    git config --global user.email "tchuamarnold211@gmail.com"
    
    git add -A
    git commit -m "change jenkins CI"
    git push
                 
                '''
            }
        }
    }
}
    post {
        always {
          script {
            notifyUpgrade(currentBuild.currentResult, "POST")
          }
        }
}


def notifyUpgrade(String buildResult, String whereAt) {
  if (Please_leave_this_section_as_it_is == 'origin/production') {
    channel = ''
  } else {
    channel = ''
  }
  if (buildResult == "SUCCESS") {
    switch(whereAt) {
    case 'WARNING':
        slackSend(channel: channel,
                color: "#439FE0",
                message: "weather-app: Upgrade starting in ${env.WARNTIME} minutes @ ${env.BUILD_URL}  Application s4arnold-weather-app")
        break
    case 'STARTING':
        slackSend(channel: channel,
                color: "good",
                message: "weather-app: Starting upgrade @ ${env.BUILD_URL} Application s4arnold-weather-app")
        break
    default:
        slackSend(channel: channel,
                color: "good",
                message: "weather-app: Upgrade completed successfully @ ${env.BUILD_URL}  Application s4arnold-weather-app")
        break
    }
  } else {
        slackSend(channel: channel,
                color: "danger",
                message: "weather-app: Upgrade was not successful. Please investigate it immediately.  @ ${env.BUILD_URL}  Application s4arnold-weather-app")
  }
}





    
