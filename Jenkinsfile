#!/usr/bin/env groovy

library identifier: 'jenkins-shared-library@master', retriever: modernSCM(
  [
    $class: 'GitSCMSource',
    remote: 'https://github.com/dhritisaluja/devops-bootcamp-jenkins-shared-library.git',
    credentialsId: 'github-credentials'
  ]
)

pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    environment {
        IMAGE_NAME = 'dhritisaluja/demo-app:java-maven-2.0'
    }
    stages {
        stage('build app') {
            steps {
               script {
                  echo 'building application jar...'
                  buildJar()
               }
            }
        }
        stage('build image') {
            steps {
                script {
                   echo 'building docker image...'
                   buildImage(env.IMAGE_NAME)
                }
            }
        }
               
        stage('Deploy to EC2') {
            steps {
                sshagent(credentials: ['ec2-server-key']) {
                    script {
                        def remoteUser = "ec2-user"
                        def remoteHost = "3.95.158.229"
                        def remotePath = "/home/ec2-user" // Home directory on EC2

                        // 1. Copy the docker-compose.yml file to the EC2 instance
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ${remoteUser}@${remoteHost}:${remotePath}/docker-compose.yaml"

                        // 2. Copy the deployment script to the EC2 instance
                        sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${remoteUser}@${remoteHost}:${remotePath}/server-cmds.sh"

                        // 3. Make the script executable and run it on the EC2 instance passing the dynamic IMAGE as a parameter
                        
                        def deployCommand = "'chmod +x ${remotePath}/server-cmds.sh && ${remotePath}/server-cmds.sh ${env.IMAGE_NAME}'"
                        
                        sh "ssh -o StrictHostKeyChecking=no ${remoteUser}@${remoteHost} ${deployCommand}"

                        echo "Deployment to EC2 completed."
                    }
                }
            }
        }
                
    }
}