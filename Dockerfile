FROM jenkins/jenkins:lts-jdk17

USER root

# On télécharge directement le binaire client Docker (statique)
# Cela évite les erreurs de dépôts 'apt-get update'
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-24.0.7.tgz \
    | tar -xzC /usr/local/bin --strip-components=1 docker/docker

# On redonne les droits à l'utilisateur jenkins
USER jenkins
