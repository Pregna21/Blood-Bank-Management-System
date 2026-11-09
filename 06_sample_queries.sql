-- 06_sample_queries.sql: Project sample queries
-- Blood Bank Management System (MySQL 8.0.31 or later)

USE BloodBank;

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
