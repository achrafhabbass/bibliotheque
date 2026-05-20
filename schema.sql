-- ============================================================
--  BiblioGest – Oracle XE Schema
--  User: biblio  |  PDB: XEPDB1
-- ============================================================

-- Sequences
CREATE SEQUENCE UTIL_SEQ    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE AUTEUR_SEQ  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE CAT_SEQ     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE LIVRE_SEQ   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE CLIENT_SEQ  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE EMPRUNT_SEQ START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE OP_SEQ      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Tables
CREATE TABLE utilisateurs (
    id          NUMBER          PRIMARY KEY,
    nom         VARCHAR2(50)    NOT NULL,
    prenom      VARCHAR2(50)    NOT NULL,
    email       VARCHAR2(100)   NOT NULL UNIQUE,
    mot_de_passe VARCHAR2(255)  NOT NULL,
    role        VARCHAR2(10)    NOT NULL CHECK (role IN ('ADMIN','MANAGER'))
);

CREATE TABLE auteurs (
    id      NUMBER          PRIMARY KEY,
    nom     VARCHAR2(50)    NOT NULL,
    prenom  VARCHAR2(50)    NOT NULL
);

CREATE TABLE categories (
    id  NUMBER          PRIMARY KEY,
    nom VARCHAR2(50)    NOT NULL UNIQUE
);

CREATE TABLE livres (
    id               NUMBER           PRIMARY KEY,
    titre            VARCHAR2(200)    NOT NULL,
    isbn             VARCHAR2(20)     UNIQUE,
    tarif_journalier NUMBER(10,2)     NOT NULL,
    disponible       NUMBER(1)        DEFAULT 1 NOT NULL CHECK (disponible IN (0,1))
);

CREATE TABLE livre_auteur (
    livre_id   NUMBER NOT NULL REFERENCES livres(id)  ON DELETE CASCADE,
    auteur_id  NUMBER NOT NULL REFERENCES auteurs(id) ON DELETE CASCADE,
    PRIMARY KEY (livre_id, auteur_id)
);

CREATE TABLE livre_categorie (
    livre_id     NUMBER NOT NULL REFERENCES livres(id)     ON DELETE CASCADE,
    categorie_id NUMBER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (livre_id, categorie_id)
);

CREATE TABLE clients (
    id         NUMBER          PRIMARY KEY,
    nom        VARCHAR2(50)    NOT NULL,
    prenom     VARCHAR2(50)    NOT NULL,
    email      VARCHAR2(100)   NOT NULL UNIQUE,
    telephone  VARCHAR2(20)
);

CREATE TABLE emprunts (
    id             NUMBER          PRIMARY KEY,
    livre_id       NUMBER          NOT NULL REFERENCES livres(id),
    client_id      NUMBER          NOT NULL REFERENCES clients(id),
    date_debut     DATE            NOT NULL,
    date_fin_prevue DATE           NOT NULL,
    date_fin_reelle DATE,
    duree_jours    NUMBER          NOT NULL CHECK (duree_jours >= 1),
    frais          NUMBER(10,2)    NOT NULL,
    penalite       NUMBER(10,2)    DEFAULT 0,
    statut         VARCHAR2(10)    NOT NULL CHECK (statut IN ('EN_COURS','RETOURNE'))
);

CREATE TABLE operations (
    id             NUMBER          PRIMARY KEY,
    emprunt_id     NUMBER          NOT NULL REFERENCES emprunts(id),
    type_op        VARCHAR2(10)    NOT NULL CHECK (type_op IN ('EMPRUNT','RETOUR','PENALITE')),
    montant        NUMBER(10,2)    NOT NULL,
    date_operation DATE            NOT NULL
);

-- Indexes
CREATE INDEX idx_emprunt_client ON emprunts(client_id);
CREATE INDEX idx_emprunt_livre  ON emprunts(livre_id);
CREATE INDEX idx_emprunt_statut ON emprunts(statut);
CREATE INDEX idx_op_emprunt     ON operations(emprunt_id);

-- ============================================================
--  Initial admin user
--  Email: admin@biblio.ma  |  Password: Admin@123
--  SHA-256("Admin@123") = below hash
-- ============================================================
INSERT INTO utilisateurs (id, nom, prenom, email, mot_de_passe, role)
VALUES (UTIL_SEQ.NEXTVAL, 'System', 'Admin', 'admin@biblio.ma',
        'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7', 'ADMIN');

COMMIT;
