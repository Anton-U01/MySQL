SELECT title FROM books
WHERE title LIKE 'The%';

SELECT REPLACE(title,'The','***') FROM books
WHERE substring(title,1,3) LIKE 'The'
ORDER BY id;

SELECT SUM(cost) FROM books;

SELECT CONCAT_ws(" ",first_name,last_name) AS "Full Name",
TIMESTAMPDIFF(DAY,born,died) AS "Days Lived" 
FROM authors;

SELECT title FROM books
WHERE title LIKE "Harry Potter%"
ORDER BY id;