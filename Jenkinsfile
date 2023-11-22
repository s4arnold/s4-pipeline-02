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

        stage('Build') {
            steps {
                sh '''
                ls 
                pwd
                ls -l
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
    channel = 'random'
  } else {
    channel = 'random'
  }
  if (buildResult == "SUCCESS") {
    switch(whereAt) {
      case 'WARNING':
        slackSend(channel: channel,
                color: "#439FE0",
                message: "S4-weather: Upgrade starting in ${env.WARNTIME} minutes @ ${env.BUILD_URL}  Application S4-weather")
        break
    case 'STARTING':
      slackSend(channel: channel,
                color: "good",
                message: "S4-weather: Starting upgrade @ ${env.BUILD_URL} Application S4-weather")
      break
    default:
        slackSend(channel: channel,
                color: "good",
                message: "S4-weather: Upgrade completed successfully @ ${env.BUILD_URL}  Application S4-weather")
        break
    }
  } else {
    slackSend(channel: channel,
              color: "danger",
              message: "S4-weather: Upgrade was not successful. Please investigate it immediately.  @ ${env.BUILD_URL}  Application S4-weather")
  }
}





    
