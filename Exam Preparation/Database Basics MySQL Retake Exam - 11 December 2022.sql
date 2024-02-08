CREATE DATABASE airlines;

CREATE TABLE countries(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    description TEXT,
    currency VARCHAR(5) NOT NULL
);

CREATE TABLE airplanes(
	id INT PRIMARY KEY AUTO_INCREMENT,
    model VARCHAR(50) NOT NULL UNIQUE,
    passengers_capacity INT NOT NULL,
    tank_capacity DECIMAL (19,2) NOT NULL,
    cost DECIMAL(19,2) NOT NULL
);

CREATE TABLE passengers(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE TABLE flights(
	id INT PRIMARY KEY AUTO_INCREMENT,
    flight_code VARCHAR(30) NOT NULL UNIQUE,
    departure_country INT NOT NULL,
    destination_country INT NOT NULL,
    airplane_id INT NOT NULL,
    has_delay TINYINT(1),
    departure DATETIME,
    FOREIGN KEY (departure_country) REFERENCES countries(id),
    FOREIGN KEY (destination_country) REFERENCES countries(id),
    FOREIGN KEY (airplane_id) REFERENCES airplanes(id)
);

CREATE TABLE flights_passengers(
	flight_id INT,
    passenger_id INT,
    FOREIGN KEY (flight_id) REFERENCES flights(id),
    FOREIGN KEY (passenger_id) REFERENCES passengers(id)
);

INSERT INTO airplanes(model,passengers_capacity,tank_capacity,cost)
(
	SELECT 
		CONCAT(REVERSE(first_name),'797'),
        LENGTH(last_name) * 17,
        id * 790,
        LENGTH(first_name) * 50.6
    FROM passengers
    WHERE id <= 5
);


UPDATE flights
JOIN countries AS c ON flights.departure_country = c.id
SET airplane_id = airplane_id + 1
WHERE c.name = 'Armenia';

DELETE f FROM flights AS f
LEFT JOIN flights_passengers AS fp ON fp.flight_id = f.id
WHERE fp.passenger_id IS NULL;

SELECT id,model,passengers_capacity,tank_capacity,cost FROM airplanes
ORDER BY cost DESC,id DESC;

SELECT flight_code,departure_country,airplane_id,departure FROM flights
WHERE YEAR(departure) = 2022
ORDER BY airplane_id,flight_code
LIMIT 20;

SELECT 
 CONCAT(UPPER(SUBSTRING(last_name,1,2)),country_id) AS flight_code,
 CONCAT_WS(" ",first_name,last_name) AS full_name,
 country_id
FROM passengers AS p
LEFT JOIN flights_passengers AS fp ON p.id = fp.passenger_id
WHERE flight_id IS NULL
ORDER BY country_id;

SELECT c.name,c.currency, COUNT(*) AS booked_tickets FROM countries AS c
JOIN flights AS f ON f.destination_country = c.id
JOIN flights_passengers AS fp ON fp.flight_id = f.id
GROUP BY c.name
HAVING booked_tickets > 20
ORDER BY booked_tickets DESC;

SELECT flight_code,departure,
	(
		CASE
			WHEN HOUR(departure) >= 5 AND HOUR(departure) < 12 THEN 'Morning'
            WHEN HOUR(departure) >= 12 AND HOUR(departure) < 17 THEN 'Afternoon'
            WHEN HOUR(departure) >= 17 AND HOUR(departure) < 21 THEN 'Evening'
            ELSE 'Night'
        END
    ) AS day_part
FROM flights
ORDER BY flight_code DESC;

DELIMITER $$
CREATE FUNCTION udf_count_flights_from_country(country VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN(
		SELECT COUNT(*) FROM countries AS c
		JOIN flights AS f ON f.departure_country = c.id
        WHERE c.name = country
        GROUP BY c.name
    );
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE udp_delay_flight(code VARCHAR(50))
BEGIN
	UPDATE flights AS f
    SET has_delay = 1 AND departure = departure + MINUTE(30)
    WHERE f.flight_code = code;
END $$
DELIMITER ;

CALL udp_delay_flight('ZP-782');