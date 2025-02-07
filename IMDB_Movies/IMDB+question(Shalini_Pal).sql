/*
NOTE :
I have used CTE's in the below queries,
CTE's should be written in a new sql query window and that is why it is showing a cross mark near WITH ,
however the query is returning the results with no error
*/

USE imdb;


/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:

SHOW TABLES FROM imdb;


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
-- COUNT(*) returns the total number of rows in the specified table
SELECT COUNT(*) AS number_of_rows_in_director_mapping_table from director_mapping;
SELECT COUNT(*) AS number_of_rows_in_genre_table from genre;
SELECT COUNT(*) AS number_of_rows_in_movie_table from movie;
SELECT COUNT(*) AS number_of_rows_in_names_table from names;
SELECT COUNT(*) AS number_of_rows_in_ratings_table from ratings;
SELECT COUNT(*) AS number__of_rows_in_role_mapping_table from role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- Using case statements to get the number of null values in each column from movie table.
SELECT
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_nulls,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_nulls,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_nulls,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_nulls,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_nulls
FROM movie;
-- country, worlwide_gross_income, languages and production_company columns have null values








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
-- Query for getting the total number of movies released each year
SELECT 
	year,
    COUNT(year) AS number_of_movies
FROM 
	movie
GROUP BY 
	year
ORDER BY 
	year;
-- The highest number of movies were released in the year 2017

-- Query for displaying month-wise trend
SELECT 
	MONTH(date_published) AS month_number,
	COUNT(date_published) as  number_of_movies
FROM 
	movie
GROUP BY  
	MONTH(date_published)
ORDER BY 
	MONTH(date_published);
-- Highest number of movies were released in the month of March (i.e 824 movies)










/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT
    COUNT(*) as number_of_movies
FROM 
	movie
WHERE 
	country in ('USA','India')
    AND year=2019;
-- 887 movies were produced in the year 2019 in USA or India


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT
	DISTINCT genre 
FROM 
	genre;







/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT 
    genre,
    COUNT(movie_id) AS movie_count
FROM 
    genre
GROUP BY 
    genre
ORDER BY 
    movie_count DESC
LIMIT 1;
-- Drama genre had the highest number of movies produced overall


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT 
    COUNT(*) AS movies_with_one_genre
FROM (
    SELECT 
        movie_id
    FROM 
        genre
    GROUP BY 
        movie_id
    HAVING 
        COUNT(*) = 1
) AS single_genre_movies;
-- 3289 number of movies belong to only one genre.








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

SELECT g.genre,
		ROUND(AVG(duration),2) as avg_duration
FROM 
	movie m
	INNER JOIN genre as g
    on m.id=g.movie_id
GROUP BY
	g.genre;







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

-- GenreMovieCount is a CTE which returns the list of genre with their number of movies resp.
WITH GenreMovieCount AS (
    SELECT 
        g.genre,
        COUNT(g.movie_id) AS movie_count
    FROM 
        genre g
    GROUP BY 
        g.genre
)
SELECT 
    genre,
    movie_count,
    RANK() OVER (ORDER BY movie_count DESC) AS genre_rank
FROM 
    GenreMovieCount;
-- Drama genre movies stand Top among all genres in terms of number of movies.








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
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
	ratings;
    






    

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
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT
		title,
		avg_rating,
        RANK() OVER (ORDER BY avg_rating desc) AS movie_rank
FROM
	movie
    JOIN ratings
    on movie.id = ratings.movie_id
LIMIT 10;










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
		median_rating,
        COUNT(movie_id) AS movie_count
FROM 
		ratings
GROUP BY 
		median_rating
ORDER BY
		movie_count DESC;










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
		production_company,
        COUNT(*) AS movie_count,
        DENSE_RANK() OVER (ORDER BY COUNT(*) desc) as prod_company_rank
FROM
		movie as m
        INNER JOIN ratings as r
        on r.movie_id = m.id
WHERE
		r.avg_rating > 8
GROUP BY production_company;


-- Dream Warrior Pictures and National Theatre Live production houses stand on top in terms of number of hit movies produced.






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
FROM 
    movie m
JOIN 
    ratings r ON m.id = r.movie_id
JOIN 
    genre g ON m.id = g.movie_id
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
	title,
	avg_rating,
    genre
FROM
	movie
    JOIN genre
    on movie.id = genre.movie_id
    JOIN ratings
    on movie.id = ratings.movie_id
WHERE
	avg_rating > 8
    AND title like 'The%'
ORDER BY
	genre,avg_rating desc;








-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT
	COUNT(*) as movie_count
FROM
	movie
JOIN
	ratings on movie.id = ratings.movie_id
WHERE
	date_published BETWEEN '2018-04-01' AND '2019-04-01'
    AND median_rating > 8
ORDER BY date_published;







-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT 
    SUM(r.total_votes) AS total_votes,
    CASE
        WHEN m.languages LIKE '%German%' THEN 'German'
        WHEN m.languages LIKE '%Italian%' THEN 'Italian'
    END AS language
FROM 
    movie m
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    m.languages LIKE '%German%' 
    OR m.languages LIKE '%Italian%'
GROUP BY 
    language
ORDER BY 
	total_votes DESC;







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
desc names;

SELECT
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM
	names;
-- height,date_of_birth and known_for_movies column have null values.







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
-- CTE Top3Genre returns the list of top 3 genre name based on their movie count with an average greater than 8
WITH Top3Genres AS
(
	SELECT
		g.genre
	FROM
		movie as m
	JOIN
		ratings as r
        ON m.id = r.movie_id
	JOIN
		genre as g
        ON m.id = g.movie_id
	WHERE 
		avg_rating > 8
	GROUP BY
		genre
	ORDER BY 
		COUNT(*) DESC
	LIMIT 3
),
-- CTE Top3Directors returns the director name and movie count of the top3 directors from the top 3 genres
Top3Directors AS
(
	SELECT 
		n.name as director_name,
        COUNT(*) as movie_count
	FROM
		movie as m
	JOIN
		ratings as r
        ON m.id = r.movie_id
	JOIN 
		genre as g
        ON m.id = g.movie_id
	JOIN
		director_mapping as dm
        ON dm.movie_id = m.id
	JOIN
		names as n
        ON n.id = dm.name_id
	WHERE 
        r.avg_rating > 8
        AND g.genre IN (SELECT genre FROM Top3Genres)
	GROUP BY
		director_name
	ORDER BY
		movie_count DESC
	LIMIT 3
)
SELECT
	director_name,
    movie_count
FROM 
	Top3Directors
ORDER BY 
	movie_count DESC;

-- James Mangold, Joe Russo and Anthony Russoare the top three directors in the top three genres whose movies have an average rating > 8





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
-- CTE ActorMovieCounts returns top 2 actors name and their movie count based 
WITH ActorMovieCounts AS (
    SELECT 
        n.name AS actor_name,
        COUNT(*) AS movie_count
    FROM 
        movie m
    JOIN 
        ratings r ON m.id = r.movie_id
    JOIN 
        role_mapping rm ON m.id = rm.movie_id
    JOIN 
        names n ON rm.name_id = n.id
    WHERE 
        r.median_rating >= 8
        AND rm.category = 'Actor'
    GROUP BY 
        n.name
    ORDER BY 
        movie_count DESC
    LIMIT 2
)
SELECT 
    actor_name,
    movie_count
FROM 
    ActorMovieCounts;

-- Mammootty and Mohanlal are the top two actors whose movies have a median rating >= 8



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

-- CTE ProductionCompanyByVotes returns the list of all prodcution house based on the votes received.
WITH ProductionCompanyByVotes AS
(
	SELECT 
		m.production_company,
		SUM(total_votes) AS vote_count
	FROM
		movie as m
	JOIN
		ratings as r ON m.id=r.movie_id
	GROUP BY
		m.production_company
	ORDER BY 
		vote_count DESC
)
-- Giving rank and selecting the top 3 production house.
SELECT *,
		RANK() OVER(ORDER BY vote_count DESC) as prod_company_rank
FROM 
	ProductionCompanyByVotes
LIMIT 3;

-- Marvel Studios, Twentieth Century Fox and Warner Bros. are the top three production houses 
-- based on the number of votes received by their movies






/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, 
-- then the total number of votes should act as the tie breaker.)

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
-- CTE IndianActorRatings returns the details of Inidna Actors who have acted in atleast 5 movies.
WITH IndianActorRatings AS
(
	SELECT 
		n.name AS actor_name,
        SUM(total_votes) AS total_votes,
        COUNT(*) AS movie_count,
        -- using weighted average
        SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS actor_avg_rating
	FROM
		movie AS m
	JOIN
		ratings AS r
        ON r.movie_id = m.id
	JOIN
		role_mapping AS rm
        ON m.id = rm.movie_id
	JOIN
		names AS n
        ON n.id = rm.name_id
	WHERE 
        m.country = 'India'
        AND rm.category = 'Actor'
	GROUP BY
		n.name
	HAVING 
		COUNT(*) >= 5
)
-- Selects the top Inidan actor based on weighted average
SELECT *,
		RANK() OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM 
	IndianActorRatings
LIMIT 1;
-- Vijay Sethupathi is at the top of the list.





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
-- -- CTE IndianActressRatings returns the details of Indian Actressees who have acted in atleast 3 movies.
WITH IndianActressRatings AS
(
	SELECT 
		n.name AS actress_name,
        SUM(total_votes) AS total_votes,
        COUNT(*) AS movie_count,
        ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),2) AS actress_avg_rating
	FROM
		movie AS m
	JOIN
		ratings AS r
        ON r.movie_id = m.id
	JOIN
		role_mapping AS rm
        ON m.id = rm.movie_id
	JOIN
		names AS n
        ON n.id = rm.name_id
	WHERE 
        m.country = 'India'
        AND rm.category = 'Actress'
        AND languages LIKE '%HINDI%'
	GROUP BY
		n.name
	HAVING 
		COUNT(*) >= 3
),
-- Selects the top Indian actress based on weighted average
Top3IndianActress AS
(
	SELECT *,
			RANK() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
	FROM 
		IndianActressRatings    
)
SELECT * 
FROM
	Top3IndianActress
WHERE 
	actress_rank<=5;
-- Taapsee Pannu stands top as actress in Hindi movies released in India based on average ratings
	







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT
	m.title,
    r.avg_rating,
    CASE 
		WHEN r.avg_rating>8 THEN 'Superhit movies'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        WHEN r.avg_rating<5 THEN 'Flop movies'
	END
    AS movie_category
FROM 
	movie as m
JOIN     
	genre as g
    ON m.id=g.movie_id
JOIN
	ratings as r
	ON m.id=r.movie_id
WHERE
	g.genre='Thriller'
ORDER BY
	avg_rating DESC;

-- Safe movie stands top within Thriller genre category in terms of average rating.


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

WITH GenreDuration AS (
    SELECT 
        g.genre,
        ROUND(AVG(m.duration),2) AS avg_duration
    FROM 
        movie m
    JOIN 
        genre g ON m.id = g.movie_id
    GROUP BY 
        g.genre
)
SELECT 
    genre,
    avg_duration,
    -- using SUM() to calculate the running total, with 
    ROUND(SUM(avg_duration) OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS running_total_duration,
    -- using AVG() to get the moving average,from 3 consecutive rows
    ROUND(AVG(avg_duration) OVER (ORDER BY genre ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS moving_avg_duration
FROM 
    GenreDuration
ORDER BY 
    running_total_duration DESC,
    moving_avg_duration;










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

-- CTE Top3Genres returns top 3 genres in terms of number of movies
WITH Top3Genres AS
(
	SELECT
		g.genre,
		COUNT(*) AS movie_count
	FROM 
		genre AS g
	JOIN
		movie AS m
        ON m.id=g.movie_id
	GROUP BY 
		g.genre
	ORDER BY 
		movie_count DESC
	LIMIT 3
),
-- CTE TopGrossingMovies returns movies details from the top 3 genres
TopGrossingMovies AS
(
	SELECT
		g.genre,
        m.year,
        m.title as movie_name,
        m.worlwide_gross_income,
        ROW_NUMBER()
        OVER(
			PARTITION BY g.genre,m.year
			ORDER BY CAST(REPLACE(m.worlwide_gross_income, '$', '') AS UNSIGNED) DESC
            )
		AS movie_rank
	FROM 
        movie m
    JOIN 
        genre g ON m.id = g.movie_id
	WHERE
		g.genre in (SELECT genre FROM Top3Genres)
)
-- Selects top 5 movies for each genre and year
SELECT 
	genre,
    year,
	movie_name,
    worlwide_gross_income,
    movie_rank
FROM
	TopGrossingMovies
WHERE
	movie_rank<=5;




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
-- CTE TopProductionHouseWithMultilingualsHits return production houses with median rating greater than 8 and have multilingual movies
WITH TopProductionHouseWithMultilingualsHits AS
(
	SELECT
		production_company,
        COUNT(*) as movie_count
	FROM
		movie as m
	JOIN
		ratings as r
        ON m.id=r.movie_id
	WHERE
		median_rating>=8
        AND languages LIKE '%,%'
	GROUP BY 
		production_company
	ORDER BY 
		movie_count DESC
),
-- Ranking the production houses using RANK()
RankProductionHouse AS
(
	SELECT
		production_company,
        movie_count,
        RANK() OVER(ORDER BY movie_count DESC) as prod_company_rank
	FROM
		TopProductionHouseWithMultilingualsHits
)
-- Selecting top 2 prodcution houses
SELECT * 
FROM
	RankProductionHouse
WHERE
	prod_company_rank<=2;
-- Star Cinema production house haa produced the highest number of hits among multilingual movies.


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- CTE TopActressInDrama returns the details of actresses who have an rating > 8 in the Drama genre.
WITH TopActressInDrama AS
(
	SELECT
		n.name AS actress_name,
        SUM(total_votes) AS total_votes,
        COUNT(*) as movie_count,
        AVG(r.avg_rating) as actress_avg_rating
	FROM
		movie as m
	JOIN
		ratings as r
        ON m.id = r.movie_id
         JOIN
		role_mapping as rm
        ON m.id = rm.movie_id
    JOIN
		names as n
        ON n.id = rm.name_id
    JOIN
		genre as g
        ON g.movie_id = m.id
	WHERE 
		r.avg_rating > 8
        AND g.genre = 'Drama'
        AND rm.category = 'actress'
	GROUP BY
		n.name
	ORDER BY 
		movie_count DESC
),
-- CTE RankTopActressInDrama ranks the actresses using RANK().
RankTopActressInDrama AS
(
	SELECT *,
			RANK() OVER(ORDER BY movie_count DESC, actress_avg_rating DESC) AS actress_rank
	FROM
		TopActressInDrama
)
-- Selects the top 3 actresses.
SELECT * FROM RankTopActressInDrama
ORDER BY actress_rank
LIMIT 3;
-- Susan Brown, Amanda Lawrence and Denise Goughare are the top 3 actresses,
-- based on number of Super Hit movies (average rating >8) in drama genre





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

-- CTE DirectorMoviesWithLead gets the directors details, uses LEAD () to get the next movie date
WITH DirectorMoviesWithLead AS
(
    SELECT
        dm.name_id AS director_id,
        n.name AS director_name,
        m.id AS movie_id,
        m.date_published,
        m.duration,
        r.avg_rating,
        r.total_votes,
        LEAD(date_published) OVER (PARTITION BY dm.name_id ORDER BY date_published) AS next_movie_date
	FROM
        director_mapping dm
    JOIN
        movie m ON dm.movie_id = m.id
    JOIN
        names n ON dm.name_id = n.id
    JOIN
        ratings r ON m.id = r.movie_id
),
-- CTE DirectorStats gets the director stats
DirectorStats AS (
    SELECT
        director_id,
        director_name,
        COUNT(movie_id) AS number_of_movies,
        AVG(DATEDIFF(next_movie_date, date_published)) AS avg_inter_movie_days,
        AVG(avg_rating) AS avg_rating,
        SUM(total_votes) AS total_votes,
        MIN(avg_rating) AS min_rating,
        MAX(avg_rating) AS max_rating,
        SUM(duration) AS total_duration
    FROM
        DirectorMoviesWithLead
    GROUP BY
        director_id, director_name
)
-- Selects the top 9 directors
SELECT
    director_id,
    director_name,
    number_of_movies,
    ROUND(avg_inter_movie_days) AS avg_inter_movie_days,
    ROUND(avg_rating, 2) AS avg_rating,
    total_votes,
    ROUND(min_rating, 1) AS min_rating,
    ROUND(max_rating, 1) AS max_rating,
    total_duration
FROM
    DirectorStats
ORDER BY
    number_of_movies DESC
LIMIT 9;