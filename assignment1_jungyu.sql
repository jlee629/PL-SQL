-- 1. List of criminals with less than average violations and having aliases.
SELECT c.first || ' ' || c.last AS full_name
    FROM criminals c
    JOIN sentences s ON c.criminal_id = s.criminal_id
    JOIN aliases a ON c.criminal_id = a.criminal_id
    WHERE s.violations < (SELECT AVG(violations) FROM sentences)
    GROUP BY c.first, c.last 
    HAVING COUNT(a.alias_id) > 0;

-- 2. List criminal(s) that Crime charges court fee is greater than min per crime.
--"List the criminal(s) whose crime charges have a court fee greater than the minimum court fee 
-- charged for each respective crime."
SELECT c.first || ' ' || c.last AS full_name
FROM criminals c
JOIN crimes cr ON c.criminal_id = cr.criminal_id
JOIN (
  SELECT crime_id, MIN(court_fee) AS min_court_fee
  FROM crime_charges
  GROUP BY crime_id
) min_fee ON cr.crime_id = min_fee.crime_id
JOIN crime_charges cc ON cr.crime_id = cc.crime_id
WHERE cc.court_fee > min_fee.min_court_fee
GROUP BY c.first, c.last;

-- 3. List Officers that have less of equal avg number of crimes assigned.
SELECT o.first || ' ' || o.last AS full_name
    FROM officers o
    JOIN crime_officers co ON o.officer_id = co.officer_id
    GROUP BY o.first, o.last
    HAVING COUNT(co.crime_id) <= (SELECT AVG(crime_count) 
        FROM (SELECT officer_id, COUNT(crime_id) AS crime_count 
            FROM crime_officers 
            GROUP BY officer_id));

SELECT o.first || ' ' || o.last AS full_name
    FROM officers o
    JOIN crime_officers co ON o.officer_id = co.officer_id
    GROUP BY o.first, o.last
    HAVING COUNT(co.crime_id) <= (SELECT AVG(COUNT(crime_id)) 
        FROM crime_officers 
        GROUP BY officer_id);

-- 4. List criminals that have Max amount paid in crime charges per crime.
-- "List the criminals who have the maximum amount paid in crime charges for each individual crime."
        
SELECT c.first || ' ' || c.last AS full_name
FROM criminals c
JOIN crimes cr ON c.criminal_id = cr.criminal_id
JOIN crime_charges cc ON cr.crime_id = cc.crime_id
WHERE cc.amount_paid = (
  SELECT MAX(amount_paid)
  FROM crime_charges
  WHERE crime_id = cr.crime_id
)
GROUP BY c.first, c.last;


-- 5. List criminals that have less or equal than average sentences issued.
SELECT c.first || ' ' || c.last AS full_name
    FROM criminals c
    JOIN sentences s ON c.criminal_id = s.criminal_id
    GROUP BY c.first, c.last
    HAVING COUNT(s.sentence_id) <= (SELECT AVG(sentence_count) 
        FROM (SELECT criminal_id, COUNT(sentence_id) AS sentence_count 
            FROM sentences 
            GROUP BY criminal_id));

SELECT c.first || ' ' || c.last AS full_name 
    FROM criminals c
    JOIN sentences s ON c.criminal_id = s.criminal_id
    GROUP BY c.first, c.last 
    HAVING COUNT(s.sentence_id) <= (SELECT AVG(COUNT(sentence_id)) 
                                        FROM sentences 
                                        GROUP BY criminal_id);

-- 6. List probation officers that have less than average criminals with sentences assigned with them.
SELECT po.first || ' ' || po.last AS full_name 
    FROM prob_officers po
    JOIN sentences s ON po.prob_id = s.prob_id
    GROUP BY po.first, po.last 
    HAVING COUNT(DISTINCT s.criminal_id) < (SELECT AVG(criminal_count) 
        FROM (SELECT prob_id, COUNT(DISTINCT criminal_id) AS criminal_count 
            FROM sentences 
            GROUP BY prob_id));

SELECT AVG(criminal_count) 
        FROM (SELECT prob_id, COUNT(DISTINCT criminal_id) AS criminal_count 
            FROM sentences 
            GROUP BY prob_id);

SELECT prob_id, COUNT(DISTINCT criminal_id) AS criminal_count 
            FROM sentences 
            GROUP BY prob_id;