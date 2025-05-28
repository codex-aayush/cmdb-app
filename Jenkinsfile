pipeline {
    agent any

    tools {
        maven 'Maven 3' // Make sure this tool is configured in Jenkins
    }

    environment {
        SONAR_TOKEN = credentials('sonar-token') // Add this credential in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQubeServer') {
                    sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=cmdb-app \
                        -Dsonar.host.url=http://52.153.224.58:9000 \
                        -Dsonar.login=$SONAR_TOKEN
                    """
                }
            }
        }
    }
}

