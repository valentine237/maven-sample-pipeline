pipeline {
    agent any

    stages {
        stage('Git clone') {
            steps {
                echo "cloning"
            }
        }
        stage('Verify') {
            steps {
                sh 'mvn validate'
            }
        }
        stage('Build') {
                    steps {
                        sh 'mvn compile'
                    }
                }

          stage('Sonarqube scan') {
                    environment {
                                   scannerHome = tool '<sonarURL>';
                               }
                              steps {
                                  sh 'echo performing sonar scans'
                                  withSonarQubeEnv(credentialsId: 'sonarID', installationName: 'sonarqube') {
                                      sh "${scannerHome}/bin/sonar-scanner"
                                  }
                              }
                       }

        stage('Run Test') {
                    steps {
                        sh 'mvn test'
                    }
         }

         stage('upload to artifactory') {
                             steps {
                                 //sh 'mvn test'
                                 configFileProvider([configFile(fileId: '5d0920bc-97c5-4877-8aa4-2f61975fa9fc', variable: 'MAVEN_SETTINGS_XML')]) {
                                     sh 'mvn -U --batch-mode -s $MAVEN_SETTINGS_XML clean deploy'
                                 }
                             }
                  }
        
          stage('Perform Docker Build') {
                             steps {
                                 
                                  docker build . -t 1.0.0
                                 
                                 }
                             }
                  }

           stage ('OWASP Dependency-Check Vulnerabilities') {
                                steps {
                                    dependencyCheck additionalArguments: '''
                                        -o "./"
                                        -s "./"
                                        -f "ALL"
                                        --prettyPrint''', odcInstallation: 'dependency-check'

                                    dependencyCheckPublisher pattern: 'dependency-check-report.xml'
                                }
                            }
        
            stage ('Send Mail') {
                                steps {
                                    emailext attachLog: true, body: '', compressLog: true, 
                                        subject: 'Pipeline started', to: 'dummy@gmail.com, no-reply@gmail.com'
                                }
                            }
        }
    }
}
