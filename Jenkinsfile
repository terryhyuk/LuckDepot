pipeline {
    agent any

    environment {
        PROJECT_NAME = "luckydepot"
        DOCKER_IMAGE_TAG = "${PROJECT_NAME}-${BUILD_NUMBER}"
        DOCKER_IMAGE = "${PROJECT_NAME}:${DOCKER_IMAGE_TAG}"
    }

    stages {
        stage("Checkout") {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker Image with tag: ${DOCKER_IMAGE_TAG}"
                    docker build -t luckydepot:${DOCKER_IMAGE_TAG} -f Dockerfile .
                    echo "Tagging image as latest"
                    docker tag luckydepot:${DOCKER_IMAGE_TAG} luckydepot:latest
                '''
            }
        }
        stage('Push Docker Image to Local Registry') {
            steps {
                sh '''
                    echo "Pushing Docker Image with tag: ${DOCKER_IMAGE_TAG}"
                    docker push "${DOCKER_IMAGE}"
                    
                    echo "Pushing Docker Image with tag: latest"
                    docker push "${DOCKER_REGISTRY}/${PROJECT_NAME}:latest"
                '''
            }
        }
        // stage("Test") {
        //     when {
        //         expression {
        //             params.executeTests
        //         }
        //     }
        //     steps {
        //         script {
        //             gv.testApp()
        //         }
        //     }
        // }
        stage("Deploy") {
            steps {
                sh '''
                    echo "Deploying Docker Image with tag: ${DOCKER_IMAGE_TAG}"
                    DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG} \
                    docker-compose -f docker-compose.yml up -d --build
                '''
            }
        }
    }
}
