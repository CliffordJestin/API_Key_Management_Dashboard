# API Key Management Dashboard

### 👤 Author: Clifford Jestin  
### 📅 Submission Date: June 22, 2025

---

## 🔧 Tech Stack

- **Database:** MySQL 8.0+
- **Interface:** SQL only (no frontend/backend)
- **Tools Used:** MySQL Workbench

---

## ✅ Features Implemented

- 👥 User registration with unique usernames/emails
- 🔐 Secure API key generation (UUID-based)
- 🌐 Support for `development` and `production` environments
- 📅 API key expiry with revocation capability
- 🚦 Rate limiting (e.g., X requests per Y minutes per API key)
- 📝 API usage logging (status: success, rate_limited, revoked)
- 📊 Reports:
  - Usage count per user
  - Most-used API keys
  - Keys nearing expiry
  - Revoked keys

---

## 🌟 Bonus Features

-  Admin audit logs for API key revocations
-  Trigger prevents usage of expired or revoked keys
-  Per-key customizable rate limits

---

## 🧪 How to Test

1. Run `Tables.sql`  
   _Creates schema and all required tables with relationships._
2. Run `Logic.sql`  
   _Loads stored procedures, triggers, and functions._
3. Run `TestData_Reports.sql`  
   _Adds sample users, generates keys, logs usage, and runs report queries._
4. Run `Admin_auditLogs.sql`  
   _Implements admin logging and tests revocation workflow._

---

## 📁 Project Files

| File Name              | Description                                 |
|------------------------|---------------------------------------------|
| `Tables.sql`           | Table definitions, relationships, indexes   |
| `Logic.sql`            | Procedures, triggers, and functions         |
| `TestData_Reports.sql` | Inserts, usage simulation, reporting queries|
| `Admin_auditLogs.sql`  | Admin audit logs and revoke procedure       |

---

## 🎥 Demo Video

[Click to watch the demo](https://drive.google.com/file/d/16IMV72l4tqT_RyLaLHKyXkv7oV9gIqON/view?usp=sharing)
