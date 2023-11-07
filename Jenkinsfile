pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                sh '''
                ls 
                pwd
                '''
            }
        }

        stage('Build') {
            steps {
                // Compile and build your application
                sh 'make build'
            }
        }

        stage('Test') {
            steps {
                // Run tests for your application
                sh 'make test'
            }
        }

        stage('Deploy') {
            steps {
                // Deploy your application to a server or container
                sh 'make deploy'
            }
        }
    }

    post {
        success {
            // Actions to take when the pipeline succeeds
            echo 'Pipeline succeeded!'
        }

        failure {
            // Actions to take when the pipeline fails
            echo 'Pipeline failed!'
        }
    }
}


    
