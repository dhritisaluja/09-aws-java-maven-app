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
                    def dockerCmd = 'docker run -d -p 3000:3080 dhritisaluja/react-nodejs-example:1.0'
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.95.158.229 ${dockerCmd}"

                    }
                }
            }
        }
    }               
}