pipeline {
	 environment {
        IMAGE_BASE = 'taruraiev/pet-clinic'
        IMAGE_TAG = "v$BUILD_NUMBER"
        IMAGE_NAME = "${env.IMAGE_BASE}:${env.IMAGE_TAG}"
        IMAGE_NAME_LATEST = "${env.IMAGE_BASE}:latest"
        DOCKERFILE_NAME = "docker/Dockerfile"
        DOCKERHUB_CREDENTIALS = credentials('taruraiev-dockerhub')
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        APP_IP = ''
    }
    agent any  
	  tools {
          terraform 'terraform_1.1.4'
          maven 'maven_3.8.4'
		}
    stages {
        stage("Build and test app") {
          stages {
            stage("Testing stage") {
              steps {
                dir ('petclinic') {
                   sh 'sh mvnw test'
                   sh 'sh mvnw surefire-report:report'
                   junit 'target/surefire-reports/TEST-*.xml'
                }
              }
            }        
            stage("Build and prepare artifact") {
              steps {
                dir ('petclinic') {
                   sh 'sh mvnw package -DskipTests'
                }
                dir ('.') {
                   echo "Copying artifact to root folder"
                   sh 'cp petclinic/target/*.jar docker/app.jar'
                   echo "Archiving artifact"
                   archiveArtifacts(artifacts: 'petclinic/target/*.jar')
                   archiveArtifacts(artifacts: 'petclinic/target/site/surefire-report.html')
                }
              }
            }
          }
        }
        
        stage('Docker Build') {
              steps {
                script {
                  def dockerImage = docker.build("${IMAGE_NAME_LATEST}", "-f ${DOCKERFILE_NAME} .") 
                  echo "Docker image name ${IMAGE_NAME}"
                  echo "Docker image name ${IMAGE_NAME_LATEST}"
            }
          }
        }
        
        stage('Docker Login by token') {
              steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                 
          }
        }

        stage('Docker Push') {
              steps {
                sh 'docker push ${IMAGE_NAME_LATEST}'
          }
        }

        stage('Docker remove image') {
              steps {
                sh "docker rmi ${IMAGE_NAME_LATEST}"
                sh "docker image prune -a -f"
                sh "docker system prune -a"
          }
        }

        stage("Terraform") {
          stages {
            stage('Terraform Init'){
              steps{
                checkout scm
                dir ('terraform') {
                sh label: '', script: 'terraform init'
		  	        }
              }
            }
   
	         	stage('Terraform apply'){
              steps{
                checkout scm
                dir ('terraform') {
				          sh label: '', script: 'terraform apply -auto-approve'
			   	        //sh label: '', script: 'terraform destroy -auto-approve'
			    
              script {
                  APP_IP = sh(returnStdout: true, script: "terraform output -raw Webserver_public_ip").trim()
                  }
                  // write env form ansible script
                  writeFile (file: '../ansible/hosts.txt', text: '[app]\n' + APP_IP)
                } 
			        }
			      }
          }
        }
   
	      stage('App environment configuring with ansible') {
          steps {
              dir ('ansible') {
              sh 'sleep 120'
              sh 'ansible-playbook app.yml'
              sh 'sleep 30'
            }
          }
        } 
      }

       
    post {
     success { 
        withCredentials([string(credentialsId: 'telegram_token', variable: 'TOKEN'), string(credentialsId: 'telegram_chat_id', variable: 'CHAT_ID')]) {
        sh  ("""
            curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='*${env.JOB_NAME}* : POC *Branch*: ${env.GIT_BRANCH} $APP_IP:8080 *Build* : OK *Published* = YES'
        """)
        }
      }
     aborted {
        withCredentials([string(credentialsId: 'telegram_token', variable: 'TOKEN'), string(credentialsId: 'telegram_chat_id', variable: 'CHAT_ID')]) {
        sh  ("""
            curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='*${env.JOB_NAME}* : POC *Branch*: ${env.GIT_BRANCH} *Build* : `Aborted` *Published* = `Aborted`'
        """)
        }    
      }
     failure {
        withCredentials([string(credentialsId: 'telegram_token', variable: 'TOKEN'), string(credentialsId: 'telegram_chat_id', variable: 'CHAT_ID')]) {
        sh  ("""
            curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='*${env.JOB_NAME}* : POC  *Branch*: ${env.GIT_BRANCH} *Build* : `not OK` *Published* = `no`'
        """)
      }
    }
  }
}