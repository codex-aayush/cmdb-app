pipeline {
    agent any

    environment {
        MAVEN_HOME = tool 'Maven' // Maven installed via Jenkins Global Tool Configuration
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm // Checkout code from the branch Jenkins detected
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean install' // Compile and package the app
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SONAR_HOST_URL = 'http://52.153.224.58:9000' // SonarQube server IP
            }
            steps {
                withSonarQubeEnv('SonarQubeServer') {
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                        // Run Sonar analysis with proper authentication
                        sh """
                            mvn sonar:sonar \
                            -Dsonar.projectKey=cmdb-app \
                            -Dsonar.host.url=$SONAR_HOST_URL \
                            -Dsonar.login=$SONAR_TOKEN
                        """
                    }
                }
            }
        }

        stage('Docker Build & Push') {
            environment {
                IMAGE_NAME = 'your-image-name'  // Should be defined or parameterized
                BRANCH_NAME = env.BRANCH_NAME  // Should be defined or parameterized
            }
            steps {
                script {
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'docker-creds',
                            usernameVariable: 'DOCKER_CREDS_USR',
                            passwordVariable: 'DOCKER_CREDS_PSW'
                        )
                    ]) {
                        sh """
                            docker build -t $IMAGE_NAME:$BRANCH_NAME .
                            echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin
                            docker push $IMAGE_NAME:$BRANCH_NAME
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean up workspace after every build
        }
    }
}