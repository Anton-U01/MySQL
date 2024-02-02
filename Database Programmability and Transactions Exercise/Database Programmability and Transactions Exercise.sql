DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
	SELECT first_name,last_name FROM employees
    WHERE salary > 35000
    ORDER BY first_name,last_name,employee_id;
END$$
DELIMITER ;
;

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(`number` DECIMAL(10,4))
BEGIN
	SELECT first_name,last_name FROM employees
    WHERE salary >= `number`
    ORDER BY first_name,last_name,employee_id;
END$$
DELIMITER ;
;

DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(string VARCHAR(10))
BEGIN
	SELECT name FROM towns
    WHERE name LIKE CONCAT(string,'%')
    ORDER BY name;
END$$

DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(30))
BEGIN
	SELECT first_name,last_name FROM employees AS e
    JOIN addresses AS a ON a.address_id = e.address_id
    JOIN towns AS t ON t.town_id = a.town_id
    WHERE t.name = town_name
    ORDER BY first_name,last_name,employee_id;
END$$

DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(salary_param DOUBLE)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
	RETURN (CASE 
		WHEN salary_param < 30000 THEN 'Low'
        WHEN salary_param >= 30000 AND salary_param <= 50000 THEN 'Average'
        ELSE 'High'
		END
    );
END$$

DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(level VARCHAR(10))
BEGIN
	SELECT first_name,last_name FROM employees
    WHERE (
    CASE (level)
		WHEN 'Low' THEN salary < 30000
        WHEN 'Average' THEN salary >= 30000 AND salary <= 50000
        ELSE salary > 50000
    END
    )
    ORDER BY first_name DESC,last_name DESC;
END$$

DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50),
word VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
RETURN  word REGEXP (CONCAT('^[',set_of_letters, ']+$'));
END$$

SELECT ufn_is_word_comprised('oistmiahf','Sofia');

/* PART 2 */
DELIMITER$$
CREATE PROCEDURE usp_get_holders_full_name() 
BEGIN
	SELECT CONCAT_WS(" ",first_name,last_name) AS full_name FROM account_holders
	ORDER BY full_name,id;
END$$

DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(number DOUBLE)
BEGIN
	SELECT first_name,last_name FROM account_holders AS ah
    JOIN accounts AS a ON ah.id = a.account_holder_id
    GROUP BY account_holder_id
    HAVING SUM(balance) > number
    ORDER BY a.account_holder_id;
END$$

CALL usp_get_holders_with_balance_higher_than(7000);

DELIMITER$$
CREATE FUNCTION ufn_calculate_future_value(sum DECIMAL(10,4),
yearly_interest_rate DOUBLE, years INT)
RETURNS DECIMAL(10,4)
DETERMINISTIC
BEGIN
	RETURN(sum * (POWER((1 + yearly_interest_rate),years)));
END$$

SELECT ufn_calculate_future_value(1000,0.5,5);

DELIMITER$$
CREATE PROCEDURE usp_calculate_future_value_for_account(id_param INT,
interest_rate DECIMAL(19,4))
BEGIN
	SELECT a.id,
    first_name,
    last_name,
    balance AS current_balance,
    ufn_calculate_future_value(balance,interest_rate,5) AS balance_in_5_years
    FROM 
    account_holders AS ah
    JOIN accounts AS a ON ah.id = a.account_holder_id
    WHERE a.id = id_param;
END$$


CREATE PROCEDURE usp_deposit_money(account_id INT,money_amount DECIMAL(19,4))
BEGIN
	IF money_amount > 0 THEN START TRANSACTION;
    
	UPDATE accounts
    SET balance = balance + money_amount
    WHERE accounts.id = account_id;
    COMMIT;
    END IF;
END;

DELIMITER$$
CREATE PROCEDURE usp_withdraw_money(account_id INT,money_amount DECIMAL(19,4))
BEGIN
	IF money_amount > 0 AND
    (
    SELECT balance
    FROM accounts 
    WHERE account_id = accounts.id
    ) - money_amount >= 0 
    THEN START TRANSACTION;
	UPDATE accounts
    SET balance = balance - money_amount
    WHERE accounts.id = account_id;
    COMMIT;
    END IF;
END$$


CREATE PROCEDURE usp_transfer_money(from_account_id INT,
to_account_id INT,amount DECIMAL(19,4))
BEGIN
	IF amount > 0 
    AND (SELECT accounts.id FROM
    accounts WHERE
    accounts.id = from_account_id) IS NOT NULL
    AND (SELECT accounts.id FROM
    accounts WHERE
    accounts.id = to_account_id) IS NOT NULL
    AND (SELECT balance FROM
    accounts WHERE
    accounts.id = from_account_id) > amount
    AND from_account_id <> to_account_id
    THEN START TRANSACTION;
    UPDATE accounts
    SET balance = balance + amount
    WHERE accounts.id = to_account_id;
    UPDATE accounts
    SET balance = balance - amount
    WHERE accounts.id = from_account_id;
    COMMIT;
    END IF;
END;

CREATE TABLE logs(
	log_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    old_sum DECIMAL(19,4),
    new_sum DECIMAL(19,4)
);

DELIMITER $$
CREATE TRIGGER `trigger`
AFTER UPDATE ON accounts
FOR EACH ROW
BEGIN
    IF OLD.balance <> NEW.balance THEN
        INSERT INTO logs
            (account_id, old_sum, new_sum)
        VALUES (OLD.id, OLD.balance, NEW.balance);
    END IF;
END $$
