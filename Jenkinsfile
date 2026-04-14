pipeline {
    agent any

    stages {
        stage('1. Checkout') {
            steps {
                echo 'Récupération du code depuis GitHub...'
                // Vérifie que l'URL et la branche correspondent à ton dépôt
                git branch: 'main', url: 'https://github.com/Ambre2Loup/mon-spring-petclinic.git'
            }
        }

        stage('2. Build Java (Maven)') {
            steps {
                echo 'Compilation de l\'application avec Maven...'
                // On utilise le wrapper ./mvnw pour ne pas avoir à installer Maven
                sh 'chmod +x mvnw'
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('3. Build Docker Image') {
            steps {
                echo 'Construction de l\'image Docker...'
                // On utilise le tag 'latest' pour le développement
                sh 'docker build -t petclinic-app:latest .'
            }
        }

        stage('4. Verification') {
            steps {
                echo 'Vérification de l\'image créée :'
                sh 'docker images | grep petclinic-app'
            }
        }
    }

    post {
        always {
            echo 'Nettoyage des images intermédiaires...'
            sh 'docker image prune -f'
        }
        success {
            echo 'Félicitations ! Ton image est prête sur ton Mac.'
        }
    }
}
