-- step1 creation of database 
create database school_analysis;

-- step2 use query of that particular database we have created 
use school_analysis;

-- step3 creation of table 
CREATE TABLE schools
(
    school_name VARCHAR(100) PRIMARY KEY,
    borough VARCHAR(100),
    building_code VARCHAR(10),
    average_math INT,
    average_reading INT,
    average_writing INT,
    percent_tested FLOAT
);


-- deletion of table if needed 
DROP TABLE schools;



/*
1. Inspecting the data
   Every year, American high school students take SATs, which are standardized tests intended to measure literacy, numeracy,
   and writing skills. There are three sections - reading, math, and writing, each with a maximum score of 800 points. 
   These tests are extremely important for students and colleges, as they play a pivotal role in the admissions process.
   Analyzing the performance of schools is important for a variety of stakeholders, including policy and education professionals,
   researchers, government, and even parents considering which school their children should attend.
   In this notebook, we will take a look at data on SATs across public schools in New York City. Our database contains a single table:
*/
-- schools

-- Select all columns from the database
-- Display only the first ten rows

SELECT *
FROM schools
LIMIT 10;


/*
2. Finding missing values
It looks like the first school in our database had no data in the percent_tested column!
Let's identify how many schools have missing data for this column, 
indicating schools that did not report the percentage of students tested.
To understand whether this missing data problem is widespread in New York,
 we will also calculate the total number of schools in the database.
*/

-- Count rows with percent_tested missing and total number of schools

SELECT COUNT(*)-COUNT(percent_tested) num_tested_missing, count(*) num_schools
FROM schools;


/*
3. Schools by building code
There are 20 schools with missing data for percent_tested, which only makes up 5% of all rows in the database.
Now let's turn our attention to how many schools there are. 
When we displayed the first ten rows of the database, several had the same value in the building_code column, 
suggesting there are multiple schools based in the same location. 
Let's find out how many unique school locations exist in our database.
*/

-- Count the number of unique building_code values

SELECT COUNT(DISTINCT building_code) num_school_buildings
FROM schools;


/*
4. Best schools for math
Out of 375 schools, only 233 (62%) have a unique building_code!
Now let's start our analysis of school performance. As each school reports individually,
we will treat them this way rather than grouping them by building_code.
First, let's find all schools with an average math score of at least 80% (out of 800).
*/

-- Select school and average_math
-- Filter for average_math 640 or higher
-- Display from largest to smallest average_math

SELECT school_name, average_math
FROM schools
WHERE average_math >= 800*0.8
ORDER BY average_math DESC;

/*
5. Lowest reading score
   Wow, there are only ten public schools in New York City with an average math score of at least 640!
   Now let's look at the other end of the spectrum and find the single lowest score for reading.
   We will only select the score, not the school, to avoid naming and shaming!
*/

-- Find lowest average_reading

SELECT min(average_reading) lowest_reading
FROM schools;

/*
6. Best writing school
The lowest average score for reading across schools in New York City is less than 40% of the total available points!
Now let's find the school with the highest average writing score.
*/

-- Find the top score for average_writing
-- Group the results by school
-- Sort by max_writing in descending order
-- Reduce output to one school

SELECT school_name, average_writing max_writing
FROM schools
ORDER BY max_writing DESC
LIMIT 1;

/*
7. Top 10 schools
An average writing score of 693 is pretty impressive!
This top writing score was at the same school that got the top math score, Stuyvesant High School. 
Stuyvesant is widely known as a perennial top school in New York.
What other schools are also excellent across the board? Let's look at scores across reading, writing, and math to find out.
*/


-- Calculate average_sat
-- Group by school_name
-- Sort by average_sat in descending order
-- Display the top ten results

SELECT school_name, sum(average_math + average_reading + average_writing) average_sat
FROM schools
GROUP BY school_name
ORDER BY average_sat DESC
LIMIT 10;

/*
8. Ranking boroughs
There are four schools with average SAT scores of over 2000! Now let's analyze performance by New York City borough.
We will build a query that calculates the number of schools and the average SAT score per borough!
*/

-- Select borough and a count of all schools, aliased as num_schools
-- Calculate the sum of average_math, average_reading, and average_writing, divided by a count of all schools, aliased as average_borough_sat
-- Organize results by borough
-- Display by average_borough_sat in descending order


SELECT borough, count(*) num_schools, sum(average_math + average_reading + average_writing)/count(*) average_borough_sat
FROM schools
GROUP BY borough
ORDER BY average_borough_sat DESC;


/*
9. Brooklyn numbers
It appears that schools in Staten Island, on average, produce higher scores across all three categories. 
However, there are only 10 schools in Staten Island, compared to an average of 91 schools in the other four boroughs!
For our final query of the database, let's focus on Brooklyn, which has 109 schools. 
We wish to find the top five schools for math performance.
*/

-- Select school and average_math
-- Filter for schools in Brooklyn
-- Aggregate on school_name
-- Display results from highest average_math and restrict output to five rows

SELECT school_name, average_math
FROM schools
WHERE borough = 'Brooklyn'
ORDER BY average_math DESC
LIMIT 5;