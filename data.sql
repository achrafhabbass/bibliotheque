-- ============================================================
--  BiblioGest – Données de test
--  Exécuter en tant que : biblio@XEPDB1
--  Prérequis : schema.sql déjà exécuté (admin existant, séquences créées)
-- ============================================================

-- ============================================================
-- AUTEURS (20)
-- ============================================================
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Camus',           'Albert');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Flaubert',        'Gustave');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Hugo',            'Victor');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'de Beauvoir',     'Simone');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Proust',          'Marcel');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'de Saint-Exupery','Antoine');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Zola',            'Emile');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Cohen',           'Albert');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Houellebecq',     'Michel');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Modiano',         'Patrick');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Murakami',        'Haruki');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Orwell',          'George');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Rowling',         'Joanne');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Christie',        'Agatha');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Asimov',          'Isaac');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Descartes',       'Rene');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Sartre',          'Jean-Paul');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Arouet',          'Francois-Marie');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Kafka',           'Franz');
INSERT INTO auteurs VALUES (AUTEUR_SEQ.NEXTVAL, 'Dumas',           'Alexandre');

-- ============================================================
-- CATEGORIES (8)
-- ============================================================
INSERT INTO categories VALUES (CAT_SEQ.NEXTVAL, 'Roman');
INSERT INTO categories VALUES (CAT_SEQ.NEXTVAL, 'Classique');
INSERT INTO categories VALUES (CAT_SEQ.NEXTVAL, 'Science-Fiction');
INSERT INTO categories VALUES (CAT_SEQ.NEXTVAL, 'Policier');
INSERT INTO categories VALUES (CAT_SEQ.NEXTVAL, 'Philosophie');
INSERT INTO categories VALUES (CAT_SEQ.NEXTVAL, 'Fantasy');
INSERT INTO categories VALUES (CAT_SEQ.NEXTVAL, 'Histoire');
INSERT INTO categories VALUES (CAT_SEQ.NEXTVAL, 'Biographie');

-- ============================================================
-- LIVRES (20)
-- disponible = 0 pour les livres actuellement empruntes (emprunts EN_COURS)
--   livre_id 2  -> Madame Bovary       (emprunt client 7)
--   livre_id 6  -> Le Petit Prince     (emprunt client 3)
--   livre_id 12 -> 1984                (emprunt client 4, en retard)
--   livre_id 15 -> Fondation           (emprunt client 6)
-- ============================================================
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'L''Etranger',                      '9782070360024', 3.00,  1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Madame Bovary',                     '9782070408504', 3.50,  0);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Les Miserables',                    '9782070408788', 5.00,  1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Le Deuxieme Sexe',                  '9782070205134', 4.00,  1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Du cote de chez Swann',             '9782070360192', 4.50,  1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Le Petit Prince',                   '9782070612758', 3.00,  0);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Germinal',                          '9782070413126', 3.50,  1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Belle du Seigneur',                 '9782070368662', 5.00,  1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Les Particules elementaires',       '9782080674586', 4.00,  1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'La Place de l''Etoile',             '9782070369980', 3.00,  1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Kafka sur le rivage',               '9782264036971', 5.00,  1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, '1984',                              '9782070368228', 4.50,  0);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Harry Potter a l''ecole des sorciers', '9782070541270', 5.00, 1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Dix Petits Negres',                 '9782702422847', 4.00,  1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Fondation',                         '9782070360420', 5.00,  0);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Discours de la Methode',            '9782080700049', 3.00,  1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'L''Etre et le Neant',               '9782070718009', 4.50,  1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Candide',                           '9782070360048', 3.00,  1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'La Metamorphose',                   '9782070360796', 3.00,  1);
INSERT INTO livres VALUES (LIVRE_SEQ.NEXTVAL, 'Le Comte de Monte-Cristo',          '9782070409228', 6.00,  1);

-- ============================================================
-- LIVRE <-> AUTEUR
-- auteur_id : 1=Camus 2=Flaubert 3=Hugo 4=Beauvoir 5=Proust
--             6=Saint-Ex 7=Zola 8=Cohen 9=Houellebecq 10=Modiano
--             11=Murakami 12=Orwell 13=Rowling 14=Christie 15=Asimov
--             16=Descartes 17=Sartre 18=Arouet(Voltaire) 19=Kafka 20=Dumas
-- NOTE: pas de commentaires inline apres les INSERT (SQL*Plus les avale
-- parfois et fait sauter l'instruction sans erreur visible).
-- ============================================================
INSERT INTO livre_auteur VALUES (1, 1);
INSERT INTO livre_auteur VALUES (2, 2);
INSERT INTO livre_auteur VALUES (3, 3);
INSERT INTO livre_auteur VALUES (4, 4);
INSERT INTO livre_auteur VALUES (5, 5);
INSERT INTO livre_auteur VALUES (6, 6);
INSERT INTO livre_auteur VALUES (7, 7);
INSERT INTO livre_auteur VALUES (8, 8);
INSERT INTO livre_auteur VALUES (9, 9);
INSERT INTO livre_auteur VALUES (10, 10);
INSERT INTO livre_auteur VALUES (11, 11);
INSERT INTO livre_auteur VALUES (12, 12);
INSERT INTO livre_auteur VALUES (13, 13);
INSERT INTO livre_auteur VALUES (14, 14);
INSERT INTO livre_auteur VALUES (15, 15);
INSERT INTO livre_auteur VALUES (16, 16);
INSERT INTO livre_auteur VALUES (17, 17);
INSERT INTO livre_auteur VALUES (18, 18);
INSERT INTO livre_auteur VALUES (19, 19);
INSERT INTO livre_auteur VALUES (20, 20);

-- ============================================================
-- LIVRE <-> CATEGORIE
-- cat_id : 1=Roman 2=Classique 3=SF 4=Policier 5=Philosophie
--          6=Fantasy 7=Histoire 8=Biographie
-- ============================================================
INSERT INTO livre_categorie VALUES (1, 1);
INSERT INTO livre_categorie VALUES (1, 2);
INSERT INTO livre_categorie VALUES (2, 1);
INSERT INTO livre_categorie VALUES (2, 2);
INSERT INTO livre_categorie VALUES (3, 1);
INSERT INTO livre_categorie VALUES (3, 2);
INSERT INTO livre_categorie VALUES (3, 7);
INSERT INTO livre_categorie VALUES (4, 5);
INSERT INTO livre_categorie VALUES (5, 1);
INSERT INTO livre_categorie VALUES (5, 2);
INSERT INTO livre_categorie VALUES (6, 1);
INSERT INTO livre_categorie VALUES (7, 1);
INSERT INTO livre_categorie VALUES (7, 2);
INSERT INTO livre_categorie VALUES (8, 1);
INSERT INTO livre_categorie VALUES (9, 1);
INSERT INTO livre_categorie VALUES (10, 1);
INSERT INTO livre_categorie VALUES (11, 1);
INSERT INTO livre_categorie VALUES (12, 1);
INSERT INTO livre_categorie VALUES (12, 3);
INSERT INTO livre_categorie VALUES (13, 6);
INSERT INTO livre_categorie VALUES (14, 4);
INSERT INTO livre_categorie VALUES (15, 3);
INSERT INTO livre_categorie VALUES (16, 5);
INSERT INTO livre_categorie VALUES (17, 5);
INSERT INTO livre_categorie VALUES (18, 1);
INSERT INTO livre_categorie VALUES (18, 2);
INSERT INTO livre_categorie VALUES (19, 1);
INSERT INTO livre_categorie VALUES (19, 2);
INSERT INTO livre_categorie VALUES (20, 1);
INSERT INTO livre_categorie VALUES (20, 2);
INSERT INTO livre_categorie VALUES (20, 7);

-- ============================================================
-- CLIENTS (10)
-- ============================================================
INSERT INTO clients VALUES (CLIENT_SEQ.NEXTVAL, 'Martin',   'Sophie',   'sophie.martin@email.com',   '0661234501');
INSERT INTO clients VALUES (CLIENT_SEQ.NEXTVAL, 'Dubois',   'Thomas',   'thomas.dubois@email.com',   '0661234502');
INSERT INTO clients VALUES (CLIENT_SEQ.NEXTVAL, 'Leroy',    'Marie',    'marie.leroy@email.com',     '0661234503');
INSERT INTO clients VALUES (CLIENT_SEQ.NEXTVAL, 'Bernard',  'Pierre',   'pierre.bernard@email.com',  '0661234504');
INSERT INTO clients VALUES (CLIENT_SEQ.NEXTVAL, 'Moreau',   'Julie',    'julie.moreau@email.com',    '0661234505');
INSERT INTO clients VALUES (CLIENT_SEQ.NEXTVAL, 'Petit',    'Francois', 'francois.petit@email.com',  '0661234506');
INSERT INTO clients VALUES (CLIENT_SEQ.NEXTVAL, 'Simon',    'Claire',   'claire.simon@email.com',    '0661234507');
INSERT INTO clients VALUES (CLIENT_SEQ.NEXTVAL, 'Laurent',  'Antoine',  'antoine.laurent@email.com', '0661234508');
INSERT INTO clients VALUES (CLIENT_SEQ.NEXTVAL, 'Roux',     'Isabelle', 'isabelle.roux@email.com',   '0661234509');
INSERT INTO clients VALUES (CLIENT_SEQ.NEXTVAL, 'Fontaine', 'Nicolas',  'nicolas.fontaine@email.com','0661234510');

-- ============================================================
-- UTILISATEURS – 2 managers supplementaires
-- Mot de passe Manager1! -> b7621cf4ef17f532847865f8a4116d79af4072dcddf05c9d3acd0be32f0ff801
-- Mot de passe Manager2! -> a024ac6293ac13a6387e2b1732c0129b63d5878dd8df81851613f27fa60980e9
-- ============================================================
INSERT INTO utilisateurs VALUES (UTIL_SEQ.NEXTVAL, 'Dupont', 'Jean',
    'jean.dupont@biblio.ma',
    'b7621cf4ef17f532847865f8a4116d79af4072dcddf05c9d3acd0be32f0ff801',
    'MANAGER');
INSERT INTO utilisateurs VALUES (UTIL_SEQ.NEXTVAL, 'Benali', 'Fatima',
    'fatima.benali@biblio.ma',
    'a024ac6293ac13a6387e2b1732c0129b63d5878dd8df81851613f27fa60980e9',
    'MANAGER');

-- ============================================================
-- EMPRUNTS (8 emprunts : 4 RETOURNE, 4 EN_COURS dont 1 en retard)
--
-- Correspondance client_id :
--   1=Sophie Martin  2=Thomas Dubois  3=Marie Leroy   4=Pierre Bernard
--   5=Julie Moreau   6=Francois Petit 7=Claire Simon
--
-- Correspondance livre_id :
--   1=L'Etranger(3.00)  2=Madame Bovary(3.50)   3=Les Mis.(5.00)
--   6=Petit Prince(3.00) 11=Kafka(5.00)          12=1984(4.50)
--   13=Harry Potter(5.00) 15=Fondation(5.00)
-- ============================================================

-- 1. Sophie Martin / L'Etranger – RETOURNE a l'heure (frais 7j*3.00=21.00)
INSERT INTO emprunts VALUES (
    EMPRUNT_SEQ.NEXTVAL, 1, 1,
    DATE '2026-04-01', DATE '2026-04-08', DATE '2026-04-07',
    7, 21.00, 0, 'RETOURNE');

-- 2. Thomas Dubois / Les Miserables – RETOURNE avec 3j de retard
--    frais=14j*5.00=70.00  penalite=3j*5.00*1.5=22.50
INSERT INTO emprunts VALUES (
    EMPRUNT_SEQ.NEXTVAL, 3, 2,
    DATE '2026-04-05', DATE '2026-04-19', DATE '2026-04-22',
    14, 70.00, 22.50, 'RETOURNE');

-- 3. Marie Leroy / Le Petit Prince – EN_COURS (dans les delais)
INSERT INTO emprunts VALUES (
    EMPRUNT_SEQ.NEXTVAL, 6, 3,
    DATE '2026-05-10', DATE '2026-05-24', NULL,
    14, 42.00, 0, 'EN_COURS');

-- 4. Pierre Bernard / 1984 – EN_COURS mais EN RETARD (date_fin_prevue depassee)
--    frais=14j*4.50=63.00  (penalite calculee au retour)
INSERT INTO emprunts VALUES (
    EMPRUNT_SEQ.NEXTVAL, 12, 4,
    DATE '2026-05-01', DATE '2026-05-15', NULL,
    14, 63.00, 0, 'EN_COURS');

-- 5. Julie Moreau / Harry Potter – RETOURNE a l'heure (frais 10j*5.00=50.00)
INSERT INTO emprunts VALUES (
    EMPRUNT_SEQ.NEXTVAL, 13, 5,
    DATE '2026-04-20', DATE '2026-04-30', DATE '2026-04-29',
    10, 50.00, 0, 'RETOURNE');

-- 6. Francois Petit / Fondation – EN_COURS (dans les delais)
INSERT INTO emprunts VALUES (
    EMPRUNT_SEQ.NEXTVAL, 15, 6,
    DATE '2026-05-12', DATE '2026-05-26', NULL,
    14, 70.00, 0, 'EN_COURS');

-- 7. Sophie Martin / Kafka sur le rivage – RETOURNE avec 2j de retard
--    frais=7j*5.00=35.00  penalite=2j*5.00*1.5=15.00
INSERT INTO emprunts VALUES (
    EMPRUNT_SEQ.NEXTVAL, 11, 1,
    DATE '2026-03-15', DATE '2026-03-22', DATE '2026-03-24',
    7, 35.00, 15.00, 'RETOURNE');

-- 8. Claire Simon / Madame Bovary – EN_COURS (dans les delais)
INSERT INTO emprunts VALUES (
    EMPRUNT_SEQ.NEXTVAL, 2, 7,
    DATE '2026-05-15', DATE '2026-05-29', NULL,
    14, 49.00, 0, 'EN_COURS');

-- ============================================================
-- OPERATIONS
-- emprunt_id : 1..8 dans l'ordre d'insertion ci-dessus
-- ============================================================

-- Emprunt 1 : Sophie / L'Etranger (RETOURNE, pas de penalite)
INSERT INTO operations VALUES (OP_SEQ.NEXTVAL, 1, 'EMPRUNT',  21.00, DATE '2026-04-01');
INSERT INTO operations VALUES (OP_SEQ.NEXTVAL, 1, 'RETOUR',    0.00, DATE '2026-04-07');

-- Emprunt 2 : Thomas / Les Miserables (RETOURNE avec penalite)
INSERT INTO operations VALUES (OP_SEQ.NEXTVAL, 2, 'EMPRUNT',  70.00, DATE '2026-04-05');
INSERT INTO operations VALUES (OP_SEQ.NEXTVAL, 2, 'PENALITE', 22.50, DATE '2026-04-22');
INSERT INTO operations VALUES (OP_SEQ.NEXTVAL, 2, 'RETOUR',    0.00, DATE '2026-04-22');

-- Emprunt 3 : Marie / Le Petit Prince (EN_COURS)
INSERT INTO operations VALUES (OP_SEQ.NEXTVAL, 3, 'EMPRUNT',  42.00, DATE '2026-05-10');

-- Emprunt 4 : Pierre / 1984 (EN_COURS, en retard)
INSERT INTO operations VALUES (OP_SEQ.NEXTVAL, 4, 'EMPRUNT',  63.00, DATE '2026-05-01');

-- Emprunt 5 : Julie / Harry Potter (RETOURNE, pas de penalite)
INSERT INTO operations VALUES (OP_SEQ.NEXTVAL, 5, 'EMPRUNT',  50.00, DATE '2026-04-20');
INSERT INTO operations VALUES (OP_SEQ.NEXTVAL, 5, 'RETOUR',    0.00, DATE '2026-04-29');

-- Emprunt 6 : Francois / Fondation (EN_COURS)
INSERT INTO operations VALUES (OP_SEQ.NEXTVAL, 6, 'EMPRUNT',  70.00, DATE '2026-05-12');

-- Emprunt 7 : Sophie / Kafka sur le rivage (RETOURNE avec penalite)
INSERT INTO operations VALUES (OP_SEQ.NEXTVAL, 7, 'EMPRUNT',  35.00, DATE '2026-03-15');
INSERT INTO operations VALUES (OP_SEQ.NEXTVAL, 7, 'PENALITE', 15.00, DATE '2026-03-24');
INSERT INTO operations VALUES (OP_SEQ.NEXTVAL, 7, 'RETOUR',    0.00, DATE '2026-03-24');

-- Emprunt 8 : Claire / Madame Bovary (EN_COURS)
INSERT INTO operations VALUES (OP_SEQ.NEXTVAL, 8, 'EMPRUNT',  49.00, DATE '2026-05-15');

COMMIT;
