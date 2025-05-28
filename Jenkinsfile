pipeline {
    agent any

    tools {
        maven 'Maven' // Make sure this tool is configured in Jenkins
    }

    environment {
        SONAR_TOKEN = credentials('sonar-token') // SonarQube credential
        DOCKER_IMAGE = 'codexaayush/cmdb-app'  // Replace with your Docker Hub username
        DOCKER_TAG = "${env.BRANCH_NAME.replace('/', '-')}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh '''
                    mvn clean package -DskipTests
                    # Ensure consistent JAR name for Docker
                    cp target/cmdb-app-*.jar target/cmdb-app.jar
                '''
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
                    credentialsId: 'dockerhub', // Add Docker Hub credentials in Jenkins
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