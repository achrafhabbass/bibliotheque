# Guide CI/CD – BiblioGest

Pipeline complète : **Lint → Tests → Qualité → Package → Docker → Sécurité → Notification**

Stack couverte : **GitHub Actions · GitLab CI/CD · Jenkins · CircleCI · Travis CI · Docker · SonarCloud / SonarQube · Trivy · Slack**

---

## Table des matières

1. [Prérequis](#1-prérequis)
2. [Structure des fichiers CI/CD](#2-structure-des-fichiers-cicd)
3. [Exécuter en local](#3-exécuter-en-local)
4. [Pipeline GitHub Actions](#4-pipeline-github-actions)
5. [Pipeline GitLab CI/CD](#5-pipeline-gitlab-cicd)
6. [Pipeline Jenkins](#6-pipeline-jenkins)
7. [Pipeline CircleCI](#7-pipeline-circleci)
8. [Pipeline Travis CI](#8-pipeline-travis-ci)
9. [SonarCloud vs SonarQube self-hosted](#9-sonarcloud-vs-sonarqube-self-hosted)
10. [Build et déploiement Docker](#10-build-et-déploiement-docker)
11. [Comparaison synthétique des cinq moteurs](#11-comparaison-synthétique-des-cinq-moteurs)
12. [Dépannage](#12-dépannage)

---

## 1. Prérequis

| Outil | Version minimale | Utilité |
|-------|-----------------|---------|
| JDK | 17 | Compilation et tests |
| Maven | 3.9 | Build, tests, SonarCloud |
| Docker | 24 | Build image, docker-compose |
| Git | 2.x | Versionning, déclenchement CI |
| Comptes externes | — | GitHub, GitLab, Docker Hub, SonarCloud, Slack |

---

## 2. Structure des fichiers CI/CD

```
bibliotheque/
├── .github/
│   └── workflows/
│       └── ci-cd.yml              ← Pipeline GitHub Actions
├── .gitlab-ci.yml                 ← Pipeline GitLab CI/CD
├── Jenkinsfile                    ← Pipeline Jenkins déclaratif
├── .circleci/
│   └── config.yml                 ← Pipeline CircleCI
├── .travis.yml                    ← Pipeline Travis CI
├── checkstyle.xml                 ← Règles de lint Checkstyle
├── sonar-project.properties       ← Configuration SonarCloud / SonarQube
├── Dockerfile                     ← Image runtime (multi-stage)
├── .dockerignore
├── docker-compose.yml             ← Stack applicative (Oracle + app)
├── docker-compose.sonarqube.yml   ← SonarQube self-hosted local
├── src/
│   ├── main/java/ma/bibliotheque/
│   │   └── util/
│   │       └── BiblioUtils.java   ← Logique métier testable
│   └── test/java/ma/bibliotheque/
│       ├── unit/
│       │   ├── PasswordUtilTest.java
│       │   └── BiblioUtilsTest.java
│       └── integration/
│           └── LivreResourceIT.java
├── cicd/
│   ├── rapport.tex                ← Rapport LaTeX
│   └── presentation.tex           ← Présentation Beamer
└── CICD-README.md                 ← Ce fichier
```

---

## 3. Exécuter en local

Aucune base de données n'est nécessaire pour les tests — les DAOs sont mockés avec Mockito.

### 3.1 Lint Checkstyle + SpotBugs

```bash
# Checkstyle (lint de style)
mvn checkstyle:check

# SpotBugs (lint sémantique – détection de bugs)
mvn compile spotbugs:check
```

Rapports générés :
- `target/checkstyle-result.xml`
- `target/spotbugsXml.xml`

### 3.2 Tests unitaires + intégration

```bash
# Unitaires uniquement (Surefire, *Test.java)
mvn test

# Unitaires + intégration (Failsafe, *IT.java)
mvn verify
```

### 3.3 Couverture JaCoCo

```bash
mvn verify
# Ouvrir target/site/jacoco/index.html
```

### 3.4 Build complet sans tests

```bash
mvn package -DskipTests
```

---

## 4. Pipeline GitHub Actions

Fichier : [.github/workflows/ci-cd.yml](.github/workflows/ci-cd.yml)

### 4.1 Jobs et dépendances

```
lint ─→ test ─┬─→ quality (main only) ─┐
              ├─→ package ─→ docker (main only) ─→ security-scan ─┐
              │                                                    ↓
              └────────────────────────────────────────────────→ notify
```

| Job | Description | Branche |
|-----|-------------|---------|
| `lint` | Checkstyle + SpotBugs | toutes |
| `test` | Unitaires + intégration + JaCoCo | toutes |
| `quality` | Analyse SonarCloud | main |
| `package` | Build du WAR + upload artifact | toutes |
| `docker` | Build + push sur Docker Hub **et** GHCR | main |
| `security-scan` | Trivy scan de l'image, upload SARIF | main |
| `notify` | Notification Slack succès / échec | main |

### 4.2 Secrets requis

**Settings → Secrets and variables → Actions → Secrets**

| Secret | Description |
|--------|-------------|
| `DOCKER_USERNAME` | Identifiant Docker Hub |
| `DOCKER_PASSWORD` | Token Docker Hub (pas le mot de passe) |
| `SONAR_TOKEN` | Token généré sur SonarCloud |
| `SLACK_WEBHOOK_URL` | URL d'un Incoming Webhook Slack (optionnel) |

**Variables (non chiffrées)** :

| Variable | Description |
|----------|-------------|
| `SONAR_PROJECT_KEY` | Clé du projet SonarCloud |
| `SONAR_ORGANIZATION` | Organisation SonarCloud |

### 4.3 Déclencheurs

- Push sur `main` ou `develop` → pipeline complète (avec quality, docker, security, notify uniquement sur `main`).
- Pull request vers `main` → lint + test + package (sans publication).

---

## 5. Pipeline GitLab CI/CD

Fichier : [.gitlab-ci.yml](.gitlab-ci.yml)

### 5.1 Stages

```yaml
stages:
  - lint
  - test
  - quality
  - package
  - docker
  - security
  - notify
```

### 5.2 Variables CI/CD à définir

**Settings → CI/CD → Variables** :

`DOCKER_USERNAME`, `DOCKER_PASSWORD`, `SONAR_TOKEN`, `SONAR_PROJECT_KEY`, `SONAR_ORGANIZATION`, `SLACK_WEBHOOK_URL`

Cocher **Masked** pour les secrets.

### 5.3 Particularités GitLab

- **Cache Maven** partagé via `cache.key`.
- **Docker-in-Docker** (`docker:24-dind`) pour le job Docker.
- **JUnit reports** intégrés au reporting GitLab via `artifacts:reports:junit`.
- **Coverage** extrait via regex `/Total.*?([0-9]{1,3})%/`.

---

## 6. Pipeline Jenkins

Fichier : [Jenkinsfile](Jenkinsfile)

### 6.1 Credentials Jenkins à créer

**Manage Jenkins → Credentials → System → Global → Add Credentials** :

| ID | Type | Description |
|----|------|-------------|
| `sonar-token` | Secret text | Token SonarCloud |
| `docker-hub` | Username with password | Docker Hub |
| `slack-webhook` | Secret text | Slack webhook URL |

### 6.2 Outils requis

**Manage Jenkins → Global Tool Configuration** :

- JDK nommé `jdk-17`
- Maven nommé `maven-3.9`

### 6.3 Plugins Jenkins requis

- Pipeline
- Docker Pipeline
- Warnings Next Generation (pour `recordIssues`)
- HTML Publisher
- JUnit
- Email Extension
- Workspace Cleanup

### 6.4 Particularités Jenkins

- **Pipeline déclaratif** (plus lisible que scripté).
- **Stages parallèles** (`parallel { ... }`) pour Checkstyle + SpotBugs.
- **Post-actions** (`post { success / failure / unstable / always }`) pour la notification.
- Le seul moteur **self-hosted** par nature (les autres sont SaaS).

---

## 7. Pipeline CircleCI

Fichier : [.circleci/config.yml](.circleci/config.yml)

### 7.1 Variables d'environnement

**Project Settings → Environment Variables** :

`DOCKER_USERNAME`, `DOCKER_PASSWORD`, `SONAR_TOKEN`, `SONAR_PROJECT_KEY`, `SONAR_ORGANIZATION`, `SLACK_WEBHOOK_URL`

### 7.2 Particularités CircleCI

- **Orbs** : modules réutilisables (`circleci/maven`, `circleci/docker`).
- **Executors** nommés (`java-executor`, `docker-executor`).
- **Resource classes** (`medium`) pour dimensionner la VM.
- **Workflow** : orchestration des jobs avec `requires:` et `filters.branches.only:`.
- **persist_to_workspace / attach_workspace** : équivalent des artifacts cross-jobs.

---

## 8. Pipeline Travis CI

Fichier : [.travis.yml](.travis.yml)

### 8.1 Variables d'environnement

**Settings → Environment Variables** (Travis UI) :

Mêmes variables que CircleCI.

### 8.2 Particularités Travis

- Syntaxe la plus **concise** des cinq moteurs (`language`, `jdk`, `services`).
- **Stages** définis dans `stages:` et déclarés dans `jobs.include:`.
- **Workspaces** Travis (équivalent artifacts).
- **Notifications natives** par email en plus de Slack.
- À noter : Travis CI a perdu en popularité depuis 2021 (passage payant pour OSS).

---

## 9. SonarCloud vs SonarQube self-hosted

### 9.1 SonarCloud (SaaS)

Utilisé par défaut dans toutes les pipelines (host = `https://sonarcloud.io`).

**Setup** :
1. Aller sur [sonarcloud.io](https://sonarcloud.io) → se connecter via GitHub.
2. **+** → **Analyze new project** → sélectionner `bibliotheque`.
3. **Administration → Analysis Method → décocher "Automatic Analysis"**.
4. Récupérer `SONAR_TOKEN`, `SONAR_PROJECT_KEY`, `SONAR_ORGANIZATION`.

### 9.2 SonarQube self-hosted (Docker Compose)

Démonstration locale avec [docker-compose.sonarqube.yml](docker-compose.sonarqube.yml) :

```bash
# Sur Linux, augmenter la limite de mémoire virtuelle Elasticsearch
sudo sysctl -w vm.max_map_count=262144

# Démarrer SonarQube + PostgreSQL
docker compose -f docker-compose.sonarqube.yml up -d

# Patience ~2 minutes → http://localhost:9000
# Login : admin / admin (à changer au premier login)
```

Analyse pointant sur l'instance locale :

```bash
mvn verify sonar:sonar \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=<token_genere_dans_sonarqube>
```

### 9.3 Comparaison

| Critère | SonarCloud | SonarQube self-hosted |
|---------|-----------|----------------------|
| Hébergement | SaaS (cloud Sonar) | À votre charge |
| Coût | Gratuit pour OSS public, payant privé | Édition Community gratuite |
| Maintenance | Aucune | Mises à jour, sauvegardes, sécurité |
| Confidentialité du code | Code envoyé chez Sonar | 100% on-prem |
| Intégration CI/CD | Token + URL | Token + URL exposée |
| Idéal pour | Démos, OSS, startups | Entreprises, code confidentiel |

---

## 10. Build et déploiement Docker

### 10.1 Dockerfile multi-stage

L'image est construite en deux étapes :
- **builder** (`eclipse-temurin:17-jdk-alpine`) — compile le WAR avec Maven.
- **runtime** (`tomcat:10.1-jdk17-temurin-alpine`) — récupère uniquement le WAR.

Avantage : l'image finale ne contient pas Maven ni le JDK complet.

### 10.2 Build local

```bash
docker build -t bibliotheque:local .
docker images | grep bibliotheque
```

### 10.3 Lancer la stack complète (app + Oracle)

```bash
docker compose up -d
```

Patience ~90s à 3 min pour l'init d'Oracle XE. Le healthcheck synchronise le démarrage.

```bash
# Schéma + données
docker exec -i oracle-xe sqlplus biblio/biblio123@//localhost:1521/XEPDB1 < schema.sql
docker exec -i oracle-xe sqlplus biblio/biblio123@//localhost:1521/XEPDB1 < data.sql
```

### 10.4 Tester l'API

```bash
curl http://localhost:8080/api/livres | python3 -m json.tool
curl "http://localhost:8080/api/livres?disponible=true"
curl http://localhost:8080/api/livres/1
```

### 10.5 Multi-registry (Docker Hub + GHCR)

La pipeline GitHub Actions publie l'image **simultanément** sur :
- `docker.io/<USER>/bibliotheque:latest` et `:<sha>`
- `ghcr.io/<USER>/bibliotheque:latest` et `:<sha>`

Avantages :
- **Docker Hub** : grand public, intégré nativement à Docker.
- **GHCR** : authentification automatique via `GITHUB_TOKEN`, lien vers le repo.

---

## 11. Comparaison synthétique des cinq moteurs

| Critère | GitHub Actions | GitLab CI/CD | Jenkins | CircleCI | Travis CI |
|---------|---------------|--------------|---------|----------|-----------|
| **Type** | SaaS | SaaS + self-host | Self-host | SaaS | SaaS |
| **Format config** | YAML | YAML | Groovy DSL | YAML | YAML |
| **Concept central** | workflows / jobs / steps | stages / jobs | pipeline / stages / steps | workflows / jobs | stages / jobs |
| **Runner** | GitHub-hosted ou self-hosted | GitLab Runner | Agents | CircleCI executors | Travis VM |
| **Secrets** | Repo / org secrets | CI/CD variables (masked) | Credentials plugin | Project env vars | Encrypted env vars |
| **Cache** | `actions/cache` | `cache: paths:` | Plugin | `save_cache / restore_cache` | `cache:` |
| **Marketplace** | Très riche (Actions) | Modéré | Très riche (plugins) | Orbs | Limité |
| **Docker natif** | Oui (services + buildx) | Oui (DinD) | Plugin Docker | Oui (machine executor) | Oui |
| **Gratuit OSS** | Oui (minutes mensuelles) | Oui (limité) | Gratuit en self-host | Limité | Payant depuis 2021 |
| **Courbe d'apprentissage** | Faible | Faible | Élevée | Moyenne | Faible |
| **Verrouillage fournisseur** | Faible (YAML standard) | Faible | Nul | Moyen | Moyen |
| **Idéal pour** | Projets GitHub | Stack GitLab complète | Entreprise, customisation | Projets cloud-native | Petits projets / héritage |

### 11.1 Concepts clés et leurs équivalents

| Concept | GitHub Actions | GitLab CI | Jenkins | CircleCI | Travis |
|---------|---------------|-----------|---------|----------|--------|
| Unité d'exécution | job | job | stage | job | job |
| Groupe logique | workflow | stage | stage | workflow | stage |
| Dépendance | `needs:` | `needs:` / `stage:` | order in `stages` | `requires:` | order in `stages` |
| Condition | `if:` | `rules:` / `only:` | `when {}` | `filters:` | `if:` (top-level) |
| Artefact entre jobs | `actions/upload-artifact` | `artifacts:` | `archiveArtifacts` | `persist_to_workspace` | `workspaces:` |
| Cache de deps | `actions/cache` | `cache:` | plugin | `save_cache` | `cache:` |
| Secret | `${{ secrets.X }}` | `$X` (masked var) | `credentials('id')` | `$X` (project var) | `$X` (encrypted) |
| Notification | action Slack | `curl` ou intégration | `post {}` | step `notify` | `notifications:` |

### 11.2 Recommandation finale

- **Petite équipe sur GitHub** : GitHub Actions (intégration native, marketplace énorme).
- **Équipe sur GitLab self-host** : GitLab CI/CD (cohérence outil unique).
- **Grand groupe, contraintes on-prem fortes** : Jenkins (extensibilité maximale).
- **Projet cloud-native polyglotte** : CircleCI (orbs, performance).
- **Projet OSS hérité** : Travis CI à éviter aujourd'hui (déclin depuis le passage payant).

---

## 12. Dépannage

### Échec `checkstyle:check`
Lire `target/checkstyle-result.xml`. Ajuster `checkstyle.xml` ou corriger le code. Le seuil par défaut est `warning` — non bloquant.

### Échec `spotbugs:check`
Lire `target/spotbugsXml.xml`. Souvent un cas de NullPointerException potentielle ou de variable non utilisée. Marqué `continue-on-error` dans GitHub Actions et `allow_failure: true` dans GitLab.

### SonarCloud ne reçoit pas la couverture
Vérifier que `target/site/jacoco/jacoco.xml` existe après `mvn verify`. Si absent, vérifier le plugin JaCoCo dans `pom.xml`.

### Trivy bloque sur une CVE
Le scan est configuré avec `exit-code: 0` → information uniquement, pas blocage. Pour rendre bloquant, passer `exit-code: 1` et `ignore-unfixed: false`.

### Slack ne reçoit rien
- Vérifier que `SLACK_WEBHOOK_URL` est bien défini comme **secret** (pas variable).
- Tester le webhook manuellement :
  ```bash
  curl -X POST -H 'Content-type: application/json' \
    --data '{"text":"test"}' "$SLACK_WEBHOOK_URL"
  ```

### SonarQube local ne démarre pas
Sur Linux, augmenter `vm.max_map_count` :
```bash
sudo sysctl -w vm.max_map_count=262144
```
Sur Windows / macOS (Docker Desktop), augmenter la mémoire allouée à ≥ 4 Go.

### `docker compose up` échoue avec "connection refused" Oracle
Le healthcheck du compose synchronise déjà. Si problème persiste, augmenter `start_period` à 180s.

---

*Fin du guide CI/CD multi-outils — Voir le rapport LaTeX dans [cicd/rapport.tex](cicd/rapport.tex) pour l'analyse approfondie.*
