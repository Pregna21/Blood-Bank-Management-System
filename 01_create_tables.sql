-- 01_create_tables.sql: Create database, tables, ALTER / RENAME
-- Blood Bank Management System (MySQL 8.0.31 or later)

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
