-- Blood Bank Management System - complete MySQL script (MySQL 8.0.31 or later)
-- Run in MySQL Workbench or the mysql command-line client, from top to bottom.


-- #################### 01_create_tables.sql ####################

-- ================= DDL commands =================

-- ---------- Create database ----------
CREATE DATABASE BloodBank;
USE BloodBank;


-- ---------- Create tables ----------
CREATE TABLE DONORS (
    Donor_id INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Gender VARCHAR(10),
    DOB DATE,
    BloodGroup VARCHAR(3) NOT NULL,
    PhoneNo VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Address VARCHAR(200),
    CHECK (Gender IN ('Male', 'Female', 'Other')),
    CHECK (BloodGroup IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'))
);

CREATE TABLE BLOOD_BANKS (
    Bank_id INT PRIMARY KEY,
    BankName VARCHAR(100) NOT NULL,
    Address VARCHAR(200),
    PhoneNo VARCHAR(15),
    Capacity INT NOT NULL,
    CHECK (Capacity > 0)
);

CREATE TABLE DONATIONS (
    Donation_id INT PRIMARY KEY,
    Donor_id INT NOT NULL,
    Bank_id INT NOT NULL,
    DonationDate DATE NOT NULL,
    Quantity_ml INT NOT NULL,
    Hemoglobin DECIMAL(4,1),
    FOREIGN KEY (Donor_id)
        REFERENCES DONORS(Donor_id),
    FOREIGN KEY (Bank_id)
        REFERENCES BLOOD_BANKS(Bank_id),
    CHECK (Quantity_ml BETWEEN 300 AND 500),
    CHECK (Hemoglobin >= 12.5)
);

CREATE TABLE BLOOD_UNITS (
    Unit_id INT PRIMARY KEY,
    Donation_id INT NOT NULL,
    Component VARCHAR(20) NOT NULL,
    ExpiryDate DATE NOT NULL,
    Status VARCHAR(20) DEFAULT 'Available',
    FOREIGN KEY (Donation_id)
        REFERENCES DONATIONS(Donation_id),
    CHECK (Component IN ('Whole Blood', 'RBC', 'Plasma', 'Platelets')),
    CHECK (Status IN ('Available', 'Reserved', 'Issued', 'Expired'))
);

CREATE TABLE HOSPITALS (
    Hospital_id INT PRIMARY KEY,
    HospitalName VARCHAR(100) NOT NULL,
    Address VARCHAR(200),
    PhoneNo VARCHAR(15)
);

CREATE TABLE PATIENTS (
    Patient_id INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Gender VARCHAR(10),
    Age INT,
    BloodGroup VARCHAR(3) NOT NULL,
    Hospital_id INT NOT NULL,
    FOREIGN KEY (Hospital_id)
        REFERENCES HOSPITALS(Hospital_id),
    CHECK (Age >= 0)
);

CREATE TABLE BLOOD_REQUESTS (
    Request_id INT PRIMARY KEY,
    Patient_id INT NOT NULL,
    Component VARCHAR(20) NOT NULL,
    UnitsRequired INT NOT NULL,
    RequestDate DATE NOT NULL,
    Priority VARCHAR(10) DEFAULT 'Normal',
    Status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (Patient_id)
        REFERENCES PATIENTS(Patient_id)
);

CREATE TABLE BLOOD_ISSUES (
    Issue_id INT PRIMARY KEY,
    Request_id INT NOT NULL,
    Unit_id INT NOT NULL UNIQUE,
    IssueDate DATE NOT NULL,
    FOREIGN KEY (Request_id)
        REFERENCES BLOOD_REQUESTS(Request_id),
    FOREIGN KEY (Unit_id)
        REFERENCES BLOOD_UNITS(Unit_id)
);

SHOW TABLES;


-- ---------- ALTER, RENAME, TRUNCATE and DROP ----------
-- Add a column
ALTER TABLE DONORS
ADD City VARCHAR(50);

-- Modify a column
ALTER TABLE DONORS
MODIFY Name VARCHAR(150) NOT NULL;

-- Rename a column
ALTER TABLE DONORS
RENAME COLUMN City TO Location;

-- Rename a table
RENAME TABLE BLOOD_ISSUES TO ISSUE_RECORDS;

-- Rename it back for the remaining code
RENAME TABLE ISSUE_RECORDS TO BLOOD_ISSUES;

-- Remove all rows while retaining the table structure
-- Execute only when you intentionally want to clear the table.
-- TRUNCATE TABLE BLOOD_ISSUES;

-- Drop a table (destructive; execute only when needed)
-- DROP TABLE BLOOD_ISSUES;

DESC DONORS;


-- #################### 02_insert_data.sql ####################

-- ================= DML COMMANDS =================

-- ---------- Insert 15 donors ----------
INSERT INTO DONORS
(Donor_id, Name, Gender, DOB, BloodGroup, PhoneNo, Email, Address, Location)
VALUES
(1, 'Arjun', 'Male', '2000-03-14', 'O+', '9848000001', 'arjun@gmail.com', 'Street 1', 'Kukatpally'),
(2, 'Meghana', 'Female', '2001-07-22', 'A+', '9848000002', 'meghana@gmail.com', 'Street 2', 'Miyapur'),
(3, 'Rahul', 'Male', '1998-11-05', 'B+', '9848000003', 'rahul@gmail.com', 'Street 3', 'Ameerpet'),
(4, 'Sneha', 'Female', '2002-01-30', 'O-', '9848000004', 'sneha@gmail.com', 'Street 4', 'Kukatpally'),
(5, 'Vikram', 'Male', '1997-09-12', 'AB+', '9848000005', 'vikram@gmail.com', 'Street 5', 'Gachibowli'),
(6, 'Ananya', 'Female', '2003-04-18', 'A-', '9848000006', 'ananya@gmail.com', 'Street 6', 'Miyapur'),
(7, 'Kiran', 'Male', '1999-12-25', 'B-', '9848000007', 'kiran@gmail.com', 'Street 7', 'Bachupally'),
(8, 'Pooja', 'Female', '2000-06-09', 'O+', '9848000008', 'pooja@gmail.com', 'Street 8', 'Ameerpet'),
(9, 'Rohit', 'Male', '1996-02-17', 'A+', '9848000009', 'rohit@gmail.com', 'Street 9', 'Kukatpally'),
(10, 'Harika', 'Female', '2001-10-03', 'B+', '9848000010', 'harika@gmail.com', 'Street 10', 'Bachupally'),
(11, 'Sai Teja', 'Male', '2002-08-28', 'AB-', '9848000011', 'saiteja@gmail.com', 'Street 11', 'Gachibowli'),
(12, 'Lavanya', 'Female', '1999-05-11', 'O+', '9848000012', 'lavanya@gmail.com', 'Street 12', 'Miyapur'),
(13, 'Varun', 'Male', '1998-01-20', 'A+', '9848000013', 'varun@gmail.com', 'Street 13', 'Ameerpet'),
(14, 'Priya', 'Female', '2000-09-07', 'B+', '9848000014', 'priya@gmail.com', 'Street 14', 'Kukatpally'),
(15, 'Nikhil', 'Male', '1997-04-26', 'O-', '9848000015', 'nikhil@gmail.com', 'Street 15', 'Bachupally');

SELECT * FROM DONORS;


-- ---------- Insert sample data into the remaining tables ----------
INSERT INTO BLOOD_BANKS VALUES
(201, 'Lifeline Blood Bank', 'Kukatpally, Hyderabad', '04023001001', 500),
(202, 'Sanjeevani Blood Bank', 'Ameerpet, Hyderabad', '04023002002', 400),
(203, 'City Blood Centre', 'Gachibowli, Hyderabad', '04023003003', 300);

INSERT INTO DONATIONS VALUES
(301, 1, 201, '2026-07-15', 450, 14.2),
(302, 2, 201, '2026-10-20', 450, 13.1),
(303, 3, 202, '2026-10-22', 350, 13.8),
(304, 4, 201, '2026-10-25', 450, 13.5),
(305, 5, 203, '2026-08-01', 350, 14.6),
(306, 6, 202, '2026-10-28', 450, 12.9),
(307, 8, 201, '2026-11-01', 450, 13.2),
(308, 9, 203, '2026-11-02', 350, 14.0),
(309, 1, 201, '2026-10-30', 450, 14.1),
(310, 10, 202, '2026-11-03', 350, 12.8),
(311, 12, 203, '2026-06-20', 450, 13.0),
(312, 14, 202, '2026-11-05', 450, 13.4);

INSERT INTO BLOOD_UNITS VALUES
(401, 301, 'Whole Blood', '2026-08-19', 'Expired'),
(402, 302, 'RBC', '2026-12-01', 'Available'),
(403, 302, 'Plasma', '2027-10-20', 'Available'),
(404, 303, 'Whole Blood', '2026-11-26', 'Issued'),
(405, 304, 'RBC', '2026-12-06', 'Available'),
(406, 304, 'Platelets', '2026-10-30', 'Expired'),
(407, 305, 'Plasma', '2027-08-01', 'Available'),
(408, 306, 'Whole Blood', '2026-12-02', 'Reserved'),
(409, 307, 'RBC', '2026-12-13', 'Issued'),
(410, 308, 'Whole Blood', '2026-12-07', 'Available'),
(411, 309, 'Whole Blood', '2026-12-04', 'Available'),
(412, 310, 'Platelets', '2026-11-08', 'Expired'),
(413, 310, 'RBC', '2026-12-15', 'Available'),
(414, 311, 'Plasma', '2027-06-20', 'Available'),
(415, 312, 'Whole Blood', '2026-12-10', 'Available'),
(416, 312, 'Platelets', '2026-11-10', 'Available');

INSERT INTO HOSPITALS VALUES
(501, 'Sunrise Hospital', 'Kukatpally, Hyderabad', '04024001001'),
(502, 'CarePlus Hospital', 'Ameerpet, Hyderabad', '04024002002'),
(503, 'Lotus Children Hospital', 'Gachibowli, Hyderabad', '04024003003');

INSERT INTO PATIENTS VALUES
(601, 'Ramesh', 'Male', 45, 'B+', 501),
(602, 'Kavya', 'Female', 28, 'A+', 502),
(603, 'Suresh', 'Male', 60, 'O+', 501),
(604, 'Divya', 'Female', 8, 'O-', 503),
(605, 'Mahesh', 'Male', 35, 'AB+', 502),
(606, 'Geetha', 'Female', 52, 'A-', 501);

INSERT INTO BLOOD_REQUESTS VALUES
(701, 601, 'Whole Blood', 1, '2026-11-04', 'Urgent', 'Fulfilled'),
(702, 602, 'RBC', 1, '2026-11-06', 'Normal', 'Fulfilled'),
(703, 603, 'Whole Blood', 2, '2026-11-08', 'Urgent', 'Pending'),
(704, 604, 'RBC', 1, '2026-11-09', 'Urgent', 'Pending'),
(705, 605, 'Plasma', 1, '2026-11-09', 'Normal', 'Pending'),
(706, 606, 'Whole Blood', 1, '2026-11-10', 'Normal', 'Pending');

INSERT INTO BLOOD_ISSUES VALUES
(801, 701, 404, '2026-11-05'),
(802, 702, 409, '2026-11-06');

SELECT * FROM BLOOD_BANKS;

SELECT * FROM DONATIONS;

SELECT * FROM BLOOD_UNITS;

SELECT * FROM HOSPITALS;

SELECT * FROM PATIENTS;

SELECT * FROM BLOOD_REQUESTS;

SELECT * FROM BLOOD_ISSUES;


-- ---------- SELECT, UPDATE and DELETE ----------
-- Display all donors
SELECT * FROM DONORS;

-- Display only selected columns
SELECT Donor_id, Name, BloodGroup, Location
FROM DONORS;

-- Update a donor's location
UPDATE DONORS
SET Location = 'Madhapur'
WHERE Donor_id = 1;

SELECT Donor_id, Name, Location
FROM DONORS
WHERE Donor_id = 1;

-- Delete an expired blood unit that has been discarded
DELETE FROM BLOOD_UNITS
WHERE Unit_id = 406;

SELECT * FROM BLOOD_UNITS
WHERE Status = 'Expired';

INSERT INTO BLOOD_UNITS VALUES
(406, 304, 'Platelets', '2026-10-30', 'Expired');


-- #################### 03_queries.sql ####################

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


-- #################### 04_views_triggers.sql ####################

-- ================= Views =================

-- ---------- Create a view ----------
CREATE VIEW BLOOD_STOCK_VIEW AS
SELECT
    B.Bank_id,
    B.BankName,
    D.BloodGroup,
    COUNT(*) AS AvailableUnits
FROM BLOOD_UNITS U
JOIN DONATIONS DN
    ON U.Donation_id = DN.Donation_id
JOIN DONORS D
    ON DN.Donor_id = D.Donor_id
JOIN BLOOD_BANKS B
    ON DN.Bank_id = B.Bank_id
WHERE U.Status = 'Available'
GROUP BY B.Bank_id, B.BankName, D.BloodGroup;


-- ---------- Display the view ----------
SELECT * FROM BLOOD_STOCK_VIEW
ORDER BY Bank_id,
    FIELD(BloodGroup, 'A+', 'A-', 'B+', 'B-',
                      'AB+', 'AB-', 'O+', 'O-');


-- ---------- Create a view for issued blood ----------
CREATE VIEW ISSUED_BLOOD_VIEW AS
SELECT
    I.Issue_id,
    P.Name AS Patient,
    H.HospitalName,
    D.BloodGroup,
    U.Component,
    I.IssueDate
FROM BLOOD_ISSUES I
JOIN BLOOD_REQUESTS R
    ON I.Request_id = R.Request_id
JOIN PATIENTS P
    ON R.Patient_id = P.Patient_id
JOIN HOSPITALS H
    ON P.Hospital_id = H.Hospital_id
JOIN BLOOD_UNITS U
    ON I.Unit_id = U.Unit_id
JOIN DONATIONS DN
    ON U.Donation_id = DN.Donation_id
JOIN DONORS D
    ON DN.Donor_id = D.Donor_id;

SELECT * FROM ISSUED_BLOOD_VIEW
ORDER BY Issue_id;


-- ---------- Drop a view ----------
DROP VIEW ISSUED_BLOOD_VIEW;


-- ================= Triggers =================

-- ---------- Create an audit table ----------
CREATE TABLE REQUEST_AUDIT (
    Audit_id INT AUTO_INCREMENT PRIMARY KEY,
    Request_id INT,
    ActionType VARCHAR(20),
    OldStatus VARCHAR(20),
    NewStatus VARCHAR(20),
    AuditTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ---------- INSERT trigger ----------
DELIMITER //

CREATE TRIGGER after_request_insert
AFTER INSERT ON BLOOD_REQUESTS
FOR EACH ROW
BEGIN
    INSERT INTO REQUEST_AUDIT
        (Request_id, ActionType, OldStatus, NewStatus)
    VALUES
        (NEW.Request_id, 'INSERT', NULL, NEW.Status);
END //

DELIMITER ;

INSERT INTO BLOOD_REQUESTS
VALUES (707, 602, 'Plasma', 1, '2026-11-10', 'Normal', 'Pending');

SELECT Audit_id, Request_id, ActionType, OldStatus, NewStatus
FROM REQUEST_AUDIT
ORDER BY Audit_id;


-- ---------- UPDATE trigger ----------
DELIMITER //

CREATE TRIGGER after_request_update
AFTER UPDATE ON BLOOD_REQUESTS
FOR EACH ROW
BEGIN
    INSERT INTO REQUEST_AUDIT
        (Request_id, ActionType, OldStatus, NewStatus)
    VALUES
        (NEW.Request_id, 'UPDATE', OLD.Status, NEW.Status);
END //

DELIMITER ;

UPDATE BLOOD_REQUESTS
SET Status = 'Cancelled'
WHERE Request_id = 707;

SELECT Audit_id, Request_id, ActionType, OldStatus, NewStatus
FROM REQUEST_AUDIT
ORDER BY Audit_id;


-- ---------- DELETE trigger ----------
DELIMITER //

CREATE TRIGGER after_request_delete
AFTER DELETE ON BLOOD_REQUESTS
FOR EACH ROW
BEGIN
    INSERT INTO REQUEST_AUDIT
        (Request_id, ActionType, OldStatus, NewStatus)
    VALUES
        (OLD.Request_id, 'DELETE', OLD.Status, NULL);
END //

DELIMITER ;

DELETE FROM BLOOD_ISSUES
WHERE Request_id = 707;

DELETE FROM BLOOD_REQUESTS
WHERE Request_id = 707;

SELECT Audit_id, Request_id, ActionType, OldStatus, NewStatus
FROM REQUEST_AUDIT
ORDER BY Audit_id;


-- ---------- Trigger to enforce the 90-day gap between donations ----------
DELIMITER //

CREATE TRIGGER before_donation_insert
BEFORE INSERT ON DONATIONS
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM DONATIONS
        WHERE Donor_id = NEW.Donor_id
          AND ABS(DATEDIFF(NEW.DonationDate, DonationDate)) < 90
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Donor must wait 90 days between donations';
    END IF;
END //

DELIMITER ;

-- This statement is EXPECTED TO FAIL (it demonstrates the trigger above).
-- Remove the -- in front of the two lines below to run it.
-- INSERT INTO DONATIONS
-- VALUES (313, 2, 201, '2026-11-10', 450, 13.0);


-- ---------- Trigger to block expired or already issued units ----------
DELIMITER //

CREATE TRIGGER before_issue_insert
BEFORE INSERT ON BLOOD_ISSUES
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM BLOOD_UNITS
        WHERE Unit_id = NEW.Unit_id
          AND Status IN ('Available', 'Reserved')
          AND ExpiryDate >= NEW.IssueDate
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Blood unit is expired or already issued';
    END IF;
END //

DELIMITER ;

-- This statement is EXPECTED TO FAIL (it demonstrates the trigger above).
-- Remove the -- in front of the two lines below to run it.
-- INSERT INTO BLOOD_ISSUES
-- VALUES (803, 703, 401, '2026-11-10');


-- ---------- Trigger to update stock automatically ----------
DELIMITER //

CREATE TRIGGER after_issue_insert
AFTER INSERT ON BLOOD_ISSUES
FOR EACH ROW
BEGIN
    UPDATE BLOOD_UNITS
    SET Status = 'Issued'
    WHERE Unit_id = NEW.Unit_id;

    UPDATE BLOOD_REQUESTS
    SET Status = 'Fulfilled'
    WHERE Request_id = NEW.Request_id;
END //

DELIMITER ;

INSERT INTO BLOOD_ISSUES
VALUES (803, 706, 408, '2026-11-10');

SELECT Unit_id, Component, Status
FROM BLOOD_UNITS
WHERE Unit_id = 408;

SELECT Request_id, Patient_id, Status
FROM BLOOD_REQUESTS
WHERE Request_id = 706;


-- #################### 05_procedures_cursors.sql ####################

-- ================= Stored procedures =================

-- ---------- Create a procedure to display donor details ----------
DELIMITER //

CREATE PROCEDURE DisplayDonors()
BEGIN
    SELECT Donor_id, Name, BloodGroup, Location
    FROM DONORS
    ORDER BY Donor_id;
END //

DELIMITER ;

CALL DisplayDonors();


-- ---------- Create a procedure to calculate the blood donated by a donor ----------
DELIMITER //

CREATE PROCEDURE GetDonorDonations(
    IN input_id INT
)
BEGIN
    SELECT
        D.Donor_id,
        D.Name,
        COUNT(DN.Donation_id) AS Donations,
        COALESCE(SUM(DN.Quantity_ml), 0) AS TotalDonated_ml
    FROM DONORS D
    LEFT JOIN DONATIONS DN
        ON D.Donor_id = DN.Donor_id
    WHERE D.Donor_id = input_id
    GROUP BY D.Donor_id, D.Name;
END //

DELIMITER ;

CALL GetDonorDonations(1);


-- ================= Cursors =================

-- ---------- Create a cursor procedure ----------
DELIMITER //

CREATE PROCEDURE DisplayCollectionSummary()
BEGIN
    DECLARE finished INT DEFAULT 0;
    DECLARE d_id INT;
    DECLARE qty INT;
    DECLARE running_total INT DEFAULT 0;

    DECLARE donation_cursor CURSOR FOR
        SELECT Donation_id, Quantity_ml
        FROM DONATIONS
        ORDER BY Donation_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET finished = 1;

    DROP TEMPORARY TABLE IF EXISTS CollectionSummary;

    CREATE TEMPORARY TABLE CollectionSummary (
        Donation_id INT,
        Quantity_ml INT,
        RunningTotal_ml INT
    );

    OPEN donation_cursor;

    read_loop: LOOP
        FETCH donation_cursor INTO d_id, qty;

        IF finished = 1 THEN
            LEAVE read_loop;
        END IF;

        SET running_total = running_total + qty;

        INSERT INTO CollectionSummary
        VALUES (d_id, qty, running_total);
    END LOOP;

    CLOSE donation_cursor;

    SELECT * FROM CollectionSummary
    ORDER BY Donation_id;
END //

DELIMITER ;

CALL DisplayCollectionSummary();


-- #################### 06_sample_queries.sql ####################

-- ================= Project sample queries =================

-- ---------- Blood groups with a shortage of stock ----------
SELECT
    G.BloodGroup,
    COUNT(S.Unit_id) AS AvailableUnits
FROM (
    SELECT 'A+' AS BloodGroup UNION ALL SELECT 'A-'
    UNION ALL SELECT 'B+' UNION ALL SELECT 'B-'
    UNION ALL SELECT 'AB+' UNION ALL SELECT 'AB-'
    UNION ALL SELECT 'O+' UNION ALL SELECT 'O-'
) G
LEFT JOIN (
    SELECT U.Unit_id, D.BloodGroup
    FROM BLOOD_UNITS U
    JOIN DONATIONS DN
        ON U.Donation_id = DN.Donation_id
    JOIN DONORS D
        ON DN.Donor_id = D.Donor_id
    WHERE U.Status = 'Available'
      AND U.ExpiryDate >= '2026-11-10'
) S
    ON G.BloodGroup = S.BloodGroup
GROUP BY G.BloodGroup
HAVING COUNT(S.Unit_id) < 2
ORDER BY FIELD(G.BloodGroup, 'A+', 'A-', 'B+', 'B-',
                             'AB+', 'AB-', 'O+', 'O-');


-- ---------- Eligible donors for blood groups that patients are waiting for ----------
SELECT
    D.Donor_id,
    D.Name,
    D.BloodGroup,
    D.PhoneNo,
    MAX(DN.DonationDate) AS LastDonation,
    DATEDIFF('2026-11-10', MAX(DN.DonationDate)) AS DaysSinceLast
FROM DONORS D
LEFT JOIN DONATIONS DN
    ON D.Donor_id = DN.Donor_id
WHERE D.BloodGroup IN (
    SELECT P.BloodGroup
    FROM BLOOD_REQUESTS R
    JOIN PATIENTS P
        ON R.Patient_id = P.Patient_id
    WHERE R.Status = 'Pending'
)
GROUP BY D.Donor_id, D.Name, D.BloodGroup, D.PhoneNo
HAVING MAX(DN.DonationDate) IS NULL
    OR DATEDIFF('2026-11-10', MAX(DN.DonationDate)) >= 90
ORDER BY D.Donor_id;


-- ---------- Units that expire within the next 30 days ----------
SELECT
    U.Unit_id,
    D.BloodGroup,
    U.Component,
    U.ExpiryDate,
    DATEDIFF(U.ExpiryDate, '2026-11-10') AS DaysLeft
FROM BLOOD_UNITS U
JOIN DONATIONS DN
    ON U.Donation_id = DN.Donation_id
JOIN DONORS D
    ON DN.Donor_id = D.Donor_id
WHERE U.Status = 'Available'
  AND U.ExpiryDate BETWEEN '2026-11-10'
                       AND DATE_ADD('2026-11-10', INTERVAL 30 DAY)
ORDER BY U.ExpiryDate, U.Unit_id;
