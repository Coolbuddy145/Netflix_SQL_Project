# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/Coolbuddy145/Netflix_SQL_Project/blob/dc9adc7850d6c86f5c6004a4e8465fb617cc52fb/Logo.jpg)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.



## Schema

```sql
DROP TABLE IF EXISTS netflix;
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
					
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT type,count(*)
FROM netflix
GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
WHERE row_number=1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT *
FROM netflix
WHERE release_year=2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
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
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT 
	title,
	duration
FROM netflix
WHERE type='Movie' AND duration IS NOT NULL
ORDER BY SPLIT_PART(duration,' ',1)::INT DESC
LIMIT 1;
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added,'Month DD, YYYY')>=CURRENT_DATE- INTERVAL '5 Years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT
	title,
	UNNEST(STRING_TO_ARRAY(director,',')) AS directors
FROM netflix	
WHERE director='Rajiv Chilaka';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT 
	title,
	type,
	duration
FROM netflix
WHERE SPLIT_PART(duration,' ',1)::INT>5 AND type='TV Show';
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	COUNT(*)
FROM netflix
GROUP BY genre;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
LIMIT 5;;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT 
	*,
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre
FROM netflix
WHERE type='Movie' AND listed_in='Documentaries';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT *
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT *
FROM netflix
WHERE casts LIKE '%Salman Khan%' AND TO_DATE(date_added,'MONTH,DD YYYY')>CURRENT_DATE-INTERVAL '10 Years'
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
	COUNT(*) as appereance
FROM netflix
WHERE country LIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



