pipeline {
    agent any 

    stages {
        stage('Checkout') {
            steps {
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
                sh 'mvn deploy'
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
