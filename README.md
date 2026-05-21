# BiblioGest – Guide de déploiement
*************just a test "Pipeline"**********

[![CI/CD](https://github.com/VOTRE_USER/bibliotheque/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/VOTRE_USER/bibliotheque/actions/workflows/ci-cd.yml)
[![Quality Gate](https://sonarcloud.io/api/project_badges/measure?project=bibliotheque&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=bibliotheque)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=bibliotheque&metric=coverage)](https://sonarcloud.io/summary/new_code?id=bibliotheque)t
[![Docker](https://img.shields.io/docker/pulls/VOTRE_USER/bibliotheque?logo=docker)](https://hub.docker.com/r/VOTRE_USER/bibliotheque)
[![Java](https://img.shields.io/badge/java-17-orange?logo=openjdk)](https://adoptium.net/)

> Pour le détail du pipeline CI/CD multi-outils (GitHub Actions, GitLab, Jenkins, CircleCI, Travis), voir [CICD-README.md](CICD-README.md).

## Prérequis

| Outil | Version minimale |
|-------|-----------------|
| JDK | 17 |
| Maven | 3.9 |
| Docker | 24 |
| Apache Tomcat | 10.1 |

---

## 1 – Oracle XE avec Docker

```bash
docker pull gvenzl/oracle-xe:21-slim

docker run -d \
  --name oracle-xe \
  -p 1521:1521 \
  -e ORACLE_PASSWORD=oracle123 \
  -e APP_USER=biblio \
  -e APP_USER_PASSWORD=biblio123 \
  gvenzl/oracle-xe:21-slim
```

Attendre ~60 s que le conteneur soit `healthy` :

```bash
docker ps   # vérifier STATUS = healthy
```

La PDB cible est **XEPDB1**. L'image `gvenzl/oracle-xe` crée automatiquement
l'utilisateur `biblio` avec tous les privilèges sur XEPDB1.

---

## 2 – Schéma de base de données

Se connecter en tant que `biblio` sur XEPDB1 et exécuter `schema.sql` :

```bash
docker exec -i oracle-xe sqlplus biblio/biblio123@//localhost:1521/XEPDB1 < schema.sql
```

Cela crée :
- 7 séquences Oracle
- 9 tables (dont 2 tables de jointure)
- Les index nécessaires
- L'utilisateur admin par défaut

**Compte admin par défaut**
- Email : `admin@biblio.ma`
- Mot de passe : `Admin@123`

---

## 3 – Configuration de la connexion

Le fichier `src/main/resources/META-INF/persistence.xml` contient les
paramètres JDBC. Modifier si nécessaire :

```xml
<property name="jakarta.persistence.jdbc.url"      value="jdbc:oracle:thin:@localhost:1521/XEPDB1"/>
<property name="jakarta.persistence.jdbc.user"     value="biblio"/>
<property name="jakarta.persistence.jdbc.password" value="biblio123"/>
```

---

## 4 – Build Maven

```bash
mvn clean package -DskipTests
```

Le WAR est généré dans `target/bibliotheque.war`.

---

## 5 – Déploiement sur Tomcat 10.1

```bash
cp target/bibliotheque.war $CATALINA_HOME/webapps/
$CATALINA_HOME/bin/startup.sh
```

Application accessible sur : **http://localhost:8080/bibliotheque**

---

## 6 – API REST (JAX-RS)

| Méthode | URL | Description |
|---------|-----|-------------|
| GET | `/bibliotheque/api/livres` | Liste de tous les livres |
| GET | `/bibliotheque/api/livres?q=java` | Recherche par mot-clé |
| GET | `/bibliotheque/api/livres?disponible=true` | Livres disponibles |
| GET | `/bibliotheque/api/livres/{id}` | Un livre par ID |

Exemple de réponse :

```json
[
  {
    "id": 1,
    "titre": "Clean Code",
    "isbn": "9780132350884",
    "tarifJournalier": 5.00,
    "disponible": true,
    "auteurs": [{"id": 1, "nom": "Robert Martin"}],
    "categories": [{"id": 2, "nom": "Informatique"}]
  }
]
```

---

## 7 – Structure du projet

```
src/main/java/ma/bibliotheque/
├── util/          JpaUtil, PasswordUtil
├── entities/      Utilisateur, Client, Livre, Auteur,
│                  Categorie, Emprunt, Operation
├── dao/           GenericDao + 6 DAOs spécialisés
├── servlet/       Login, Logout + 6 servlets CRUD
├── rest/          JaxRsApp, LivreResource
└── filter/        AuthFilter (toutes routes), AdminFilter (/utilisateurs/*)
```

---

## 8 – Règles métier importantes

- Un livre marqué **non disponible** ne peut pas être emprunté.
- Un client ne peut avoir qu'**un emprunt EN_COURS** par livre.
- À la création d'un emprunt : `frais = dureeJours × tarifJournalier`.
- Au retour, si `dateRetour > dateFinPrevue` :
  `pénalité = joursExcès × tarifJournalier × 1.5`.
- La suppression du **dernier administrateur** est bloquée.

---

## 9 – Sécurité

- `AuthFilter` intercepte toutes les requêtes sauf `/login` et `/api/*`.
- `AdminFilter` bloque `/utilisateurs/*` pour les non-admins.
- Les mots de passe sont hachés en **SHA-256**.
- Les sessions expirent après **30 minutes** d'inactivité.
- Les cookies de session sont `HttpOnly`.

Readme file 