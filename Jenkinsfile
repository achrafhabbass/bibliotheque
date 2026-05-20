// ─────────────────────────────────────────────────────────────
//  Jenkinsfile – Pipeline déclaratif BiblioGest
//  Équivalent du workflow GitHub Actions et du .gitlab-ci.yml.
//  Stages : Lint → Tests → Quality → Package → Docker → Security → Notify
// ─────────────────────────────────────────────────────────────

pipeline {
    agent any

    options {
        timeout(time: 30, unit: 'MINUTES')
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    environment {
        // Credentials Jenkins à créer dans Manage Jenkins → Credentials
        SONAR_TOKEN      = credentials('sonar-token')
        DOCKER_CREDS     = credentials('docker-hub')
        SLACK_WEBHOOK    = credentials('slack-webhook')

        SONAR_HOST       = 'https://sonarcloud.io'
        IMAGE_NAME       = 'bibliotheque'
        DOCKER_HUB_IMAGE = "${DOCKER_CREDS_USR}/${IMAGE_NAME}"
        MAVEN_OPTS       = '-Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=WARN'
    }

    tools {
        // Le nom doit correspondre à un outil configuré dans Manage Jenkins → Global Tool Configuration
        jdk   'jdk-17'
        maven 'maven-3.9'
    }

    stages {

        // ─────────────────────────────────────────────
        // Stage 1 : Checkout
        // ─────────────────────────────────────────────
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    env.GIT_SHORT = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                }
            }
        }

        // ─────────────────────────────────────────────
        // Stage 2 : Lint (Checkstyle + SpotBugs) en parallèle
        // ─────────────────────────────────────────────
        stage('Lint') {
            parallel {
                stage('Checkstyle') {
                    steps {
                        sh 'mvn -B checkstyle:check --no-transfer-progress'
                    }
                    post {
                        always {
                            recordIssues(
                                enabledForFailure: true,
                                tools: [checkStyle(pattern: 'target/checkstyle-result.xml')]
                            )
                        }
                    }
                }
                stage('SpotBugs') {
                    steps {
                        sh 'mvn -B compile -DskipTests --no-transfer-progress'
                        sh 'mvn -B spotbugs:check --no-transfer-progress || true'
                    }
                    post {
                        always {
                            recordIssues(
                                enabledForFailure: true,
                                tools: [spotBugs(pattern: 'target/spotbugsXml.xml')]
                            )
                        }
                    }
                }
            }
        }

        // ─────────────────────────────────────────────
        // Stage 3 : Tests unitaires + intégration
        // ─────────────────────────────────────────────
        stage('Tests') {
            steps {
                sh 'mvn -B verify --no-transfer-progress'
            }
            post {
                always {
                    junit allowEmptyResults: true,
                          testResults: 'target/surefire-reports/*.xml,target/failsafe-reports/*.xml'
                    publishHTML(target: [
                        allowMissing: true,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'target/site/jacoco',
                        reportFiles: 'index.html',
                        reportName: 'Couverture JaCoCo'
                    ])
                }
            }
        }

        // ─────────────────────────────────────────────
        // Stage 4 : Analyse qualité SonarCloud (main only)
        // ─────────────────────────────────────────────
        stage('Quality - SonarCloud') {
            when { branch 'main' }
            steps {
                sh """
                    mvn -B sonar:sonar \\
                        -Dsonar.projectKey=${env.SONAR_PROJECT_KEY ?: 'bibliotheque'} \\
                        -Dsonar.organization=${env.SONAR_ORGANIZATION ?: 'bibliotheque-org'} \\
                        -Dsonar.host.url=${SONAR_HOST} \\
                        -Dsonar.token=${SONAR_TOKEN} \\
                        --no-transfer-progress
                """
            }
        }

        // ─────────────────────────────────────────────
        // Stage 5 : Packaging du WAR
        // ─────────────────────────────────────────────
        stage('Package') {
            steps {
                sh 'mvn -B package -DskipTests --no-transfer-progress'
                archiveArtifacts artifacts: 'target/bibliotheque.war',
                                 fingerprint: true,
                                 onlyIfSuccessful: true
            }
        }

        // ─────────────────────────────────────────────
        // Stage 6 : Build et push de l'image Docker (main only)
        // ─────────────────────────────────────────────
        stage('Docker - Build & Push') {
            when { branch 'main' }
            steps {
                sh "docker build -t ${DOCKER_HUB_IMAGE}:${GIT_COMMIT} -t ${DOCKER_HUB_IMAGE}:latest ."
                sh "echo \$DOCKER_CREDS_PSW | docker login -u \$DOCKER_CREDS_USR --password-stdin"
                sh "docker push ${DOCKER_HUB_IMAGE}:${GIT_COMMIT}"
                sh "docker push ${DOCKER_HUB_IMAGE}:latest"
            }
        }

        // ─────────────────────────────────────────────
        // Stage 7 : Scan sécurité Trivy (main only)
        // ─────────────────────────────────────────────
        stage('Security - Trivy') {
            when { branch 'main' }
            steps {
                sh """
                    docker run --rm \\
                        -v /var/run/docker.sock:/var/run/docker.sock \\
                        aquasec/trivy:latest image \\
                        --severity CRITICAL,HIGH \\
                        --ignore-unfixed \\
                        --exit-code 0 \\
                        ${DOCKER_HUB_IMAGE}:latest
                """
            }
        }
    }

    // ─────────────────────────────────────────────
    // Post-actions : notification finale Slack
    // ─────────────────────────────────────────────
    post {
        success {
            slackNotify('good', '✅ RÉUSSIE')
        }
        failure {
            slackNotify('danger', '❌ ÉCHOUÉE')
            emailext(
                subject: "Build échoué : ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Détails : ${env.BUILD_URL}",
                to: 'equipe@example.com'
            )
        }
        unstable {
            slackNotify('warning', '⚠️ INSTABLE')
        }
        always {
            cleanWs()
        }
    }
}

// ─────────────────────────────────────────────
// Fonction utilitaire de notification Slack
// ─────────────────────────────────────────────
def slackNotify(String color, String statusText) {
    def payload = """
    {
        "attachments": [{
            "color": "${color}",
            "text": "${statusText} - BiblioGest - ${env.BRANCH_NAME ?: 'main'} @ ${env.GIT_SHORT} - <${env.BUILD_URL}|Voir build>"
        }]
    }
    """
    sh """
        curl -X POST -H 'Content-type: application/json' \\
            --data '${payload}' \\
            \$SLACK_WEBHOOK || true
    """
}
