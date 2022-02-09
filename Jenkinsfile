pipeline {
	 environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    agent any  /*{
        docker {
            image 'maven'
            args '-v $HOME:/home'
            } 
        }
    */
	  tools {
            terraform 'terraform'
            maven '3.8.4'
		}
	/* stages {
        stage("Build and test app") {
          stages {
            stage("testing stage") {
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
                   sh 'cp petclinic/target/*.jar app.jar'
                   echo "Archiving artifact"
                   archiveArtifacts(artifacts: 'petclinic/target/*.jar')
                   archiveArtifacts(artifacts: 'petclinic/target/site/surefire-report.html')
                }
              }
            }

          }
        }*/
    stage('Terraform Init'){
		    steps{
				  sh label: '', script: 'terraform init'
			  }
	    }
		/*stage('Terraform apply'){
		    steps{
				//sh label: '', script: 'terraform apply -auto-approve'
				sh label: '', script: 'terraform destroy -auto-approve'
			script {
                WEB_IP = sh(returnStdout: true, script: "terraform output -raw Webserver_public_ip").trim()
                DB_IP = sh(returnStdout: true, script: "terraform output -raw Webserver_public_ip_db").trim()
                }
                writeFile (file: '../ansible/hosts.txt', text: '[web]\n' + WEB_IP + '\n' + '[db]\n' + DB_IP + '\n')
			 }
			 
	    }

	}*/
    post {

        success { 
            withCredentials([string(credentialsId: 'telegram_token', variable: 'TOKEN'), string(credentialsId: 'telegram_chat_id', variable: 'CHAT_ID')]) {
			sh  ("""
                curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='*Build*: ${env.JOB_NAME} *№*: ${env.BUILD_NUMBER} *Branch*: ${env.GIT_BRANCH} $WEB_IP *Build* : OK *Published* = YES'
            """)
            }
        } 

        aborted {
            withCredentials([string(credentialsId: 'telegram_token', variable: 'TOKEN'), string(credentialsId: 'telegram_chat_id', variable: 'CHAT_ID')]) {
            sh  ("""
                curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='*Build*: ${env.JOB_NAME} *№*: ${env.BUILD_NUMBER} *Branch*: ${env.GIT_BRANCH} *Build* : `Aborted` *Published* = `Aborted`'
            """)
            }
     
        }

        failure {
            withCredentials([string(credentialsId: 'telegram_token', variable: 'TOKEN'), string(credentialsId: 'telegram_chat_id', variable: 'CHAT_ID')]) {
            sh  ("""
                curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='*Build*: ${env.JOB_NAME} *№*: ${env.BUILD_NUMBER} *Branch*: ${env.GIT_BRANCH} *Build* : `not OK` *Published* = `no`'
            """)
            }
        }   
	}

}