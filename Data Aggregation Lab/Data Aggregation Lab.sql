SELECT first_name,last_name FROM employees
WHERE first_name LIKE 'Sa%'
ORDER BY employee_id;

SELECT first_name,last_name FROM employees
WHERE last_name LIKE '%ei%'
ORDER BY employee_id;

SELECT first_name FROM employees
WHERE department_id IN (3,10) AND (YEAR(hire_date) BETWEEN 1995 AND 2005)
ORDER BY employee_id;

SELECT first_name,last_name FROM employees
WHERE job_title NOT LIKE "%engineer%"
ORDER BY employee_id;

SELECT name FROM towns
WHERE char_length(name) BETWEEN 5 AND 6
ORDER BY name;

SELECT town_id,name FROM towns
WHERE name LIKE "M%" or name LIKE "K%" or name LIKE "B%" or name LIKE "E%"
ORDER BY name;

SELECT town_id,name FROM towns
WHERE name NOT REGEXP "^[RBD]"
ORDER BY name;

CREATE VIEW v_employees_hired_after_2000 AS
SELECT first_name,last_name FROM employees
WHERE YEAR(hire_date) > 2000;

SELECT first_name,last_name FROM employees
WHERE last_name LIKE "_____";

SELECT country_name,iso_code FROM countries
WHERE country_name LIKE "%a%a%a%"
ORDER BY iso_code;

SELECT peak_name,river_name, LOWER (CONCAT(peak_name,SUBSTRING(river_name,2))) AS mix FROM peaks,rivers
WHERE
    LOWER(RIGHT(peak_name, 1)) = LOWER(LEFT(river_name, 1))
ORDER BY mix;

SELECT name, DATE_FORMAT(start, '%Y-%m-%d') FROM games
WHERE YEAR(start) IN (2011,2012)
ORDER BY start;

SELECT user_name, SUBSTRING_INDEX(email,"@", -1) AS "email provider" FROM users
ORDER BY `email provider`,user_name;

SELECT user_name,ip_address FROM users
WHERE ip_address LIKE "___.1%.%.___"
ORDER BY user_name;
 
 SELECT name AS "game", 
 CASE 
	WHEN HOUR(start) BETWEEN 0 AND 11 THEN "Morning"
	WHEN HOUR(start) BETWEEN 12 AND 17 THEN "Afternoon"
    ELSE "Evening"
    END AS "Part of the day"
    ,
CASE
	WHEN duration <= 3 THEN "Extra Short"
    WHEN duration BETWEEN 3 AND 6 THEN "Short"
    WHEN duration BETWEEN 6 AND 10 THEN "Long"
    ELSE "Extra Long"
    END AS "Duration"
FROM games;

SELECT product_name,order_date,
 DATE_ADD(order_date, INTERVAL 3 DAY) as pay_due,
 DATE_ADD(order_date,INTERVAL 1 MONTH) as deliver_due
FROM orders;
