--------------------------------------------------------
--  Constraints for Table ATHLETE
--------------------------------------------------------

ALTER TABLE "ATHLETE" MODIFY ("GENRE" NOT NULL ENABLE);
ALTER TABLE "ATHLETE" ADD PRIMARY KEY ("IDATHLETE") USING INDEX  ENABLE;

--------------------------------------------------------
--  Constraints for Table COMPOSITION_EQUIPE
--------------------------------------------------------

ALTER TABLE "COMPOSITION_EQUIPE" ADD CONSTRAINT "PK_COMPOSITION_EQUIPE" PRIMARY KEY ("IDEQUIPE", "IDATHLETE") USING INDEX  ENABLE;

--------------------------------------------------------
--  Constraints for Table DISCIPLINE
--------------------------------------------------------

ALTER TABLE "DISCIPLINE" MODIFY ("NOMDISCIPLINE" NOT NULL ENABLE);
ALTER TABLE "DISCIPLINE" MODIFY ("CODESPORT" NOT NULL ENABLE);
ALTER TABLE "DISCIPLINE" ADD PRIMARY KEY ("CODEDISCIPLINE") USING INDEX  ENABLE;

--------------------------------------------------------
--  Constraints for Table EQUIPE
--------------------------------------------------------

ALTER TABLE "EQUIPE" MODIFY ("NOMEQUIPE" NOT NULL ENABLE);
ALTER TABLE "EQUIPE" MODIFY ("NOC" NOT NULL ENABLE);
ALTER TABLE "EQUIPE" ADD CONSTRAINT "PK_EQUIPE" PRIMARY KEY ("IDEQUIPE") USING INDEX  ENABLE;

--------------------------------------------------------
--  Constraints for Table EVENEMENT
--------------------------------------------------------

ALTER TABLE "EVENEMENT" MODIFY ("NOMEVENEMENT" NOT NULL ENABLE);
ALTER TABLE "EVENEMENT" MODIFY ("CODEDISCIPLINE" NOT NULL ENABLE);
ALTER TABLE "EVENEMENT" MODIFY ("IDHOTE" NOT NULL ENABLE);
ALTER TABLE "EVENEMENT" ADD PRIMARY KEY ("IDEVENEMENT") USING INDEX  ENABLE;

--------------------------------------------------------
--  Constraints for Table HOTE
--------------------------------------------------------

ALTER TABLE "HOTE" MODIFY ("LIBELLEHOTE" NOT NULL ENABLE);
ALTER TABLE "HOTE" MODIFY ("ANNEEHOTE" NOT NULL ENABLE);
ALTER TABLE "HOTE" MODIFY ("SAISON" NOT NULL ENABLE);
ALTER TABLE "HOTE" MODIFY ("VILLEHOTE" NOT NULL ENABLE);
ALTER TABLE "HOTE" MODIFY ("CODENOCHOTE" NOT NULL ENABLE);
ALTER TABLE "HOTE" MODIFY ("DATESCOMPETITION" NOT NULL ENABLE);
ALTER TABLE "HOTE" ADD PRIMARY KEY ("IDHOTE") USING INDEX  ENABLE;

--------------------------------------------------------
--  Constraints for Table NOC
--------------------------------------------------------

ALTER TABLE "NOC" MODIFY ("NOMNOC" NOT NULL ENABLE);
ALTER TABLE "NOC" ADD PRIMARY KEY ("CODENOC") USING INDEX  ENABLE;

--------------------------------------------------------
--  Constraints for Table SPORT
--------------------------------------------------------

ALTER TABLE "SPORT" MODIFY ("NOMSPORT" NOT NULL ENABLE);
ALTER TABLE "SPORT" ADD PRIMARY KEY ("CODESPORT") USING INDEX  ENABLE;

--------------------------------------------------------
--  DDL for Index PK_PARTICIPATION_EQUIPE
--------------------------------------------------------

CREATE UNIQUE INDEX "PK_PARTICIPATION_EQUIPE" ON "PARTICIPATION_EQUIPE" ("IDEVENEMENT", "IDEQUIPE");

--------------------------------------------------------
--  DDL for Index PK_PARTICIPATION_INDIVIDUELLE
--------------------------------------------------------

CREATE UNIQUE INDEX "PK_PARTICIPATION_INDIVIDUELLE" ON "PARTICIPATION_INDIVIDUELLE" ("IDATHLETE", "IDEVENT");

--------------------------------------------------------
--  Ref Constraints for Table HOTE
--------------------------------------------------------

ALTER TABLE "HOTE" ADD CONSTRAINT "FK_HOTE_NOC" FOREIGN KEY ("CODENOCHOTE") REFERENCES "NOC" ("CODENOC") ENABLE;

--------------------------------------------------------
--  Ref Constraints for Table COMPOSITION_EQUIPE
--------------------------------------------------------

ALTER TABLE "COMPOSITION_EQUIPE" ADD CONSTRAINT "FK_COMPOSITION_EQUIPE_EQUIPE" FOREIGN KEY ("IDEQUIPE") REFERENCES "EQUIPE" ("IDEQUIPE") ENABLE;
ALTER TABLE "COMPOSITION_EQUIPE" ADD CONSTRAINT "FK_COMPOSITION_EQUIPE_ATHLETE" FOREIGN KEY ("IDATHLETE") REFERENCES "ATHLETE" ("IDATHLETE") ENABLE;

--------------------------------------------------------
--  Ref Constraints for Table DISCIPLINE
--------------------------------------------------------

ALTER TABLE "DISCIPLINE" ADD CONSTRAINT "FK_DISCIPLINE_SPORT" FOREIGN KEY ("CODESPORT") REFERENCES "SPORT" ("CODESPORT") ENABLE;

--------------------------------------------------------
--  Ref Constraints for Table EQUIPE
--------------------------------------------------------

ALTER TABLE "EQUIPE" ADD CONSTRAINT "FK_EQUIPE_NOC" FOREIGN KEY ("NOC") REFERENCES "NOC" ("CODENOC") ENABLE;

--------------------------------------------------------
--  Ref Constraints for Table EVENEMENT
--------------------------------------------------------

ALTER TABLE "EVENEMENT" ADD CONSTRAINT "FK_EVENEMENT_HOTE" FOREIGN KEY ("IDHOTE") REFERENCES "HOTE" ("IDHOTE") ENABLE;
ALTER TABLE "EVENEMENT" ADD CONSTRAINT "FK_EVENEMENT_DISCIPLINE" FOREIGN KEY ("CODEDISCIPLINE") REFERENCES "DISCIPLINE" ("CODEDISCIPLINE") ENABLE;

--------------------------------------------------------
--  Constraints for Table PARTICIPATION_INDIVIDUELLE
--------------------------------------------------------

ALTER TABLE "PARTICIPATION_INDIVIDUELLE" MODIFY ("RESULTAT" NOT NULL ENABLE);
ALTER TABLE "PARTICIPATION_INDIVIDUELLE" ADD CONSTRAINT "PK_PARTICIPATION_INDIVIDUELLE" PRIMARY KEY ("IDATHLETE", "IDEVENT") USING INDEX  ENABLE;

--------------------------------------------------------
--  Ref Constraints for Table PARTICIPATION
--------------------------------------------------------

ALTER TABLE "PARTICIPATION_INDIVIDUELLE" ADD CONSTRAINT "FK_PARTICIPATION_INDIVIDUELLE_ATHLETE" FOREIGN KEY ("IDATHLETE") REFERENCES "ATHLETE" ("IDATHLETE") ENABLE;
ALTER TABLE "PARTICIPATION_INDIVIDUELLE" ADD CONSTRAINT "FK_PARTICIPATION_INDIVIDUELLE_EVENEMENT" FOREIGN KEY ("IDEVENT") REFERENCES "EVENEMENT" ("IDEVENEMENT") ENABLE;
ALTER TABLE "PARTICIPATION_INDIVIDUELLE" ADD CONSTRAINT "FK_PARTICIPATION_INDIVIDUELLE_NOC" FOREIGN KEY ("NOC") REFERENCES "NOC" ("CODENOC") ENABLE;

--------------------------------------------------------
--  Constraints for Table PARTICIPATION_EQUIPE
--------------------------------------------------------

ALTER TABLE "PARTICIPATION_EQUIPE" ADD CONSTRAINT "PK_PARTICIPATION_EQUIPE" PRIMARY KEY ("IDEVENEMENT", "IDEQUIPE") USING INDEX  ENABLE;

--------------------------------------------------------
--  Ref Constraints for Table PARTICIPATION_EQUIPE
--------------------------------------------------------

ALTER TABLE "PARTICIPATION_EQUIPE" ADD CONSTRAINT "FK_PARTICIPATION_EQUIPE_EVENEMENT" FOREIGN KEY ("IDEVENEMENT") REFERENCES "EVENEMENT" ("IDEVENEMENT") ENABLE;
ALTER TABLE "PARTICIPATION_EQUIPE" ADD CONSTRAINT "FK_PARTICIPATION_EQUIPE_EQUIPE" FOREIGN KEY ("IDEQUIPE") REFERENCES "EQUIPE" ("IDEQUIPE") ENABLE;
