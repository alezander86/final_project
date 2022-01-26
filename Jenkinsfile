pipeline {
    agent any
	environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_IN_AUTOMATION      = '1'
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
			    sh label: '', script: 'terraform apply -auto-approve'
			 }
	    }
	
	}
	
    stages {
	            	  	 
        stage("build"){

            steps {
                echo 'build the application v2'
            }
        }    
        stage("test"){

            steps {
                echo 'testing the application v2'
            }
        }

        stage("deploy"){

            steps {
                echo 'deploy the application'
            }
        }
    }
}