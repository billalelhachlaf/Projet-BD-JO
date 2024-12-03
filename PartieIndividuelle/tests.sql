DROP TABLE PHASE CASCADE CONSTRAINTS ;
CREATE TABLE PHASE (
       IdPhase NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) PRIMARY KEY ,
       IdEvenement NUMBER NOT NULL REFERENCES EVENEMENT(IDEVENEMENT),
       TitrePhase  VARCHAR2(100)
);

DROP TABLE STAT_PHASE CASCADE CONSTRAINTS ;
CREATE TABLE STAT_PHASE (
        idStatPhase NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) PRIMARY KEY ,
        IdPhase    NUMBER NOT NULL REFERENCES PHASE(IDPHASE)  ,
        IdAthlete  NUMBER, -- REFERENCES PARTICIPATION_INDIVIDUELLE(IDATHLETE)  ,
        IdEquipe   NUMBER,-- REFERENCES PARTICIPATION_EQUIPE(IDEQUIPE) ,
        TitreStat  VARCHAR2(100),
        ValeurStat VARCHAR(40)
);


INSERT INTO PHASE (IDEVENEMENT, TITREPHASE)VALUES (333, '');
SELECT * FROM PHASE;

declare
    idEquipe_ NUMBER;
begin
    SELECT IDEQUIPE INTO idEquipe_ FROM PARTICIPATION_EQUIPE
    NATURAL JOIN EQUIPE
    NATURAL JOIN COMPOSITION_EQUIPE
    NATURAL JOIN ATHLETE
    WHERE IDEVENEMENT=333 AND NOMATHLETE='Zimmerer';

    --INSERT INTO STAT_PHASE(IdPhase, IdAthlete, IdEquipe, TitreStat, ValeurStat) VALUES(1, NULL, IDEQUIPE_ , 'Time', '4:57.07');
    INSERT INTO STAT_PHASE(IdPhase, IdAthlete, IdEquipe, TitreStat, ValeurStat) VALUES(1, NULL, IDEQUIPE_, 'Run #1', '1:14.81 (1)');
    INSERT INTO STAT_PHASE(IdPhase, IdAthlete, IdEquipe, TitreStat, ValeurStat) VALUES(1, NULL, IDEQUIPE_, 'Run #2', '1:14.56 (1)');
    INSERT INTO STAT_PHASE(IdPhase, IdAthlete, IdEquipe, TitreStat, ValeurStat) VALUES(1, NULL, IDEQUIPE_, 'Run #3','1:13.51 (1)');
    INSERT INTO STAT_PHASE(IdPhase, IdAthlete, IdEquipe, TitreStat, ValeurStat) VALUES(1, NULL, IDEQUIPE_, 'Run #4', '1:14.19 (4)');
end;





INSERT INTO PHASE (IDEVENEMENT, TITREPHASE) VALUES(1291,'Final Round');
--idPhase=2

declare
    idAthlete_ NUMBER;
begin
    idAthlete_:=85681;
    INSERT INTO STAT_PHASE(IdPhase, IdAthlete, IdEquipe, TitreStat, ValeurStat) VALUES(2, idAthlete_, NULL, 'Pos', '1');
    INSERT INTO STAT_PHASE(IdPhase, IdAthlete, IdEquipe, TitreStat, ValeurStat) VALUES(2, idAthlete_, NULL, 'Number', '2');
    INSERT INTO STAT_PHASE(IdPhase, IdAthlete, IdEquipe, TitreStat, ValeurStat) VALUES(2, idAthlete_, NULL, 'Time', '1:49.27');
    INSERT INTO STAT_PHASE(IdPhase, IdAthlete, IdEquipe, TitreStat, ValeurStat) VALUES(2, idAthlete_, NULL, 'Run #1', '55.36 (1)');
    INSERT INTO STAT_PHASE(IdPhase, IdAthlete, IdEquipe, TitreStat, ValeurStat) VALUES(2, idAthlete_, NULL, 'Run #2', '53.91 (2)'	);
end;

CREATE OR REPLACE VIEW STATS_EVENEMENT AS SELECT LISTAGG(TitreStat||': '||ValeurStat, ',') statistiques, IdAthlete, IdEquipe, IDEVENEMENT, TitrePhase   FROM STAT_PHASE
NATURAL JOIN PHASE
NATURAL JOIN EVENEMENT
GROUP BY IdAthlete, IdEquipe, TitrePhase, IDEVENEMENT;



SELECT * FROM STATS_EVENEMENT
WHERE IDEVENEMENT=1291 AND IdAthlete=85681;


SELECT * FROM MEDAILLES_ATHLETES;
SELECT s.inst_id,
       s.sid,
       s.serial#,
       p.spid,
       s.username,
       s.program FROM   gv$session s
                            JOIN gv$process p ON p.addr = s.paddr AND p.inst_id = s.inst_id;

SELECT SUM(note) FROM NOTE_AUTO_S204;