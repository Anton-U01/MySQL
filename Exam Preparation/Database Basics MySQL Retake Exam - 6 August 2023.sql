CREATE DATABASE real_estate_db;

CREATE TABLE cities(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE property_types(
	id INT PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(40) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE properties(
	id INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(80) NOT NULL UNIQUE,
    price DECIMAL(19,2) NOT NULL,
    area DECIMAL(19,2),
    property_type_id INT,
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES cities(id),
    FOREIGN KEY (property_type_id) REFERENCES property_types(id)
);

CREATE TABLE agents(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES cities(id)
);

CREATE TABLE buyers(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES cities(id)
);

CREATE TABLE property_offers(
	property_id INT NOT NULL,
    agent_id INT NOT NULL,
    price DECIMAL(19,2) NOT NULL,
    offer_datetime DATETIME,
    FOREIGN KEY (agent_id) REFERENCES agents(id),
    FOREIGN KEY (property_id) REFERENCES properties(id)
);

CREATE TABLE property_transactions(
	id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    buyer_id INT NOT NULL,
    transaction_date DATE,
    bank_name VARCHAR(30),
    iban VARCHAR(40) UNIQUE,
    is_successful TINYINT(1),
    FOREIGN KEY (property_id) REFERENCES properties(id),
    FOREIGN KEY (buyer_id) REFERENCES buyers(id)
);


INSERT INTO property_transactions (property_id,buyer_id,
transaction_date,bank_name,iban,is_successful)
(
	SELECT 
		agent_id + DAY(offer_datetime),
        agent_id + MONTH(offer_datetime),
        DATE(offer_datetime),
        CONCAT('Bank ',agent_id),
        CONCAT('BG',price,agent_id),
        TRUE
    FROM property_offers
    WHERE agent_id <= 2
);

UPDATE properties
SET price = price - 50000
WHERE price >= 800000;

DELETE FROM property_transactions 
WHERE is_successful = 0;

SELECT id,first_name,last_name,phone,email,city_id FROM agents
ORDER BY city_id DESC,phone DESC;

SELECT property_id,agent_id,price,offer_datetime FROM property_offers
WHERE YEAR(offer_datetime) = 2021
ORDER BY price
LIMIT 10;

SELECT 
	SUBSTRING(address,1,6) AS agent_name,
	LENGTH(address) * 5430 AS pr_price
 FROM properties AS p
 LEFT JOIN property_offers AS po ON p.id = po.property_id
 WHERE agent_id IS NULL
 ORDER BY agent_name DESC,pr_price DESC;
 
 SELECT bank_name,COUNT(iban) AS count FROM property_transactions AS pt
 GROUP BY bank_name
 HAVING count >= 9
 ORDER BY count DESC,bank_name;
 
 SELECT
	address,
	area,
	(
		CASE
        WHEN area <= 100 THEN 'small'
        WHEN area <= 200 THEN 'medium'
        WHEN area <= 500 THEN 'large'
        WHEN area > 500 THEN 'extra large'
        END
    ) AS size
 FROM properties AS p
 ORDER BY area,address DESC;
 
 
 DELIMITER $$
 CREATE FUNCTION udf_offers_from_city_name(cityName VARCHAR(50))
 RETURNS INT
 DETERMINISTIC
 BEGIN
	RETURN(
		SELECT COUNT(*) FROM cities AS c
        JOIN properties AS p ON p.city_id = c.id
        JOIN property_offers AS po ON po.property_id = p.id
        WHERE c.name = cityName
    );
 END $$
 DELIMITER ;
 
 DELIMITER $$
 CREATE PROCEDURE udp_special_offer(first_name VARCHAR(50))
 BEGIN
	UPDATE property_offers AS po
    JOIN agents AS a ON po.agent_id = a.id
    SET po.price = 0.90 * po.price
    WHERE a.first_name = first_name;
 END $$
 DELIMITER ;
 