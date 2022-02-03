pipeline {
	 environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
		//TELEGRAM_TOKEN     = credentials('TELEGRAM_TOKEN')
        //TELEGRAM_CHAT_ID = credentials('TELEGRAM_CHAT_ID')
    }
    agent any
	tools {
            terraform 'terraform'
		}
	stages {
		stage('Terraform Init'){
		    steps{
				sh label: '', script: 'terraform init'
			}
	    }
		stage('Terraform apply'){
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
	}
    post {

        success { 
            withCredentials([string(credentialsId: 'TELEGRAM_TOKEN', variable: 'TOKEN'), string(credentialsId: 'TELEGRAM_CHAT_ID', variable: 'CHAT_ID')]) {
            sh  ("""
                curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='*Build: ${env.JOB_NAME}* №: ${env.BUILD_NUMBER} *Branch*: ${env.GIT_BRANCH} *Build* : OK *Published* = YES'
            """)
            }
        } 

        aborted {
            withCredentials([string(credentialsId: 'TELEGRAM_TOKEN', variable: 'TOKEN'), string(credentialsId: 'TELEGRAM_CHAT_ID', variable: 'CHAT_ID')]) {
            sh  ("""
                curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='*Build: ${env.JOB_NAME}* №: ${env.BUILD_NUMBER} *Branch*: ${env.GIT_BRANCH} *Build* : `Aborted` *Published* = `Aborted`'
            """)
            }
     
        }

        failure {
            withCredentials([string(credentialsId: 'TELEGRAM_TOKEN', variable: 'TOKEN'), string(credentialsId: 'TELEGRAM_CHAT_ID', variable: 'CHAT_ID')]) {
            sh  ("""
                curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='*Build: ${env.JOB_NAME}* №:  ${env.BUILD_NUMBER} *Branch*: ${env.GIT_BRANCH} *Build* : `not OK` *Published* = `no`'
            """)
            }
        }   
	}
}
