# 📊 DAX Measures Documentation

This document outlines the core DAX measures used in the Agriculture Revenue Scenario Impact Analysis dashboard.

---

## 1️⃣ Total Base Revenue

```DAX
Total Base Revenue =
SUM('AGRICULTURE_ANALYTICS'[BASE_REVENUE])
```

**Purpose:**  
Aggregates baseline revenue across selected filters (year, crop, location, rainfall group).

---

## 2️⃣ Total Scenario Revenue

```DAX
Total Scenario Revenue =
SUM('AGRICULTURE_ANALYTICS'[SCENARIO_REVENUE])
```

**Purpose:**  
Calculates revenue under simulated scenario conditions.

---

## 3️⃣ Revenue Impact (Absolute)

```DAX
Revenue Impact =
SUM('AGRICULTURE_ANALYTICS'[SCENARIO_REVENUE])
-
SUM('AGRICULTURE_ANALYTICS'[BASE_REVENUE])
```

**Purpose:**  
Measures total financial gain or loss due to scenario adjustments.

---

## 4️⃣ Revenue % Impact

```DAX
Revenue % Impact =
DIVIDE(
    SUM('AGRICULTURE_ANALYTICS'[SCENARIO_REVENUE])
    -
    SUM('AGRICULTURE_ANALYTICS'[BASE_REVENUE]),
    SUM('AGRICULTURE_ANALYTICS'[BASE_REVENUE])
)
```

**Purpose:**  
Calculates percentage change relative to baseline revenue.

**Why DIVIDE()?**  
Prevents division-by-zero errors and ensures safe calculation.

## 5️⃣ Crop Revenue Impact (Absolute)

```DAX
Crop Revenue Impact =
CALCULATE(
    [Revenue Impact],
    ALLEXCEPT('AGRICULTURE_ANALYTICS', 'AGRICULTURE_ANALYTICS'[CROPS])
)
```

**Purpose:**  
Calculates impact aggregated at crop level while preserving crop filter context.

---

## 6️⃣ Crop % Impact

```DAX
Crop % Impact =
CALCULATE(
    [Revenue % Impact],
    ALLEXCEPT('AGRICULTURE_ANALYTICS', 'AGRICULTURE_ANALYTICS'[CROPS])
)
```

**Purpose:**  
Measures relative impact per crop category.

---

## 7️⃣ Location Revenue Impact (Absolute)

```DAX
Location Revenue Impact =
CALCULATE(
    [Revenue Impact],
    ALLEXCEPT('AGRICULTURE_ANALYTICS', 'AGRICULTURE_ANALYTICS'[LOCATION])
)
```

**Purpose:**  
Calculates revenue impact grouped by district/location.

---

## 8️⃣ Location % Impact

```DAX
Location % Impact =
CALCULATE(
    [Revenue % Impact],
    ALLEXCEPT('AGRICULTURE_ANALYTICS', 'AGRICULTURE_ANALYTICS'[LOCATION])
)
```

**Purpose:**  
Measures relative impact across locations.

---

## 9️⃣ Crop Sensitivity Factor

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

**Purpose:**  
Introduces crop-level differentiated revenue response within the scenario model.

This ensures that each crop reacts uniquely under simulated environmental changes.

## 🔁 Bookmark Logic (UI Toggle)

The dashboard uses Power BI bookmarks to toggle between:

- Absolute Impact by Crop  
- Relative Impact (%) by Crop  

This enhances user experience without duplicating pages.

---

## 📌 Key Design Principles

- Measures built using modular structure
- Core logic centralized in base measures
- Safe division using `DIVIDE()`
- Context control using `CALCULATE()` and `ALLEXCEPT()`
- Fully dynamic across slicers and filters

---

## 💡 Analytical Outcome

All measures dynamically respond to:

- Year
- Crop
- Location
- Rainfall Group
- Soil Type

Ensuring consistent and scalable scenario modeling.

