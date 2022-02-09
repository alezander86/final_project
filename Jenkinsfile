pipeline {
    agent any
    stages {
        stage("build"){

            steps {
                echo 'build the application'
            }
        }    
        stage("test"){

            steps {
                echo 'testing the application'
            }
        }

        stage("deploy"){

            steps {
                echo 'deploy the application'
            }
        }
    }
    post {
     success { 
        withCredentials([string(credentialsId: 'telegram_token', variable: 'TOKEN'), string(credentialsId: 'telegram_chat_id', variable: 'CHAT_ID')]) {
        sh  ("""
            curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='*${env.JOB_NAME}* : POC *Branch*: ${env.GIT_BRANCH} *Build* : OK *Published* = YES'
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