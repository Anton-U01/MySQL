CREATE DATABASE universities_db;

CREATE TABLE countries (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE cities (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    population INT,
    country_id INT NOT NULL,
    CONSTRAINT fk_cities_countries
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE TABLE universities (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(60) NOT NULL UNIQUE,
    address VARCHAR(80) NOT NULL UNIQUE,
    tuition_fee DECIMAL(19,2) NOT NULL,
    number_of_staff INT,
    city_id INT,
     CONSTRAINT fk_universities_cities
    FOREIGN KEY (city_id) REFERENCES cities(id)
);

CREATE TABLE students (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    age INT,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    is_graduated TINYINT(1) NOT NULL,
    city_id INT,
    CONSTRAINT fk_students_cities
    FOREIGN KEY (city_id) REFERENCES cities(id)
);

CREATE TABLE courses (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    duration_hours DECIMAL(19,2),
    start_date DATE,
    teacher_name VARCHAR(60) NOT NULL UNIQUE,
    description TEXT,
    university_id INT,
    CONSTRAINT fk_courses_universities
    FOREIGN KEY (university_id) REFERENCES universities(id)
);

CREATE TABLE students_courses (
	grade DECIMAL (19,2) NOT NULL,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
	CONSTRAINT fk_students_courses_courses
    FOREIGN KEY (course_id) REFERENCES courses(id),
    CONSTRAINT fk_students_courses_students
    FOREIGN KEY (student_id) REFERENCES students(id)
);

INSERT INTO courses (name,duration_hours,start_date,teacher_name,
					description,university_id)
SELECT CONCAT_WS(' ',teacher_name,'course'),
	LENGTH(name) / 10,
    DATE_ADD(start_date, INTERVAL 5 DAY),
    REVERSE(teacher_name),
    CONCAT('Course ',teacher_name,REVERSE(description)),
    DAY(start_date)
    FROM courses
    WHERE id <= 5;
    
UPDATE universities
SET tuition_fee = tuition_fee + 300
WHERE id >= 5 AND id <= 12;

DELETE FROM universities
WHERE number_of_staff IS NULL;

SELECT id,name,population,country_id FROM cities
ORDER BY population DESC;

SELECT first_name,last_name,age,phone,email FROM students
WHERE age >= 21
ORDER BY first_name DESC,email,id
LIMIT 10;

SELECT CONCAT_WS(" ",first_name,last_name) AS full_name,
		SUBSTRING(email,2,10) AS username, 
        REVERSE(phone) AS password
FROM students AS s
LEFT JOIN students_courses AS sc ON s.id = sc.student_id
WHERE sc.course_id IS NULL
ORDER BY password DESC;

SELECT COUNT(st.student_id) AS students_count,u.name FROM universities AS u
JOIN courses AS c ON u.id = c.university_id
JOIN students_courses AS st ON c.id = st.course_id
GROUP BY u.name
HAVING students_count >= 8
ORDER BY students_count DESC,u.name DESC;

SELECT u.name,c.name,u.address,
	(CASE
		WHEN tuition_fee < 800 THEN 'cheap'
        WHEN tuition_fee >= 800 AND tuition_fee < 1200 THEN 'normal'
        WHEN tuition_fee >= 1200 AND tuition_fee < 2500 THEN 'high'
        ELSE 'expensive'
	END) AS price_rank
    ,tuition_fee
 FROM universities AS u
JOIN cities AS c ON c.id = u.city_id
ORDER BY tuition_fee;

DELIMITER $$
CREATE FUNCTION udf_average_alumni_grade_by_course_name (course_name VARCHAR(60))
RETURNS DECIMAL(19,2)
DETERMINISTIC
BEGIN
RETURN(
	SELECT AVG(grade) FROM courses AS c
	JOIN students_courses AS sc ON c.id = sc.course_id
	JOIN students AS st ON st.id = sc.student_id
	WHERE c.name = course_name AND is_graduated IS TRUE
    GROUP BY c.id
);
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE udp_graduate_all_students_by_year(year_started INT)
BEGIN
	UPDATE students AS st
	JOIN students_courses AS sc ON st.id = sc.student_id
    JOIN courses AS c ON c.id = sc.course_id
    SET is_graduated = 1
    WHERE YEAR(c.start_date) = year_started;
END $$
DELIMITER ;
