pipeline {
    agent any // This means it can run on any available agent

    stages {
        stage('Checkout') {
            steps {
                // This stage checks out your source code from a version control system (e.g., Git)
                script {
                    checkout scm
                }
            }
        }

        stage('Build') {
            steps {
                
                sh 'mvn clean package' 
            }
        }

        stage('Test') {
            steps {
                
                sh 'mvn test' 
            }
        }

        stage('Deploy') {
            steps {
                // This stage can include deployment commands
                sh 'mvn deploy' // Example: Deploying with Maven
            }
        }
    }

    post {
        success {
            // This block of steps will be executed if the pipeline succeeds
            echo 'The pipeline was successful!'
        }
        failure {
            // This block of steps will be executed if the pipeline fails
            echo 'The pipeline failed.'
        }
    }
}
