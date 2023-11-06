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
                // This stage can include build commands, like compiling code
                sh 'mvn clean package' // Example: Maven build
            }
        }

        stage('Test') {
            steps {
                // This stage can include testing commands
                sh 'mvn test' // Example: Running tests with Maven
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
