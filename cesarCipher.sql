/* PL/SQL Training exercises*/
/* PLEASE CREATE PL/SQL FUNCTION THAT WILL USE CAESAR CIPHER TO ENCRYPT TEXT */

CREATE OR REPLACE FUNCTION changeChar (letter CHAR)

RETURN CHAR
IS
   output CHAR;
BEGIN
    IF ASCII(letter) < 91
    THEN
        SELECT CHR(MOD(ASCII(letter)-62,26)+65) INTO output FROM dual;
    ELSE
        SELECT CHR(MOD(ASCII(letter)-94,26)+97) INTO output FROM dual;
    END IF;
    RETURN output;
END changeChar;

CREATE OR REPLACE FUNCTION caesarcipher (inscription VARCHAR)
RETURN VARCHAR
IS
    I INT;
    L INT;
    output VARCHAR(100) := '';
BEGIN
    SELECT LENGTH(inscription) INTO L FROM dual;
    FOR I IN 1 .. L LOOP
        IF (substr(inscription,I,1) <> ' ')
        THEN
            SELECT output||changeChar(substr(inscription,I,1)) INTO output FROM dual;
        ELSE
            SELECT output||substr(inscription,I,1) INTO output FROM dual;
        END IF;
    END LOOP;
RETURN output;
END;
/
SHOW ERRORS

SELECT caesarCipher('ala ma kota') FROM dual;