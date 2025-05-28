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
    }

    post {
        always {
            script {
                cleanWs() // Clean up workspace after every build
            }
        }
    }
}

