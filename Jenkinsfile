#!groovy
pipeline {
 agent any
    environment {  
     EncCred = credentials('aesencrypt')   
    //Apigee-environment for each environment
    apg_env_dev = "dev-4"
    apg_env_uat = "uatint01"
    apg_env_prod = "prodint01"
    
    //Apigee organization for each environment
    apg_org_dev = "sidgs-hybrid"
    apg_org_uat = "hdfcbank-apigee-runtime-uat"
    apg_org_prod = "hdfcbank-apigee-runtime-prod"

    //Service account filename for each environment
    apg_svc_dev = "sidgs-hybrid-adcaf5883700.json"
    apg_svc_uat = "hdfcbank-apigee-runtime-uat"
    apg_svc_prod = "hdfcbank-apigee-runtime-prod"
        
    //API profile for each environment
    apg_prof_dev = "dev-4"
    apg_prof_uat = "uatint01"
    apg_prof_prod = "prodint01"    
}

tools { 
        nodejs "NodeJS"
        maven "Maven"
        }

//Please note i have commented the sed commands below, will need to enable them but the replacing values should be matching with the pom.xml's template code.
stages {
    stage('Modify Pom file') {
        steps {
            dir('edge') {
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        sh '''
                        echo "Modifying POM file with development configuration"
                         sed -i 's#<id>apigee_dev_id</id>#<id>'$apg_env_dev'</id>#' pom.xml
                         sed -i 's#<apigee.profile>apigee_dev_prof</apigee.profile>#<apigee.profile>'$apg_prof_dev'</apigee.profile>#' pom.xml
                         sed -i 's#<apigee.env>apigee_dev_env</apigee.env>#<apigee.env>'$apg_env_dev'</apigee.env>#' pom.xml
                         sed -i 's#<apigee.serviceaccount.file>apigee_dev_svc</apigee.serviceaccount.file>#<apigee.serviceaccount.file>'$apg_svc_dev'</apigee.serviceaccount.file>#' pom.xml
                         sed -i 's#<apigee.org>apigee_dev_org</apigee.org>#<apigee.org>'$apg_org_dev'</apigee.org>#' pom.xml
                        '''
                       }
                    else if (env.BRANCH_NAME == 'uat') {
                        sh '''
                        echo "Modifying POM file with UAT configuration"
                        // sed -i 's#<id>default_id</id>#<id>'$apg_env_uat'</id>#' pom.xml
                        // sed -i 's#<apigee.env>default_env</apigee.env>#<apigee.env>'$apg_env_uat'</apigee.env>#' pom.xml
                        // sed -i 's#<apigee.serviceaccount.file>./default_svc.json</apigee.serviceaccount.file>#<apigee.serviceaccount.file>./'$apg_svc_uat'.json</apigee.serviceaccount.file>' pom.xml
                        '''
                    }
                    else if (env.BRANCH_NAME == 'master') {
                        sh '''
                        echo "Modifying POM file with Prod_DR configuration"
                        // sed -i 's#<id>default_id</id>#<id>'$apg_env_prod'</id>#' pom.xml
                        // sed -i 's#<apigee.env>default_env</apigee.env>#<apigee.env>'$apg_env_prod'</apigee.env>#' pom.xml
                        // sed -i 's#<apigee.serviceaccount.file>./default_svc.json</apigee.serviceaccount.file>#<apigee.serviceaccount.file>./'$apg_svc_prod'.json</apigee.serviceaccount.file>' pom.xml
                        '''
                    }
                    else {
                        sh '''
                        echo "No branch matching"
                        exit 0
                        '''
                    }                       
                }
            }
        }
    }

    stage('Prepare Deployment - Decrypting Service account file') {
        steps{
            dir('edge') {
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        sh '''
                        cd /tmp/APIGEE
                        la -la 
                         cp /tmp/APIGEE/sidgs_dev_sa.enc .
                        export key=$EncCred_PSW
                        openssl enc -d -aes-256-cbc -in sidgs_dev_sa.enc -out $apg_svc_dev.json -k $key
                        '''
                       }
                    else if (env.BRANCH_NAME == 'uat') {
                        sh '''
                        cp /tmp/APIGEE/hdfc_uat_sa.enc .
                        export key=$EncCred_PSW
                        openssl enc -d -aes-256-cbc -in hdfc_uat_sa.enc -out $apg_svc_uat.json -k $key
                        '''
                    }
                    else if (env.BRANCH_NAME == 'master') {
                        sh '''
                        cp /tmp/APIGEE/hdfc_prod_sa.enc .
                        export key=$EncCred_PSW
                        openssl enc -d -aes-256-cbc -in hdfc_prod_sa.enc -out $apg_svc_prod.json -k $key
                        '''
                    }
                    else {
                        sh '''
                        echo "No branch matching run this stage"
                        exit 0
                        '''
                    }
                }                
            }
        }
    }

    stage('Clean') {
        steps {
            dir('edge') {
                sh "mvn clean"
            }
        }
    }

    stage('Linting') {
        steps {
            dir('edge') {
                    sh "npm install"
                    sh  "mvn package"
                    sh "apigeelint -s apiproxy -f html.js > target/apigeelint"
                    echo "publish html report"
                    publishHTML(target: [
                            allowMissing         : false,
                            alwaysLinkToLastBuild: false,
                            keepAll              : true,
                            reportDir            : 'target',
                            reportFiles          : 'apigeelint.html',
                            reportName           : 'Linting HTML Report'
                    ])
                }
            }
        }

    stage('Pre-Deployment Configurations for API ') {
        steps {
            dir('edge') {
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        sh "mvn -P$apg_env_dev -Denv=$apg_env_dev -Dorg=$apg_org_dev " +
                            "    -Dapigee.config.options=create -Dapigee.config.dir=resources/edge " +
                            "    apigee-config:targetservers"
                    }
                    else if (env.BRANCH_NAME == 'uat') {
                        sh "mvn -P$apg_env_uat -Denv=$apg_env_uat -Dorg=$apg_org_uat " +
                            "    -Dapigee.config.options=create -Dapigee.config.dir=resources/edge " +
                            "    apigee-config:targetservers"
                    }
                    else if (env.BRANCH_NAME == 'master') {
                        sh "mvn -P$apg_env_prod -Denv=$apg_env_prod -Dorg=$apg_org_prod " +
                            "    -Dapigee.config.options=create -Dapigee.config.dir=resources/edge " +
                            "    apigee-config:targetservers"
                    }
                    else {
                        sh '''
                        echo "No branch matching"
                        exit 0
                        '''
                        }
                    }                
                }
            }
        }
    stage('Build proxy bundle') {
            steps {
                dir('edge') {    
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        sh "mvn package -P$apg_env_dev -Denv=$apg_env_dev -Dorg=$apg_org_dev"
                       }
                    else if (env.BRANCH_NAME == 'uat') {
                        sh "mvn package -P$apg_env_uat -Denv=$apg_env_uat -Dorg=$apg_org_uat"
                    }
                    else if (env.BRANCH_NAME == 'master') {    
                        sh "mvn package -P$apg_env_prod -Denv=$apg_env_prod -Dorg=$apg_org_prod"
                    }
                    else {
                        sh '''
                        echo "No branch matching"
                        exit 0
                        '''
                        }
                    }                
                }
            }
        }

    stage('Deploy proxy bundle') {
            steps {
                dir('edge') {    
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        sh "mvn install -P$apg_env_dev -Denv=$apg_env_dev -Dorg=$apg_org_prod"
                       }
                    else if (env.BRANCH_NAME == 'uat') {
                        sh "mvn install -P$apg_env_uat -Denv=$apg_env_uat -Dorg=$apg_org_prod"
                    }
                    else if (env.BRANCH_NAME == 'master') {
                        sh "mvn install -P$apg_env_prod -Denv=$apg_env_prod -Dorg=$apg_org_prod"
                    }
                    else {
                        sh '''
                        echo "No branch matching"
                        exit 0
                        '''
                        }
                    }                
                }
            }
        }

    stage('Post-Deployment Configurations for API') {
            steps {
                dir('edge') {    
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        println "Post-Deployment Configurations for API Products Configurations, App Developer and App Configuration "
                             sh "mvn -P$apg_env_dev -Denv=$apg_env_dev -Dorg=$apg_org_dev " +
                              "    -Dapigee.config.options=create -Dapigee.config.dir=resources/edge " +
                              "    apigee-config:apiproducts " +
                              "    apigee-config:developers apigee-config:developerapps"
                       }
                    else if (env.BRANCH_NAME == 'uat') {
                        println "Post-Deployment Configurations for API Products Configurations, App Developer and App Configuration "
                             sh "mvn -P$apg_env_uat -Denv=$apg_env_uat -Dorg=$apg_org_uat " +
                              "    -Dapigee.config.options=create -Dapigee.config.dir=resources/edge " +
                              "    apigee-config:apiproducts " +
                              "    apigee-config:developers apigee-config:developerapps"
                    }
                    else if (env.BRANCH_NAME == 'master') {
                        println "Post-Deployment Configurations for API Products Configurations, App Developer and App Configuration "
                             sh "mvn -P$apg_env_prod -Denv=$apg_env_prod -Dorg=$apg_org_prod " +
                              "    -Dapigee.config.options=create -Dapigee.config.dir=resources/edge " +
                              "    apigee-config:apiproducts " +
                              "    apigee-config:developers apigee-config:developerapps"
                    }
                    else {
                        sh '''
                        echo "No branch matching"
                        exit 0
                        '''
                        }
                    }                
                }
            }
        }

    stage('Remove Unencrypted-ServiceAccountFile') {
        steps{
            dir('edge') {
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        sh '''
                        rm -rf $apg_svc_dev.json
                        '''
                    }
                    else if (env.BRANCH_NAME == 'uat') {
                        sh '''
                        rm -rf $apg_svc_uat.json
                        '''
                    }
                    else if (env.BRANCH_NAME == 'master') {
                        sh '''
                        rm -rf $apg_svc_prod.json
                        '''
                    }
                    else {
                        sh '''
                        echo "No branch matching"
                        exit 0
                        '''
                        }
                    }            
                }
            }
        }
    }
}
