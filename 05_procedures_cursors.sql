-- 05_procedures_cursors.sql: Stored procedures and cursors
-- Blood Bank Management System (MySQL 8.0.31 or later)

USE BloodBank;

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
