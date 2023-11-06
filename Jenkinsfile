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
            
            echo 'The pipeline was successful!'
        }
        failure {
            
            echo 'The pipeline failed.'
        }
    }
}
