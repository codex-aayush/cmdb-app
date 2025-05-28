pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm // Automatically checks out code from GitHub
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Hello') {
            steps {
                echo 'Hello from Jenkins multibranch pipeline!'
            }
        }
    }
}

