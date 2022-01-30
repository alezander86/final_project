pipeline {
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
				withAWS(credentials: 'aws-credentials')
			    sh label: '', script: 'terraform apply -auto-approve'
			 }
	    }
	
	}
	
}