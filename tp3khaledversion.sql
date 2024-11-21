--hello there
--this is the sql code of khaled :p 

SELECT TABLE_NAME AS Name, Constraint_name AS const, Constraint_type FROM user_constraints;

ALTER TABLE Biologiste ADD CONSTRAINT BMCheck CHECK( RoleB IN('Biologiste-Resonsable','Biologiste-Medical','Ing-Qualite','Aide-Laboratoire','Secretaire','technicien','Ing-Informatique','B-M a Domicile'));

ALTER TABLE Patient ADD CONSTRAINT DateCheck CHECK(DateNaissance < SYSDATE);

--on peut pas utiliser sysdate dans CHECK donc j ai utilise un trigger
CREATE OR REPLACE TRIGGER DateCheck 
BEFORE INSERT OR UPDATE ON Patient FOR EACH ROW
BEGIN
	if(SYSDATE < :new.DateNaissance) THEN
		RAISE_APPLICATION_ERROR(-20000,'nah man');
	end IF;
end;
/
--unique constraint violated
INSERT INTO Patient VALUES (15,'SENDJAK','RAouf',TO_DATE('02/04/2025'));
--row created succesfully
INSERT INTO Patient VALUES (20,'Random','Randy',TO_DATE('02/04/2022'));
DELETE FROM Patient WHERE NumP = 20;


--unique key refrenced in forgein keys
drop TABLE Biologiste;


--pl/sql
set serveroutput ON;
DECLARE
 x INTEGER := 0;
 z INTEGER := 0;
 type namearray is VARRAY(8) of VARCHAR2(60);
 y namearray;
BEGIN
	y := namearray('Biologiste-Resonsable','Biologiste-Medical','Ing-Qualite','Aide-Laboratoire','Secretaire','technicien','Ing-Informatique','B-M a Domicile');
	z := y.count;
	for i in 1 .. z loop
	select COUNT(*) into x 
	FROM Biologiste
	WHERE RoleB = y(i);
	DBMS_OUTPUT.PUT_LINE('il y a ' || x || ' ' || y(i));
	end loop;

end;
/
--updating covid normes
	UPDATE Resultat r set  Norme = '>0.8' where TypePr = 'PCR Covid';
	UPDATE Resultat r set  Norme = '>0.8' where TypePr = 'Antig-Covid';
	UPDATE Resultat r set  r.Resultat = 'Positif' where TypePr = 'Antig-Covid' and Resultat > '0.8';
	UPDATE Resultat r set  r.Resultat = 'Positif' where TypePr = 'PCR Covid' and Resultat > '0.8';
	UPDATE Resultat r set  r.Resultat = 'Negatif' where TypePr = 'Antig-Covid' and Resultat <= '0.8';
	UPDATE Resultat r set  r.Resultat = 'Negatif' where TypePr = 'PCR Covid' and Resultat <= '0.8';

--it just works

DECLARE
 CURSOR cr is select t.NOM, k.Resultat, k.TypePr from Prelevement f, Resultat k, Patient t WHERE t.NumP = f.NumP AND k.NumPr = f.NumPr;
 c_rec     cr%rowtype; 
 type namearray is VARRAY(8) of VARCHAR2(60);
 y namearray;
 z INTEGER;
BEGIN
	y := namearray('PCR Covid','Antig-Covid');
	z := y.count;
	for i in 1 .. z loop
		for c_rec in cr loop 
			if(c_rec.TypePr = y(i)) then 
				if(c_rec.Resultat > '0.8') then 
					DBMS_OUTPUT.PUT_LINE('il y a ' || c_rec.Nom || ' avec ' || c_rec.Resultat);
				end if;
			end if;
		end loop;
	end loop;

end;
/

--biologiste et prelevement
 Create or replace PROCEDURE BioCount IS
 CURSOR cr is select k.NOM, count(*) as gman from EffectuePrelevement f, Biologiste k WHERE f.NumB = k.NumB GROUP BY k.NOM;
 c_rec     cr%rowtype;
 
 BEGIN
	for c_rec in cr loop 
		DBMS_OUTPUT.PUT_LINE('le biologiste ' || c_rec.Nom || ' a fait ' || c_rec.gman);
	end loop;
 end;
 /

--procedure insertion
--
--

CREATE OR REPLACE TRIGGER BiologyNoUpdate
BEFORE UPDATE ON Biologiste FOR EACH ROW
BEGIN
	if(:new.NumB != :old.NumB) then
		RAISE_APPLICATION_ERROR(-20000,'nah man');
	end if;
end;
/



--triggers pour insertion and so on
CREATE OR REPLACE TRIGGER PatientMSGInsert
BEFORE INSERT ON Patient FOR EACH ROW
BEGIN
	DBMS_OUTPUT.PUT_LINE('Patient ajoute');
end;
/


CREATE OR REPLACE TRIGGER PatientMSGUpdate
BEFORE UPDATE ON Patient FOR EACH ROW
BEGIN
	DBMS_OUTPUT.PUT_LINE('Patient updated');

end;
/

CREATE OR REPLACE TRIGGER PatientMSGDelete
BEFORE DELETE ON Patient FOR EACH ROW
BEGIN
	DBMS_OUTPUT.PUT_LINE('Patient delete');

end;
/
--test
INSERT INTO Patient VALUES (20,'Random','Randy',TO_DATE('02/04/2022'));
DELETE FROM Patient WHERE NumP = 20;

-- altering and adding the trigger
ALTER TABLE Biologiste ADD Nb_Pr INTEGER DEFAULT 0;
UPDATE Biologiste b set Nb_Pr = (select count(*) from Biologiste c, EffectuePrelevement p WHERE c.NumB = b.NumB AND p.NumB = c.NumB);

Create or replace trigger AutoBio
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