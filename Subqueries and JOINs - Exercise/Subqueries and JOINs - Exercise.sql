/* 1 */
SELECT e.employee_id,e.job_title,e.address_id,a.address_text
 FROM employees AS e
JOIN addresses AS a ON a.address_id = e.address_id
ORDER BY address_id
LIMIT 5;

/* 2 */
SELECT e.first_name,e.last_name,t.name,a.address_text
 FROM employees AS e
JOIN addresses AS a ON a.address_id = e.address_id
 JOIN towns AS t ON a.town_id = t.town_id
ORDER BY first_name,last_name
LIMIT 5;

/* 3 */
SELECT e.employee_id,e.first_name,e.last_name,d.name
 FROM employees AS e
JOIN departments AS d ON d.department_id = e.department_id
WHERE d.name = 'Sales'
ORDER BY employee_id DESC;

/* 4 */
SELECT e.employee_id,e.first_name,e.salary,d.name
 FROM employees AS e
JOIN departments AS d ON d.department_id = e.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;

/* 5 */
SELECT e.employee_id,e.first_name
 FROM employees AS e
LEFT JOIN employees_projects AS ep ON ep.employee_id = e.employee_id
WHERE ep.project_id IS NULL
ORDER BY e.employee_id DESC
LIMIT 3;

/* 6 */
SELECT e.first_name,e.last_name,e.hire_date,d.name
 FROM employees AS e
JOIN departments AS d ON e.department_id = d.department_id
WHERE e.hire_date > '1999-1-1' AND d.name IN ('Sales', 'Finance')
ORDER BY e.hire_date;

/* 7 */
SELECT e.employee_id,e.first_name,p.name
 FROM employees AS e
JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
JOIN projects AS p ON p.project_id = ep.project_id
WHERE p.start_date > '2002-08-13' AND p.end_date IS NULL
ORDER BY e.first_name,p.name
LIMIT 5;

/* 8 */
SELECT e.employee_id,e.first_name,IF(YEAR(p.start_date) >= 2005,NULL,p.name)
 FROM employees AS e
JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
JOIN projects AS p ON p.project_id = ep.project_id
WHERE e.employee_id = 24
ORDER BY e.first_name,p.name
LIMIT 5;

/* 9 */
SELECT e.employee_id,e.first_name,m.employee_id,m.first_name
 FROM employees AS e
JOIN employees AS m ON e.manager_id = m.employee_id
WHERE m.employee_id IN (3,7)
ORDER BY e.first_name;

/* 10 */
SELECT e.employee_id,CONCAT_WS(' ',e.first_name,e.last_name) AS employee_name,
CONCAT_WS(" ",m.first_name,m.last_name),d.name
 FROM employees AS e
JOIN employees AS m ON e.manager_id = m.employee_id
JOIN departments AS d ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 5;

/* 11 */
SELECT AVG(salary) AS min_average_salary FROM employees AS e
GROUP BY e.department_id
ORDER BY min_average_salary
LIMIT 1;

/* 12 */
SELECT c.country_code, m.mountain_range, p.peak_name,p.elevation FROM countries AS c 
JOIN mountains_countries AS mc ON c.country_code = mc.country_code
JOIN mountains AS m ON mc.mountain_id = m.id
JOIN peaks AS p ON m.id = p.mountain_id
WHERE c.country_code = 'BG' AND p.elevation > 2835
ORDER BY p.elevation DESC;

/* 13 */
SELECT c.country_code, COUNT(mc.mountain_id) AS mountain_range FROM countries AS c 
JOIN mountains_countries AS mc ON c.country_code = mc.country_code
WHERE c.country_code IN ('BG','RU','US')
GROUP BY c.country_code
ORDER BY mountain_range DESC;

/* 14 */
SELECT c.country_name,r.river_name FROM countries AS c
LEFT JOIN countries_rivers AS cr ON c.country_code = cr.country_code
LEFT JOIN rivers AS r ON cr.river_id = r.id
JOIN continents AS cont ON cont.continent_code = c.continent_code
WHERE cont.continent_name = 'Africa'
ORDER BY c.country_name
LIMIT 5;

/* 15 */
SELECT c.continent_code,currency_code,COUNT(*) AS currency_usage
FROM countries AS c
GROUP BY c.continent_code, c.currency_code
HAVING currency_usage > 1 
AND currency_usage = (
	SELECT COUNT(*) AS count_of_currencies
	FROM countries as c2
    WHERE c2.continent_code = c.continent_code
    GROUP BY c2.currency_code
    ORDER BY count_of_currencies DESC
    LIMIT 1)
ORDER BY c.continent_code, c.currency_code;

/* 16 */
SELECT COUNT(*) FROM (
	SELECT mc.country_code FROM mountains_countries AS mc
    GROUP BY mc.country_code) AS rslt
    RIGHT JOIN countries AS c 
    ON c.country_code = rslt.country_code
    WHERE rslt.country_code IS NULL;
    
/* 17 */
SELECT country_name,MAX(elevation) AS peak,MAX(length) AS river FROM countries AS c
JOIN mountains_countries AS mc ON c.country_code = mc.country_code
JOIN mountains AS m ON mc.mountain_id = m.id
JOIN peaks AS p ON m.id = p.mountain_id
JOIN countries_rivers AS cr ON cr.country_code = c.country_code
JOIN rivers AS r ON cr.river_id = r.id
GROUP BY country_name
ORDER BY peak DESC,river DESC,country_name
LIMIT 5;