DVD Rental Co — Customer Churn and Lifetime Value Analysis

Project Overview
DVD Rental Co. is facing declining rentals due to competition from streaming platforms.
This project identifies low-hanging fruit by analyzing:
•	Customers who are churning or at risk
•	Film categories that drive the highest Lifetime Value (LTV)
•	Movies and categories that are not rented by customers in certain location
•	High-value customers for targeted marketing campaigns
The output supports data-driven retention, inventory optimization, and marketing strategy.

🎯 Business Objectives
•	Identify customers at risk of churn
•	Segment customers by spending and engagement
•	Detect content gaps across store locations
•	Understand engagement frequency and rental behaviour
•	Identify high-performing genries by revenue and rental duration
•	Create a daily refreshed marketing target view for retention campaign

🧠 Key Questions Answered
•	Who are our Top Tier (Platinum) customers?
•	Which customers haven’t rented recently?
•	Which movie categories generate the highest LTV?
•	What content is taking up shelf space without demand?
•	Which genres keep customers engaged longer?

📊 Analysis Breakdown
1.	Customer Segmentation
Using a value based segmentation, customers are segmented base on lifetime spend and last rental date.
Based on lifetime spend customers are segmented into:
•	Platinum(Top Tier):  lifetime spend > 150
•	Gold:  100< = lifetime spend <= 150 
•	Silver: 50 < = lifetime spend <= 99.9
•	Bronze: lifetime spend < 50
Using MAX(rental_date) + 2 days as current day, customers are segmented into 3 based on last rental date: 
•	Occational :  last rental days < 15
•	Regular:  15<= last rental days <30
•	At Risk: >=30
2.	Content Gap Analysis
Identifies film categories with zero rentals in specific store and customer locations:
•	Highlights inventory inefficiencies
•	Informs content removal or promotion strategies
3. Engagement Frequency
•	Calculates average days between rentals per customer:
•	Measures engagement intensity
•	Helps explain churn behaviour
 4. Engagement Tracking by Category
Calculates average rental duration per category:
•	Longer duration = higher perceived value
•	Helps prioritize content acquisition
5. LTV-driving Genres
Summarizes total revenue per genre and Identify most watched genre by platinum customers
•	Filter only categories generating above-average revenue
•	Identifies LTV-driving genres
•	Enable customised campaign

📈 Marketing Output
marketing_targets_vw (Materialized View): An up to date churn signal containing Platinum customers who have not rented in the last 14 days
Criteria:
Lifetime spend ≥ 150
No rentals in the last 14 days
Includes customer name, email, last rental date and kind of genre they watch

💡 Business Impact
•	Enables targeted retention campaigns
•	Reduces churn from high-value customers
•	Improves inventory ROI
•	Aligns marketing spend with customer lifetime value


