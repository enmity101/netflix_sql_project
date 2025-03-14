-- Netflix Project

DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix
(
show_id VARCHAR(6),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(220),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(500),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(260)
);


SELECT * FROM netflix;


-- Some Business Problems

-- Count the no. of movies vs TV shows

SELECT 
	type,
	COUNT(*) as total_content	
FROM netflix 
GROUP BY type


-- Find the most comman rating for movies and TV shows

SELECT
	type,
	rating
FROM
(
SELECT
	type,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY count(*) DESC) as ranking
FROM netflix
GROUP BY 1, 2
) as t1
WHERE
	ranking=1



-- List all movies released in a secific year (e.g., 2020)

-- filter 2020
-- movies


SELECT * FROM netflix
WHERE
	type = 'Movie'
	AND
	release_year = 2020

-- Find the top 5 countries with the most content on netflix

SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Identify the latest movie?
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	duration = (SELECT MAX (duration) FROM netflix)


-- Find content added in the last 5 years?
	SELECT * FROM netflix
	WHERE 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

-- Find all the movies/TV shows by director 'Rajiv Chilaka'?
SELECT * FROM netflix
where director LIKE '%Rajiv Chilaka%'

-- List all TV shows with more than 5 seasons

	SELECT 
	* 
	FROM netflix
	WHERE 
		type = 'TV Show'
		AND
		SPLIT_PART(duration, ' ', 1)::numeric > 5

	 -- SELECT 
	 -- ('Apple Banana Cherry', ' ', 1)	





-- Count the number of content items in each genre
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1


-- --  Find each year and the average numbers of content release by India on netflix.
-- return top 5 year with highest avg content release !
SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY') )as year,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100
	,2)as avg_content_per_year
	FROM netflix
	WHERE country = 'India'
	GROUP BY 1



-- List all movies that are documentaries

SELECT * FROM netflix
WHERE
	listed_in ILIKE '%documentaries%'


-- Find all content without a director.
SELECT * FROM netflix
WHERE
	 director IS NULL

-- Find how many movies actor 'salman khan' appeared in last 15 years?
SELECT * FROM netflix
WHERE
	casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 15

-- Find the top 10 actors who have appeared in the highest number of movies produced in India?
SELECT
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10 


-- Categorize the content based on the presence of khe keywords 'kilt' and 'violence' in
-- the description field. Label content containing these keywords as 'Bad' and all other
-- content as 'Good'. Count how many items fall into each category.


WITH new_table
AS
(
SELECT
*,
CASE 
WHEN description ILIKE '%Kill%' OR
	description ILIKE '%Violence%' THEN 'Bad_content'
	ELSE 'Good Content'
	END category
FROM netflix
)
SELECT 
	category,
	count(*)as total_content
FROM new_table
GROUP BY 1



























