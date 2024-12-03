/*
LOG avec comme informations :

l'auteur de l'action (colonne : idAuteur)
l'action (ajout, modification, suppression) (action)
la date et l'heure de l'action (dateHeureAction)
le contenu (sous forme de texte) de la ligne avant (ou null si elle n'existait pas) (ligneAvant)
le contenu (idem) de la ligne après (ou null si elle a été supprimée) (ligneApres)
*/

/
/*
CREATE OR REPLACE TRIGGER trigger_compo_equipe
    AFTER INSERT OR UPDATE OR DELETE ON COMPOSITION_EQUIPE
    FOR EACH ROW
DECLARE
    action_ VARCHAR(20);
    ligneAvant_ VARCHAR(200);
    ligneApres_ VARCHAR(200);
BEGIN

    ligneAvant_ := 'IDEQUIPE: ' || :OLD.IDEQUIPE || ', ' || 'IDATHLETE: ' || :OLD.IDATHLETE;
    ligneApres_ := 'IDEQUIPE: ' || :NEW.IDEQUIPE || ', ' || 'IDATHLETE: ' || :NEW.IDATHLETE;
    IF INSERTING THEN action_ := 'Insertion'; ligneAvant_:=null;
    ELSIF UPDATING THEN action_ := 'Mise à jour';
    ELSIF DELETING THEN action_ := 'Suppression'; ligneApres_:=null;
    END IF;
    INSERT INTO LOG (idAuteur, action, dateHeureAction, ligneAvant, ligneApres)
    VALUES (USER, action_, SYSDATE, ligneAvant_, ligneApres_);
END;
*/


------------------
CREATE OR REPLACE TRIGGER trg_athlete
    AFTER INSERT OR UPDATE OR DELETE ON ATHLETE
    FOR EACH ROW
DECLARE
    action_ VARCHAR(20);
    ligneAvant_ VARCHAR(200);
    ligneApres_ VARCHAR(200);
BEGIN
    ligneAvant_ := 'IDATHLETE: ' || :OLD.IDATHLETE || ', ' || 'NOMATHLETE: ' || :OLD.NOMATHLETE || ', ' || 'PRENOMATHLETE: ' || :OLD.PRENOMATHLETE || ', ' || 'SURNOM: ' || :OLD.SURNOM || ', ' || 'GENRE: ' || :OLD.GENRE || ', ' || 'DATENAISSANCE: ' || :OLD.DATENAISSANCE || ', ' || 'DATEDECES: ' || :OLD.DATEDECES || ', ' || 'TAILLE: ' || :OLD.TAILLE || ', ' || 'POIDS: ' || :OLD.POIDS;
    ligneApres_ := 'IDATHLETE: ' || :NEW.IDATHLETE || ', ' || 'NOMATHLETE: ' || :NEW.NOMATHLETE || ', ' || 'PRENOMATHLETE: ' || :NEW.PRENOMATHLETE || ', ' || 'SURNOM: ' || :NEW.SURNOM || ', ' || 'GENRE: ' || :NEW.GENRE || ', ' || 'DATENAISSANCE: ' || :NEW.DATENAISSANCE || ', ' || 'DATEDECES: ' || :NEW.DATEDECES || ', ' || 'TAILLE: ' || :NEW.TAILLE || ', ' || 'POIDS: ' || :NEW.POIDS;

    IF INSERTING THEN
        action_ := 'Ajout';
        ligneAvant_ := NULL;
    ELSIF UPDATING THEN
        action_ := 'Modification';
    ELSIF DELETING THEN
        action_ := 'Suppression';
        ligneApres_ := NULL;
    END IF;

    INSERT INTO LOG (idAuteur, action, dateHeureAction, ligneAvant, ligneApres)
    VALUES (USER, action_, SYSDATE, ligneAvant_, ligneApres_);
END;
/

CREATE OR REPLACE TRIGGER trg_composition_equipe
    AFTER INSERT OR UPDATE OR DELETE ON COMPOSITION_EQUIPE
    FOR EACH ROW
DECLARE
    action_ VARCHAR(20);
    ligneAvant_ VARCHAR(200);
    ligneApres_ VARCHAR(200);
BEGIN
    ligneAvant_ := 'IDEQUIPE: ' || :OLD.IDEQUIPE || ', ' || 'IDATHLETE: ' || :OLD.IDATHLETE;
    ligneApres_ := 'IDEQUIPE: ' || :NEW.IDEQUIPE || ', ' || 'IDATHLETE: ' || :NEW.IDATHLETE;

    IF INSERTING THEN
        action_ := 'Ajout';
        ligneAvant_ := NULL;
    ELSIF UPDATING THEN
        action_ := 'Modification';
    ELSIF DELETING THEN
        action_ := 'Suppression';
        ligneApres_ := NULL;
    END IF;

    INSERT INTO LOG (idAuteur, action, dateHeureAction, ligneAvant, ligneApres)
    VALUES (USER, action_, SYSDATE, ligneAvant_, ligneApres_);
END;
/

CREATE OR REPLACE TRIGGER trg_discipline
    AFTER INSERT OR UPDATE OR DELETE ON DISCIPLINE
    FOR EACH ROW
DECLARE
    action_ VARCHAR(20);
    ligneAvant_ VARCHAR(200);
    ligneApres_ VARCHAR(200);
BEGIN
    ligneAvant_ := 'CODEDISCIPLINE: ' || :OLD.CODEDISCIPLINE || ', ' || 'NOMDISCIPLINE: ' || :OLD.NOMDISCIPLINE || ', ' || 'CODESPORT: ' || :OLD.CODESPORT;
    ligneApres_ := 'CODEDISCIPLINE: ' || :NEW.CODEDISCIPLINE || ', ' || 'NOMDISCIPLINE: ' || :NEW.NOMDISCIPLINE || ', ' || 'CODESPORT: ' || :NEW.CODESPORT;

    IF INSERTING THEN
        action_ := 'Ajout';
        ligneAvant_ := NULL;
    ELSIF UPDATING THEN
        action_ := 'Modification';
    ELSIF DELETING THEN
        action_ := 'Suppression';
        ligneApres_ := NULL;
    END IF;

    INSERT INTO LOG (idAuteur, action, dateHeureAction, ligneAvant, ligneApres)
    VALUES (USER, action_, SYSDATE, ligneAvant_, ligneApres_);
END;
/

-- Continue with triggers for the remaining tables...
CREATE OR REPLACE TRIGGER trg_equipe
    AFTER INSERT OR UPDATE OR DELETE ON EQUIPE
    FOR EACH ROW
DECLARE
    action_ VARCHAR(20);
    ligneAvant_ VARCHAR(200);
    ligneApres_ VARCHAR(200);
BEGIN
    ligneAvant_ := 'IDEQUIPE: ' || :OLD.IDEQUIPE || ', ' || 'NOMEQUIPE: ' || :OLD.NOMEQUIPE || ', ' || 'NOC: ' || :OLD.NOC;
    ligneApres_ := 'IDEQUIPE: ' || :NEW.IDEQUIPE || ', ' || 'NOMEQUIPE: ' || :NEW.NOMEQUIPE || ', ' || 'NOC: ' || :NEW.NOC;

    IF INSERTING THEN
        action_ := 'Ajout';
        ligneAvant_ := NULL;
    ELSIF UPDATING THEN
        action_ := 'Modification';
    ELSIF DELETING THEN
        action_ := 'Suppression';
        ligneApres_ := NULL;
    END IF;

    INSERT INTO LOG (idAuteur, action, dateHeureAction, ligneAvant, ligneApres)
    VALUES (USER, action_, SYSDATE, ligneAvant_, ligneApres_);
END;
/

CREATE OR REPLACE TRIGGER trg_evenement
    AFTER INSERT OR UPDATE OR DELETE ON EVENEMENT
    FOR EACH ROW
DECLARE
    action_ VARCHAR(20);
    ligneAvant_ VARCHAR(200);
    ligneApres_ VARCHAR(200);
BEGIN
    ligneAvant_ := 'IDEVENEMENT: ' || :OLD.IDEVENEMENT || ', ' || 'NOMEVENEMENT: ' || :OLD.NOMEVENEMENT || ', ' || 'STATUTEVENEMENT: ' || :OLD.STATUTEVENEMENT || ', ' || 'CODEDISCIPLINE: ' || :OLD.CODEDISCIPLINE || ', ' || 'IDHOTE: ' || :OLD.IDHOTE;
    ligneApres_ := 'IDEVENEMENT: ' || :NEW.IDEVENEMENT || ', ' || 'NOMEVENEMENT: ' || :NEW.NOMEVENEMENT || ', ' || 'STATUTEVENEMENT: ' || :NEW.STATUTEVENEMENT || ', ' || 'CODEDISCIPLINE: ' || :NEW.CODEDISCIPLINE || ', ' || 'IDHOTE: ' || :NEW.IDHOTE;

    IF INSERTING THEN
        action_ := 'Ajout';
        ligneAvant_ := NULL;
    ELSIF UPDATING THEN
        action_ := 'Modification';
    ELSIF DELETING THEN
        action_ := 'Suppression';
        ligneApres_ := NULL;
    END IF;

    INSERT INTO LOG (idAuteur, action, dateHeureAction, ligneAvant, ligneApres)
    VALUES (USER, action_, SYSDATE, ligneAvant_, ligneApres_);
END;
/

CREATE OR REPLACE TRIGGER trg_hote
    AFTER INSERT OR UPDATE OR DELETE ON HOTE
    FOR EACH ROW
DECLARE
    action_ VARCHAR(20);
    ligneAvant_ VARCHAR(200);
    ligneApres_ VARCHAR(200);
BEGIN
    ligneAvant_ := 'IDHOTE: ' || :OLD.IDHOTE || ', ' || 'NUMEROHOTE: ' || :OLD.NUMEROHOTE || ', ' || 'LIBELLEHOTE: ' || :OLD.LIBELLEHOTE || ', ' || 'ANNEEHOTE: ' || :OLD.ANNEEHOTE || ', ' || 'SAISON: ' || :OLD.SAISON || ', ' || 'VILLEHOTE: ' || :OLD.VILLEHOTE || ', ' || 'CODENOCHOTE: ' || :OLD.CODENOCHOTE || ', ' || 'DATEOUVERTURE: ' || :OLD.DATEOUVERTURE || ', ' || 'DATEFERMETURE: ' || :OLD.DATEFERMETURE || ', ' || 'DATESCOMPETITION: ' || :OLD.DATESCOMPETITION || ', ' || 'NOTES: ' || :OLD.NOTES;
    ligneApres_ := 'IDHOTE: ' || :NEW.IDHOTE || ', ' || 'NUMEROHOTE: ' || :NEW.NUMEROHOTE || ', ' || 'LIBELLEHOTE: ' || :NEW.LIBELLEHOTE || ', ' || 'ANNEEHOTE: ' || :NEW.ANNEEHOTE || ', ' || 'SAISON: ' || :NEW.SAISON || ', ' || 'VILLEHOTE: ' || :NEW.VILLEHOTE || ', ' || 'CODENOCHOTE: ' || :NEW.CODENOCHOTE || ', ' || 'DATEOUVERTURE: ' || :NEW.DATEOUVERTURE || ', ' || 'DATEFERMETURE: ' || :NEW.DATEFERMETURE || ', ' || 'DATESCOMPETITION: ' || :NEW.DATESCOMPETITION || ', ' || 'NOTES: ' || :NEW.NOTES;

    IF INSERTING THEN
        action_ := 'Ajout';
        ligneAvant_ := NULL;
    ELSIF UPDATING THEN
        action_ := 'Modification';
    ELSIF DELETING THEN
        action_ := 'Suppression';
        ligneApres_ := NULL;
    END IF;

    INSERT INTO LOG (idAuteur, action, dateHeureAction, ligneAvant, ligneApres)
    VALUES (USER, action_, SYSDATE, ligneAvant_, ligneApres_);
END;
/

CREATE OR REPLACE TRIGGER trg_noc
    AFTER INSERT OR UPDATE OR DELETE ON NOC
    FOR EACH ROW
DECLARE
    action_ VARCHAR(20);
    ligneAvant_ VARCHAR(200);
    ligneApres_ VARCHAR(200);
BEGIN
    ligneAvant_ := 'CODENOC: ' || :OLD.CODENOC || ', ' || 'NOMNOC: ' || :OLD.NOMNOC;
    ligneApres_ := 'CODENOC: ' || :NEW.CODENOC || ', ' || 'NOMNOC: ' || :NEW.NOMNOC;

    IF INSERTING THEN
        action_ := 'Ajout';
        ligneAvant_ := NULL;
    ELSIF UPDATING THEN
        action_ := 'Modification';
    ELSIF DELETING THEN
        action_ := 'Suppression';
        ligneApres_ := NULL;
    END IF;

    INSERT INTO LOG (idAuteur, action, dateHeureAction, ligneAvant, ligneApres)
    VALUES (USER, action_, SYSDATE, ligneAvant_, ligneApres_);
END;
/

CREATE OR REPLACE TRIGGER trg_participation_individuelle
    AFTER INSERT OR UPDATE OR DELETE ON PARTICIPATION_INDIVIDUELLE
    FOR EACH ROW
DECLARE
    action_ VARCHAR(20);
    ligneAvant_ VARCHAR(200);
    ligneApres_ VARCHAR(200);
BEGIN
    ligneAvant_ := 'IDATHLETE: ' || :OLD.IDATHLETE || ', '
        || 'IDEVENT: ' || :OLD.IDEVENT || ', ' || 'RESULTAT: ' || :OLD.RESULTAT || ', ' || 'MEDAILLE: ' || :OLD.MEDAILLE || ', ' || 'NOC: ' || :OLD.NOC;
    ligneApres_ := 'IDATHLETE: ' || :NEW.IDATHLETE || ', ' || 'IDEVENT: ' || :NEW.IDEVENT || ', ' || 'RESULTAT: ' || :NEW.RESULTAT || ', ' || 'MEDAILLE: ' || :NEW.MEDAILLE || ', ' || 'NOC: ' || :NEW.NOC;

    IF INSERTING THEN
        action_ := 'Ajout';
        ligneAvant_ := NULL;
    ELSIF UPDATING THEN
        action_ := 'Modification';
    ELSIF DELETING THEN
        action_ := 'Suppression';
        ligneApres_ := NULL;
    END IF;

    INSERT INTO LOG (idAuteur, action, dateHeureAction, ligneAvant, ligneApres)
    VALUES (USER, action_, SYSDATE, ligneAvant_, ligneApres_);
END;
/

CREATE OR REPLACE TRIGGER trg_participation_equipe
    AFTER INSERT OR UPDATE OR DELETE ON PARTICIPATION_EQUIPE
    FOR EACH ROW
DECLARE
    action_ VARCHAR(20);
    ligneAvant_ VARCHAR(200);
    ligneApres_ VARCHAR(200);
BEGIN
    ligneAvant_ := 'IDEVENEMENT: ' || :OLD.IDEVENEMENT || ', ' || 'IDEQUIPE: ' || :OLD.IDEQUIPE || ', ' || 'RESULTAT: ' || :OLD.RESULTAT || ', ' || 'MEDAILLE: ' || :OLD.MEDAILLE;
    ligneApres_ := 'IDEVENEMENT: ' || :NEW.IDEVENEMENT || ', ' || 'IDEQUIPE: ' || :NEW.IDEQUIPE || ', ' || 'RESULTAT: ' || :NEW.RESULTAT || ', ' || 'MEDAILLE: ' || :NEW.MEDAILLE;

    IF INSERTING THEN
        action_ := 'Ajout';
        ligneAvant_ := NULL;
    ELSIF UPDATING THEN
        action_ := 'Modification';
    ELSIF DELETING THEN
        action_ := 'Suppression';
        ligneApres_ := NULL;
    END IF;

    INSERT INTO LOG (idAuteur, action, dateHeureAction, ligneAvant, ligneApres)
    VALUES (USER, action_, SYSDATE, ligneAvant_, ligneApres_);
END;
/

CREATE OR REPLACE TRIGGER trg_sport
    AFTER INSERT OR UPDATE OR DELETE ON SPORT
    FOR EACH ROW
DECLARE
    action_ VARCHAR(20);
    ligneAvant_ VARCHAR(200);
    ligneApres_ VARCHAR(200);
BEGIN
    ligneAvant_ := 'CODESPORT: ' || :OLD.CODESPORT || ', ' || 'NOMSPORT: ' || :OLD.NOMSPORT;
    ligneApres_ := 'CODESPORT: ' || :NEW.CODESPORT || ', ' || 'NOMSPORT: ' || :NEW.NOMSPORT;

    IF INSERTING THEN
        action_ := 'Ajout';
        ligneAvant_ := NULL;
    ELSIF UPDATING THEN
        action_ := 'Modification';
    ELSIF DELETING THEN
        action_ := 'Suppression';
        ligneApres_ := NULL;
    END IF;

    INSERT INTO LOG (idAuteur, action, dateHeureAction, ligneAvant, ligneApres)
    VALUES (USER, action_, SYSDATE, ligneAvant_, ligneApres_);
END;
/

/*
INSERT INTO COMPOSITION_EQUIPE VALUES(1, 99);
DELETE FROM COMPOSITION_EQUIPE WHERE IDEQUIPE=1 AND IDATHLETE=99;
SELECT * FROM LOG;

*/
SELECT * FROM sys.all_triggers WHERE owner='BELHAC1';
