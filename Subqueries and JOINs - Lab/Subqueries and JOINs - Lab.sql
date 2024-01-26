SELECT e.employee_id,CONCAT_WS(" ",e.first_name,e.last_name),
d.department_id,d.name FROM employees AS e
JOIN departments AS d ON e.employee_id = d.manager_id
ORDER BY employee_id
LIMIT 5;

SELECT t.town_id,t.name,a.address_text FROM towns AS t
JOIN addresses AS a ON t.town_id = a.town_id
WHERE t.name IN ('San Francisco','Sofia','Carnation')
ORDER BY t.town_id,address_id;

SELECT e.employee_id,e.first_name,e.last_name,e.department_id,e.salary FROM employees AS e
WHERE e.manager_id IS NULL;

SELECT COUNT(employee_id) FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);