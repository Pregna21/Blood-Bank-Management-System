-- 03_queries.sql: Constraints, ANY, ALL, UNION, INTERSECT, JOIN, subqueries, aggregates, GROUP BY, HAVING, window functions
-- Blood Bank Management System (MySQL 8.0.31 or later)

USE BloodBank;

-- ================= Constraints and special queries =================

-- ---------- Constraints ----------
-- Add a constraint
ALTER TABLE BLOOD_REQUESTS
ADD CONSTRAINT chk_units_required
CHECK (UnitsRequired > 0);

-- Inspect table constraints and column definitions
SHOW CREATE TABLE DONATIONS;


-- ---------- ANY ----------
SELECT Donor_id, Name
FROM DONORS
WHERE Donor_id IN (
    SELECT Donor_id
    FROM DONATIONS
    WHERE Hemoglobin > ANY (
        SELECT Hemoglobin
        FROM DONATIONS
        WHERE Bank_id = 202
    )
)
ORDER BY Donor_id;


-- ---------- ALL ----------
SELECT Donor_id, Name
FROM DONORS
WHERE Donor_id IN (
    SELECT Donor_id
    FROM DONATIONS
    WHERE Hemoglobin > ALL (
        SELECT Hemoglobin
        FROM DONATIONS
        WHERE Bank_id = 202
    )
)
ORDER BY Donor_id;


-- ---------- UNION ----------
SELECT Name, BloodGroup, 'Donor' AS Role
FROM DONORS
WHERE BloodGroup = 'O-'
UNION
SELECT Name, BloodGroup, 'Patient' AS Role
FROM PATIENTS
WHERE BloodGroup = 'O-';


-- ---------- INTERSECT ----------
SELECT Donor_id
FROM DONATIONS
INTERSECT
SELECT Donor_id
FROM DONORS
WHERE Location = 'Kukatpally'
ORDER BY Donor_id;


-- ---------- JOIN ----------
SELECT
    DN.Donation_id,
    D.Name,
    D.BloodGroup,
    B.BankName,
    DN.DonationDate,
    DN.Quantity_ml
FROM DONATIONS DN
JOIN DONORS D
    ON DN.Donor_id = D.Donor_id
JOIN BLOOD_BANKS B
    ON DN.Bank_id = B.Bank_id
ORDER BY DN.Donation_id;


-- ================= Nested and correlated subqueries =================

-- ---------- Nested subquery ----------
SELECT Donor_id, Name
FROM DONORS
WHERE Donor_id IN (
    SELECT Donor_id
    FROM DONATIONS
    WHERE Hemoglobin > (
        SELECT AVG(Hemoglobin)
        FROM DONATIONS
    )
)
ORDER BY Donor_id;


-- ---------- Correlated subquery ----------
SELECT
    DN.Donation_id,
    DN.Bank_id,
    DN.Quantity_ml
FROM DONATIONS DN
WHERE DN.Quantity_ml > (
    SELECT AVG(D2.Quantity_ml)
    FROM DONATIONS D2
    WHERE D2.Bank_id = DN.Bank_id
)
ORDER BY DN.Donation_id;


-- ================= Aggregate functions, window functions, GROUP BY and HAVING =================

-- ---------- Aggregate functions ----------
SELECT
    COUNT(*) AS TotalDonations,
    SUM(Quantity_ml) AS TotalCollected_ml,
    AVG(Quantity_ml) AS AverageQuantity,
    MAX(Quantity_ml) AS MaximumQuantity,
    MIN(Quantity_ml) AS MinimumQuantity
FROM DONATIONS;


-- ---------- GROUP BY ----------
SELECT
    B.Bank_id,
    B.BankName,
    COUNT(DN.Donation_id) AS Donations,
    SUM(DN.Quantity_ml) AS TotalCollected_ml
FROM BLOOD_BANKS B
JOIN DONATIONS DN
    ON B.Bank_id = DN.Bank_id
GROUP BY B.Bank_id, B.BankName
ORDER BY B.Bank_id;


-- ---------- HAVING ----------
SELECT
    Bank_id,
    SUM(Quantity_ml) AS TotalCollected_ml
FROM DONATIONS
GROUP BY Bank_id
HAVING SUM(Quantity_ml) > 1500
ORDER BY Bank_id;


-- ---------- Window functions ----------
SELECT
    Bank_id,
    Donation_id,
    Hemoglobin,
    RANK() OVER (
        ORDER BY Hemoglobin DESC
    ) AS HbRank,
    SUM(Quantity_ml) OVER (
        PARTITION BY Bank_id
    ) AS BankTotal_ml
FROM DONATIONS
ORDER BY HbRank, Donation_id;
