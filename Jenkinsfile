pipeline {
	 environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
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
	
}