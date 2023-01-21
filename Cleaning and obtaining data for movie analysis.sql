

EXEC sp_rename 'movies$','movies'

SELECT TOP (50) *
FROM movies

-- Seeing datatype of the columns
SELECT DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE 
     TABLE_NAME   = 'movies'


-- Removing unuseful column for my analysis, I want to see how score is dropping along the years for every movie genre
ALTER TABLE movies
DROP COLUMN rating , released, votes, director, writer, star, country, company, runtime

SELECT *
FROM movies

ALTER TABLE movies
ADD
earnings FLOAT, budget_rec_perc FLOAT

-- For merge some calculations 
CREATE TABLE #ForInserting(
	name nvarchar(255),
	earnings FLOAT,
	budget_rec_perc FLOAT)

INSERT INTO #Forinserting
SELECT name, gross-budget, (gross-budget)/budget*100
FROM movies

SELECT * FROM #ForInserting

UPDATE m
set m.earnings = FI.earnings,
	m.budget_rec_perc = FI.budget_rec_perc
FROM movies AS m
INNER JOIN
#ForInserting as FI
ON m.name = FI.name

-- Deeleting unuseful data
DELETE FROM movies
WHERE earnings is NULL

SELECT DISTINCT year, genre, AVG(score)  OVER(PARTITION BY year, genre) 'Average Score by Gender and Year' , AVG(budget_rec_perc) OVER(PARTITION BY year, genre)  AS 'Average Recovery % by Gender and Year'
FROM movies

