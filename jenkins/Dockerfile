FROM eclipse-temurin:21-jdk

# Instala Jenkins
RUN curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

RUN echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

RUN apt-get update && apt-get install -y jenkins

# Exponer el puerto 8080 para Jenkins
EXPOSE 8080

# Comando para ejecutar Jenkins
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
