-- Active: 1731451074068@@127.0.0.1@1521@XE@SYSTEM


ALTER PROFILE DEFAULT LIMIT PASSWORD_VERIFY_FUNCTION NULL;

create user lamo identified by "Admin123!";


GRANT ALL PRIVILEGES ON TO lamo;


CREATE TABLE Biologiste (
    NumB INT PRIMARY KEY ,  
    Nom VARCHAR(50),
    Prenom VARCHAR(50),
    Specialite VARCHAR(50),
    RoleB VARCHAR(50)
);


CREATE TABLE Patient (
    NumP INT PRIMARY KEY, 
    Nom VARCHAR(50),
    Prenom VARCHAR(50),
    DateNaissance DATE
);


CREATE TABLE Prelevement (
    NumPr INT PRIMARY KEY,  
    NumP INT, 
    DatePr DATE,
    TypePr VARCHAR(50),
    CONSTRAINT fk_Prelevement_Patient FOREIGN KEY (NumP) REFERENCES Patient(NumP) ON DELETE CASCADE
);


CREATE TABLE EffectuePrelevement (
    NumB INT, 
    NumP INT,  
    NumPr INT,  
    PRIMARY KEY (NumB, NumP, NumPr),  
    CONSTRAINT fk_EffectuePrelevement_Biologiste FOREIGN KEY (NumB) REFERENCES Biologiste(NumB) ON DELETE CASCADE,
    CONSTRAINT fk_EffectuePrelevement_Patient FOREIGN KEY (NumP) REFERENCES Patient(NumP) ON DELETE CASCADE,
    CONSTRAINT fk_EffectuePrelevement_Prelevement FOREIGN KEY (NumPr) REFERENCES Prelevement(NumPr) ON DELETE CASCADE
);

-- Table Resultat
CREATE TABLE Resultat (
    NumR INT PRIMARY KEY ,  
    NumPr INT, 
    TypePr VARCHAR(50),
    Resul VARCHAR(100),
    Norme VARCHAR(100),
    Conclusion VARCHAR(200),
    CONSTRAINT fk_Resultat_Prelevement FOREIGN KEY (NumPr) REFERENCES Prelevement(NumPr) ON DELETE CASCADE
);

INSERT INTO Biologiste (NumB, Nom, Prenom, Specialite, RoleB) VALUES (1, 'BADI', 'Salim', 'Microbio', 'Biologiste-Responsable');
INSERT INTO Biologiste (NumB, Nom, Prenom, Specialite, RoleB) VALUES (2, 'AMRAN', 'Zineb', 'Bio-Med', 'Biologist-Médical');
INSERT INTO Biologiste (NumB, Nom, Prenom, Specialite, RoleB) VALUES (3, 'SAHLI', 'Lamia', 'Ingénieur', 'Ing-Qualité');
INSERT INTO Biologiste (NumB, Nom, Prenom, Specialite, RoleB) VALUES (4, 'NADIR', 'Ahmed', 'Biologie', 'Aide-laboratoire');
INSERT INTO Biologiste (NumB, Nom, Prenom, Specialite, RoleB) VALUES (5, 'BENMIHOUB', 'Djamila', 'Ingénieur', 'Secrétaire');
INSERT INTO Biologiste (NumB, Nom, Prenom, Specialite, RoleB) VALUES (6, 'CHERGUI', 'Selma', 'Technicien', 'Technicien');
INSERT INTO Biologiste (NumB, Nom, Prenom, Specialite, RoleB) VALUES (7, 'BOUSALEM', 'Ziad', 'Biologie', 'Aide-laboratoire');
INSERT INTO Biologiste (NumB, Nom, Prenom, Specialite, RoleB) VALUES (8, 'KADI', 'Nadia', 'Ingénieur', 'Ing-Informatique');
INSERT INTO Biologiste (NumB, Nom, Prenom, Specialite, RoleB) VALUES (9, 'SMATI', 'Radia', 'Bio-Med', 'Biologist-Médical');
INSERT INTO Biologiste (NumB, Nom, Prenom, Specialite, RoleB) VALUES (10, 'NAILI', 'Mourad', 'Bio-Med', 'Biologist-Médical');



SELECT * from biologiste ; 


   INSERT INTO Patient (NumP, Nom, Prenom, DateNaissance) VALUES (1, 'SAIDI', 'Ryad', TO_DATE('1970-02-10', 'YYYY-MM-DD'));
   INSERT INTO Patient (NumP, Nom, Prenom, DateNaissance) VALUES (2, 'BELHADJ', 'Selma', TO_DATE('1976-03-21', 'YYYY-MM-DD')) ;
   INSERT INTO Patient (NumP, Nom, Prenom, DateNaissance) VALUES (3, 'DIB', 'Ahmed', TO_DATE('2000-08-03', 'YYYY-MM-DD')) ;
  INSERT  INTO Patient (NumP, Nom, Prenom, DateNaissance) VALUES (4, 'BRAHIMI', 'Djalil', TO_DATE('2002-06-22', 'YYYY-MM-DD')) ;
  INSERT  INTO Patient (NumP, Nom, Prenom, DateNaissance) VALUES (5, 'SYAD', 'Hadjer', TO_DATE('1999-09-14', 'YYYY-MM-DD'));
  INSERT  INTO Patient (NumP, Nom, Prenom, DateNaissance) VALUES (6, 'NAIM', 'Fouad', TO_DATE('1998-07-23', 'YYYY-MM-DD'));
   INSERT INTO Patient (NumP, Nom, Prenom, DateNaissance) VALUES (7, 'KADRI', 'Amine', TO_DATE('1970-05-28', 'YYYY-MM-DD'));
   INSERT INTO Patient (NumP, Nom, Prenom, DateNaissance) VALUES (8, 'SEDDIKI', 'Wail', TO_DATE('1986-10-20', 'YYYY-MM-DD'));
   INSERT INTO Patient (NumP, Nom, Prenom, DateNaissance) VALUES (9, 'AITALI', 'Bahia', TO_DATE('1950-10-08', 'YYYY-MM-DD'));
   INSERT INTO Patient (NumP, Nom, Prenom, DateNaissance) VALUES (10, 'SENDJAK', 'Raouf', TO_DATE('1968-04-02', 'YYYY-MM-DD'));




SELECT * FROM patient; 



SELECT * FROM prelevement;

INSERT INTO Prelevement (NumPr, NumP, DatePr, TypePr) VALUES (1, 1, TO_DATE('2022-02-04', 'YYYY-MM-DD'), 'Sanguin');
INSERT INTO Prelevement (NumPr, NumP, DatePr, TypePr) VALUES (2, 1, TO_DATE('2022-02-04', 'YYYY-MM-DD'), 'Nasopharyngé');
INSERT INTO Prelevement (NumPr, NumP, DatePr, TypePr) VALUES (3, 2, TO_DATE('2022-02-04', 'YYYY-MM-DD'), 'Sanguin');
INSERT INTO Prelevement (NumPr, NumP, DatePr, TypePr) VALUES (4, 3, TO_DATE('2022-02-04', 'YYYY-MM-DD'), 'Cutanéo-Muqueux');
INSERT INTO Prelevement (NumPr, NumP, DatePr, TypePr) VALUES (5, 3, TO_DATE('2022-02-04', 'YYYY-MM-DD'), 'Sanguin');
INSERT INTO Prelevement (NumPr, NumP, DatePr, TypePr) VALUES (6, 4, TO_DATE('2022-02-04', 'YYYY-MM-DD'), 'Nasopharyngé');
INSERT INTO Prelevement (NumPr, NumP, DatePr, TypePr) VALUES (7, 5, TO_DATE('2022-02-05', 'YYYY-MM-DD'), 'Sanguin');
INSERT INTO Prelevement (NumPr, NumP, DatePr, TypePr) VALUES (8, 6, TO_DATE('2022-02-05', 'YYYY-MM-DD'), 'Sanguin');
INSERT INTO Prelevement (NumPr, NumP, DatePr, TypePr) VALUES (9, 7, TO_DATE('2022-02-05', 'YYYY-MM-DD'), 'Nasopharyngé');
INSERT INTO Prelevement (NumPr, NumP, DatePr, TypePr) VALUES (10, 8, TO_DATE('2022-02-05', 'YYYY-MM-DD'), 'Cutanéo-Muqueux');
INSERT INTO Prelevement (NumPr, NumP, DatePr, TypePr) VALUES (11, 8, TO_DATE('2022-02-05', 'YYYY-MM-DD'), 'Sanguin');
INSERT INTO Prelevement (NumPr, NumP, DatePr, TypePr) VALUES (12, 9, TO_DATE('2022-02-05', 'YYYY-MM-DD'), 'Sanguin');
INSERT INTO Prelevement (NumPr, NumP, DatePr, TypePr) VALUES (13, 10, TO_DATE('2022-02-06', 'YYYY-MM-DD'), 'Sanguin');


INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (7, 1, 1);
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (1, 1, 2);
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (2, 2, 3);
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (10, 3, 4);
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (4, 3, 4);
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (9, 3, 5);
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (2, 4, 6);
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (9, 5, 7);
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (4, 5, 7);
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (7, 6, 8);
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (1, 7, 9);
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (10, 8, 10);
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (1, 8, 11);
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (2, 9, 12);
INSERT INTO EffectuePrelevement (NumB, NumP, NumPr) VALUES (7, 10, 13);


--DESCRIBE Resultat;

SELECT column_name 
FROM user_tab_columns 
WHERE table_name = 'RESULTAT';


INSERT INTO Resultat (NumR, NumPr, TypePr, Resul, Norme, Conclusion) VALUES (1, 1, 'Hemoglobine', 10.2, '12 a 16g/dL', 'Anemie');
INSERT INTO Resultat (NumR, NumPr, TypePr, Resul, Norme, Conclusion) VALUES (2, 1, 'Plaquettes', '155k', '150k a 400k/mm3', 'Sans Particularite');
INSERT INTO Resultat (NumR, NumPr, TypePr, Resul, Norme, Conclusion) VALUES (3, 1, 'Leucocytes', 6.2, '4k a 10k/mm3', 'Sans Particularite');
INSERT INTO Resultat (NumR, NumPr, TypePr, Resul, Norme, Conclusion) VALUES (4, 1, 'Lymphocytes', 4.8, '1.5k a 4k/mm3', 'Poss. Infection');
INSERT INTO Resultat (NumR, NumPr, TypePr, Resul, Norme, Conclusion) VALUES (5, 2, 'Antig-Covid', 0.2, '>0.5', 'Negatif');
INSERT INTO Resultat (NumR, NumPr, TypePr, Resul, Norme, Conclusion) VALUES (6, 3, 'Groupage', 'A R+', 'A, B, AB, O -+', 'A+');
INSERT INTO Resultat (NumR, NumPr, TypePr, Resul, Norme, Conclusion) VALUES (7, 4, 'Culture', 'Staphyl.', '-', 'Infection au Staphylococcus');
INSERT INTO Resultat (NumR, NumPr, TypePr, Resul, Norme, Conclusion) VALUES (8, 4, 'Sens. Antibiotique', '+Amoxicilline', '-', 'Sensible a l''Amoxicilline');
INSERT INTO Resultat (NumR, NumPr, TypePr, Resul, Norme, Conclusion) VALUES (9, 5, 'Hemoglobine', 13.2, '12 a 16g/dL', 'Sans Particularite');
INSERT INTO Resultat (NumR, NumPr, TypePr, Resul, Norme, Conclusion) VALUES (10, 5, 'Plaquettes', '235k', '150k a 400k/mm3', 'Sans Particularite');
INSERT INTO Resultat (NumR, NumPr, TypePr, Resul, Norme, Conclusion) VALUES (11, 5, 'Leucocytes', 8.1, '4k a 10k/mm3', 'Sans Particularite');
INSERT INTO Resultat (NumR, NumPr, TypePr, Resul, Norme, Conclusion) VALUES (12, 5, 'Lymphocytes', 2.8, '1.5k a 4k/mm3', 'Sans Particularite');
INSERT INTO Resultat (NumR, NumPr, TypePr, Resul, Norme, Conclusion) VALUES (13, 6, 'Antig-Covid', 12.6, '>0.5', 'Positif');
INSERT INTO Resultat (NumR, NumPr, TypePr, Resul, Norme, Conclusion) VALUES (14, 7, 'PCR Covid', 8.2, '>0.5', 'Positif');


ALTER TABLE Resultat 
ADD TypeRes VARCHAR2(50);


SELECT * FROM resultat; 

ALTER TABLE resultat
DROP COLUMN TypePr;

-- Cardinalité (nombre de lignes)
SELECT COUNT(*) AS cardinalite FROM Biologiste;
SELECT COUNT(*) AS cardinalite FROM Patient;
SELECT COUNT(*) AS cardinalite FROM Prelevement;
SELECT COUNT(*) AS cardinalite FROM Resultat;

-- Degré (nombre de colonnes)
SELECT COUNT(*) AS degre FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'BIOLOGISTE';
SELECT COUNT(*) AS degre FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'PATIENT';
SELECT COUNT(*) AS degre FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'PRELEVEMENT';SELECT COUNT(*) AS degre FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'RESULTAT';



ALTER TABLE resultat
RENAME COLUMN TypeRes TO TypeResultat ;

ALTER TABLE Resultat MODIFY Conclusion VARCHAR2(100);



Describe Resultat ;

--creation d'index
CREATE INDEX idx_patient_nom ON patient(Nom);

SELECT INDEX_NAME, TABLE_NAME 
 FROM  USER_INDEXES;

--catalogues
--Afficher le catalogue des tables et décrire ses attributs
SELECT * FROM USER_TABLES;
SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'BIOLOGISTE';

--Lister les contraintes de la table « Biologiste »
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, STATUS FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'BIOLOGISTE';

--Lister toutes les contraintes de ce schéma (base de données actuelle)
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME FROM USER_CONSTRAINTS;

--Créer un index primaire sur la table « Patient »
ALTER TABLE Patient ADD CONSTRAINT PK_Patient PRIMARY KEY (NumP);

--Créer un index secondaire

CREATE INDEX idx_patient_nom ON Patient (Nom);

--Afficher l’ensemble des index existants
SELECT INDEX_NAME, TABLE_NAME, UNIQUENESS FROM USER_INDEXES;

--interrogation tables

--Quels sont les Biologistes qui participent dans le plus de prélèvements ? le moins de prélèvements ?
SELECT NumB, COUNT(NumPr) AS Nombre_Prelevements 
FROM EffectuePrelevement 
GROUP BY NumB 
ORDER BY Nombre_Prelevements DESC;

--Nombre de tests COVID Positifs, en précisant le type de prélèvemen
SELECT COUNT(*), x.TypePr FROM Prelevement x, Resultat y 
WHERE y.NumPr = x.NumPr AND y.Conclusion = 'Positif' GROUP BY x.TypePr;

--Âge des patients testés positifs au COVID-19 en Février
SELECT TRUNC(MONTHS_BETWEEN(SYSDATE,DateNaissance)/12) FROM Patient z, Resultat y, Prelevement x 
WHERE y.NumPr = x.NumPr AND y.Conclusion = 'Positif' AND z.NumP = x.NumP;

--Lister les types de prélèvements effectués par ce laboratoire
SELECT DISTINCT TypePr FROM Prelevement;









