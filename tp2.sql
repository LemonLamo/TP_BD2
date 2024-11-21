-- Active: 1731451074068@@127.0.0.1@1521

--commande d'execution du tp1
@C:\Users\khbic\OneDrive\Bureau\L3\BD2\TP\tp1.sql --execute le tp1

--Partie creation des vues 
--question 1
CREATE VIEW ListeBiologistes AS
SELECT NumB, Nom, Prenom FROM Biologiste;

SELECT * FROM ListeBiologistes;

--question 2
INSERT INTO Biologiste (NumB, Nom, Prenom, Specialite, RoleB)
VALUES (11, 'Saadi', 'Amine', 'Biologie', 'Aide-laboratoire');

SELECT * FROM ListeBiologistes;
--commentaire : chaque ajout ou modification qui se fais dans la table va avoir un effet sur la vue 

--question 3
CREATE VIEW ListeNomsBiologistes AS
SELECT Nom, Prenom FROM Biologiste;

SELECT * FROM ListeNomsBiologistes;

--question 4
CREATE VIEW PreBiologiste AS
SELECT NumPr, COUNT(NumB) AS NbBio
FROM EffectuePrelevement
GROUP BY NumPr;

SELECT * FROM PreBiologiste;

--question 5
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (11, 3, 4);

INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (11, 9, 12);

SELECT * FROM PreBiologiste;
--observation : la modification de la table a modifié le contenue de la vue 

--question 6
SELECT Nom, Prenom 
FROM Biologiste 
WHERE NumB IN (
    SELECT NumB 
    FROM EffectuePrelevement 
    GROUP BY NumB 
    HAVING COUNT(NumPr) = (
        SELECT MIN(part_count) 
        FROM (
            SELECT COUNT(NumPr) AS part_count 
            FROM EffectuePrelevement 
            GROUP BY NumB
        )
    )
);
--im not sure about this one x)

--question 7 
--suppression du biologiste 
DELETE FROM Biologiste WHERE Nom = 'Saadi' AND Prenom = 'Amine';

SELECT NumPr 
FROM PreBiologiste 
WHERE NbBio = (
    SELECT MAX(NbBio) FROM PreBiologiste
);

--partie 2 : Mise a jour a travers les vues 
--question 1
INSERT INTO ListeBiologistes (NumB, Nom, Prenom)
VALUES (12, 'Rabhi', 'Smail');

SELECT * FROM ListeBiologistes;

SELECT * FROM Biologiste;
--commentaire : nous avons rajouté un tuple dans la vue crée a partir de biologiste mais 
--cela n'a crée aucun changement dans la table d'origine , cela est expliqué par les conditions de oracle des mises a jour dans les vues 

--question 2

UPDATE ListeBiologistes 
SET Nom = 'nouveaunom' 
WHERE NumB = 12;

DELETE FROM ListeBiologistes 
WHERE NumB = 12;

SELECT * FROM ListeBiologistes;
SELECT * FROM Biologiste;

--commentaire : avec oracle ,les updates et les deletes sont possibles 
--si la vue est relié a la table de base sans aggregation

-- question 3
INSERT INTO ListeNomsBiologistes (Nom, Prenom)
VALUES ('Boukhari', 'Ryma');
--commentaire: cela va créer une erreur car la vue crée a partir de la table biologiste
--est faite sans utilliser de clé primaire (numB) , donc l'insertion n'est pas authorisé a cause de l'information manquante

--question 4
create table EffectuePrelevement2  (
   NumB                INTEGER,
   NumP                INTEGER,
   NumPr                INTEGER,
   constraint SK_EPrelevement21 FOREIGN KEY (NumB) REFERENCES Biologiste(NumB),
   constraint SK_EPrelevement22 FOREIGN KEY (NumP) REFERENCES Patient(NumP),
   constraint SK_EPrelevement23 FOREIGN KEY (NumPr) REFERENCES Prelevement(NumPr)
);

--question 5 
--remplir effectprelev2 a partir de effectprelev1
INSERT INTO EffectuePrelevement2
SELECT * FROM EffectuePrelevement;

--question 6
CREATE VIEW VBiologiste AS 
SELECT NumB FROM EffectuePrelevement2 GROUP BY NumB;

--que fait cette vue ?
--la vue sert a identifier quels biologistes ont participé aux prélèvements en regroupant leurs identifiants 

--question 7

INSERT INTO VBiologiste VALUES (13);
INSERT INTO VBiologiste VALUES (9);

SELECT * FROM EffectuePrelevement2;

--commentaire : cette commande crée une erreur car vu que 
--la vue VBiologiste est crée en utillisant un GROUP BY ce qui la rend read-only
--on ne peut pas inserer des données dans une vue groupé 

--question 8
--replacing the view we created 
CREATE OR REPLACE VIEW VBiologiste AS 
SELECT NumB, COUNT(*) AS CountPrelevements 
FROM EffectuePrelevement2 
GROUP BY NumB;

SELECT * FROM VBiologiste;

--cette vue calcule le nombre de prelevements de chaque biologiste 

--question 9 
INSERT INTO VBiologiste VALUES (18, 3);
INSERT INTO VBiologiste VALUES (10, 2);

--cette commande va créer une erreur car on peut pas inserer des données dans une vue groupé 

--question 10
-- Try to insert into the view
INSERT INTO PreBiologiste VALUES (13, 2);

--ici aussi c'est pas authorisé de faire le insert car la vue contient une aggregation (count(numB)) donc
--elle deviens read-only

--question 11

--creer une nouvelle vue qui comporte une jointure entre resultat et prelevement
CREATE VIEW ResultatPrelevementView AS 
SELECT r.NumR, p.NumPr, r.TypeResultat, p.TypePr 
FROM Resultat r 
JOIN Prelevement p ON r.NumPr = p.NumPr;


SELECT * FROM ResultatPrelevementView;

INSERT INTO ResultatPrelevementView (NumR, NumPr, TypeResultat, TypePr)
VALUES (15, 5, 'NewResult', 'NewType');












