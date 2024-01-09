CREATE DATABASE minions;

/* 1.  Create Tables*/ 
CREATE TABLE minions (
	id INT PRIMARY KEY auto_increment,
    name VARCHAR(50),
    age INT
);

CREATE TABLE towns (
	town_id INT PRIMARY KEY auto_increment,
    name VARCHAR(50)
);

/* 2. Alter Minions Table*/ 
ALTER TABLE minions
ADD COLUMN town_id INT;

ALTER TABLE minions
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY (town_id)
REFERENCES towns(id);

/* 3. Insert Records in Both Tables*/ 
INSERT INTO towns(id,name) values
(1,'Sofia'),
(2,'Plovdiv'),
(3,'Varna');

INSERT INTO minions(id,name,age,town_id) values
(1,'Kevin',22,1),
(2,'Bob',15,3),
(3,'Steward',null,2);

/* 4. Truncate Table Minions*/ 
truncate table minions;

/* 5. Drop All Tables*/ 
DROP TABLE minions;
DROP TABLE towns;

/* 6. Create Table People*/ 
CREATE TABLE people(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    picture BLOB,
    height DOUBLE(5,2),
    weight DOUBLE(5,2),
    gender CHAR(1) NOT NULL,
    birthdate DATE NOT NULL,
    biography TEXT
);

INSERT INTO people(name,gender,birthdate) values
('Georgi','m',DATE(now())),
('Petar','m',DATE(now())),
('Gergana','f',DATE(NOW())),
('Petar','m',DATE(now())),
('Gergana','f',DATE(NOW()));

/* 7. Create Table Users*/ 
CREATE TABLE users(
	id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL,
    password VARCHAR(26) NOT NULL,
    profile_picture BLOB,
    last_login_time DATE,
    is_deleted bool
);
INSERT INTO users (username,password) values
('Georgi','mgc'),
('Petar','msda'),
('Gergana','fsad'),
('Petar1','mdsa'),
('Gergana1','fsadsa');

/* 8. Change Primary Key*/ 
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY users(id,username);

/*  10.  Set Default Value of a Field*/ 
ALTER TABLE users
CHANGE COLUMN last_login_time last_login_time DATETIME DEFAULT NOW();

/*  10.  Set Unique Field*/  
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY (id),
CHANGE COLUMN username 
username VARCHAR(30) UNIQUE; 

/*  11. Movies Database*/  
CREATE DATABASE movies;
use movies;
CREATE TABLE directors (
	id INT PRIMARY KEY,
    director_name VARCHAR(20) NOT NULL,
    notes TEXT
);

INSERT INTO directors (id,director_name) values 
(1,'test'), (2,'test'),(3,'test'),(4,'test'),(5,'test');

CREATE TABLE genres (
	id INT PRIMARY KEY,
    genre_name VARCHAR(20) NOT NULL,
    notes TEXT
);

INSERT INTO genres (id,genre_name) values 
(1,'test'), (2,'test'),(3,'test'),(4,'test'),(5,'test');

CREATE TABLE categories (
	id INT PRIMARY KEY,
    category_name VARCHAR(30) NOT NULL,
    notes TEXT
);

INSERT INTO categories (id,category_name) values 
(1,'test'), (2,'test'),(3,'test'),(4,'test'),(5,'test');

CREATE TABLE movies (
	id INT PRIMARY KEY,
    title VARCHAR(30) NOT NULL,
    director_id INT,
    copyright_year INT,
    length DOUBLE,
    genre_id INT,
    category_id INT,
    rating DOUBLE,
    notes TEXT
);
INSERT INTO movies (id,title) values 
(1,'test'), (2,'test'),(3,'test'),(4,'test'),(5,'test');

/* 12 Car Rental Database*/  
CREATE DATABASE car_rental;
use car_rental;

CREATE TABLE categories (
	id INT PRIMARY KEY,
    category VARCHAR(20) NOT NULL,
    daily_rate DOUBLE, 
    weekly_rate DOUBLE , 
    monthly_rate DOUBLE, 
    weekend_rate DOUBLE
);
INSERT INTO categories (id,category) values 
(1,'test'), (2,'test'),(3,'test');

CREATE TABLE cars  (
 id INT PRIMARY KEY,
 plate_number INT not null, 
 make VARCHAR(20), 
 model VARCHAR(20), 
 car_year INT, 
 category_id INT, 
 doors INT, 
 picture BLOB, 
 car_condition VARCHAR(20), 
 available BOOL
 );
 INSERT INTO cars (id,plate_number) values 
(1,23), (2,2),(3,12);

CREATE TABLE employees  (
 id INT PRIMARY KEY,
 first_name VARCHAR(20), 
 last_name VARCHAR(20),
 title VARCHAR(20),
 notes TEXT
 );
 INSERT INTO employees (id) values 
(1), (2),(3);

CREATE TABLE customers  (
 id INT PRIMARY KEY,
 driver_licence_number VARCHAR(20), 
 full_name VARCHAR(50),
 address VARCHAR(20),
 city VARCHAR(30),
 zip_code VARCHAR(5),
 notes TEXT
 );
 INSERT INTO customers (id) values 
(1), (2),(3);

 
CREATE TABLE rental_orders  (
 id INT PRIMARY KEY,
 employee_id INT, 
 customer_id int,
 car_id Int,
 car_condition VARCHAR(30),
 tank_level DOUBLE,
 kilometrage_start INT,
 kilometrage_end INT,
 total_kilometrage INT,
 start_date DATE,
 end_date DATE,
 total_days INT,
 rate_applied DOUBLE,
 order_status BOOL,
 notes TEXT
 );
 
  INSERT INTO rental_orders(id) values 
(1), (2),(3);

/* 13 Basic Select Some Fields*/ 
CREATE DATABASE soft_uni;
use soft_uni;
CREATE TABLE towns (
	id INT AUTO_INCREMENT,
    name VARCHAR(30)
);
ALTER TABLE towns
ADD CONSTRAINT pk_towns
PRIMARY KEY (id);


CREATE TABLE addresses (
	id INT AUTO_INCREMENT,
    address_text VARCHAR(30),
    town_id INT
);
ALTER TABLE addresses
ADD CONSTRAINT pk_addresses
PRIMARY KEY (id),
ADD CONSTRAINT fk_addresses_towns
FOREIGN KEY (town_id)
REFERENCES towns(id);

CREATE TABLE departments (
	id INT AUTO_INCREMENT,
    name VARCHAR(20)
);
INSERT INTO departments (id,name) values
(1,'Engineering'), (2,'Sales'), (3, 'Marketing'), (4, 'Software Development'),(5,'Quality Assurance');
ALTER TABLE addresses
ADD CONSTRAINT pk_departments
PRIMARY KEY (id);

CREATE TABLE employees (
	id INT AUTO_INCREMENT,
    first_name VARCHAR(20),
    middle_name VARCHAR(20),
    last_name VARCHAR(20),
    job_title VARCHAR(20),
    department_id INT,
    hire_date DATE,
    salary DOUBLE,
    address_id INT
);

ALTER TABLE employees
ADD CONSTRAINT pk_employees
PRIMARY KEY (id),
ADD CONSTRAINT fk_employees_department
FOREIGN KEY (department_id)
REFERENCES departments(id),
ADD CONSTRAINT fk_employees_address
FOREIGN KEY (address_id)
REFERENCES addresses(id);


INSERT INTO towns (id,name) values 
(1,'Sofia'), (2, 'Plovdiv'), (3, 'Varna'), (4,'Burgas');
INSERT INTO departments (id,name) values
(1,'Engineering'), (2,'Sales'), (3, 'Marketing'), (4, 'Software Development'),(5,'Quality Assurance');
INSERT INTO employees
		(first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
	VALUES
		('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
		('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
		('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
		('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
		('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);

/* 14.  Basic Select All Fields*/      
SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

/* 15.  Basic Select All Fields and Order Them*/      
SELECT * FROM towns ORDER BY name;
SELECT * FROM departments ORDER BY name;
SELECT * FROM employees ORDER BY salary DESC;

 /* 16 Basic Select Some Fields*/       
SELECT name FROM towns ORDER BY name;
SELECT name FROM departments ORDER BY name;
SELECT first_name,last_name,job_title,salary FROM employees ORDER BY salary DESC;
 
 /* 17 Increase Employees Salary */      
UPDATE employees
SET salary = salary * 1.1;
SELECT salary FROM employees;
