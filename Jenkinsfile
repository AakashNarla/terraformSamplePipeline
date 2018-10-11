pipeline {
    agent {
        node {
            label 'master'
        }
    }
environment {
        TERRAFORM_CMD = 'docker run --network host " -w /app -v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v `pwd`:/app hashicorp/terraform:light'
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
                sh  "${TERRAFORM_CMD} init -backend=true -input=false "
            }
        }
        stage('plan') {
            steps {{
                sh  "${TERRAFORM_CMD} plan -out=tfplan -input=false"
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