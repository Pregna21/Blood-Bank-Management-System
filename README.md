# Blood Bank Management System

DBMS course project (MySQL) by:

| Roll No. | Name | GitHub |
|---|---|---|
| 25WH1A0568 | P. Sri Pregna | [Pregna21](https://github.com/Pregna21) |
| 25WH1A0565 | N. Yoshitha | [Yoshitha2214](https://github.com/Yoshitha2214) |
| 25WH1A05A7 | S. V. Nainika | [25wh1a05a7](https://github.com/25wh1a05a7) |

## About the project

Blood cannot be manufactured, and every unit has a short shelf life. This database manages blood banks, donors
and their donations, the blood units separated from each donation, hospitals, patients and their blood requests,
so that blood is collected safely, stocked by blood group, issued before it expires and never handed out twice.

**Core entities:** Donors, Blood Banks, Donations, Blood Units, Hospitals, Patients, Blood Requests, Blood Issues.

**Key MySQL features**

- A view that shows the real-time stock of every blood group in each blood bank.
- Triggers that stop a donor from donating again within 90 days, stop an expired or already issued unit from
  being issued, update the stock automatically when a unit is issued, and keep an audit log of request changes.
- Stored procedures and a cursor that summarise the blood collected.

**Sample queries:** blood groups with a shortage of stock, eligible donors for the blood groups patients are
waiting for, and units that expire within the next 30 days.

## ER diagram

![ER Diagram](docs/ER_Diagram.png)

## Repository structure

```
Blood-Bank-Management-System/
├── README.md
├── docs/
│   ├── ER_Diagram.png
│   └── Blood_Bank_Management_System_Report.pdf  <- full report with expected outputs
└── sql/
    ├── 01_create_tables.sql            <- database, tables, ALTER / RENAME
    ├── 02_insert_data.sql              <- sample data, SELECT / UPDATE / DELETE
    ├── 03_queries.sql                  <- constraints, set operators, joins, subqueries, aggregates, window functions
    ├── 04_views_triggers.sql           <- views and triggers
    ├── 05_procedures_cursors.sql       <- stored procedures and cursors
    ├── 06_sample_queries.sql           <- project sample queries
    └── blood_bank_full.sql             <- all of the above in one file
```

## How to run

1. Install MySQL 8.0.31 or later (needed for `INTERSECT`).
2. Open MySQL Workbench (or the `mysql` command-line client).
3. Run the files in `sql/` in order, from `01` to `06`, or run `blood_bank_full.sql` once.
4. The two statements that demonstrate the blocking triggers are commented out because they are meant to fail;
   remove the `--` in front of them to see the error message.

## Work split

| Member | Part |
|---|---|
| P. Sri Pregna | ER diagram, relational model, normalization, DDL (`01_create_tables.sql`) |
| N. Yoshitha | Sample data, DML and queries (`02_insert_data.sql`, `03_queries.sql`) |
| S. V. Nainika | Views, triggers, procedures, cursors, sample queries (`04`, `05`, `06`) |
