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
        IMAGE_NAME = 'dhritisaluja/demo-app:java-maven-1.0'
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
        stage("deploy") {
            steps {
                
                script {
                    def dockerCmd = "docker run -d -p 8080:8080 ${IMAGE_NAME}"
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.95.158.229 ${dockerCmd}"

                    }
                }
            }
        }
        
    }
}