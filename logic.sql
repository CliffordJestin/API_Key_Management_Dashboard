use api_key_dashboard;

-- ============================================
-- Procedure: generate_api_key
-- Description: Generates a secure UUID-based API key for a user
-- Inputs: user_id, environment, expiry date
-- ============================================

delimiter //

create procedure generate_api_key(
in in_user_id int,
in in_env varchar(20),
in in_expiry datetime)
begin
declare new_key varchar(64);

-- Generate UUID (remove hyphens)
set new_key=replace(uuid(), '-', '');

-- Validate environment
IF in_env NOT IN ('development', 'production') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid environment. Must be development or production.';
    END IF;
    
    -- Insert the generated key
insert into api_keys(user_id,api_key,environment,expires_at) values (in_user_id,new_key, in_env, in_expiry);

-- Return the key
select new_key as generated_api_key;
end//

delimiter ;

-- Sample insert + test
INSERT INTO users (username, email)
VALUES ('test_user', 'test@example.com');
SELECT * FROM users;


CALL generate_api_key(1, 'production', DATE_ADD(NOW(), INTERVAL 30 DAY));

-- ============================================
-- Trigger: before_api_key_usage
-- Description: Prevents usage of revoked or expired keys
-- ============================================

delimiter //

create trigger before_api_key_usage
before insert on api_key_usage
for each row
begin
declare key_status ENUM('active','inactive','revoked');
declare expiry datetime;

-- Get key status and expiry
select status, expires_at
into key_status, expiry
from api_keys
where key_id=new.key_id;

-- Block non-active keys
IF key_status != 'active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'API key is not active.';
    END IF;

-- Block expired keys
    IF expiry IS NOT NULL AND expiry < NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'API key has expired.';
    END IF;
end //
delimiter ;    

-- ======================================
-- Function: check_rate_limit
-- Returns TRUE if key has not exceeded its limit, FALSE otherwise
-- ======================================
delimiter //

create function check_rate_limit(p_key_id int) returns boolean reads sql data 
begin 
declare allowed int;
declare interval_minutes int;
declare count_requests int;
declare window_start datetime;

-- Get rate limit config
select max_requests, per_minutes
into allowed, interval_minutes
from rate_limits
where key_id=p_key_id;

-- Define time window
SET window_start = DATE_SUB(NOW(), INTERVAL interval_minutes MINUTE);

-- Count requests within window
select count(*)into count_requests from api_key_usage
where key_id=p_key_id and request_time>=window_start;
return count_requests< allowed;
END //

delimiter ;

-- Test rate limit check
SELECT check_rate_limit(2);

-- Assign a rate limit (test data)
INSERT INTO rate_limits (key_id, max_requests, per_minutes)
VALUES (2, 5, 1);
SELECT * FROM api_keys;

-- ======================================
-- Procedure: log_api_usage
-- Logs an API request and applies rate-limiting
-- ======================================
DELIMITER //

CREATE PROCEDURE log_api_usage(IN in_key_id INT)
BEGIN
IF check_rate_limit(in_key_id) THEN
INSERT INTO api_key_usage (key_id, status)
VALUES (in_key_id, 'success');
ELSE
INSERT INTO api_key_usage (key_id, status)
VALUES (in_key_id, 'rate_limited');
END IF;
END //

DELIMITER ;




