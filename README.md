# DVD Rental Co: Customer Churn and Lifetime Value (LTV) Analysis

## Project Overview

DVD Rental Co. is experiencing declining rentals due to increasing competition from streaming platforms. This project applies data analytics to identify retention opportunities, high-value customers, and inventory inefficiencies.

The analysis focuses on:

* Customers who have churned or are at risk of churning
* Film categories that generate the highest **Customer Lifetime Value (LTV)**
* Movies and genres with low or zero demand across customer locations
* High-value customers suitable for **targeted marketing campaigns**

The outputs support **data-driven decision-making** across customer retention, inventory optimisation, and marketing strategy.

---

## 🎯 Business Objectives

* Identify customers at risk of churn
* Segment customers by lifetime value and engagement level
* Detect content gaps across store and customer locations
* Understand rental frequency and customer engagement behaviour
* Identify high-performing genres by revenue and rental duration
* Create a **daily refreshed marketing target view** to support retention campaigns

---

## 🧠 Key Business Questions

* Who are the highest-value (Platinum) customers?
* Which customers have not rented recently and may be at risk?
* Which movie categories generate the highest LTV?
* What content occupies shelf space without customer demand?
* Which genres keep customers engaged for longer periods?

---

## 📊 Analysis Breakdown

### 1. Customer Segmentation

Customers are segmented using a **value-based and behaviour-based approach**, combining lifetime spend and recency of rentals.

**Lifetime Value Segments**

* **Platinum (Top Tier):** Lifetime spend > 150
* **Gold:** 100 ≤ Lifetime spend ≤ 150
* **Silver:** 50 ≤ Lifetime spend < 100
* **Bronze:** Lifetime spend < 50

**Engagement Segments**
Using `MAX(rental_date) + 2 days` as the reference date:

* **Occasional:** Last rental < 15 days
* **Regular:** 15 ≤ Last rental < 30 days
* **At Risk:** Last rental ≥ 30 days

---

### 2. Content Gap Analysis

Identifies film categories with **zero rentals** across specific store and customer locations:

* Highlights inventory inefficiencies
* Supports decisions on content removal, reallocation, or promotion

---

### 3. Engagement Frequency Analysis

Calculates the **average number of days between rentals per customer**:

* Measures engagement intensity
* Helps explain churn and disengagement patterns

---

### 4. Engagement Tracking by Category

Calculates **average rental duration per film category**:

* Longer rental duration indicates higher perceived customer value
* Informs content acquisition and prioritisation decisions

---

### 5. LTV-Driving Genres

Analyses revenue and viewing behaviour by genre:

* Summarises total revenue per genre
* Identifies genres most watched by **Platinum customers**
* Filters categories generating **above-average revenue**
* Enables personalised and genre-specific marketing campaigns

---

## 📈 Marketing Output

### `marketing_targets_vw` (Materialized View)

A daily refreshed churn signal used for retention campaigns.

**Criteria**

* Lifetime spend ≥ 150
* No rentals in the last 14 days

**Fields Included**

* Customer name
* Email address
* Last rental date
* Preferred genres

This view enables marketing teams to act quickly on early churn signals among high-value customers.

---

## 💡 Business Impact

* Enables targeted retention of high-value customers
* Reduces churn risk among Platinum customers
* Improves inventory return on investment (ROI)
* Aligns marketing spend with customer lifetime value
* Supports proactive, data-driven marketing strategies
