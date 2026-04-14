# ──────────────────────────────────────────
# ÉTAPE 1 : BUILD
# ──────────────────────────────────────────

# Image de base avec Java 17 + Maven intégré
FROM eclipse-temurin:17-jdk AS build

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers de config Maven en premier
# (optimise le cache Docker : les dépendances ne sont
#  re-téléchargées que si pom.xml change)
COPY pom.xml .
COPY .mvn/ .mvn/
COPY mvnw .

# Télécharger les dépendances Maven (mise en cache)
RUN ./mvnw dependency:go-offline -B

# Copier le reste du code source
COPY src/ src/

# Compiler et packager l'application (sans les tests)
RUN ./mvnw package -DskipTests

# ──────────────────────────────────────────
# ÉTAPE 2 : RUN
# ──────────────────────────────────────────

# Image légère, sans Maven ni sources
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copier uniquement le .jar produit à l'étape précédente
COPY --from=build /app/target/*.jar app.jar

# Exposer le port de l'application
EXPOSE 8080

# Commande de démarrage
ENTRYPOINT ["java", "-jar", "app.jar"]
