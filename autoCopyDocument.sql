/* PL/SQL Training exercises*/

DROP TABLE dokumenty CASCADE CONSTRAINTS;
DROP TABLE kopie CASCADE CONSTRAINTS;
 
CREATE TABLE dokumenty
( numdzn NUMBER
,numdok NUMBER
,status CHAR
,CONSTRAINT dok_pk
PRIMARY KEY(numdzn, numdok)
);
 
CREATE TABLE kopie
( numdzn NUMBER
,numdok NUMBER
,status CHAR
,CONSTRAINT kop_pk PRIMARY KEY(numdzn, numdok)
,CONSTRAINT kop_fk
FOREIGN KEY(numdzn, numdok) REFERENCES dokumenty
);
 
DROP TABLE dokumenty_temp;
CREATE GLOBAL TEMPORARY TABLE dokumenty_temp
( numdzn NUMBER
,numdok NUMBER
,status CHAR);
 
CREATE OR REPLACE TRIGGER statusy
BEFORE INSERT OR UPDATE OR DELETE ON dokumenty
FOR EACH ROW
BEGIN
    CASE
        WHEN inserting THEN
            IF :NEW.status = 'D' THEN
                INSERT INTO dokumenty_temp VALUES (:NEW.numdzn, :NEW.numdok, :NEW.status);
            END IF;
        WHEN deleting THEN
            IF :OLD.status = 'D' THEN
                raise_application_error(-20000,'Usuniecie mozliwe tylko w przypadku innych statusow niz D');
            END IF;   
            IF :NEW.status = 'D' AND (:OLD.numdzn != :NEW.numdzn OR :OLD.numdok != :NEW.numdok) THEN
                raise_application_error(-20000,'Nie mozna wprowadzac zmian w dokumencie o statusie D poza statusem');
            ELSIF :NEW.status = 'R' AND :OLD.status = 'D' AND :OLD.numdzn = :NEW.numdzn AND :OLD.numdok = :NEW.numdok THEN
                INSERT INTO dokumenty_temp VALUES (:OLD.numdzn, :OLD.numdok, :NEW.status);
            ELSIF :NEW.status = 'D' AND :OLD.status = 'R' AND :OLD.numdzn = :NEW.numdzn AND :OLD.numdok = :NEW.numdok THEN
                INSERT INTO dokumenty_temp VALUES (:OLD.numdzn, :OLD.numdok, :NEW.status);
            END IF;
    END CASE;
END;
 
CREATE OR REPLACE TRIGGER tworz_kopie
AFTER INSERT OR UPDATE OR DELETE ON dokumenty
DECLARE
ile_statusow CHAR;
BEGIN
FOR I IN (SELECT * FROM dokumenty_temp) LOOP
    IF I.status = 'D' THEN
        SELECT COUNT(status) INTO ile_statusow FROM kopie WHERE numdzn = I.numdzn AND numdok = I.numdok;
        IF ile_statusow = 0 THEN
            INSERT INTO kopie VALUES (I.numdzn, I.numdok, I.status);
        ELSE
            UPDATE kopie SET status = 'D' WHERE numdzn = I.numdzn AND numdok = I.numdok;
        END IF;
    END IF;
    IF I.status = 'R' THEN
        DELETE kopie WHERE numdok = I.numdok AND numdzn = I.numdzn;
    END IF;
END LOOP;
END;
