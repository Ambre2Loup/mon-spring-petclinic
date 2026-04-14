pipeline {
    agent any

    stages {
        stage('1. Checkout') {
            steps {
                echo 'Récupération du code...'
                // Comme tu es en "Pipeline script from SCM", cette ligne suffit :
                checkout scm
            }
        }

        stage('2. Build & Unit Tests') {
            steps {
                echo 'Compilation et exécution des tests unitaires...'
                sh 'chmod +x mvnw'
                // On retire -DskipTests pour que Maven lance les tests JUnit
                sh './mvnw clean test'
            }
        }

        stage('3. Packaging') {
            steps {
                echo 'Création du fichier JAR...'
                // On repackage sans relancer les tests pour gagner du temps
                sh './mvnw package -DskipTests'
            }
        }

        stage('4. Build Docker Image') {
            steps {
                echo 'Construction de l\'image Docker...'
                sh 'docker build -t petclinic-app:latest .'
            }
        }
    }

    post {
        always {
            // Best Practice : Récupérer les rapports de tests même si ça échoue
            junit '**/target/surefire-reports/*.xml'
            echo 'Nettoyage...'
            sh 'docker image prune -f'
        }
    }
}
