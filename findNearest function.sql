/* PL/SQL Training exercises*/
/* 
Please create a function that takes arguments regarding localisation and type of restaurant.
Find the nearest local serving selected type of food for those params. Test a function.
*/

-- Create Table and insert sample data
DROP TABLE localisation;

CREATE TABLE localisation(
    latitude NUMBER,
    longitude NUMBER,
    adress VARCHAR2(100), 
    food VARCHAR2(30)
);

INSERT INTO localisation VALUES(12,15,'Warszawa','pizza');
INSERT INTO localisation VALUES(12,16,'Warszawa','kebab');
INSERT INTO localisation VALUES(20,30,'Poznan','pizza');
INSERT INTO localisation VALUES(30,40,'Wroclaw','kebab');
INSERT INTO localisation VALUES(31,41,'Wroclaw','pizza');

-- Calculation the distance between two points
CREATE OR REPLACE FUNCTION calculate_distance (latitude NUMBER, longitude NUMBER, myLatitude NUMBER, myLongitude NUMBER)
RETURN NUMBER
AS
    distance NUMBER;
BEGIN
    -- Calculation distance of 2 points
    distance :=  sqrt((( latitude - myLatitude) * (latitude - myLatitude)) + ((longitude - myLongitude)*(longitude - myLongitude)));
    RETURN distance;
END;

-- Function testing
SELECT calculate_distance(1,1,4,5) FROM dual;

--  Finding the shortest distance between two points 
CREATE OR REPLACE FUNCTION findThePoint(myLatitude IN NUMBER, myLongitude IN NUMBER, typeOfFood IN VARCHAR2)
RETURN VARCHAR2
AS
    theNearest VARCHAR2(100);
    dist NUMBER;
BEGIN
    SELECT MIN(calculate_distance(myLatitude, myLongitude, latitude, longitude)) INTO dist FROM localisation
    WHERE food = typeOfFood;
    
    SELECT adress  INTO theNearest FROM localisation WHERE calculate_distance(myLatitude, myLongitude, latitude, longitude)=dist AND ROWNUM=1 AND food = typeOfFood;
    RETURN theNearest;
END;

-- findThePoint function testing
SELECT  findThePoint(24,34,'pizza') FROM dual;






