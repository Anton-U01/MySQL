CREATE TABLE products (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    type VARCHAR(30) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE clients (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthdate DATE NOT NULL,
    card VARCHAR(50),
    review TEXT
);

CREATE TABLE `tables` (
	id INT PRIMARY KEY AUTO_INCREMENT,
    floor INTEGER NOT NULL,
    reserved TINYINT(1) ,
    capacity INT NOT NULL
);

CREATE TABLE waiters (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    salary DECIMAL(10,2)
);

CREATE TABLE orders (
	id INT PRIMARY KEY AUTO_INCREMENT,
    table_id INT NOT NULL,
    waiter_id INT NOT NULL,
    order_time TIME NOT NULL,
    payed_status TINYINT(1),
	CONSTRAINT fk_orders_tables
    FOREIGN KEY (table_id) REFERENCES `tables`(id),
    CONSTRAINT fk_orders_waiters
    FOREIGN KEY (waiter_id) REFERENCES waiters(id)
);

CREATE TABLE orders_clients (
	order_id INT,
    client_id INT,
    CONSTRAINT fk_orders_clients_orders
	FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_orders_clients_clients
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE TABLE orders_products (
	order_id INT,
    product_id INT,
    CONSTRAINT fk_orders_products_orders
	FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_orders_products_products
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO products (name,type,price)
(
SELECT concat(last_name, ' specialty'),
'Cocktail',
ceiling(0.01 * salary)
FROM waiters
WHERE id > 6
);

UPDATE tables AS t
JOIN orders AS o ON o.table_id = t.id
SET table_id = table_id - 1
WHERE o.id >= 12 AND o.id <= 23;


DELETE FROM waiters AS w
WHERE (SELECT COUNT(*) FROM orders WHERE waiter_id = w.id) = 0;


SELECT id,first_name,last_name,birthdate,card,review FROM clients
ORDER BY birthdate DESC,id DESC;

SELECT first_name,last_name,birthdate,review FROM clients
WHERE card IS NULL and YEAR(birthdate) BETWEEN 1978 AND 1993
ORDER BY last_name DESC, id
LIMIT 5;

SELECT
	CONCAT(last_name,first_name,LENGTH(first_name),'Restaurant')
	AS username,
    REVERSE(SUBSTRING(email,2,12))
	AS password
 FROM waiters
 WHERE salary IS NOT NULL
 ORDER BY password DESC;

SELECT id,name,COUNT(id) AS count FROM products AS p
JOIN orders_products AS op ON p.id = op.product_id
GROUP BY id
HAVING count >= 5
ORDER BY count DESC,name;

SELECT table_id,
capacity,
 COUNT(oc.client_id) AS count_clients,
 (IF(COUNT(oc.client_id) < capacity,'Free seats',
 IF(COUNT(oc.client_id) = capacity,'Full','Extra seats')
 ))AS availability
 FROM `tables` AS t
 JOIN orders AS o ON t.id = o.table_id
 JOIN orders_clients AS oc ON oc.order_id = o.id
 WHERE floor = 1
 GROUP BY t.id
ORDER BY t.id DESC;



DELIMITER//
CREATE FUNCTION udf_client_bill(full_name VARCHAR(50))
RETURNS DECIMAL (19,2)
DETERMINISTIC
BEGIN
	DECLARE space_index INT;
    SET space_index := LOCATE(' ',full_name);
    RETURN(
	SELECT SUM(price) FROM clients AS c
	JOIN orders_clients AS oc ON oc.client_id = c.id
	JOIN orders AS o ON o.id = oc.order_id
	JOIN orders_products AS op ON op.order_id = o.id
	JOIN products AS p ON p.id = op.product_id
	WHERE first_name = SUBSTRING(full_name,1,space_index - 1)
    AND last_name = SUBSTRING(full_name,space_index + 1)
    )
END//
DELIMITER ;

DELIMITER//
CREATE PROCEDURE udp_happy_hour (`type` VARCHAR(50))
BEGIN 
	UPDATE products AS p
	SET price = price * 0.80
    WHERE price >= 10 AND p.type = type 
END//
DELIMITER ;

