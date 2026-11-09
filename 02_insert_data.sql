-- 02_insert_data.sql: Insert sample data; SELECT, UPDATE and DELETE
-- Blood Bank Management System (MySQL 8.0.31 or later)

USE BloodBank;

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
