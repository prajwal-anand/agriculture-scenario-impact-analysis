# 🌾 Agriculture Revenue Scenario Impact Analysis

## 📌 Project Overview

This project analyzes the financial impact of simulated agricultural scenario changes on total revenue across crops, locations, and time.

Using a layered Snowflake data architecture and a Power BI analytical dashboard, the solution evaluates how environmental and operational changes affect revenue performance.

The final output is deployed as an interactive **Power BI App**.

---

## 🎯 Business Objective

Agricultural revenue is highly sensitive to environmental variables such as rainfall and cultivated area.

This project was designed to:

- Simulate controlled environmental and operational changes  
- Measure absolute and relative revenue impact  
- Identify the most affected crops and districts  
- Enable interactive exploration through a BI application  

---

## 🏗️ Architecture

![Architecture Diagram](03_documentation/architecture-diagram.png)

### Data Flow

1. **AWS S3** – External raw data storage  
2. **Snowflake – RAW Layer** – Ingested source data  
3. **Snowflake – STAGING Layer** – Data cleansing and transformations  
4. **Snowflake – CURATED Layer** – Business-ready analytical models  
5. **Power BI Desktop** – Data modeling, DAX calculations, dashboard design  
6. **Power BI Service (App)** – Published interactive report  

---

## 📊 Dashboard Preview

![Dashboard Overview](03_documentation/dashboard-overview.png)

---

## 🧠 Scenario Assumptions

- Rainfall increased by **10% across all years**
- Cultivated area reduced by **10%**
- Impact calculated relative to baseline revenue

---

## 📈 Scenario Analysis & Modeling Logic

### Baseline Adjustment Logic

The scenario simulates a controlled environmental and operational shock:

- Rainfall increase assumed at 10%
- Cultivated land reduced by 10%
- Revenue impact evaluated against baseline

---

### 🌱 Crop Sensitivity Modeling (Power BI Layer)

To simulate differentiated crop behavior under the scenario, a dynamic DAX measure was introduced:

```DAX
Crop Sensitivity Factor =
SWITCH(
    SELECTEDVALUE('AGRICULTURE_ANALYTICS'[CROPS]),
    "Coconut", 1.10,
    "Coffee", 1.20,
    "Rice", 0.95,
    "Arecanut", 1.05,
    1.00
)
```

This measure assigns crop-specific response multipliers to model heterogeneous revenue sensitivity.

### Scenario Revenue Logic

Scenario Revenue is calculated as:

Adjusted Scenario Revenue =  
Base Revenue × Crop Sensitivity Factor × Area Adjustment

This ensures each crop reacts differently to environmental changes rather than assuming uniform elasticity.

---

## 📊 Key Findings

### Overall Impact

- The scenario resulted in an approximate **5% decline in total revenue**
- Yield improvements were insufficient to offset cultivated area reduction
- Land availability showed stronger revenue influence than rainfall improvements

---

### Crop-Level Insights

- **Coconut** experienced the largest absolute revenue decline  
- **Coffee** showed the highest relative sensitivity  
- High-revenue crops displayed greater absolute volatility  

---

### Location-Level Insights

- **Hassan district** recorded the largest absolute revenue loss  
- Impact distribution remained consistent across years due to uniform scenario application  

---

## 🧮 Core DAX Logic

Revenue percentage impact is calculated as:

```DAX
Revenue % Impact =
DIVIDE(
    SUM('AGRICULTURE_ANALYTICS'[SCENARIO_REVENUE])
    -
    SUM('AGRICULTURE_ANALYTICS'[BASE_REVENUE]),
    SUM('AGRICULTURE_ANALYTICS'[BASE_REVENUE])
)
```

Safe division ensures error handling and dynamic recalculation across filters.

---

## 📊 DAX Measures

Full DAX implementation details available here:

[View DAX Measures](03_documentation/dax_measures.md)

---

## 🛠️ Tech Stack

- **AWS S3** – Cloud storage  
- **Snowflake** – Data warehousing & layered modeling  
- **SQL** – ETL and transformations  
- **Power BI Desktop** – Data modeling & visualization  
- **Power BI Service** – App deployment  
- **DAX** – Analytical calculations  
- **GitHub** – Version control & documentation  

---

## 🚀 Live Power BI App

Access the deployed application here:

🔗 https://app.powerbi.com/Redirect?action=OpenApp&appId=3f084f58-be01-44c2-8bcd-3f35a6ce1bc1&ctid=f419c9fe-f7b0-4d87-bee8-e8dfb2190cab&experience=power-bi

---

## 📁 Repository Structure

```
agriculture-scenario-impact-analysis/
│
├── 01_snowflake_sql/
│   ├── 01_s3_integration_and_raw_ingestion.sql
│   ├── 02_staging_transformations.sql
│   └── 03_curated_business_layer.sql
│
├── 02_powerbi/
│   └── agriculture-scenario-impact-dashboard.pbix
│
├── 03_documentation/
│   ├── dashboard-overview.png
│   ├── architecture-diagram.png
│   └── dax_measures.md
│
└── README.md
```

---

## 💡 What This Project Demonstrates

- End-to-end data engineering pipeline design  
- Snowflake layered architecture (RAW → STAGING → CURATED)  
- Scenario-based revenue sensitivity modeling  
- Crop-level differentiated impact modeling  
- Advanced Power BI dashboard development  
- Bookmark-based visual toggling  
- Conditional formatting for impact visualization  
- Production-style BI app deployment  

---

## 👤 Author

**Prajwal Anand**
Cloud Data Engineering & Analytics | AWS | Snowflake | Power BI

---
