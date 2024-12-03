--à finir


CREATE OR REPLACE VIEW MedailleAth AS SELECT IDATHLETE,
       count(CASE WHEN MEDAILLE='Gold' THEN 'Gold' END) as medaillesOr,
        count(CASE WHEN MEDAILLE='Silver' THEN 'Silver' END) as medaillesArgent,
       count(CASE WHEN MEDAILLE='Bronze' THEN 'Bronze' END) as medaillesBronze,
       count(MEDAILLE) as totalMedailles
FROM (
    (SELECT medaille, A.IDATHLETE FROM ATHLETE A
    LEFT JOIN PARTICIPATION_INDIVIDUELLE PI ON A.IDATHLETE = PI.IDATHLETE) union all
    (SELECT medaille, IDATHLETE FROM ATHLETE A
    NATURAL JOIN COMPOSITION_EQUIPE
    NATURAL JOIN PARTICIPATION_EQUIPE)
)
group by IDATHLETE;


CREATE OR REPLACE VIEW MEDAILLES_ATHLETES AS SELECT IDATHLETE, NOMATHLETE, PRENOMATHLETE, medaillesOr,medaillesArgent, medaillesBronze, totalMedailles FROM ATHLETE
NATURAL JOIN MedailleAth
ORDER BY medaillesOr DESC , medaillesArgent DESC, medaillesBronze DESC, totalMedailles DESC, NOMATHLETE ASC, PRENOMATHLETE ASC, IDATHLETE ASC;

/*
SELECT COUNT(*) FROM MEDAILLES_ATHLETES;
SELECT COUNT(*) FROM ATHLETE; -- =====
*/
SELECT * FROM MEDAILLES_ATHLETES;


create or replace view MedaillesNocIntermediaire AS SELECT codeNoc,
    count(CASE WHEN MEDAILLE='Gold' THEN 'Gold' END) as medaillesOr,
    count(CASE WHEN MEDAILLE='Silver' THEN 'Silver' END) as medaillesArgent,
    count(CASE WHEN MEDAILLE='Bronze' THEN 'Bronze' END) as medaillesBronze,
    count(MEDAILLE) as totalMedailles
    FROM (
    (SELECT medaille, NOC as codeNoc FROM PARTICIPATION_INDIVIDUELLE PI) union all
    (SELECT medaille, NOC as codeNoc FROM  EQUIPE E
    NATURAL JOIN PARTICIPATION_EQUIPE)
    ) WHERE MEDAILLE IS NOT NULL
group by codeNoc;


CREATE OR REPLACE VIEW MEDAILLES_NOC AS SELECT NOC.CODENOC, NVL(MEDAILLESOR, 0) as medaillesOr, NVL(MEDAILLESARGENT,0) as medaillesArgent, NVL(MEDAILLESBRONZE,0) as medaillesBronze, NVL(TOTALMEDAILLES,0) as totalMedailles FROM
MedaillesNocIntermediaire MNI
RIGHT JOIN NOC ON NOC.CODENOC=MNI.CODENOC
ORDER BY medaillesOr DESC, MEDAILLESARGENT DESC, MEDAILLESBRONZE DESC, TOTALMEDAILLES DESC, NOC.codeNoc ASC;

/*
SELECT * FROM NOC WHERE CODENOC NOT IN(SELECT CODENOC FROM MEDAILLES_NOC);
SELECT * FROM MEDAILLES_NOC;
*/

CREATE OR REPLACE FUNCTION biographie(id_athlete ATHLETE.IDATHLETE%TYPE) RETURN VARCHAR2 IS
    bioJson VARCHAR2(32767);
    nbAthletes NUMBER;
    BEGIN
        SELECT COUNT(*) INTO nbAthletes FROM ATHLETE WHERE IDATHLETE=id_athlete;
        IF nbAthletes=0 THEN
            RAISE_APPLICATION_ERROR(-20011, 'Athlète inconnu');
        END IF;
        SELECT JSON_OBJECT(
                       'nom' is NOMATHLETE,
                       'prénom' is PRENOMATHLETE,
                       'surnom' is SURNOM,
                       'genre' is SUBSTR(GENRE, 1, 1),
                       'dateNaissance' is to_char(DATENAISSANCE, 'YYYY-MM-DD'),
                       'dateDécès' is to_char(DATEDECES, 'YYYY-MM-DD'),
                       'taille' is (TAILLE||' cm'),
                       'poids' is (POIDS||' kg'),
                       'médaillesOr' is TO_CHAR(medaillesOr),
                       'médaillesArgent' is TO_CHAR(medaillesArgent),
                       'médaillesBronze' is TO_CHAR(medaillesBronze),
                       'médaillesTotal' is TO_CHAR(totalMedailles)
               ) INTO bioJson FROM MEDAILLES_ATHLETES
                              NATURAL JOIN ATHLETE
                              WHERE IDATHLETE=id_athlete;
        RETURN bioJson;




    end;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(biographie(93860));
end;

/
SELECT * FROM ATHLETE;
/*
SELECT
    JSON_OBJECT(
        'résultats' VALUE

            JSON_ARRAYAGG(
                JSON_OBJECT('position' IS RESULTAT, 'athlète(s)' IS PRENOMATHLETE || ' ' || NOMATHLETE, 'noc' IS NOC,
                            'médaille' IS MEDAILLE
                )
                 ORDER BY CAST(REGEXP_SUBSTR(RESULTAT, '\d+') AS INT) ASC, NOMATHLETE ASC, PRENOMATHLETE ASC  returning clob
            )
            returning clob


   )
FROM EVENEMENT EV
INNER JOIN PARTICIPATION_INDIVIDUELLE PI ON EV.IDEVENEMENT=PI.IDEVENT
INNER JOIN ATHLETE ON PI.IDATHLETE = ATHLETE.IDATHLETE
WHERE IDEVENEMENT=70148;
*/

/*
SELECT SUM(note)
FROM NOTE_AUTO_S204;
SELECT * FROM NOTE_AUTO_S204;

SELECT

    JSON_OBJECT(
        'résultats' VALUE
            JSON_ARRAYAGG(
                JSON_OBJECT('position' IS RESULTAT, 'athlète(s)' IS LISTAGG(PRENOMATHLETE || ' ' || NOMATHLETE , ' / '), 'noc' IS NOC,
                            'médaille' IS MEDAILLE
                )
                 ORDER BY CAST(REGEXP_SUBSTR(RESULTAT, '\d+') AS INT) ASC, 'athlète(s)' ASC
            )
            returning clob


   )


FROM EVENEMENT
NATURAL JOIN PARTICIPATION_EQUIPE
NATURAL JOIN EQUIPE
NATURAL JOIN COMPOSITION_EQUIPE
NATURAL JOIN ATHLETE
WHERE IDEVENEMENT=19005277
GROUP BY IDEQUIPE, RESULTAT, NOC, MEDAILLE;
*/



CREATE OR REPLACE FUNCTION resultats(id_evenement EVENEMENT.IDEVENEMENT%TYPE) RETURN varchar2 IS
    nbParticipantsIndividuelsEvenements NUMBER;
    resultatsJson VARCHAR2(32767);
    evenementInexistant NUMBER;
    --permet de déterminer si évenement par équipe ou individuel
BEGIN
    SELECT (CASE WHEN COUNT(*)=0 THEN 1 ELSE 0 END) into evenementInexistant FROM EVENEMENT WHERE IDEVENEMENT=id_evenement;
    IF evenementInexistant=1 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Événement inconnu');
    END IF;
    SELECT COUNT(*) INTO nbParticipantsIndividuelsEvenements FROM
    PARTICIPATION_INDIVIDUELLE WHERE IDEVENT=id_evenement;
    IF nbParticipantsIndividuelsEvenements>0 THEN --PENSER A FINIR LE FORMATTAGE JSON

        --evenement individuel
        SELECT
            JSON_OBJECT(
                    'résultats' VALUE

                    JSON_ARRAYAGG(
                            JSON_OBJECT('position' IS RESULTAT, 'athlète(s)' IS PRENOMATHLETE || ' ' || NOMATHLETE, 'noc' IS NOC,
                                        'médaille' IS MEDAILLE
                            )
                            ORDER BY CAST(REGEXP_SUBSTR(RESULTAT, '\d+') AS INT) ASC, NOMATHLETE ASC, PRENOMATHLETE ASC
                    )
                    returning clob


            ) INTO resultatsJson
        FROM EVENEMENT EV
                 INNER JOIN PARTICIPATION_INDIVIDUELLE PI ON EV.IDEVENEMENT=PI.IDEVENT
                 INNER JOIN ATHLETE ON PI.IDATHLETE = ATHLETE.IDATHLETE
        WHERE IDEVENEMENT=id_evenement;

    ELSE
        SELECT
            JSON_OBJECT(
                    'résultats' VALUE
                    JSON_ARRAYAGG(
                            JSON_OBJECT('position' IS RESULTAT, 'athlète(s)' IS LISTAGG(PRENOMATHLETE || ' ' || NOMATHLETE , ' / ')WITHIN GROUP (ORDER BY NOMATHLETE, PRENOMATHLETE), 'noc' IS NOC,
                                        'médaille' IS MEDAILLE
                            )
                            ORDER BY CAST(REGEXP_SUBSTR(RESULTAT, '\d+') AS INT) ASC
                            returning clob
                    )
                    returning clob


            ) INTO resultatsJson


        FROM EVENEMENT
                 NATURAL JOIN PARTICIPATION_EQUIPE
                 NATURAL JOIN EQUIPE
                 NATURAL JOIN COMPOSITION_EQUIPE
                 NATURAL JOIN ATHLETE
        WHERE IDEVENEMENT=id_evenement
        GROUP BY IDEQUIPE, RESULTAT, NOC, MEDAILLE;

    END IF;
    RETURN resultatsJson;
end;
/

SELECT IDEVENEMENT, COUNT(IDEQUIPE) FROM PARTICIPATION_EQUIPE GROUP BY IDEVENEMENT;

begin
    a
end;
/

---bien rajouter le '/' à la fin de chaque fonction/procédure !!

BEGIN
    DBMS_OUTPUT.PUT_LINE(resultats(403));
end;

SELECT * FROM NOTE_AUTO_S204;
SELECT * FROM USER_TAB_PRIVS WHERE TABLE_NAME = 'ATHLETE';

--PENSER A FINIR LE FORMATTAGE JSON
/*

---PENSER A TRIER PAR ORDRE ALPHABETIQUE DE NOM !!!!

---NE PAS OUBLIER LES DROITS : GRANT ALTER, SELECT... ON .... TO ... GRANT EXECUTE ON ... TO ...
*/



----REVOIR MEDAILLES_NOC !!

CREATE OR REPLACE PROCEDURE ajouter_resultat_individuel(id_evenement EVENEMENT.IDEVENEMENT%TYPE, id_athlete ATHLETE.IDATHLETE%TYPE, code_noc NOC.CODENOC%TYPE, resultat_ PARTICIPATION_INDIVIDUELLE.RESULTAT%TYPE) IS
    athleteInexistant NUMBER;
    evenementInexistant NUMBER;
    nocInexistant NUMBER;

    athleteDejaPresent NUMBER;
    nocCoherent NUMBER;
    medailleDeterminee varchar2(20);

    cntSansEg NUMBER;
    cntAvecEg NUMBER;
    estExaequo NUMBER;

    BEGIN
        SELECT (CASE WHEN COUNT(*)=0 THEN 1 ELSE 0 END) into athleteInexistant FROM ATHLETE WHERE IDATHLETE=id_athlete;
        SELECT (CASE WHEN COUNT(*)=0 THEN 1 ELSE 0 END) into evenementInexistant FROM EVENEMENT WHERE IDEVENEMENT=id_evenement;
        SELECT (CASE WHEN COUNT(*)=0 THEN 1 ELSE 0 END) into nocInexistant FROM NOC WHERE CODENOC=code_noc;


        IF athleteInexistant=1 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Athlète inexistant' );
        END IF;

        IF evenementInexistant=1 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Événement inexistant' );
        END IF;

        IF nocInexistant=1 THEN
            RAISE_APPLICATION_ERROR(-20001, 'NOC inexistant' );
        END IF;

        IF SUBSTR(resultat_, 0, 1) = '=' THEN
            estExaequo := 1;
        ELSE estExaequo:=0;
        END IF;

        SELECT COUNT(RESULTAT) INTO cntAvecEg FROM PARTICIPATION_INDIVIDUELLE
        WHERE IDEVENT=id_evenement AND RESULTAT=('='|| REPLACE(resultat_, '=', ''));

        SELECT COUNT(RESULTAT) INTO cntSansEg FROM PARTICIPATION_INDIVIDUELLE
        WHERE IDEVENT=id_evenement AND RESULTAT=REPLACE(resultat_, '=', '');



        --'=1' et '1'
        IF estExaequo=1 AND cntSansEg>0 THEN RAISE_APPLICATION_ERROR(-20002,'Position déjà occupée');
        END IF;
        /*
        --'=1' et aucun autre '=1'
        IF estExaequo=1 AND cntAvecEg=0 THEN RAISE_APPLICATION_ERROR(-20011,'Position déjà occupée');
        END IF;
        ??? que faire si aucun '=1' mais qu'on souhaite en insérer un pour la premiere fois pour en mettre un deuxieme ?
        */

        --'1' et '=1' '=1'
        IF estExaequo=0 AND cntAvecEg>0 THEN RAISE_APPLICATION_ERROR(-20002,'Position déjà occupée');
        END IF;

        --'1' et '1'
        IF estExaequo=0 AND cntSansEg>0 THEN RAISE_APPLICATION_ERROR( -20002, 'Position déjà occupée');
        END IF;




        SELECT CASE WHEN COUNT(*)>0 THEN 1 ELSE 0 END INTO athleteDejaPresent
             FROM PARTICIPATION_INDIVIDUELLE
            WHERE IDEVENT=id_evenement AND IDATHLETE=id_athlete ;

        --select puis if, select puis if, select puis if...

        SELECT CASE WHEN COUNT(*)>0 THEN 0 ELSE 1 END INTO nocCoherent FROM PARTICIPATION_INDIVIDUELLE
            NATURAL JOIN EVENEMENT
            NATURAL JOIN HOTE
            WHERE IDATHLETE=id_athlete AND NOC!=code_noc;

        IF athleteDejaPresent=1 THEN RAISE_APPLICATION_ERROR(-20003, 'Athlète déjà classé');
        end if;

        IF nocCoherent=0 THEN RAISE_APPLICATION_ERROR(-20004, 'Incohérence de NOC');
        END IF;

        IF REPLACE(resultat_, '=', '')='1' THEN medailleDeterminee:='Gold';
        ELSIF REPLACE(resultat_, '=', '')='2' THEN medailleDeterminee:='Silver';
        ELSIF REPLACE(resultat_, '=', '')='3' THEN medailleDeterminee:='Bronze';
        END IF;


    INSERT INTO PARTICIPATION_INDIVIDUELLE(IDATHLETE, IDEVENT, RESULTAT, MEDAILLE, NOC) VALUES(
    id_athlete,id_evenement,resultat_,medailleDeterminee,code_noc);
        --DBMS_OUTPUT.PUT_LINE(id_athlete || ' ' || id_evenement || ' ' || resultat_ || ' ' || medailleDeterminee || ' ' || code_noc);
end;

SELECT * FROM PARTICIPATION_INDIVIDUELLE;
BEGIN
    ajouter_resultat_individuel(930015, 7435, 'ALG', '2');
end;

DELETE FROM PARTICIPATION_INDIVIDUELLE WHERE IDEVENT=930015 AND IDATHLETE=7435;
SELECT * FROM LOG;


SELECT * FROM PARTICIPATION_INDIVIDUELLE WHERE RESULTAT='=1';



CREATE OR REPLACE PROCEDURE ajouter_resultat_equipe(id_evenement EVENEMENT.IDEVENEMENT%TYPE, id_equipe EQUIPE.IDEQUIPE%TYPE, resultat_ PARTICIPATION_EQUIPE.RESULTAT%TYPE) IS
    equipeInexistante NUMBER;
    evenementInexistant NUMBER;
    equipeDejaPresente NUMBER;

    medailleDeterminee varchar2(20);

    cntSansEg NUMBER;
    cntAvecEg NUMBER;
    estExaequo NUMBER;

BEGIN
    SELECT CASE WHEN COUNT(*)=0 THEN 1 ELSE 0 END INTO equipeInexistante FROM EQUIPE WHERE IDEQUIPE=id_equipe;

    SELECT (CASE WHEN COUNT(*)=0 THEN 1 ELSE 0 END) into evenementInexistant FROM EVENEMENT WHERE IDEVENEMENT=id_evenement;


    IF equipeInexistante=1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Équipe inexistante' );
    END IF;

    IF evenementInexistant=1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Événement inexistant' );
    END IF;


    IF SUBSTR(resultat_, 0, 1) = '=' THEN
        estExaequo := 1;
    ELSE estExaequo:=0;
    END IF;

    SELECT COUNT(RESULTAT) INTO cntAvecEg FROM PARTICIPATION_EQUIPE
    WHERE IDEVENEMENT=id_evenement AND RESULTAT=('='|| REPLACE(resultat_, '=', ''));

    SELECT COUNT(RESULTAT) INTO cntSansEg FROM PARTICIPATION_EQUIPE
    WHERE IDEVENEMENT=id_evenement AND RESULTAT=REPLACE(resultat_, '=', '');



    --'=1' et '1'
    IF estExaequo=1 AND cntSansEg>0 THEN RAISE_APPLICATION_ERROR(-20002,'Position déjà occupée');
    END IF;
    /*
    --'=1' et aucun autre '=1'
    IF estExaequo=1 AND cntAvecEg=0 THEN RAISE_APPLICATION_ERROR(-20011,'Position déjà occupée');
    END IF;
    ??? que faire si aucun '=1' mais qu'on souhaite en insérer un pour la premiere fois pour en mettre un deuxieme ?
    */

    --'1' et '=1' '=1'
    IF estExaequo=0 AND cntAvecEg>0 THEN RAISE_APPLICATION_ERROR(-20002,'Position déjà occupée');
    END IF;

    --'1' et '1'
    IF estExaequo=0 AND cntSansEg>0 THEN RAISE_APPLICATION_ERROR( -20002, 'Position déjà occupée');
    END IF;




    SELECT CASE WHEN COUNT(*)>0 THEN 1 ELSE 0 END INTO equipeDejaPresente
    FROM PARTICIPATION_EQUIPE
    WHERE IDEVENEMENT=id_evenement AND IDEQUIPE=id_equipe ;


    --select puis if, select puis if, select puis if...

    IF equipeDejaPresente=1 THEN RAISE_APPLICATION_ERROR(-20003, 'Équipe déjà classée');
    end if;

    IF REPLACE(resultat_, '=', '')='1' THEN medailleDeterminee:='Gold';
    ELSIF REPLACE(resultat_, '=', '')='2' THEN medailleDeterminee:='Silver';
    ELSIF REPLACE(resultat_, '=', '')='3' THEN medailleDeterminee:='Bronze';
    ELSE medailleDeterminee:=null;--pour être sûr
    END IF;


    INSERT INTO PARTICIPATION_EQUIPE VALUES(id_evenement, id_equipe, resultat_, medailleDeterminee);
end;
/

/*
SELECT * FROM NOTE_AUTO_S204;

SELECT *
FROM DBA_TAB_PRIVS WHERE TABLE_NAME='LOG' AND OWNER='BELHAC1';
SELECT * FROM LOG;
*/

SELECT * FROM NOTE_AUTO_S204;

DECLARE
    a JSON_OBJECT_T;
begin
    DBMS_OUTPUT.PUT_LINE('');
end;

SELECT count() FROM LOG;


SELECT * FROM NOTE_AUTO_S204;
---AthletesMedailles
/*
MedaillesAthletes + medaillesEquipe
diviser en vues
nvl(orMedaille, )
*/
SELECT COUNT(*) FROM MEDAILLES_ATHLETES; //155943

SELECT COUNT(*) FROM MEDAILLES_NOC; //234


SELECT * FROM PARTICIPATION_INDIVIDUELLE WHERE IDEVENT=333;