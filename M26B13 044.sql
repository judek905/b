use Humanresource;
show tables;
SELECT * FROM employee;
create view viewA as select * FROM employee WHERE 'Ename' LIKE 'S%';
create view viewB as select * FROM employee WHERE 'DeptNo' NOT IN (20);
create view viewC as select * FROM employee WHERE 'Salary' BETWEEN '40000' AND '60000';
create view viewD as select * FROM employee WHERE 'Job' = 'Manager' AND 'Salary' > 40000;
create view viewE as select * FROM employee WHERE 'Salary' > 40000 AND 'DeptNo' IN (20, 50);
create view viewF as select * FROM employee WHERE 'Job' BETWEEN 'A%' AND 'Z%';
create view viewG as select * FROM employee WHERE 'Salary' > 40000;

SELECT * FROM employee ADD COLUMN 'Residence' DECIMAL(10,2);

