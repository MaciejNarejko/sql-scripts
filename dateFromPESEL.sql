/* PL/SQL Training exercises*/
/* FOR FIELD TYPE CHAR(11) CREATE PL/SQL FUNCTION THAT GET BIRTHDAY DATE FROM PESEL NUMBER */

CREATE OR REPLACE FUNCTION bddateFromPesel(pesel IN CHAR)
RETURN VARCHAR2
IS
    p_year number;
    p_month number;
    p_day number;
    result varchar2(40);
BEGIN
    p_year := to_number(substr(pesel,1,2));
    p_month := to_number(substr(pesel,3,2));
    p_day := to_number(substr(pesel,5,2));
    If p_month > 80 THEN
        p_year := p_year + 1800;
        p_month := p_month - 80;
    ELSE
        IF p_month > 40 THEN
            p_year := p_year + 2100;
            p_month := p_month - 40;
        ELSE
             IF p_month > 20 THEN
                p_year := p_year + 2000;
                p_month := p_month - 20;
             ELSE
                p_year := p_year + 1900;
             END IF;
        END IF;
    END IF;
    result := to_char(p_year);
    result := result || '-';
    result := result || to_char(p_miesiac);
    result := result || '-';
    result := result || to_char(p_day);
    return to_date(result,'YYYY-MM-DD');

END;

-- TESTING ON RANDOMLY DATA
SELECT bddateFromPesel('02271405245') FROM dual;
SELECT bddateFromPesel('02441405245') FROM dual;
SELECT bddateFromPesel('02851405245') FROM dual;
SELECT bddateFromPesel('02111405245') FROM dual;