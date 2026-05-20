# ─────────────────────────────────────────────────────────────
#  Dockerfile multi-stage pour BiblioGest
#  Stage 1 (builder) : compile le WAR avec Maven
#  Stage 2 (runtime) : Tomcat 10.1 minimal avec le WAR
# ─────────────────────────────────────────────────────────────

# ===== Stage 1 : Build Maven =====
FROM maven:3.9-eclipse-temurin-17 AS builder
LABEL stage="builder"

WORKDIR /build

# Copie du POM en premier pour profiter du cache Docker
# si les dépendances ne changent pas.
COPY pom.xml ./
RUN mvn -B dependency:go-offline --no-transfer-progress || true

# Copie du code source et compilation
COPY src ./src
COPY checkstyle.xml ./
RUN mvn -B package -DskipTests --no-transfer-progress

# ===== Stage 2 : Runtime Tomcat =====
FROM tomcat:10.1-jdk17-temurin AS runtime

LABEL maintainer="bibliotheque"
LABEL org.opencontainers.image.title="BiblioGest"
LABEL org.opencontainers.image.description="Application de gestion de bibliothèque"
LABEL org.opencontainers.image.source="https://github.com/VOTRE_USER/bibliotheque"
LABEL org.opencontainers.image.licenses="MIT"

# Nettoyage des webapps par défaut
RUN rm -rf /usr/local/tomcat/webapps/*

# Récupération du WAR depuis le stage builder
COPY --from=builder /build/target/bibliotheque.war /usr/local/tomcat/webapps/ROOT.war

# Variables d'environnement (DB) – override possible au runtime
ENV DB_URL=jdbc:oracle:thin:@oracle-xe:1521/XEPDB1 \
    DB_USER=biblio \
    DB_PASSWORD=biblio123 \
    JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

# Installation de wget pour le healthcheck (image Debian)
RUN apt-get update && apt-get install -y --no-install-recommends wget && \
    rm -rf /var/lib/apt/lists/*

# Exécution sans root pour des raisons de sécurité
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat && \
    chown -R tomcat:tomcat /usr/local/tomcat
USER tomcat

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=3 \
    CMD wget -qO- http://localhost:8080/api/livres >/dev/null 2>&1 || exit 1

CMD ["catalina.sh", "run"]
