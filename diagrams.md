# Diagrammes UML – BiblioGest

## 1. Diagramme de classes (Modèles)

```mermaid
classDiagram
    class Utilisateur {
        +Long id
        +String nom
        +String prenom
        +String email
        +String motDePasse
        +Role role
        <<enum>> Role: ADMIN, MANAGER
    }

    class Client {
        +Long id
        +String nom
        +String prenom
        +String email
        +String telephone
    }

    class Livre {
        +Long id
        +String titre
        +String isbn
        +BigDecimal tarifJournalier
        +boolean disponible
    }

    class Auteur {
        +Long id
        +String nom
        +String prenom
    }

    class Categorie {
        +Long id
        +String nom
    }

    class Emprunt {
        +Long id
        +LocalDate dateDebut
        +LocalDate dateFinPrevue
        +LocalDate dateFinReelle
        +int dureeJours
        +BigDecimal frais
        +BigDecimal penalite
        +Statut statut
        <<enum>> Statut: EN_COURS, RETOURNE
    }

    class Operation {
        +Long id
        +TypeOperation typeOp
        +BigDecimal montant
        +LocalDate dateOperation
        <<enum>> TypeOperation: EMPRUNT, RETOUR, PENALITE
    }

    Livre        "1..*" --  "0..*" Auteur    : écrit par
    Livre        "1..*" --  "0..*" Categorie : appartient à
    Livre        "1"    --  "0..*" Emprunt   : fait l'objet de
    Client       "1"    --  "0..*" Emprunt   : effectue
    Emprunt      "1"    --  "0..*" Operation : génère
```

---

## 2. Diagramme de cas d'utilisation

```mermaid
graph TD
    Admin(["👤 Admin"])
    Manager(["👤 Manager"])

    Admin --> UC1[Gérer utilisateurs\nAjouter / Modifier / Supprimer]
    Admin --> UC2[Toutes les fonctions manager]

    Manager --> UC3[Se connecter / Déconnecter]
    Manager --> UC4[Gérer livres\nCRUD + recherche]
    Manager --> UC5[Gérer auteurs\nCRUD + recherche]
    Manager --> UC6[Gérer catégories\nCRUD + recherche]
    Manager --> UC7[Gérer clients\nCRUD + recherche]
    Manager --> UC8[Créer un emprunt]
    Manager --> UC9[Retourner un livre]
    Manager --> UC10[Consulter emprunts\nfiltrer par statut]
    Manager --> UC11[Consulter API REST\nlivres en JSON]
```

---

## 3. Diagramme de séquence – Créer un emprunt

```mermaid
sequenceDiagram
    actor M as Manager
    participant S as EmpruntServlet
    participant D as EmpruntDao
    participant DB as Oracle XE

    M->>S: POST /emprunts (clientId, livreId, duree)
    S->>D: hasActiveEmprunt(clientId, livreId)
    D->>DB: SELECT COUNT(*) FROM emprunts WHERE statut='EN_COURS'
    DB-->>D: 0
    D-->>S: false
    S->>D: creerEmprunt(clientId, livreId, duree)
    D->>DB: BEGIN TRANSACTION
    D->>DB: SELECT livre (lock)
    D->>DB: INSERT INTO emprunts
    D->>DB: UPDATE livres SET disponible=0
    D->>DB: INSERT INTO operations (type=EMPRUNT)
    D->>DB: COMMIT
    DB-->>D: OK
    D-->>S: Emprunt
    S->>M: redirect /emprunts + message succès
```

---

## 4. Diagramme de séquence – Retour avec pénalité

```mermaid
sequenceDiagram
    actor M as Manager
    participant S as EmpruntServlet
    participant D as EmpruntDao
    participant DB as Oracle XE

    M->>S: POST /emprunts (action=retour, empruntId)
    S->>D: retournerLivre(empruntId)
    D->>DB: SELECT emprunt + livre
    D->>DB: BEGIN TRANSACTION
    Note over D: today > dateFinPrevue ?
    D->>DB: UPDATE emprunts SET statut=RETOURNE, penalite=X
    D->>DB: UPDATE livres SET disponible=1
    D->>DB: INSERT INTO operations (type=PENALITE, montant=X)
    D->>DB: INSERT INTO operations (type=RETOUR, montant=0)
    D->>DB: COMMIT
    DB-->>D: OK
    D-->>S: Emprunt mis à jour
    S->>M: redirect /emprunts + message succès
```

---

## 5. Diagramme d'activité – Authentification

```mermaid
flowchart TD
    A([Début]) --> B[Afficher formulaire login]
    B --> C[Saisir email + mot de passe]
    C --> D[POST /login]
    D --> E{Email trouvé\ndans la DB ?}
    E -- Non --> F[Afficher erreur]
    F --> B
    E -- Oui --> G{Hash MDP\ncorrespond ?}
    G -- Non --> F
    G -- Oui --> H[Créer HTTPSession\nstorer Utilisateur]
    H --> I[Redirect /livres]
    I --> J([Fin])
```

---

## 6. Diagramme d'activité – Cycle d'un emprunt

```mermaid
flowchart TD
    A([Début]) --> B[Manager sélectionne\nclient + livre + durée]
    B --> C{Livre\ndisponible ?}
    C -- Non --> D[Erreur : livre indisponible]
    D --> A
    C -- Oui --> E{Emprunt EN_COURS\nexistant pour ce\nclient + livre ?}
    E -- Oui --> F[Erreur : doublon]
    F --> A
    E -- Non --> G[Calculer frais\n= durée × tarif]
    G --> H[Créer Emprunt EN_COURS]
    H --> I[Marquer livre non disponible]
    I --> J[Enregistrer opération EMPRUNT]
    J --> K([En attente de retour])
    K --> L[Manager déclenche retour]
    L --> M{Date retour\n> date prévue ?}
    M -- Oui --> N[Calculer pénalité\n= excès × tarif × 1.5]
    N --> O[Enregistrer opération PENALITE]
    O --> P[Passer statut RETOURNE]
    M -- Non --> P
    P --> Q[Marquer livre disponible]
    Q --> R[Enregistrer opération RETOUR]
    R --> S([Fin])
```
