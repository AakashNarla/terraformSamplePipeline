pipeline {
    agent {
        node {
            label 'master'
        }
    }
environment {
        TERRAFORM_CMD = 'docker run  -v `pwd`:/tf-k8s-installer  --workdir=/tf-k8s-installer hashicorp/terraform:light'
        ARM_SUBSCRIPTION_ID=credentials('azure_subscription')
        ARM_TENANT_ID=credentials('azure_tenant')
        ARM_CLIENT_ID=credentials('azure_client_id')
        ARM_CLIENT_SECRET=credentials('azure_client_secret')
        TF_VAR_client_id=credentials('azure_client_id')
        TF_VAR_client_secret=credentials('azure_client_secret')
    }
    stages {
        stage('checkout repo') {
            steps {
              checkout scm
            }
        }
        
        stage('pull latest light terraform image') {
            steps {
                sh  "docker pull hashicorp/terraform:light"
            }
        }
        stage('init') {
            steps {
                sh "ls -altr"
                sh "pwd"                
                sh "echo ${TERRAFORM_CMD}"
                sh  "${TERRAFORM_CMD} init -backend=true -input=false"
                sh "ls -altr"
            }
        }
        stage('plan') {
            steps {
                sh  "${TERRAFORM_CMD} plan -out=tfplan -input=false ./terraformDemo"
                script {
                  timeout(time: 10, unit: 'MINUTES') {
                    input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
                  }
                }
            }
        }
        stage('apply') {
            steps {
                sh  "${TERRAFORM_CMD} apply -lock=false -input=false tfplan"

}
        }
    }
}