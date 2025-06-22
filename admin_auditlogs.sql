use api_key_dashboard;
-- =========================================
-- Table: admin_audit_logs
-- Logs admin actions like key revocations
-- =========================================
create table admin_audit_logs(
log_id int primary key auto_increment,      -- Unique log entry
action_type varchar (50),                   -- Action type
performed_by varchar(100),                  -- Admin performing the action
target_key_id int,                          -- Key ID affected
log_time datetime default current_timestamp, -- Timestamp of the action
notes text);                                 -- Optional description
-- =========================================
-- Procedure: revoke_api_key
-- Revokes an API key and logs the action in admin_audit_logs
-- =========================================
DROP PROCEDURE IF EXISTS revoke_api_key;

delimiter //
create procedure revoke_api_key(
in in_api_key varchar(64),          -- API key string to revoke
in in_admin varchar(100))           -- Admin identifier/email
begin
declare k_id int;

-- Get the key_id from api_key string
select key_id into k_id FROM api_keys WHERE api_key = in_api_key;

-- Revoke the API key
update api_keys set status='revoked' where api_key=in_api_key;

-- Log the admin action
insert into admin_audit_logs (action_type, performed_by, target_key_id, notes)
values ('revoke', in_admin, k_id, 'API key revoked manually');
end //
delimiter ;    

-- =========================================
-- Test Call: Revoke a Key and View Audit Log
-- =========================================
CALL revoke_api_key('626b319a4f4f11f0bdf9c85acfd81bb6', 'admin@devifyx.com');

-- View log entry
SELECT * FROM admin_audit_logs;