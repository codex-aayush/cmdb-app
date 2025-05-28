pipeline {
    agent any

    tools {
        maven 'Maven' // Make sure this tool is configured in Jenkins
    }

    environment {
        SONAR_TOKEN = credentials('sonar-token') // SonarQube credential
        DOCKER_IMAGE = 'your-docker-image-name' // Define your Docker image name here
        DOCKER_TAG = "${env.BRANCH_NAME.replace('/', '-')}" // Auto-sanitize branch name for tag
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

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-creds', // Add Docker Hub credentials in Jenkins
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $DOCKER_IMAGE:$DOCKER_TAG
                    """
                }
            }
        }
    }
}