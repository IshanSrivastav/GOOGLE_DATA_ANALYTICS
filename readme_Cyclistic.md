# 🚴‍♂️ Cyclistic Bike Share Data Analysis 

This project explores and analyzes cyclist ride data using SQL & Excel. The dataset includes ride details such as start and end times, 
ride, and user type (member or casual). The queries focus on cleaning the data, generating insights, and understanding rider behavior across different time periods.

---

## 📂 Database Used As In MySQL

- **Database Name:** `cyclist`
- **Main Table:** `cycle_data`

---

## 🗃️ Dataset Information

- **Source:** Provided by **DIVVY** & **City of Chicago**, made available through **Motivate International Inc.**
- **License:** [Divvy Data License](https://ride.divvybikes.com/system-data)
- **Timeframe:** January 2024 to December 2024
- **Volume:** Approximately **5.9 million records**

---

## 🧹 Pre-Processing (Excel)

Before importing the data into MySQL, Excel was used for preliminary cleaning:
- Removed irrelevant columns:
  - `start_station_name`
  - `start_station_id`
  - `end_station_name`
  - `end_station_id`
  - `start_lat`
  - `start_lng`
  - `end_lat`
  - `end_lng`
- Concatenated 12 individual monthly CSVs into one consolidated file
- Ensured proper formatting for `started_at`, `ended_at`, and `member_casual` columns

---

## ⚙️ Data Import (MySQL)

Data was imported using the `LOAD DATA LOCAL INFILE` method:

```sql
-- For reference: used this method to load the CSVs
LOAD DATA LOCAL INFILE 'C:/Users/abydo/Documents/Case_Study/MySQL/Mysql_analysis/202412-divvy-tripdata.csv'
INTO TABLE cycle_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

---

## ❗ Common Challenges Faced

### 1. **Timeout / Lost Connection Error**
While running large queries, the following error was encountered:

> **Error Code: 2013 – Lost connection to MySQL server during query**

✅ This was resolved using solutions suggested [in this StackOverflow thread](https://stackoverflow.com/questions/10563619/error-code-2013-lost-connection-to-mysql-server-during-query), such as increasing timeout and packet size in the `my.ini` config or session settings.

### 2. **Data Formatting Issues**
- Some rows had `ended_at` values earlier than `started_at`.
- `member_casual` column had hidden characters (`\r`, `\n`) which caused mismatched groupings.
- Used `HEX()` and `REPLACE()` to identify and clean these anomalies.

---

## 🏗️ Step-by-Step Overview (MySQL)

### 1. **Setup**
- Create database and table.
- Import the cleaned CSV file.

### 2. **Initial Exploration**
- Count total records.
- Extract datetime features.

### 3. **Data Cleaning**
- Normalize `member_casual` values.
- Remove carriage returns, newlines, and trim whitespace.

### 4. **Data Analysis**

#### 👥 User Distribution
#### 📅 Monthly Trends
#### 🍂 Seasonal Trends
#### 📆 Weekday Analysis
#### ⏱️ Ride Duration
#### 🕒 Time of Day Usage

(Each section uses SQL queries to extract and analyze insights.)

---

## 📊 Key Insights

- **Most Popular Month:** September
- **Least Active Month:** January
- **Casual vs Member Usage Patterns:** Weekends vs weekdays
- **Ride Duration:** Casual riders ride longer
- **Time of Day:** Members prefer work hours; casuals ride later in the day

---

## 🔧 Technologies Used

- Excel (Initial Cleaning)
- MySQL 8.0+ (Querying & Analysis)

---

## 💡 How to Use

1. Clone this repository.
2. Load your cleaned dataset into the `cycle_data` table.
3. Run the SQL script step by step in a MySQL client.
4. Explore, tweak, and visualize the insights!

---

## 📬 Feedback

If you have suggestions, feedback, or improvements, feel free to open an issue or pull request.

---
