-- Active: 1731451074068@@127.0.0.1@1521@XE@SYSTEM

--LAMIA KOUCEM GROUPE 1


--lister les contraines d'integrité du schema
SELECT 
     table_name,
     constraint_name,
     constraint_type
     FROM
     user_constraints
    ORDER BY table_name;
--C pour check, P pour primary key, U pour unique, R pour foreign key

--question 2
--etendre la liste des roles possibles 
ALTER TABLE BIOLOGISTE
ADD CONSTRAINT chk_role_biologiste
CHECK (RoleB IN ('Biologiste-Responsable', 'Ing-Qualité', 'Aide-Laboratoire', 'Secrétaire', 'Technicien', 'Ing-Informatique','Biologist-Médical', 'B-M à Domicile'));

--question 3 exiger une date pour qu'elle sois anterieur a la date d'aujoudhui
ALTER TABLE PATIENT
ADD CONSTRAINT chk_date_naissance
CHECK (DateNaissance < SYSDATE);

--tester avec quelques insertions 
INSERT INTO Patient (NumP, Nom, Prenom, DateNaissance) VALUES (17, 'Koucem', 'Lamia', TO_DATE('2025-02-10', 'YYYY-MM-DD'));

select * from patient;
--question 4 : ingenieur pas biomedical

ALTER TABLE Biologiste 
ADD CONSTRAINT chk_ingenieur_not_bio
CHECK (NOT(Specialite = 'Ingénieur' and RoleB = 'Biologist-Médical'));

select * from BIOLOGISTE;


INSERT INTO Biologiste (NumB, Nom, Prenom, Specialite, RoleB) 
VALUES (13, 'Test', 'User', 'Ingénieur', 'Biologist-Médical'); -- Doit échouer


DROP TABLE Biologiste;


--on ne peut pas supprimer biologiste car d'autres tables dependent d'elle
--via des cles etrangeres


SELECT 
    constraint_name, 
    constraint_type, 
    table_name, 
    r_constraint_name
FROM 
    user_constraints
WHERE 
    table_name = 'EFFECTUEPRELEVEMENT';


--pour supprimer completement la contraine : 
ALTER TABLE EffectuePrelevement DROP CONSTRAINT FK_EFFECTUEPRELEVEMENT_BIOLOGISTE;
--la conclusion ici est que l'on peut drop la table apres desactivation de la contrainte de la clé etrangere
DROP TABLE Biologiste;

--partie 2 :
--Afficher le nb de biologiste pour chaque role

set serveroutput ON;

DECLARE 
    CURSOR c_roles IS 
      SELECT RoleB, COUNT(*) as nb_biologistes
      FROM Biologiste
      GROUP BY RoleB;
    
BEGIN 
      FOR rec IN c_roles LOOP 
      DBMS_OUTPUT.PUT_LINE('Il y a' || rec.nb_biologistes ||'par personne(s) qui exerce(nt) en tant que ' || rec.RoleB );
      END LOOP;
END;


select * from resultat;

--mettre a jour la norme covid 
UPDATE Resultat
SET Norme = '>0.8'
WHERE TypeRes = 'PCR-Covid';


ALTER TABLE Resultat
ADD CONSTRAINT chk_conclusion_covid
CHECK (
    (TypeRes = 'Antig-Covid' AND TO_NUMBER(Resul) > 0.8 AND Conclusion = 'Positif') 
);



CREATE OR REPLACE PROCEDURE CasPositifs IS
    CURSOR c_patients IS
        SELECT DISTINCT p.NumP, p.Nom, p.Prenom
        FROM Patient p
        JOIN Prelevement pr ON p.NumP = pr.NumP
        JOIN Resultat r ON pr.NumPr = r.NumPr
        WHERE r.TypeResultat LIKE '%Covid%' AND r.Conclusion = 'Positif';
BEGIN
    FOR rec IN c_patients LOOP
        DBMS_OUTPUT.PUT_LINE('Le patient "' || rec.Nom || ' ' || rec.Prenom || '" a été testé positif.');
    END LOOP;
END;
/


--fonction pour le nb de prelevement --d'un bioligiste donnée

CREATE OR REPLACE FUNCTION nb_prelevement_biologiste(p_numB INT) RETURN INT IS
     v_nb_prelevement INT
BEGIN 
     SELECT COUNT(*) 
     into v_nb_prelevement
     FROM EFFECTUEPRELEVEMENT
     where numb= p_numb
     RETURN v_nb_prelevement;
END;
/


--pour executer la fonction 
DECLARE
    nb INT;
BEGIN
    nb := v_nb_prelevement(1); 
    DBMS_OUTPUT.PUT_LINE('Le Biologiste a effectué ' || nb || ' prélèvement(s).');
END;
/

--verifier si la fonction a ete crée
SELECT object_name, object_type
FROM user_objects
WHERE object_name = 'NB_PRELEVEMENT_BIOLOGISTE'
  AND object_type = 'FUNCTION';


SELECT * FROM EFFECTUEPRELEVEMENT;
--procedure pour ajouter un prelevement a partir de tout les autres attributs

create or replace Procedure Ajouterprelevement (
    p_numb INT,
    p_numB INT,
    p_numpr INT
) IS 
    v_prelevement_existe INT
BEGIN 
    --verif si patient et biologiste existent deja 
     IF NOT EXISTS (SELECT 1 FROM patient 
                    WHERE numP = p_numP) THEN 
                    raise_application_error (-20001, 'le patient avec le numP' ||p_numP || 'nexiste pas');
END IF;
    --verifier que la cle est unique 
       SELECT COUNT(*) 
       INTO v_prelevement_exists
       FROM EFFECTUEPRELEVEMENT
       WHERE numP = p_numP AND  numpr=p_numpr;
IF v_prelevement_exists >0 then 
         raise_application_error(-20003,'Ce prelevement existe deja');
END IF;

--Ajouter le prelevement 
INSERT INTO EFFECTUEPRELEVEMENT (NUMB, NUMP, NUMPR) VALUES (p_numB,p_numB,p_numpr);
DBMS_output.put.line('le prelevement a ete ajouté avec succès');

END;
/


--les triggers pour INSERT UPDATE ET DELETE DUN PATIENT 

CREATE OR REPLACE TRIGGER trigger_patient_changes
AFTER INSERT OR UPDATE OR DELETE ON patient
FOR EACH ROW
BEGIN
   IF INSERTING THEN
      DBMS_OUTPUT.PUT_LINE('Un patient a ete ajouté');
   ELSIF UPDATING THEN
      DBMS_OUTPUT.PUT_LINE('Un patient a ete mis a jour');
   ELSIF DELETING THEN
      DBMS_OUTPUT.PUT_LINE('Un patient a ete supprimé');
   END IF;
END;
/


SET SERVEROUTPUT ON;


--trigger pour empecher la modification d'un numero de biologiste 
CREATE OR REPLACE TRIGGER trigger_no_update_NumB
BEFORE UPDATE OF numB on Biologiste
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20004, "Modification du Numero de biologiste interdite");
 END;
/


ALTER TABLE Biologiste ADD Nb_Pr INTEGER DEFAULT 0;

--trigger pour mettre a jour nb_pr automatiquement

Create or replace trigger nb_pr_auto
After insert or delete or update on EffectuePrelevement
For each row
Begin
 if inserting then
    update Biologiste set Nb_Pr = Nb_Pr+1 where NumB = :new.NumB;
  endif;
if deleting then
    update Biologiste set Nb_Pr = Nb_Pr-1 where NumB = :old.NumB;
endif;
if updating then if(:new.NumB != :old.NumB) then
    update Biologiste set Nb_Pr = Nb_Pr+1 where NumB = :new.NumB;
	update Biologiste set Nb_Pr = Nb_Pr-1 where NumB = :old.NumB;
endif;
endif;
End;
/

