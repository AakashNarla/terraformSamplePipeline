pipeline {
    agent { label 'terraform-slave' }
environment {
        ARM_SUBSCRIPTION_ID=credentials('azure_subscription')
        ARM_TENANT_ID=credentials('azure_tenant')
        ARM_CLIENT_ID=credentials('azure_client_id')
        ARM_CLIENT_SECRET=credentials('azure_client_secret')
        TF_VAR_client_id=credentials('azure_client_id')
        TF_VAR_client_secret=credentials('azure_client_secret')
    }
    stages {
        stage('Checkout Repo') {
            steps {
              checkout scm
            }
        }
        
        stage('Check for Terraform Version') {
            steps {
                container('terraform') {
                    sh 'terraform version'
                }
            }
        }
        stage('init') {
            steps {
                container('terraform') {
                    sh 'terraform init -input=false'
                    sh 'ls -altr'
                }
            }
        }
        stage('plan') {
            steps {
                container('terraform') {
                    sh 'terraform plan -input=false -out myplan'
                }
                script {
                  timeout(time: 10, unit: 'MINUTES') {
                    input(id: "Deploy Gate", message: "Deploy the script?", ok: 'Deploy')
                  }
                }
            }
        }
        stage('apply') {
            steps {
                container('terraform') {
                    sh 'terraform apply -lock=false -input=false myplan'
                }
            }
        }
    }
}