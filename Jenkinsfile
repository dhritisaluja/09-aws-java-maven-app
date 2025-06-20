#!/usr/bin/env groovy

pipeline {   
    agent any
    stages {
        stage("test") {
            steps {
                script {
                    echo "Testing the application...."
                }
            }
        }
        
        stage("build") {
            steps {
                script {
                    echo "Building the application...."
                }
            }
        }

        stage("deploy") {
            steps {
                
                script {
                    def dockerCmd = 'docker run -d -p 8000:8080 dhritisaluja/demo-app:1.1.1-17'
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.95.158.229 ${dockerCmd}"

                    }
                }
            }
        }
    }               
}