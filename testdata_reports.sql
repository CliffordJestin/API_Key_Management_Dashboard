use api_key_dashboard;
-- =========================================
-- Insert Sample Users
-- =========================================
insert into users(username,email) values 
('Cletus','cletus@gmail.com'),
('John', 'john@gmail.com'),
('bob', 'bob@example.com'),
('Minna','mrj@gmail.com'),
('Achu','achuth@gmail.com'),
('Jestin','jestinks@hotmail.com');

-- Generate API Keys for Users
-- (Assumes generate_api_key procedure is already created)
CALL generate_api_key(1, 'production', DATE_ADD(NOW(), INTERVAL 30 DAY));
CALL generate_api_key(2, 'development', DATE_ADD(NOW(), INTERVAL 15 DAY));
select*from users;

-- =========================================
-- Setup Rate Limits for Each API Key
-- =========================================
-- Clear existing test limits
DELETE FROM rate_limits WHERE key_id IN (2, 3, 4);

-- Add rate limits
INSERT INTO rate_limits (key_id, max_requests, per_minutes) VALUES
(2, 5, 1),
(3, 10, 2),
(4, 15, 3);

-- Simulate API Usage (uses log_api_usage procedure)
CALL log_api_usage(2);
CALL log_api_usage(3);
CALL log_api_usage(4);

-- View usage logs for these keys
select*from api_key_usage where key_id in(2,3,4);

-- Check rate limit for key 3
select check_rate_limit(3);

-- =========================================
-- Report Queries
-- =========================================

-- 1. Usage count per user
select u.username,count(*) as total_requests
from users u
join api_keys k on u.user_id=k.user_id
join api_key_usage a on k.key_id=a.key_id
group by u.user_id;

-- 2. Top 5 most used API keys
select k.api_key, count(*) as usage_count
from api_keys k
join api_key_usage a on k.key_id=a.key_id
group by k.api_key
order by usage_count desc
limit 5;

-- 3. API keys expiring within 3 days
select api_key, expires_at
from api_keys
where expires_at< date_add(now(),interval 3 day);

-- 4. Revoked keys
select api_key, status from api_keys where status='revoked';


