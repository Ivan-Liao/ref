
SELECT
    f.film_id,
    f.title,
    f.release_date,
    f.price,
    f.rating,
    f.user_rating,
    CASE
        WHEN f.user_rating >= 4.5 THEN 'Excellent'
        WHEN f.user_rating >= 4.0 THEN 'Good'
        WHEN f.user_rating >= 3.0 THEN 'Average'
        ELSE 'Poor'
    END AS rating_category,
    STRING_AGG(a.actor_name, ', ') AS actors  -- Aggregating actor names for each film
FROM {{ ref('films') }} f
LEFT JOIN {{ ref('film_actors') }} fa ON f.film_id = fa.film_id
LEFT JOIN {{ ref('actors') }} a ON fa.actor_id = a.actor_id
GROUP BY 1,2,3,4,5,6,7