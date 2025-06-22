USE api_key_dashboard;
-- Table: users
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,        -- Unique user ID
    username VARCHAR(100) NOT NULL UNIQUE,         -- Username 
    email VARCHAR(255) NOT NULL UNIQUE,            -- Email
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP  -- Timestamp of user creation
);

-- Table: api_keys
create table api_keys(
key_id int auto_increment primary key,                                -- Unique key ID
user_id int not null,                                                 -- FK to users
api_key varchar(64) not null unique,                                  -- Secure API key
status ENUM('active','inactive','revoked') default 'active',          -- Key status
environment ENUM('development', 'production') default 'production',   -- Key environment
created_at datetime default current_timestamp,                        -- Timestamp of creation
expires_at datetime,                                                  -- expiry time
foreign key (user_id) references users(user_id));                     -- Link to users

-- Table: api_key_usage
create table api_key_usage(                                    
usage_id int auto_increment primary key,                     -- Unique usage log ID
key_id int not null,                                         -- FK to api_keys
request_time datetime default current_timestamp,             -- When the key was used
status ENUM('success','rate_limited', 'revoked') not null,   -- Outcome of request
 foreign key(key_id) references api_keys(key_id));           -- Link to API key

-- Table: rate_limits
create table rate_limits(                             
key_id int primary key,                               -- FK to api_keys (1:1)
max_requests int not null,                            -- Max allowed in time window
per_minutes int not null,                             -- Time window in minutes
foreign key(key_id) references api_keys(key_id));     -- Link to API key

-- Indexes for performance
CREATE INDEX idx_user_id ON api_keys(user_id);
CREATE INDEX idx_key_id ON api_key_usage(key_id);
CREATE INDEX idx_request_time ON api_key_usage(request_time);


