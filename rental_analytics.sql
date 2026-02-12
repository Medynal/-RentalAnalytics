--creating a fragment view containing sales information 
DROP VIEW IF EXISTS sales 
CREATE VIEW sales AS
	(SELECT r.*,
		p.payment_id, p.amount, p.payment_date,
		c.store_id, c.first_name, c.last_name, c.email, c.address_id, c.activebool, c.create_date
	FROM rental as r
	LEFT JOIN payment AS p ON r.rental_id = p.rental_id
	LEFT JOIN customer AS c ON r.customer_id = c.customer_id);
SELECT * FROM payment
	
-- creating a fragment view containing customer location information	
DROP VIEW IF EXISTS	location
CREATE VIEW location AS
	(SELECT a.address_id, a.address, city.city, co.country
	FROM address AS a
	LEFT JOIN city ON a.city_id = city.city_id
	LEFT JOIN country AS co ON city.country_id = co.country_id);
	
-- creating a fragment view containing inventory information	
DROP VIEW IF EXISTS films
CREATE VIEW films AS
	(SELECT i.film_id,i.inventory_id, f.title, fc.category_id, ct.name AS genre
	FROM inventory AS i 
	LEFT JOIN film AS f ON i.film_id = f.film_id
	LEFT JOIN film_category AS fc ON i.film_id = fc.film_id
	LEFT JOIN category AS ct ON fc.category_id = ct.category_id);

-- create one big table using maximum rental date + 2 days as current date	
DROP TABLE IF EXISTS obt
CREATE TABLE obt AS (
	SELECT 
		b.rental_id,
		b.store_id,
		b.rental_date :: DATE,
		b.return_date :: DATE,
		b.return_date::DATE - b.rental_date::DATE AS rental_duration,
		b.customer_id,
		b.first_name || ' ' || b.last_name AS customer_name, 
		l.address AS customer_address,
		l.city || ' ' || l.country AS customer_city,
		b.payment_id,
		b.amount,
		b.payment_date :: DATE,
		b.last_update,
		b.email, 
		b.activebool,
		(MAX(b.rental_date) OVER() + INTERVAL '2 days')::DATE - b.rental_date :: DATE AS last_film_rental_day,
		LEAD(b.rental_date::DATE) OVER (PARTITION BY b.customer_id ORDER BY b.rental_date) - b.rental_date::DATE 
			AS days_between,
		films.*
	FROM sales AS b
	LEFT JOIN films ON b.inventory_id = films.inventory_id
	LEFT JOIN location AS l ON b.address_id = l.address_id);

SELECT MAX (rental_date)
from obt

--Customer segment and performance 
/* Based on lifetime spend customers are segmented into: 
Platinum(Top Tier): lifetime spend > 150 
Gold: 100< = lifetime spend <= 150 
Silver: 50 < = lifetime spend <= 99.9 
Bronze: lifetime spend < 50 
Using MAX(rental_date) + 2 days as current day, customers are segmented into 3 based on last rental date: 
 Occational : last rental days < 15 
 Regular: 15<= last rental days <30 
 At Risk: >=30*/
SELECT 
	customer_id,
	customer_name,
	SUM(amount) AS total_spend,
	MAX(rental_date::DATE) AS last_rental_date,
	MIN(last_film_rental_day) AS last_rental_day,
	AVG(days_between):: INT AS avg_days_btw,
	CASE WHEN SUM(amount) > 150 THEN 'platinum'
		WHEN SUM(amount) BETWEEN 100 AND 150 THEN 'gold'
		WHEN SUM(amount) BETWEEN 50 AND 99.99 THEN  'silver'
		ELSE 'bronze'
		END cust_spend_category,
	CASE WHEN MIN(last_film_rental_day) < 15 THEN 'regular'
		WHEN MIN(last_film_rental_day) >= 15 AND MIN(last_film_rental_day)<30 THEN 'occasional'
		ELSE 'at risk'
		END cust_rental_category
FROM obt 
GROUP BY 
	customer_id,
	customer_name
ORDER BY AVG(days_between) ASC

---most watched genre by platinum customers
WITH platinum_customers AS( 
	SELECT 
		customer_id,
		customer_name
	FROM obt 
	GROUP BY 
		customer_id,
		customer_name
	HAVING SUM (amount) > 150)
SELECT o.genre, COUNT(o.genre) AS watch_count
FROM platinum_customers p
LEFT JOIN obt o ON p.customer_id = o.customer_id
GROUP BY o.genre
ORDER BY watch_count DESC;

-- content gap analysis: film category with zero rental in certain customer and store location
SELECT 
	genre,
	customer_city,
	COUNT (rental_id) AS number_of_rentals
FROM obt
GROUP BY genre, customer_city
HAVING COUNT (rental_id)= 0;

SELECT 
	genre,
	store_id,
	COUNT (rental_id) AS number_of_rentals
FROM obt
GROUP BY genre, store_id
HAVING COUNT (rental_id)= 0;

-- Engagement tracking (which genre stays longer with customer?)
SELECT 
	genre,
	ROUND( AVG(rental_duration), 2) AS average_rental_duration
FROM obt
GROUP BY genre
ORDER BY AVG(rental_duration) DESC;

--revenue driver (which genre generates revenue higher than avegrage revenue per genre? )
WITH genre_revenue AS (
	SELECT 
		genre,
		SUM(amount) AS revenue
	FROM obt
	GROUP BY genre)
SELECT * FROM genre_revenue
WHERE revenue >(SELECT AVG(revenue) FROM genre_revenue)
ORDER BY revenue DESC;

-- Marketing targets: materialised view of platinum customers who haven't rented in the last 14 days.
DROP MATERIALIZED VIEW marketing_targets
CREATE MATERIALIZED VIEW marketing_targets AS(
	SELECT 
		s.customer_id,
		s.first_name || ' ' || s.last_name AS customer_name,
		s.email,
		MAX(s.rental_date :: DATE) AS last_rental_date,
		STRING_AGG (DISTINCT f.genre, ', '),
		CASE WHEN SUM(s.amount)>= 150 THEN 'PLATINUM' 
			ELSE 'OTHERS' END customer_type
	FROM sales s
	LEFT JOIN films f ON s.inventory_id = f.inventory_id
	GROUP BY s.customer_id, s.first_name || ' ' || s.last_name, S.email
	HAVING SUM(s.amount)>= 150 AND CURRENT_DATE - MAX(s.rental_date :: DATE) > 14 
	ORDER BY MAX(s.rental_date :: DATE));

REFRESH MATERIALIZED VIEW marketing_targets



	
	


	

	
	

 
 




