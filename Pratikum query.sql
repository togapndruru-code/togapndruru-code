#PRAKTIKUM MYSQL
#Nama : Togap Ndruru

#BAGIAN 1 : TABEL COURSE DAN STUDENT
#Menggunakan database
#USE PratikunTogap_sql;

#Membuat tabel course
CREATE TABLE course (
    Coursecode VARCHAR(10) PRIMARY KEY,
    Coursename VARCHAR(100) NOT NULL,
    Section CHAR(1)
);

#Menambahkan CHECK Constraint
ALTER TABLE course
ADD CONSTRAINT chk_section
CHECK (Section IN ('m', 'e'));

#Membuat tabel student
CREATE TABLE student (
    Rollno INT,
    Firstname VARCHAR(50),
    Lname VARCHAR(50),
    Address VARCHAR(100) UNIQUE,
    Coursecode VARCHAR(10),

    FOREIGN KEY (Coursecode)
    REFERENCES course(Coursecode)
);

#Menambahkan Primary Key
ALTER TABLE student
ADD PRIMARY KEY (Rollno);

#Mengubah kolom Firstname menjadi NOT NULL
ALTER TABLE student
MODIFY Firstname VARCHAR(50) NOT NULL;

#Menampilkan struktur tabel
SHOW TABLES;
DESC course;
DESC student;

#Menambahkan data ke tabel course
INSERT INTO course VALUES
('C01', 'Database', 'm'),
('C02', 'Networking', 'e');

#Menambahkan data ke tabel student
INSERT INTO student VALUES
(1, 'Andi', 'Saputra', 'Jakarta', 'C01'),
(2, 'Budi', 'Pratama', 'Bandung', 'C02');

#Menampilkan data
SELECT * FROM course;
SELECT * FROM student;

#Menghapus Primary Key
ALTER TABLE student
DROP PRIMARY KEY;

DESC student;


#BAGIAN 2 : FOREIGN KEY DAN CONSTRAINT

#Membuat tabel person
CREATE TABLE person (
    p_id INT PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50),
    address VARCHAR(100),
    city VARCHAR(50)
);

#Membuat tabel orders
CREATE TABLE orders (
    o_id INT PRIMARY KEY,
    orderno INT NOT NULL UNIQUE,
    p_id INT,

    FOREIGN KEY (p_id)
    REFERENCES person(p_id)
);

SHOW TABLES;

#Menambahkan data ke tabel person
INSERT INTO person VALUES
(1, 'Hari', 'Om', 'Tilaknagar 10', 'Delhi'),
(2, 'Shyam', 'Tomar', 'Base 23', 'Bangalore'),
(3, 'Petter', 'Joseph', 'Staff 20', 'Chandigarh');

#Menambahkan data ke tabel orders
INSERT INTO orders VALUES
(1, 77895, 3),
(2, 44678, 3),
(3, 22456, 2),
(4, 24562, 1);

#Menampilkan data
SELECT * FROM person;
SELECT * FROM orders;

#Menambahkan default value
ALTER TABLE person
MODIFY city VARCHAR(50) DEFAULT 'Delhi';

#Menambahkan CHECK constraint
ALTER TABLE person
ADD CONSTRAINT chk_pid
CHECK (p_id > 0);

#Menghapus UNIQUE index
ALTER TABLE orders
DROP INDEX orderno;

#Menguji foreign key
DELETE FROM person
WHERE p_id = 1;

#Menghapus data order terlebih dahulu
DELETE FROM orders
WHERE o_id = 4;

SELECT * FROM orders;


#BAGIAN 3 : SUBQUERY

#Membuat tabel Department2
CREATE TABLE Department2 (
    Dno INT PRIMARY KEY,
    Dname VARCHAR(50) UNIQUE,
    Dlocation VARCHAR(50)
);

#Membuat tabel Employee
CREATE TABLE Employee (
    Eno INT PRIMARY KEY,
    Ename VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2),
    Designation VARCHAR(50),
    Dno INT,

    FOREIGN KEY (Dno)
    REFERENCES Department2(Dno)
);

#Menambahkan data Department2
INSERT INTO Department2 VALUES
(10, 'Sales', 'Noida'),
(20, 'Finance', 'Gurgaon'),
(30, 'HR', 'Delhi'),
(40, 'Marketing', 'Delhi'),
(50, 'IT', 'Gurgaon');

#Menambahkan data Employee
INSERT INTO Employee VALUES
(101, 'Akash', 40000, 'Manager', 30),
(102, 'Neha', 30000, 'Executive', 50),
(103, 'Kunal', 25000, 'Executive', 10),
(104, 'Saksham', 60000, 'Manager', 50),
(105, 'Dheeraj', 50000, 'Team Leader', 20);

#Mencari pegawai dengan gaji tertinggi
SELECT *
FROM Employee
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employee
);

#Mencari pegawai dengan gaji di atas rata-rata
SELECT *
FROM Employee
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employee
);

#Menampilkan pegawai yang bekerja di Noida
SELECT e.*
FROM Employee e
JOIN Department2 d
ON e.Dno = d.Dno
WHERE d.Dlocation = 'Noida';

#Menampilkan lokasi departemen yang unik
SELECT DISTINCT d.Dlocation
FROM Employee e
JOIN Department2 d
ON e.Dno = d.Dno;

#Menambahkan gaji manager
UPDATE Employee
SET Salary = Salary + 1000
WHERE Designation = 'Manager';

SELECT * FROM Employee;

#Mengubah nama kolom
ALTER TABLE Employee
CHANGE Designation Job VARCHAR(50);

#Menghapus kolom lokasi
ALTER TABLE Department2
DROP COLUMN Dlocation;

DESC Department2;

#BAGIAN 4 : JOIN

#Membuat tabel Department3
CREATE TABLE Department3 (
    Dno INT PRIMARY KEY,
    Dname VARCHAR(50),
    Dloc VARCHAR(50)
);

INSERT INTO Department3 VALUES
(10, 'Accounts', 'New York'),
(20, 'Research', 'Dallas'),
(30, 'Sales', 'Chicago'),
(40, 'Operation', 'Boston'),
(50, 'Payroll', 'Dallas');

#Membuat tabel Employee3
CREATE TABLE Employee3 (
    Empno INT PRIMARY KEY,
    Ename VARCHAR(50),
    Salary DECIMAL(10,2),
    Commission DECIMAL(10,2),
    Deptno INT,
    Mgrid INT,

    FOREIGN KEY (Deptno)
    REFERENCES Department3(Dno)
);

INSERT INTO Employee3 VALUES
(75, 'Jones', 20000, NULL, 20, NULL),
(76, 'Martin', 30000, NULL, 30, 75),
(77, 'Blake', 40000, 1400, 30, 75),
(78, 'Ford', 10000, NULL, 20, NULL),
(79, 'Tummes', 20000, 5000, 10, 78);

#Membuat tabel Salary Grade
CREATE TABLE SalGrade (
    Grade CHAR(1),
    Lowsal INT,
    Highsal INT
);

INSERT INTO SalGrade VALUES
('A', 10000, 19000),
('B', 20000, 29000),
('C', 30000, 50000);

#INNER JOIN
SELECT
    e.Empno,
    e.Salary,
    d.Dname
FROM Employee3 e
JOIN Department3 d
ON e.Deptno = d.Dno;

#JOIN menggunakan rentang gaji
SELECT
    e.Empno,
    e.Ename,
    s.Grade,
    e.Salary
FROM Employee3 e
JOIN SalGrade s
ON e.Salary BETWEEN s.Lowsal AND s.Highsal;

#SELF JOIN
SELECT DISTINCT e1.Ename
FROM Employee3 e1
JOIN Employee3 e2
ON e1.Empno = e2.Mgrid;

#LEFT JOIN
SELECT
    e.Empno,
    e.Ename,
    d.Dname,
    d.Dloc
FROM Employee3 e
LEFT JOIN Department3 d
ON e.Deptno = d.Dno;

#RIGHT JOIN (disimulasikan dengan LEFT JOIN terbalik)
SELECT
    e.Empno,
    e.Ename,
    d.Dname,
    d.Dloc
FROM Department3 d
LEFT JOIN Employee3 e
ON e.Deptno = d.Dno;

#SELF JOIN : Pegawai dan Manajer
SELECT
    e.Empno AS Employee_No,
    e.Ename AS Employee_Name,
    m.Empno AS Manager_No,
    m.Ename AS Manager_Name
FROM Employee3 e
LEFT JOIN Employee3 m
ON e.Mgrid = m.Empno;

SHOW TABLES;

DESC Department3;
DESC Employee3;
DESC SalGrade;