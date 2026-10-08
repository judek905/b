# M26B13 044: Humanresource Views Script

A MySQL script that works with the `employee` table in the `Humanresource` database. It creates seven filtered views (`viewA` to `viewG`) and tries to add a `Residence` column to the table.

## Contents

| File | Purpose |
|------|---------|
| `M26B13_044.sql` | The script: selects the database, lists tables, creates the views, alters the table |

## What the Script Does

1. `use Humanresource;` selects the database.
2. `show tables;` and `SELECT * FROM employee;` inspect the data.
3. Seven views are created, each meant to filter `employee`:

| View | Intended filter |
|------|-----------------|
| `viewA` | Employees whose name (`Ename`) starts with "S" |
| `viewB` | Employees not in department 20 (`DeptNo`) |
| `viewC` | Employees earning between 40,000 and 60,000 (`Salary`) |
| `viewD` | Managers (`Job`) earning more than 40,000 |
| `viewE` | Employees earning more than 40,000 in department 20 or 50 |
| `viewF` | Employees whose job title starts with a letter A to Z |
| `viewG` | Employees earning more than 40,000 |

4. The last statement tries to add a `Residence` column to `employee`.

## Known Issues

The script runs partly, but several statements do not do what they were meant to do.

1. **Column names are in quotes.** In `WHERE 'Ename' LIKE 'S%'`, the single quotes make `'Ename'` a text string, not a column. The condition compares the word "Ename" to `S%`, which is never true. The same mistake affects every view: `viewA`, `viewC`, `viewD`, `viewE`, and `viewG` come out **empty**, while `viewB` and `viewF` return **every row** (the text comparison happens to be true), so none of them filter correctly. Column names should have no quotes (or use backticks).
2. **Numbers are compared as text.** `'Salary' > 40000` and `BETWEEN '40000' AND '60000'` have the same quoting problem.
3. **`viewF` uses `BETWEEN 'A%' AND 'Z%'`.** `BETWEEN` does not support wildcards; `%` is treated as a literal character.
4. **The last statement is invalid syntax.** `SELECT * FROM employee ADD COLUMN ...` mixes `SELECT` with an `ALTER`. Adding a column needs `ALTER TABLE`, and column names are not quoted there either.
5. **`DECIMAL(10,2)` is an odd type for `Residence`.** A residence is text (an address or area), so `VARCHAR` fits better.

## Corrected Version

```sql
USE Humanresource;
SHOW TABLES;
SELECT * FROM employee;

CREATE VIEW viewA AS SELECT * FROM employee WHERE Ename LIKE 'S%';
CREATE VIEW viewB AS SELECT * FROM employee WHERE DeptNo NOT IN (20);
CREATE VIEW viewC AS SELECT * FROM employee WHERE Salary BETWEEN 40000 AND 60000;
CREATE VIEW viewD AS SELECT * FROM employee WHERE Job = 'Manager' AND Salary > 40000;
CREATE VIEW viewE AS SELECT * FROM employee WHERE Salary > 40000 AND DeptNo IN (20, 50);
CREATE VIEW viewF AS SELECT * FROM employee WHERE Job REGEXP '^[A-Za-z]';
CREATE VIEW viewG AS SELECT * FROM employee WHERE Salary > 40000;

ALTER TABLE employee ADD COLUMN Residence VARCHAR(100);
```

## How to Run

```bash
mysql -u your_user -p < M26B13_044.sql
```

Or paste the statements into MySQL Workbench and run them in order. If a view already exists, drop it first (`DROP VIEW viewA;`) or use `CREATE OR REPLACE VIEW`.

## Checking the Results

```sql
SELECT * FROM viewA;   -- repeat for viewB ... viewG
SHOW FULL TABLES WHERE Table_type = 'VIEW';
DESCRIBE employee;     -- confirms Residence was added
```

## Notes

- The views assume `employee` has the columns `Ename`, `DeptNo`, `Salary`, and `Job`. Check them with `DESCRIBE employee;`.
- `SELECT *` in a view is fixed at creation time, so a column added later (like `Residence`) will not appear in existing views unless they are recreated.
