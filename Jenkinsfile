pipeline {
    agent any 

    options {
        buildDiscarder(logRotator(numToKeepStr: '50'))
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
                            choice( 
                                choices: ['DEV', 'QA', 'PREPROD'], 
                                name: 'ENVIRONMENT'
                            ),
                            string(
                                defaultValue: '50',
                                name: 'auth_tag',
                                description: '''type the auth image tag''',
                                ),
                            
                            string(
                                defaultValue: '50',
                                name: 'db_tag',
                                description: '''type the db image tag''',
                                ),
                            
                            string(
                                defaultValue: '50',
                                name: 'ui_tag',
                                description: '''type the ui image tag''',
                                ),
                            
                            string(
                                defaultValue: '50',
                                name: 'weather_tag',
                                description: '''type the weather image tag''',
                                ),
                            
                            string(
                                name: 'WARNTIME',
                                defaultValue: '0',
                                description: '''Warning time (in minutes) before starting upgrade'''
                            ),
                            string(
                                defaultValue: 'production',
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
            when {
                expression {
                   env.ENVIRONMENT == 'DEV' 
                }
            }
            agent {
                docker {
                  image 'docker.io/sonarsource/sonar-scanner-cli:4.8.0.12008'
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
            when {
                expression {
                   env.ENVIRONMENT == 'DEV' 
                }
            }
            steps {
                sh '''
                   cd auth
                   docker build -t s4arnold/s4-pipepine-02-auth:${BUILD_NUMBER} .
                   cd -
                '''
            }
        }

        stage('push auth') {
            when {
                expression {
                   env.ENVIRONMENT == 'DEV' 
                }
            }
            steps {
                sh '''
                   docker push s4arnold/s4-pipepine-02-auth:${BUILD_NUMBER}
                '''
            }
        }

        stage('Build DB') {
            when {
                expression {
                   env.ENVIRONMENT == 'DEV' 
                }
            }
            steps {
                sh '''
                   cd DB
                   docker build -t s4arnold/s4-pipepine-02-db:${BUILD_NUMBER} .
                   cd -
                   ls -l
                '''
            }
        }

        stage('push DB') {
            when {
                expression {
                   env.ENVIRONMENT == 'DEV' 
                }
            }
            steps {
                sh '''
                   docker push s4arnold/s4-pipepine-02-db:${BUILD_NUMBER}
                '''
            }
        }

        stage('Build UI') {
            when {
                expression {
                   env.ENVIRONMENT == 'DEV' 
                }
            }
            steps {
                sh '''
                   cd UI
                   docker build -t s4arnold/s4-pipepine-02-ui:${BUILD_NUMBER} .
                   cd -
                '''
            }
        }

        stage('push UI') {
            when {
                expression {
                   env.ENVIRONMENT == 'DEV' 
                }
            }
            steps {
                sh '''
                   docker push s4arnold/s4-pipepine-02-ui:${BUILD_NUMBER}
                '''
            }
        }

        stage('Build weather') {
            when {
                expression {
                   env.ENVIRONMENT == 'DEV' 
                }
            }
            steps {
                sh '''
                   cd weather
                   docker build -t s4arnold/s4-pipepine-02-weather:${BUILD_NUMBER} .
                   cd -
                '''
            }
        }

        stage('push weather') {
            when {
                expression {
                   env.ENVIRONMENT == 'DEV' 
                }
            }
            steps {
                sh '''
                   docker push s4arnold/s4-pipepine-02-weather:${BUILD_NUMBER}
                   
                '''
            }
        }

        stage('QA: pull images') {
            when{   
                expression {
                     env.ENVIRONMENT == 'QA' 
                    }
                }
            steps {
                sh '''
                   docker pull  s4arnold/s4-pipepine-02-auth:$auth_tag  
                   docker pull  s4arnold/s4-pipepine-02-db:$db_tag 
                   docker pull  s4arnold/s4-pipepine-02-ui:$ui_tag
                   docker pull  s4arnold/s4-pipepine-02-weather:$weather_tag 
                
               '''       
            }
        }

        stage('QA: tag images') {
             when{
                 expression {
                    env.ENVIRONMENT == 'QA'
                }
            }
             steps {
                sh '''
                    docker tag  s4arnold/s4-pipepine-02-auth:$auth_tag   s4arnold/s4-pipepine-02-auth:qa-$auth_tag
                    docker tag  s4arnold/s4-pipepine-02-db:$db_tag      s4arnold/s4-pipepine-02-db:qa-$qa-db_tag
                    docker tag  s4arnold/s4-pipepine-02-ui:$ui_tag      s4arnold/s4-pipepine-02-ui:qa-$qa-ui_tag
                    docker tag  s4arnold/s4-pipepine-02-weather:$weather_tag  s4arnold/s4-pipepine-02-weather:qa-$weather_tag
                 
                '''       
            }
        }

        stage('Update DEV charts') {
            when{
                expression {
                   env.ENVIRONMENT == 'DEV' 
                }
            }

            steps {
                sh '''
    rm -rf s4arnold-projects-charts || true 
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

        stage('Update QA charts') {
            when{
                expression {
                   env.ENVIRONMENT == 'QA' 
                }
            }

            steps {
                sh '''
    rm -rf s4arnold-projects-charts
    git clone git@github.com:s4arnold/s4arnold-projects-charts.git
    cd s4arnold-projects-charts
    
    cat << EOF > charts/weatherapp-auth/qa-values.yaml
    image:
      repository: s4arnold/s4-pipepine-02-auth
      tag: qa-auth_tag}
    EOF
    
    cat << EOF > charts/weatherapp-mysql/qa-values.yaml
    image:
      repository: s4arnold/s4-pipepine-02-db
      tag: qa-db_tag}
    EOF 
    
    cat << EOF > charts/weatherapp-ui/qa-values.yaml
    image:
      repository: s4arnold/s4-pipepine-02-ui
      tag: qa-ui_tag}
    EOF
    
    cat << EOF > charts/weatherapp-weather/qa-values.yaml
    image:
      repository: s4arnold/s4-pipepine-02-weather
      tag: qa-weather_tag}
    EOF
    
    git config --global user.name "s4arnold"
    git config --global user.email "tchuamarnold211@gmail.com"
    
    git add -A
    git commit -m "change jenkins CI"
    git push
                '''            
            }
        }

        stage('Update PREPROD charts') {
            when{
                expression {
                   env.ENVIRONMENT == 'PREPROD' 
                }
            }

            steps {
                sh '''
    rm -rf s4arnold-projects-charts
    git clone git@github.com:s4arnold/s4arnold-projects-charts.git
    cd s4arnold-projects-charts
    
    cat << EOF > charts/weatherapp-auth/preprod-values.yaml
    image:
      repository: s4arnold/s4-pipepine-02-auth
      tag: "${BUILD_NUMBER}"
    EOF
    
    cat << EOF > charts/weatherapp-mysql/preprod-values.yaml
    image:
      repository: s4arnold/s4-pipepine-02-db
      tag: "${BUILD_NUMBER}"
    EOF 
    
    cat << EOF > charts/weatherapp-ui/preprod-values.yaml
    image:
      repository: s4arnold/s4-pipepine-02-ui
      tag: "${BUILD_NUMBER}"
    EOF
    
    cat << EOF > charts/weatherapp-weather/preprod-values.yaml
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
    

    post {
        always {
            script {
                notifyUpgrade(currentBuild.currentResult, "POST")
            }
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





    
