CREATE TABLE mountains (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE peaks (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    mountain_id INT,
    CONSTRAINT fk_peaks_mountain_id_mountains_id
    FOREIGN KEY (mountain_id)
    REFERENCES mountains(id)
);

SELECT driver_id,vehicle_type,CONCAT(first_name, " ",last_name) AS 'driver_name' from vehicles 
JOIN campers AS c ON driver_id = c.id;

SELECT starting_point,end_point,leader_id,CONCAT(first_name," ",last_name) AS 'leader_name' from routes
JOIN campers ON leader_id = campers.id;

CREATE TABLE mountains(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30)
);

CREATE TABLE peaks (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30),
    mountain_id INT,
    CONSTRAINT fk_peaks_mountain_id_mountains_id
    FOREIGN KEY (mountain_id)
    REFERENCES mountains(id)
    ON DELETE CASCADE
);


