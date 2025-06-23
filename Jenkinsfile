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
    
    stages {
        
        stage('Increment Version') {
            steps {
                script {
                    echo "Incrementing bugfix version of the application version..."
                    
                    sh '''
                       mvn build-helper:parse-version \\
                       versions:set \\
                       -DnewVersion=\\${parsedVersion.majorVersion}.\\${parsedVersion.minorVersion}.\\${parsedVersion.nextIncrementalVersion} \\
                       versions:commit
                    '''

                    echo "Reading new version from pom.xml..."
                    def version = sh(script: "mvn help:evaluate -Dexpression=project.version -q -DforceStdout", returnStdout: true).trim()
                    env.IMAGE_TAG = "$version-$BUILD_NUMBER"
                
                }
            }
        }
        
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
                   echo 'building docker image and publishing it to Docker Hub..'
                   buildImage("dhritisaluja/demo-app:java-maven-${env.IMAGE_TAG}")
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
                        
                        def deployCommand = "'chmod +x ${remotePath}/server-cmds.sh && ${remotePath}/server-cmds.sh dhritisaluja/demo-app:java-maven-${env.IMAGE_TAG}'"
                        
                        sh "ssh -o StrictHostKeyChecking=no ${remoteUser}@${remoteHost} ${deployCommand}"

                        echo "Deployment to EC2 completed."
                    }
                }
            }
        }
        stage('Commit Version Update') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/dhritisaluja/09-jenkins-java-maven-app.git"
                        sh 'git add .'
                        sh 'git commit -m "jenkins: version bump"'
                        sh 'git push origin HEAD:main'
                    }
                }
            }
        }
                
    }
}