DELIMITER $
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE count INT;
    SET @count := (SELECT COUNT(*) FROM employees AS e
			JOIN addresses as a ON e.address_id = a.address_id
            JOIN towns AS t ON t.town_id = a.town_id
            WHERE t.name = town_name
        );
        RETURN @count;
END$
DELIMITER ;
;


DELIMITER $$
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50))
BEGIN
	UPDATE employees AS e
    JOIN departments AS d ON e.department_id = d.department_id
    SET salary = salary * 1.05
    WHERE d.name = department_name;
END$$
DELIMITER ;
;

DELIMITER $$
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
	UPDATE employees AS e
    SET salary = salary * 1.05
    WHERE e.employee_id = id;
END$$
DELIMITER ;
;

CREATE TABLE deleted_employees(
	employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    middle_name VARCHAR(30),
    job_title VARCHAR(30),
    department_id INT,
    salary DOUBLE
);

DELIMITER $$
CREATE TRIGGER tr_deleted_employees
AFTER DELETE
ON employees
FOR EACH ROW
BEGIN
	INSERT INTO deleted_employees(first_name,last_name,middle_name,job_title,
    department_id,salary)
    VALUES(OLD.first_name,OLD.last_name,OLD.middle_name,OLD.job_title,
    OLD.department_id,OLD.salary);
END$$


