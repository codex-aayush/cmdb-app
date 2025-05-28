pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sonarqube-token')
        DOCKER_CREDS = credentials('dockerhub')
        IMAGE_NAME = "your_dockerhub_username/cmdb-app"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Code Quality - SonarQube') {
            steps {
                withSonarQubeEnv('SonarQubeServer') {
                    sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=cmdb-app \
                        -Dsonar.host.url=http:52.153.224.58:9000 \
                        -Dsonar.login=$SONAR_TOKEN
                    """
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    sh """
                        docker build -t $IMAGE_NAME:$BRANCH_NAME .
                        echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin
                        docker push $IMAGE_NAME:$BRANCH_NAME
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

