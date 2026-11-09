-- 04_views_triggers.sql: Views and triggers
-- Blood Bank Management System (MySQL 8.0.31 or later)

USE BloodBank;

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
