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
				sh label: '', script: 'terraform destroy -auto-approve'
			script {
                DEV_IP = sh(returnStdout: true, script: "terraform output -raw Webserver_public_ip").trim()
                PROD_IP = sh(returnStdout: true, script: "terraform output -raw Webserver_public_ip_db").trim()
                }
                writeFile (file: '../ansible/hosts.txt', text: '[dev]\n' + DEV_IP + '\n' + '[prod]\n' + PROD_IP + '\n')
			 }
			 
	    }
	
	}
	
}