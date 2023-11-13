/* 1. List the names of all criminals who have committed less or equal than average number of crimes 
and aren’t listed as violent offenders. */
SELECT c.first || ' ' || c.last AS full_name
FROM criminals c
JOIN (
  SELECT cr.criminal_id, COUNT(cr.crime_id) AS crime_count
  FROM crimes cr
  JOIN crime_charges cc ON cr.crime_id = cc.crime_id
  JOIN criminals c ON c.criminal_id = cr.criminal_id
  WHERE c.v_status = 'N' -- Not a violent offender
  GROUP BY cr.criminal_id
) sub ON c.criminal_id = sub.criminal_id
WHERE sub.crime_count <= (
  SELECT AVG(num_of_crimes)
  FROM (
    SELECT cr.criminal_id, COUNT(cr.crime_id) AS num_of_crimes
    FROM crimes cr
    GROUP BY cr.criminal_id
  )
);


SELECT c.first || ' ' || c.last AS full_name, sub.crime_count
FROM criminals c

JOIN (
  SELECT cr.criminal_id, COUNT(cr.crime_id) AS crime_count
  FROM crimes cr
  JOIN crime_charges cc ON cr.crime_id = cc.crime_id
  JOIN criminals c ON c.criminal_id = cr.criminal_id
  WHERE c.v_status = 'Y' -- Not a violent offender
  GROUP BY cr.criminal_id
) sub ON c.criminal_id = sub.criminal_id;

SELECT c.first || ' ' || c.last AS full_name, sub.crime_count
FROM criminals c
JOIN (
  SELECT cr.criminal_id, COUNT(cr.crime_id) AS crime_count
  FROM crimes cr
  JOIN crime_charges cc ON cr.crime_id = cc.crime_id
  JOIN criminals c ON c.criminal_id = cr.criminal_id
  WHERE c.v_status = 'N' -- Not a violent offender
  GROUP BY cr.criminal_id
) sub ON c.criminal_id = sub.criminal_id;



SELECT c.first || ' ' || c.last AS full_name
FROM criminals c
JOIN (
  SELECT cr.criminal_id, COUNT(cr.crime_id) AS crime_count
  FROM crimes cr
  JOIN crime_charges cc ON cr.crime_id = cc.crime_id
  JOIN criminals c ON c.criminal_id = cr.criminal_id
  WHERE c.v_status = 'N' -- Not a violent offender
  GROUP BY cr.criminal_id
) sub ON c.criminal_id = sub.criminal_id
WHERE sub.crime_count <= (
  SELECT AVG(num_of_crimes) 
  FROM (
    SELECT cr.criminal_id, COUNT(cr.crime_id) AS num_of_crimes
    FROM crimes cr
    GROUP BY cr.criminal_id
  ) 
);


/* 
2. List appeal information for each appeal that has a min number of days between the filing and hearing dates.
*/

SELECT *
FROM appeals
WHERE (hearing_date - filing_date) = (
    SELECT MIN(hearing_date - filing_date)
    FROM appeals
);


/*
3. Using a Cursor Variable
Create a block with a single cursor that can perform a different query of pledge payment data based on user input. 
Input provided to the block includes a donor ID and an indicator value of D or S. 
The D represents details and indicates that each payment on all pledges the donor has made should be displayed. 
The S indicates displaying summary data of the pledge payment total for each pledge the donor has made. 
Both D and S has to be in one execution of code.
*/
DECLARE
  TYPE payment_cursor_type IS REF CURSOR;
  payment_cursor payment_cursor_type;

  v_donor_id dd_donor.iddonor%TYPE;
  v_indicator CHAR(1);

  v_idpledge dd_pledge.idpledge%TYPE;
  v_pledgedate dd_pledge.pledgedate%TYPE;
  v_payamt dd_payment.payamt%TYPE;
  v_paymethod dd_payment.paymethod%TYPE;

  v_total_payment NUMBER := 0;
BEGIN
  -- test 1 (indicator 'D')
  v_donor_id := 301;  
  v_indicator := 'D';

  OPEN payment_cursor FOR
    SELECT p.idpledge, p.pledgedate, pm.payamt, pm.paymethod
    FROM dd_pledge p
    JOIN dd_payment pm ON p.idpledge = pm.idpledge
    WHERE p.iddonor = v_donor_id;

  LOOP
    FETCH payment_cursor INTO v_idpledge, v_pledgedate, v_payamt, v_paymethod;
    EXIT WHEN payment_cursor%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE('Pledge ID: ' || v_idpledge || ', Pledgedate: ' || v_pledgedate || ', Payment Amount: ' || v_payamt || ', Payment Method:' || v_paymethod);
  END LOOP;

  CLOSE payment_cursor;

  -- test 2 (indicator 'S')
  v_donor_id := 301;  
  v_indicator := 'S';

  OPEN payment_cursor FOR
    SELECT p.idpledge, SUM(pm.payamt)
    FROM dd_pledge p
    JOIN dd_payment pm ON p.idpledge = pm.idpledge
    WHERE p.iddonor = v_donor_id
    GROUP BY p.idpledge;

  LOOP
    FETCH payment_cursor INTO v_idpledge, v_payamt;
    EXIT WHEN payment_cursor%NOTFOUND;

    v_total_payment := v_total_payment + v_payamt;
     DBMS_OUTPUT.PUT_LINE('Pledge ID: ' || v_idpledge || ', Total Payment: ' || v_payamt);
  END LOOP;

  CLOSE payment_cursor;

  DBMS_OUTPUT.PUT_LINE('Total Payment: ' || v_total_payment);
END;
/


















/* 1. List the names of all criminals who have committed less or equal than average number of crimes 
and aren’t listed as violent offenders. */

SELECT c.first || ' ' || c.last AS full_name
FROM criminals c
JOIN (
  SELECT cr.criminal_id, COUNT(cr.crime_id) AS crime_count
  FROM crimes cr
  JOIN crime_charges cc ON cr.crime_id = cc.crime_id
  JOIN criminals c ON c.criminal_id = cr.criminal_id
  WHERE c.v_status = 'N' -- Not a violent offender
  GROUP BY cr.criminal_id
) sub ON c.criminal_id = sub.criminal_id
WHERE sub.crime_count <= (
  SELECT AVG(num_of_crimes)
  FROM (
    SELECT cr.criminal_id, COUNT(cr.crime_id) AS num_of_crimes
    FROM crimes cr
    GROUP BY cr.criminal_id
  )
);


/* 
2. List appeal information for each appeal that has a min number of days between the filing and hearing dates.
*/

SELECT *
FROM appeals
WHERE (hearing_date - filing_date) = (
    SELECT MIN(hearing_date - filing_date)
    FROM appeals
);


/*
3. Using a Cursor Variable
Create a block with a single cursor that can perform a different query of pledge payment data based on user input. 
Input provided to the block includes a donor ID and an indicator value of D or S. 
The D represents details and indicates that each payment on all pledges the donor has made should be displayed. 
The S indicates displaying summary data of the pledge payment total for each pledge the donor has made. 
Both D and S has to be in one execution of code.
*/
DECLARE
  TYPE payment_cursor_type IS REF CURSOR;
  payment_cursor payment_cursor_type;

  v_donor_id dd_donor.iddonor%TYPE;
  v_indicator CHAR(1);

  v_idpledge dd_pledge.idpledge%TYPE;
  v_pledgedate dd_pledge.pledgedate%TYPE;
  v_payamt dd_payment.payamt%TYPE;
  v_paymethod dd_payment.paymethod%TYPE;

  v_total_payment NUMBER := 0;
BEGIN
  -- test 1 (indicator 'D')
  v_donor_id := 301;  
  v_indicator := 'D';

  OPEN payment_cursor FOR
    SELECT p.idpledge, p.pledgedate, pm.payamt, pm.paymethod
    FROM dd_pledge p
    JOIN dd_payment pm ON p.idpledge = pm.idpledge
    WHERE p.iddonor = v_donor_id;

  LOOP
    FETCH payment_cursor INTO v_idpledge, v_pledgedate, v_payamt, v_paymethod;
    EXIT WHEN payment_cursor%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE('Pledge ID: ' || v_idpledge || ', Pledgedate: ' || v_pledgedate || ', Payment Amount: ' || v_payamt || ', Payment Method:' || v_paymethod);
  END LOOP;

  CLOSE payment_cursor;

  -- test 2 (indicator 'S')
  v_donor_id := 301;  
  v_indicator := 'S';

  OPEN payment_cursor FOR
    SELECT p.idpledge, SUM(pm.payamt)
    FROM dd_pledge p
    JOIN dd_payment pm ON p.idpledge = pm.idpledge
    WHERE p.iddonor = v_donor_id
    GROUP BY p.idpledge;

  LOOP
    FETCH payment_cursor INTO v_idpledge, v_payamt;
    EXIT WHEN payment_cursor%NOTFOUND;

    v_total_payment := v_total_payment + v_payamt;
     DBMS_OUTPUT.PUT_LINE('Pledge ID: ' || v_idpledge || ', Total Payment: ' || v_payamt);
  END LOOP;

  CLOSE payment_cursor;

  DBMS_OUTPUT.PUT_LINE('Total Payment: ' || v_total_payment);
END;
/









/* 1. List the names of all criminals who have committed less or equal than average number of crimes 
and aren’t listed as violent offenders. */

SELECT c.first || ' ' || c.last AS full_name
FROM criminals c
JOIN (
  SELECT cr.criminal_id, COUNT(cr.crime_id) AS crime_count
  FROM crimes cr
  JOIN crime_charges cc ON cr.crime_id = cc.crime_id
  JOIN criminals c ON c.criminal_id = cr.criminal_id
  WHERE c.v_status = 'N' -- Not a violent offender
  GROUP BY cr.criminal_id
) sub ON c.criminal_id = sub.criminal_id
WHERE sub.crime_count <= (
  SELECT AVG(num_of_crimes)
  FROM (
    SELECT cr.criminal_id, COUNT(cr.crime_id) AS num_of_crimes
    FROM crimes cr
    GROUP BY cr.criminal_id
  )
);


/* 
2. List appeal information for each appeal that has a min number of days between the filing and hearing dates.
*/

SELECT *
FROM appeals
WHERE (hearing_date - filing_date) = (
    SELECT MIN(hearing_date - filing_date)
    FROM appeals
);


/*
3. Using a Cursor Variable
Create a block with a single cursor that can perform a different query of pledge payment data based on user input. 
Input provided to the block includes a donor ID and an indicator value of D or S. 
The D represents details and indicates that each payment on all pledges the donor has made should be displayed. 
The S indicates displaying summary data of the pledge payment total for each pledge the donor has made. 
Both D and S has to be in one execution of code.
*/
DECLARE
  TYPE payment_cursor_type IS REF CURSOR;
  payment_cursor payment_cursor_type;

  v_donor_id dd_donor.iddonor%TYPE;
  v_indicator CHAR(1);

  v_idpledge dd_pledge.idpledge%TYPE;
  v_pledgedate dd_pledge.pledgedate%TYPE;
  v_payamt dd_payment.payamt%TYPE;
  v_paymethod dd_payment.paymethod%TYPE;

  v_total_payment NUMBER := 0;
BEGIN
  -- test 1 (indicator 'D')
  v_donor_id := 301;  
  v_indicator := 'D';

  OPEN payment_cursor FOR
    SELECT p.idpledge, p.pledgedate, pm.payamt, pm.paymethod
    FROM dd_pledge p
    JOIN dd_payment pm ON p.idpledge = pm.idpledge
    WHERE p.iddonor = v_donor_id;

  LOOP
    FETCH payment_cursor INTO v_idpledge, v_pledgedate, v_payamt, v_paymethod;
    EXIT WHEN payment_cursor%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE('Pledge ID: ' || v_idpledge || ', Pledgedate: ' || v_pledgedate || ', Payment Amount: ' || v_payamt || ', Payment Method:' || v_paymethod);
  END LOOP;

  CLOSE payment_cursor;

  -- test 2 (indicator 'S')
  v_donor_id := 301;  
  v_indicator := 'S';

  OPEN payment_cursor FOR
    SELECT p.idpledge, SUM(pm.payamt)
    FROM dd_pledge p
    JOIN dd_payment pm ON p.idpledge = pm.idpledge
    WHERE p.iddonor = v_donor_id
    GROUP BY p.idpledge;

  LOOP
    FETCH payment_cursor INTO v_idpledge, v_payamt;
    EXIT WHEN payment_cursor%NOTFOUND;

    v_total_payment := v_total_payment + v_payamt;
     DBMS_OUTPUT.PUT_LINE('Pledge ID: ' || v_idpledge || ', Total Payment: ' || v_payamt);
  END LOOP;

  CLOSE payment_cursor;

  DBMS_OUTPUT.PUT_LINE('Total Payment: ' || v_total_payment);
END;
/
