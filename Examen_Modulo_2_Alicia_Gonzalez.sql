
USE sakila;

SELECT * FROM film;
SELECT * FROM actor;
SELECT * FROM customer;
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM category;
SELECT * FROM film_actor;
SELECT * FROM film_category;
SELECT * FROM payment;
SELECT * FROM staff;
SELECT * FROM store;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM language;

# 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title 
FROM film;

# 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title 
FROM film
WHERE rating = 'PG-13';

# 3. Encuentra el título y la descripción de todas las películas que contengan la cadena de caracteres "amazing" en su descripción.

SELECT title, description
FROM film
WHERE description LIKE '%amazing%';

# 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title
FROM film
WHERE length > 120;

# 5. Recupera los nombres y apellidos de todos los actores.

SELECT CONCAT(first_name, ' ', last_name) name
FROM actor;

# 6. Encuentra el nombre y apellidos de los actores que tengan "Gibson" en su apellido.

SELECT CONCAT(first_name, ' ', last_name) name
FROM actor
WHERE last_name LIKE '%Gibson%';

# 7. Encuentra los nombres y apellidos de los actores que tengan un actor_id entre 10 y 20.

SELECT CONCAT(first_name, ' ', last_name) name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

# 8. Encuentra el título de las películas en la tabla `film` que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT title 
FROM film
WHERE rating NOT IN ('R','PG-13');

# 9. Encuentra la cantidad total de películas en cada clasificación de la tabla `film` y muestra la clasificación junto con el recuento.

SELECT rating, COUNT(*) num_films
FROM film
GROUP BY rating;

# 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(*) num_rentals
FROM customer c
LEFT JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY customer_id
ORDER BY num_rentals DESC; 

# 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT c.name category, COUNT(r.rental_id) num_rentals
FROM category c
INNER JOIN film_category fm
ON c.category_id = fm.category_id
INNER JOIN inventory i
ON fm.film_id = i.film_id 
INNER JOIN rental r 
ON i.inventory_id = r.inventory_id
GROUP BY category
ORDER BY COUNT(r.rental_id) DESC;

# 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla `film` y muestra la clasificación junto con el promedio de duración.

SELECT rating, ROUND(AVG(length),1) average_length
FROM film
GROUP BY rating;

# 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT CONCAT(first_name, ' ', last_name) name
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
INNER JOIN film f
ON fa.film_id = f.film_id
WHERE title = 'Indian Love';

# 14. Muestra el título de todas las películas que contengan la cadena de caracteres "dog" o "cat" en su descripción.

SELECT title
FROM film 
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

# 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla `film_actor`.

SELECT CONCAT(first_name, ' ', last_name) name
FROM actor a
LEFT JOIN film_actor fa 
ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;

# 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title 
FROM film 
WHERE release_year BETWEEN 2005 AND 2010;

# 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT title
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
WHERE fc.category_id IN (
    SELECT c.category_id
    FROM category c
    WHERE c.name = 'Family'
);

# 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT CONCAT(first_name, ' ', last_name) name
FROM actor a
JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY name
HAVING COUNT(DISTINCT film_id) > 10;

# 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla `film`.

SELECT title 
FROM film 
WHERE rating = 'R' AND length > 120;

# 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT c.name category, ROUND(AVG(f.length),1) average_length 
FROM category c
INNER JOIN film_category fc
ON c.category_id = fc.category_id
INNER JOIN film f
ON fc.film_id = f.film_id 
GROUP BY category 
HAVING AVG(f.length) > 120;

# 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT CONCAT(first_name, ' ', last_name) name, COUNT(DISTINCT fa.film_id) num_films
FROM actor a
JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY name 
HAVING COUNT(DISTINCT fa.film_id) >=5
ORDER BY COUNT(DISTINCT fa.film_id) DESC;

# 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

SELECT DISTINCT title
FROM film f
INNER JOIN inventory i
ON  f.film_id = i.film_id
WHERE inventory_id IN (
    SELECT r.inventory_id
    FROM rental r
    WHERE DATEDIFF(return_date, rental_date) > 5
);

# 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT CONCAT(first_name, ' ', last_name) name 
FROM actor
WHERE actor_id NOT IN (
    SELECT actor_id
    FROM film_actor fa
    JOIN film_category fc
    ON fa.film_id = fc.film_id
    JOIN category c
    ON fc.category_id = c.category_id
    WHERE c.name = 'Horror'
);

# 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla `film`.

SELECT title
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
WHERE fc.category_id IN (
    SELECT c.category_id
    FROM category c
    WHERE c.name = 'Comedy')
AND f.length > 180;
