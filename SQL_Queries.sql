-- Creating Table

CREATE TABLE netflix(
					show_id	VARCHAR(10),
					type VARCHAR(20),	
					title VARCHAR(150),	
					director VARCHAR(208),	
					casts VARCHAR(1000),	
					country	VARCHAR(150),
					date_added VARCHAR(50),	
					release_year INT,	
					rating VARCHAR(15),	
					duration VARCHAR(20),
					listed_in VARCHAR(100),	
					description VARCHAR(250)
					
)

SELECT * FROM netflix


-- Business Problems and Solutions

-- Task 1:Count the Number of Movies vs TV Shows

SELECT type,count(*)
FROM netflix
GROUP BY type


-- Task 2:Find the Most Common Rating for Movies and TV Shows

WITH final_rank AS(
SELECT 
	type,
	rating,
	count(*) as count_number,
	ROW_NUMBER() OVER(PARTITION BY type ORDER BY count(*) DESC)
FROM netflix
GROUP BY type,rating
ORDER BY type,count_number desc
)
SELECT type,rating
FROM final_rank
WHERE row_number=1


-- Task 3:List All Movies Released in a Specific Year (e.g., 2020)

SELECT *
FROM netflix
WHERE release_year=2020



-- TAsk 4:Find the Top 5 Countries with the Most Content on Netflix

WITH new_country AS(
SELECT 
	UNNEST(STRING_TO_ARRAY(country,',')) as countries,
	count(*) AS total
FROM netflix
GROUP BY countries
)
SELECT *
FROM new_country
WHERE countries IS NOT NULL
ORDER BY total DESC 
LIMIT 5



-- Task 5:Identify the Longest Movie

SELECT 
	title,
	duration
FROM netflix
WHERE type='Movie' AND duration IS NOT NULL
ORDER BY SPLIT_PART(duration,' ',1)::INT DESC
LIMIT 1


-- Task 6:Find Content Added in the Last 5 Years

SELECT *
FROM netflix
WHERE TO_DATE(date_added,'Month DD, YYYY')>=CURRENT_DATE- INTERVAL '5 Years'


 -- Task 7:Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT
	title,
	UNNEST(STRING_TO_ARRAY(director,',')) AS directors
FROM netflix	
WHERE director='Rajiv Chilaka'


-- Task 8:List All TV Shows with More Than 5 Seasons

SELECT 
	title,
	type,
	duration
FROM netflix
WHERE SPLIT_PART(duration,' ',1)::INT>5 AND type='TV Show'


-- Task 9:Count the Number of Content Items in Each Genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	COUNT(*)
FROM netflix
GROUP BY genre



-- Task 10:Find each year and the average numbers of content release in India on netflix.


SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;





-- Task 11:List All Movies that are Documentaries


SELECT 
	*,
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre
FROM netflix
WHERE type='Movie' AND listed_in='Documentaries'


-- Task 12:Find All Content Without a Director

SELECT *
FROM netflix
WHERE director IS NULL


-- Task 13:Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT *
FROM netflix
WHERE casts LIKE '%Salman Khan%' AND TO_DATE(date_added,'MONTH,DD YYYY')>CURRENT_DATE-INTERVAL '10 Years'



-- Task 14:Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT 
	UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
	COUNT(*) as appereance
FROM netflix
WHERE country LIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10



-- Task 15:Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords


SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;
























