pipeline {
    agent any
	environment {    
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
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
				withAWS(credentials: 'aws-credentials')
			    sh label: '', script: 'terraform apply -auto-approve'
			 }
	    }
	
	}
	
}