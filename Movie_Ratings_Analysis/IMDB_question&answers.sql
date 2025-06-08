USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
  TABLE_NAME,
  TABLE_ROWS       AS total_row_count
FROM
  INFORMATION_SCHEMA.TABLES
WHERE
  TABLE_SCHEMA = 'imdb'
  AND TABLE_TYPE = 'BASE TABLE'
ORDER BY
  TABLE_NAME;









-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT
	SUM(CASE WHEN id            IS NULL THEN 1 ELSE 0 END) AS id_nulls,
	SUM(CASE WHEN title         IS NULL THEN 1 ELSE 0 END) AS title_nulls,
	SUM(CASE WHEN year          IS NULL THEN 1 ELSE 0 END) AS year_nulls,
	SUM(CASE WHEN date_published   IS NULL THEN 1 ELSE 0 END) AS date_published_nulls,
	SUM(CASE WHEN duration      IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
	SUM(CASE WHEN country        IS NULL THEN 1 ELSE 0 END) AS country_nulls,
	SUM(CASE WHEN worlwide_gross_income         IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_nulls,
	SUM(CASE WHEN languages      IS NULL THEN 1 ELSE 0 END) AS languages_nulls,
	SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_nulls
 
FROM
  imdb.movie;

SELECT 'title' AS column_name, COUNT(*) AS null_count
FROM imdb.movie
WHERE title IS NULL

UNION ALL

SELECT 'year', COUNT(*)
FROM imdb.movie
WHERE year IS NULL

UNION ALL

SELECT 'date_published', COUNT(*)
FROM imdb.movie
WHERE date_published IS NULL

UNION ALL

SELECT 'duration', COUNT(*)
FROM imdb.movie
WHERE duration IS NULL

UNION ALL

SELECT 'country', COUNT(*)
FROM imdb.movie
WHERE country IS NULL

UNION ALL

SELECT 'worlwide_gross_income', COUNT(*)
FROM imdb.movie
WHERE worlwide_gross_income IS NULL

UNION ALL

SELECT 'languages', COUNT(*)
FROM imdb.movie
WHERE languages IS NULL

UNION ALL

SELECT 'production_company', COUNT(*)
FROM imdb.movie
WHERE production_company IS NULL;






-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
/*the total number of movies released each year*/
SELECT
  YEAR(date_published) AS Year,
  COUNT(*)              AS number_of_movies
FROM
  imdb.movie
WHERE
  date_published IS NOT NULL
GROUP BY
  YEAR(date_published)
ORDER BY
  Year;

/* month wise trend*/
SELECT
  MONTH(date_published) AS month_num,
  COUNT(*)             AS number_of_movies
FROM
  imdb.movie
WHERE
  date_published IS NOT NULL
GROUP BY
  MONTH(date_published)
ORDER BY
  month_num;







/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(*) AS movie_count
FROM movie
WHERE country IN ('USA', 'India')
  AND year = 2019;
/*GROUP BY country (in case if we want to know movie count of both India & USA )*/










/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM Genre;












/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT
  g.genre,
  COUNT(*) AS movie_count
FROM movie m
JOIN Genre g
  ON m.id = g.movie_id      -- adjust column names if yours differ
GROUP BY
  g.genre
ORDER BY
  movie_count DESC
LIMIT 1;











/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT COUNT(*) AS single_genre_movie_count
FROM (
  SELECT 
    mg.movie_id,
    COUNT(*) AS genre_count
  FROM genre AS mg
  GROUP BY 
    mg.movie_id
  HAVING 
    COUNT(*) = 1
) AS only_one_genre;












/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
  g.genre,
  ROUND(AVG(m.duration), 0) AS avg_duration
FROM genre AS g
JOIN movie AS m
  ON g.movie_id = m.id
GROUP BY
  g.genre
ORDER BY
  avg_duration DESC;










/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
  t.genre,
  t.movie_count,
  t.genre_rank
FROM (
  SELECT
    g.genre,
    COUNT(*) AS movie_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
  FROM genre AS g
  JOIN movie AS m
    ON g.movie_id = m.id
  GROUP BY
    g.genre
) AS t
WHERE
  t.genre = 'thriller';










/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT
  MIN(avg_rating)     AS min_avg_rating,
  MAX(avg_rating)     AS max_avg_rating,
  MIN(total_votes)    AS min_total_votes,
  MAX(total_votes)    AS max_total_votes,
  MIN(median_rating)  AS min_median_rating,
  MAX(median_rating)  AS max_median_rating
FROM ratings;





    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

SELECT
  t.title,
  t.avg_rating,
  t.movie_rank
FROM (
  SELECT
    m.title,
    r.avg_rating,
    RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
  FROM ratings AS r
  JOIN movie AS m
    ON r.movie_id = m.id
) AS t
WHERE
  t.movie_rank <= 10
ORDER BY
  t.movie_rank,
  t.avg_rating DESC;







/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT
  r.median_rating,
  COUNT(*) AS movie_count
FROM ratings AS r
GROUP BY
  r.median_rating
ORDER BY
  r.median_rating;









/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
  
  SELECT
  t.production_company,
  t.movie_count,
  t.prod_company_rank
FROM (
  SELECT
    m.production_company,
    COUNT(*) AS movie_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS prod_company_rank
  FROM movie AS m
  JOIN ratings AS r
    ON m.id = r.movie_id
  WHERE
    r.avg_rating > 8
    AND m.production_company IS NOT NULL
  GROUP BY
    m.production_company
) AS t
WHERE
  t.prod_company_rank = 1;










-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
  g.genre,
  COUNT(*) AS movie_count
FROM genre AS g
JOIN movie AS m
  ON g.movie_id = m.id
JOIN ratings AS r
  ON m.id = r.movie_id
WHERE
  m.country = 'USA'
  AND m.date_published BETWEEN '2017-03-01' AND '2017-03-31'
  AND r.total_votes > 1000
GROUP BY
  g.genre
ORDER BY
  movie_count DESC;



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT
  m.title,
  r.avg_rating,
  g.genre
FROM movie AS m
JOIN ratings AS r
  ON m.id = r.movie_id
JOIN genre AS g
  ON m.id = g.movie_id
WHERE
  m.title LIKE 'The %'
  AND r.avg_rating > 8
ORDER BY
  g.genre,
  r.avg_rating DESC,
  m.title;









-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT
  COUNT(*) AS movies_with_median_8
FROM movie AS m
JOIN ratings AS r
  ON m.id = r.movie_id
WHERE
  m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
  AND r.median_rating = 8;








-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT
  m.country,
  SUM(r.total_votes) AS total_votes
FROM movie AS m
JOIN ratings AS r
  ON m.id = r.movie_id
WHERE
  m.country IN ('Germany', 'Italy')
GROUP BY
  m.country;







-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
  SUM(name IS NULL)           AS name_nulls,
  SUM(height IS NULL)         AS height_nulls,
  SUM(date_of_birth IS NULL)  AS date_of_birth_nulls,
  SUM(known_for_movies IS NULL) AS known_for_movies_nulls
FROM names;







/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Below code gives output along with genre, director_name & movie_count :
/*WITH high_rated AS (
  -- Movies with avg_rating > 8
  SELECT
    m.id AS movie_id,
    m.title
  FROM movie AS m
  JOIN ratings AS r
    ON m.id = r.movie_id
  WHERE r.avg_rating > 8
),
genre_counts AS (
  -- Count high-rated movies per genre
  SELECT
    g.genre,
    COUNT(*) AS movie_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
  FROM genre AS g
  JOIN high_rated AS hr
    ON g.movie_id = hr.movie_id
  GROUP BY
    g.genre
),
top_genres AS (
  -- Select top 3 genres
  SELECT genre
  FROM genre_counts
  WHERE genre_rank <= 3
),
director_counts AS (
  -- Count high-rated movies per director within top genres
  SELECT
    n.name AS director_name,
    g.genre,
    COUNT(*) AS movie_count,
    RANK() OVER (PARTITION BY g.genre ORDER BY COUNT(*) DESC) AS director_rank
  FROM director_mapping AS dm
  JOIN high_rated AS hr
    ON dm.movie_id = hr.movie_id
  JOIN names AS n
    ON dm.name_id = n.id
  JOIN genre AS g
    ON dm.movie_id = g.movie_id
  WHERE g.genre IN (SELECT genre FROM top_genres)
  GROUP BY
    g.genre, n.name
)
-- Final: top 3 directors in each of the top 3 genres
SELECT
  genre,
  director_name,
  movie_count
FROM director_counts
WHERE director_rank <= 3
ORDER BY
  genre,
  director_rank;
*/
-- Below code gives output with director_name & movie_count :
WITH high_rated AS (
  SELECT m.id AS movie_id
  FROM movie AS m
  JOIN ratings AS r ON m.id = r.movie_id
  WHERE r.avg_rating > 8
),
genre_counts AS (
  SELECT
    g.genre,
    COUNT(*) AS cnt,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
  FROM genre AS g
  JOIN high_rated AS hr ON g.movie_id = hr.movie_id
  GROUP BY g.genre
),
top_genres AS (
  SELECT genre
  FROM genre_counts
  WHERE genre_rank <= 3
),
director_counts AS (
  SELECT
    n.name AS director_name,
    COUNT(*) AS movie_count,
    RANK() OVER (PARTITION BY g.genre ORDER BY COUNT(*) DESC) AS dir_rank
  FROM director_mapping AS dm
  JOIN high_rated AS hr        ON dm.movie_id = hr.movie_id
  JOIN names AS n              ON dm.name_id    = n.id
  JOIN genre AS g              ON dm.movie_id   = g.movie_id
  WHERE g.genre IN (SELECT genre FROM top_genres)
  GROUP BY g.genre, n.name
)
SELECT
  director_name,
  movie_count
FROM director_counts
WHERE dir_rank <= 3
ORDER BY movie_count DESC;







/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
  n.name AS actor_name,
  COUNT(DISTINCT rm.movie_id) AS movie_count
FROM role_mapping AS rm
JOIN ratings AS r
  ON rm.movie_id = r.movie_id
JOIN names AS n
  ON rm.name_id = n.id
WHERE
  r.median_rating >= 8
  AND rm.category = 'actor'
GROUP BY
  n.name
ORDER BY
  movie_count DESC
LIMIT 2;







/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
  t.production_company,
  t.vote_count,
  t.prod_comp_rank
FROM (
  SELECT
    m.production_company,
    SUM(r.total_votes) AS vote_count,
    RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
  FROM movie AS m
  JOIN ratings AS r
    ON m.id = r.movie_id
  WHERE m.production_company IS NOT NULL
  GROUP BY
    m.production_company
) AS t
WHERE
  t.prod_comp_rank <= 3
ORDER BY
  t.prod_comp_rank;










/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actor_indian AS (
  -- Join actors with their Indian movies and ratings
  SELECT
    rm.name_id,
    COUNT(DISTINCT m.id) AS movie_count,
    SUM(r.total_votes) AS total_votes,
    SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS actor_avg_rating
  FROM role_mapping AS rm
  JOIN movie AS m
    ON rm.movie_id = m.id
  JOIN ratings AS r
    ON m.id = r.movie_id
  WHERE
    rm.category = 'actor'
    AND m.country = 'India'
  GROUP BY
    rm.name_id
  HAVING
    COUNT(DISTINCT m.id) >= 5
),
ranked_actors AS (
  SELECT
    n.name AS actor_name,
    ai.total_votes,
    ai.movie_count,
    ROUND(ai.actor_avg_rating, 2) AS actor_avg_rating,
    RANK() OVER (
      ORDER BY ai.actor_avg_rating DESC, ai.total_votes DESC
    ) AS actor_rank
  FROM actor_indian AS ai
  JOIN names AS n
    ON ai.name_id = n.id
)
SELECT
  actor_name,
  total_votes,
  movie_count,
  actor_avg_rating,
  actor_rank
FROM ranked_actors
WHERE actor_rank = 1;









-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_hindi AS (
  -- Aggregate votes and ratings for actresses in Hindi movies released in India
  SELECT
    rm.name_id,
    COUNT(DISTINCT m.id)          AS movie_count,
    SUM(r.total_votes)            AS total_votes,
    SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS actress_avg_rating
  FROM role_mapping AS rm
  JOIN movie AS m
    ON rm.movie_id = m.id
  JOIN ratings AS r
    ON m.id = r.movie_id
  WHERE
    rm.category = 'actress'           -- assuming both actors and actresses use category 'actor'
    AND m.country = 'India'
    AND m.languages LIKE '%Hindi%'  -- filter for Hindi-language films
  GROUP BY
    rm.name_id
  HAVING
    COUNT(DISTINCT m.id) >= 3
),
ranked_actresses AS (
  SELECT
    n.name               AS actress_name,
    ah.total_votes,
    ah.movie_count,
    ROUND(ah.actress_avg_rating, 2) AS actress_avg_rating,
    RANK() OVER (
      ORDER BY
        ah.actress_avg_rating DESC,
        ah.total_votes DESC
    ) AS actress_rank
  FROM actress_hindi AS ah
  JOIN names AS n
    ON ah.name_id = n.id
)
SELECT
  actress_name,
  total_votes,
  movie_count,
  actress_avg_rating,
  actress_rank
FROM ranked_actresses
WHERE actress_rank <= 5
ORDER BY actress_rank;








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:

SELECT
  m.title AS movie_name,
  CASE
    WHEN r.avg_rating > 8 THEN 'Superhit'
    WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
    WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
    ELSE 'Flop'
  END AS movie_category
FROM movie AS m
JOIN genre AS g
  ON m.id = g.movie_id
JOIN ratings AS r
  ON m.id = r.movie_id
WHERE
  g.genre = 'thriller'
  AND r.total_votes >= 25000
ORDER BY
  r.avg_rating DESC;








/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH genre_durations AS (
  -- Step 1: Compute average duration per genre
  SELECT
    g.genre,
    ROUND(AVG(m.duration), 2) AS avg_duration
  FROM genre AS g
  JOIN movie AS m
    ON g.movie_id = m.id
  GROUP BY
    g.genre
),
running_and_moving AS (
  SELECT
    genre,
    avg_duration,
    -- Running total of avg_duration over genres ordered alphabetically
    SUM(avg_duration) OVER (
      ORDER BY genre
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_duration,
    -- Moving (rolling) average of avg_duration over the current row and the two preceding rows
    ROUND(
      AVG(avg_duration) OVER (
        ORDER BY genre
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
      ),
      2
    ) AS moving_avg_duration
  FROM genre_durations
)
SELECT
  genre,
  avg_duration,
  ROUND(running_total_duration, 2)    AS running_total_duration,
  moving_avg_duration
FROM running_and_moving
ORDER BY genre;









-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH genre_counts AS (
  -- Count total movies per genre
  SELECT
    g.genre,
    COUNT(*) AS movie_count
  FROM genre AS g
  JOIN movie AS m
    ON g.movie_id = m.id
  GROUP BY
    g.genre
),
top_genres AS (
  -- Select the top 3 genres by count
  SELECT
    genre
  FROM genre_counts
  ORDER BY
    movie_count DESC
  LIMIT 3
),
ranked_movies AS (
  -- For movies in those top genres, compute rank per year by worldwide gross
  SELECT
    g.genre,
    m.year,
    m.title       AS movie_name,
    m.worlwide_gross_income,
    RANK() OVER (
      PARTITION BY g.genre, m.year
      ORDER BY m.worlwide_gross_income DESC
    ) AS movie_rank
  FROM movie AS m
  JOIN genre AS g
    ON m.id = g.movie_id
  WHERE
    g.genre IN (SELECT genre FROM top_genres)
)
-- Final: pull only the top 5 per genre per year
SELECT
  genre,
  year,
  movie_name,
  worlwide_gross_income,
  movie_rank
FROM
  ranked_movies
WHERE
  movie_rank <= 5
ORDER BY
  genre,
  year,
  movie_rank;









-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH multilingual_hits AS (
  -- Filter for multilingual movies with median rating >= 8
  SELECT
    m.production_company,
    m.id AS movie_id
  FROM movie AS m
  JOIN ratings AS r
    ON m.id = r.movie_id
  WHERE
    r.median_rating >= 8
    AND m.languages LIKE '%,%'        -- at least two languages means comma-separated
    AND m.production_company IS NOT NULL
),
company_counts AS (
  -- Count hits per production company
  SELECT
    production_company,
    COUNT(*) AS movie_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS prod_comp_rank
  FROM multilingual_hits
  GROUP BY production_company
)
SELECT
  production_company,
  movie_count,
  prod_comp_rank
FROM company_counts
WHERE prod_comp_rank <= 2
ORDER BY prod_comp_rank;









-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH superhit_drama AS (
  -- Select superhit drama movies
  SELECT
    m.id AS movie_id,
    r.avg_rating,
    r.total_votes
  FROM movie AS m
  JOIN genre AS g
    ON m.id = g.movie_id
  JOIN ratings AS r
    ON m.id = r.movie_id
  WHERE
    g.genre = 'drama'
    AND r.avg_rating > 8
),
actress_stats AS (
  -- Aggregate votes and compute weighted average for each actress
  SELECT
    rm.name_id,
    COUNT(DISTINCT sd.movie_id)                     AS movie_count,
    SUM(sd.total_votes)                             AS total_votes,
    SUM(sd.avg_rating * sd.total_votes) / SUM(sd.total_votes) AS actress_avg_rating
  FROM role_mapping AS rm
  JOIN superhit_drama AS sd
    ON rm.movie_id = sd.movie_id
  WHERE
    rm.category = 'actress'
  GROUP BY
    rm.name_id
),
ranked_actresses AS (
  -- Rank actresses by weighted average, then votes, then name
  SELECT
    n.name                           AS actress_name,
    asf.total_votes,
    asf.movie_count,
    ROUND(asf.actress_avg_rating, 4) AS actress_avg_rating,
    RANK() OVER (
      ORDER BY
        asf.actress_avg_rating DESC,
        asf.total_votes DESC,
        n.name ASC
    ) AS actress_rank
  FROM actress_stats AS asf
  JOIN names AS n
    ON asf.name_id = n.id
)
SELECT
  actress_name,
  total_votes,
  movie_count,
  actress_avg_rating,
  actress_rank
FROM ranked_actresses
WHERE actress_rank <= 3
ORDER BY actress_rank;







/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH director_movies AS (
  -- Gather each director's movies with needed fields
  SELECT
    dm.name_id                                            AS director_id,
    n.name                                                AS director_name,
    m.id                                                  AS movie_id,
    m.date_published,
    m.duration                                           AS movie_duration,
    r.avg_rating,
    r.total_votes,
    LAG(m.date_published) OVER (
      PARTITION BY dm.name_id
      ORDER BY m.date_published
    )                                                    AS prev_date
  FROM director_mapping AS dm
  JOIN movie           AS m ON dm.movie_id = m.id
  JOIN ratings         AS r ON m.id = r.movie_id
  JOIN names           AS n ON dm.name_id = n.id
),
director_intervals AS (
  -- Compute inter-movie gaps in days
  SELECT
    director_id,
    director_name,
    movie_id,
    date_published,
    movie_duration,
    avg_rating,
    total_votes,
    DATEDIFF(date_published, prev_date)                  AS days_since_prev
  FROM director_movies
),
director_agg AS (
  -- Aggregate per director
  SELECT
    director_id,
    director_name,
    COUNT(*)                                             AS number_of_movies,
    ROUND(AVG(days_since_prev), 0)                       AS avg_inter_movie_days,
    ROUND(AVG(avg_rating), 2)                            AS avg_rating,
    SUM(total_votes)                                     AS total_votes,
    MIN(avg_rating)                                      AS min_rating,
    MAX(avg_rating)                                      AS max_rating,
    SUM(movie_duration)                                  AS total_duration
  FROM director_intervals
  GROUP BY
    director_id,
    director_name
),
ranked_directors AS (
  -- Rank by movie count and pick top 9
  SELECT
    *,
    RANK() OVER (ORDER BY number_of_movies DESC)          AS director_rank
  FROM director_agg
)
SELECT
  director_id,
  director_name,
  number_of_movies,
  avg_inter_movie_days,
  avg_rating,
  total_votes,
  min_rating,
  max_rating,
  total_duration
FROM ranked_directors
WHERE
  director_rank <= 9
ORDER BY
  director_rank;






