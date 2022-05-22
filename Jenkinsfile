pipeline {
    agent any

    tools {
        maven 'Maven3'
    }
    environment {
        //once you sign up for Docker hub, use that user_id here
        registry = "kuga01/rearc"
        //- update your credentials ID after creating credentials for connecting to Docker Hub
        registryCredential = 'dockerhub'
        dockerImage = ''
        // Docker TAG
        DOCKER_TAG = getVersion()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/kuga01/quest']]])
            }
        }
        
        stage ('Build docker image') {
            steps {
                sh "docker build . -t $registry:${DOCKER_TAG}"
            }
        }
        
        // Uploading Docker images into Docker Hub
        stage('Upload Image') {
            steps{   
                script {
                    docker.withRegistry( '', registryCredential ) {
                        sh "docker push $registry:${DOCKER_TAG}"
                    }
               }
            }
        }
        stage('Cleaning up') {
            steps{
                sh "docker rmi $registry:${DOCKER_TAG}"
            }
        }
        
        stage('Docker Run') {
            steps{
                script {
                    sh 'docker run --name rearc-app -d -p 8081:3000 --rm $registry:${DOCKER_TAG}'
                }
            }
        } 
        
        stage('K8S Deploy') {
            steps{   
                script {
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'K8S', namespace: '', serverUrl: '') {
                    sh ('kubectl apply -f  kubernetes_files')
                    }
                }
            }
        } 
        
        stage('Ingress Deploy') {
            steps{   
                script {
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'K8S', namespace: '', serverUrl: '') {
                    sh ('kubectl apply -f  rearc-app-ingress.yaml')
                    }
                }
            }
        }         
                
    }
}

def getVersion() {
    def commitHash = sh label: '', returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
