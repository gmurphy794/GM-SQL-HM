USE sakila;

-- 1a
SELECT first_name, last_name
FROM actor;

-- 1b 
SELECT CONCAT (first_name, ' ', last_name) as 'Actor Name'
From actor; 

-- 2a 
select actor_id, first_name, last_name
from actor
WHERE first_name = 'Joe';

-- 2b
select first_name, last_name from actor
WHERE last_name like('%gen%');

-- 2c
select first_name, last_name from actor
WHERE last_name like('%li%')
ORDER BY last_name, first_name;

-- 2d
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a 
ALTER TABLE actor
add middle_name varchar(45);

-- 3b 
alter table actor
modify column middle_name BLOB; 

-- 3c
ALTER TABLE actor
DROP COLUMN middle_name; 

-- 4a
SELECT last_name, count(last_name)
FROM actor
GROUP BY (last_name);

-- 4b
SELECT last_name, count(last_name)
FROM actor
GROUP BY (last_name)
HAVING count(last_name) > 1;

-- 4c
UPDATE actor
Set first_name = 'Harpo'
where first_name = 'Groucho' and last_name = 'Williams';

-- 4d
UPDATE actor
SET first_name = 
CASE WHEN first_name = 'Groucho' THEN 'Mucho Groucho'
ELSE 'Groucho' END
where actor_id = 172;

-- 5a
SHOW CREATE TABLE address;

-- 6a
SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
ON (s.address_id = a.address_id);

-- 6b
SELECT s.first_name, s.last_name, SUM(p.amount) as 'Total Amount'
FROM staff s
JOIN payment p
ON (s.staff_id = p.staff_id)
GROUP BY s.first_name, s.last_name;

-- 6c
SELECT f.title, COUNT(a.actor_id) as 'Actors'
FROM film f
JOIN film_actor a
ON (f.film_id = a.film_id)
GROUP BY f.title;

-- 6d
SELECT f.title, COUNT(i.inventory_id)
from film f
JOIN inventory i
ON (f.film_id = i.film_id)
WHERE title = 'Hunchback Impossible'
GROUP BY title;

-- 6e
SELECT c.first_name, c.last_name, SUM(p.amount) as 'Total Amount Paid'
from customer c
JOIN payment p
ON (c.customer_id = p.customer_id)
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name, c.first_name;

-- 7a
SELECT title
from film
WHERE language_id =
	(SELECT language_id
    from language
    WHERE name = 'English')
AND (title like 'K%' OR title like 'Q%');

-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id in
	(SELECT actor_id
    FROM film_actor
    WHERE film_id =
    (SELECT film_id
    FROM film
    WHERE title = 'Alone Trip')
    );
    
-- 7c
SELECT first_name, last_name, email
FROM customer
WHERE address_id in
	(SELECT address_id
    FROM address
    WHERE city_id in
		(SELECT city_id
        FROM city
        WHERE country_id =
			(SELECT country_id
			FROM country
			WHERE country = 'Canada')
        )
	);


-- 7d
SELECT title
FROM film
WHERE film_id in
	(SELECT film_id
    FROM film_category
    WHERE category_id = 
    (SELECT category_id
    from category
    WHERE name = 'Family')
    );
    
-- 7e 
SELECT title, 
	(SELECT COUNT(rental_id)
	FROM rental
	WHERE inventory_id in
		(SELECT inventory_id
        FROM inventory
        WHERE film_id = film.film_id)
	) as 'Number of Rentals'
FROM film
ORDER BY 
(SELECT COUNT(rental_id)
	FROM rental
	WHERE inventory_id in
		(SELECT inventory_id
        FROM inventory
        WHERE film_id = film.film_id)
	) DESC;
    
-- 7f
SELECT store_id, 
	(SELECT SUM(amount)
    FROM payment
    WHERE staff_id in
    (SELECT staff_id
    FROM STAFF
    WHERE store_id = store.store_id)
    ) as 'Total Revenue'
FROM store;

-- 7g
SELECT store_id,
	(SELECT city
    FROM city
    WHERE city_id =
		(SELECT city_id
        FROM address
        WHERE address_id = store.address_id)
	) as 'City',
    (SELECT country
    FROM country
    WHERE country_id = 
		(SELECT country_id
		FROM city
		WHERE city_id = 
			(SELECT city_id
			FROM address
			WHERE address_id = store.address_id)
		)
	) as 'Country'
FROM store;

-- 7h
SELECT name as 'Category', 
	(SELECT SUM(amount)
    FROM payment
    WHERE rental_id in
		(SELECT rental_id
        FROM rental
        WHERE inventory_id in
			(SELECT inventory_id
            FROM inventory
            WHERE film_id in
				(SELECT film_id
                FROM film_category
                WHERE category_id = category.category_id)
			)
		)
	) as 'Gross Revenue'
FROM category
ORDER by (SELECT SUM(amount)
    FROM payment
    WHERE rental_id in
		(SELECT rental_id
        FROM rental
        WHERE inventory_id in
			(SELECT inventory_id
            FROM inventory
            WHERE film_id in
				(SELECT film_id
                FROM film_category
                WHERE category_id = category.category_id)
			)
		)
	) DESC;

-- 8a 
CREATE VIEW Top_Five_Genres AS
SELECT name as 'Category', 
	(SELECT SUM(amount)
    FROM payment
    WHERE rental_id in
		(SELECT rental_id
        FROM rental
        WHERE inventory_id in
			(SELECT inventory_id
            FROM inventory
            WHERE film_id in
				(SELECT film_id
                FROM film_category
                WHERE category_id = category.category_id)
			)
		)
	) as 'Gross Revenue'
FROM category
ORDER by (SELECT SUM(amount)
    FROM payment
    WHERE rental_id in
		(SELECT rental_id
        FROM rental
        WHERE inventory_id in
			(SELECT inventory_id
            FROM inventory
            WHERE film_id in
				(SELECT film_id
                FROM film_category
                WHERE category_id = category.category_id)
			)
		)
	) DESC
    LIMIT 5;
    
-- 8b 
SELECT * FROM Top_Five_Genres;

-- 8c
DROP VIEW Top_Five_Genres;
