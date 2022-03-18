#F28DM CW2

#username = yc89

#question 1
SELECT COUNT(actorid) FROM imdb_actors WHERE sex='F';

#question 2
SELECT title FROM imdb_movies WHERE year = (SELECT MIN(year) FROM imdb_movies);

#question 3
SELECT COUNT(movieid) 
FROM (
 SELECT movieid, COUNT(directorid) AS dirnum 
 FROM imdb_movies2directors 
 GROUP BY movieid 
 HAVING dirnum > 5
)movnum;

#question 4 
SELECT title 
FROM imdb_movies 
WHERE movieid = (
 SELECT movieid 
 FROM imdb_movies2directors 
 GROUP BY movieid 
 HAVING COUNT(directorid) = (
  SELECT MAX(dirnum) 
  FROM (
   SELECT movieid, COUNT(directorid) AS dirnum 
   FROM imdb_movies2directors 
   GROUP BY movieid
  )num
 )
);

#question 5
SELECT SUM(Time.time1) AS TotalRunningTime 
FROM (
 SELECT time1 
 FROM imdb_runningtimes RT, imdb_movies2directors M2D 
 WHERE RT.movieid = M2D.movieid 
 AND genre = 'Sci-fi' 
 GROUP BY RT.movieid
)Time;

#question 6
SELECT COUNT(Ewan.movieid) 
FROM (
 SELECT movieid 
 FROM imdb_movies2actors 
 WHERE actorid = (
  SELECT actorid 
  FROM imdb_actors 
  WHERE name LIKE '%McGregor%Ewan%'
 )
)Ewan 
INNER JOIN (
 SELECT movieid 
 FROM imdb_movies2actors 
 WHERE actorid = (
  SELECT actorid 
  FROM imdb_actors 
  WHERE name LIKE '%Carlyle%Robert%'
 )
)Robert 
ON Ewan.movieid = Robert.movieid;

#question 7
SELECT COUNT(*) FROM (SELECT DISTINCT 
CASE WHEN Actor1ID > Actor2ID THEN Actor1ID ELSE Actor2ID END AS Actor1ID,
CASE WHEN Actor1ID > Actor2ID THEN Actor2ID ELSE Actor1ID END AS Actor2ID  
FROM (SELECT a1.AA as Actor1ID, a2.AA as Actor2ID, COUNT(a1.movieid) AS Collaboration 
FROM (
 SELECT actorid AA, movieid FROM imdb_movies2actors M2A)a1 
JOIN (
 SELECT actorid AA, movieid FROM imdb_movies2actors M2A)a2 
ON a1.movieid = a2.movieid 
WHERE a1.AA != a2.AA 
GROUP BY a1.AA, a2.AA HAVING Collaboration >= 10)Collab)A;

#question 8
SELECT COUNT(movieid) AS NumMovies, T.Years 
FROM (
 SELECT movieid, 
 CASE WHEN year BETWEEN 1960 AND 1969 THEN '1960-1969' 
 WHEN year BETWEEN 1970 AND 1979 THEN '1970-1979'
 WHEN year BETWEEN 1980 AND 1989 THEN '1980-1989'
 WHEN year BETWEEN 1990 AND 1999 THEN '1990-1999'
 WHEN year BETWEEN 2000 AND 2009 THEN '2000-2009'
 ELSE 'Others' 
 END AS Years 
 FROM imdb_movies
)T 
GROUP BY T.Years 
HAVING NOT T.Years = 'Others';

#question 9 
SELECT COUNT(*) 
FROM (
 SELECT M2A.movieid, COUNT(M.actorid) AS MaleActor 
 FROM imdb_movies2actors AS M2A 
 LEFT JOIN (
  SELECT actorid FROM imdb_actors WHERE sex = 'M'
 )M 
 ON M2A.actorid = M.actorid 
 GROUP BY M2A.movieid
)Male 
JOIN (
 SELECT M2A.movieid, COUNT(F.actorid) AS FemaleActor 
 FROM imdb_movies2actors AS M2A 
 LEFT JOIN (
  SELECT actorid FROM imdb_actors WHERE sex = 'F'
 )F 
 ON M2A.actorid = F.actorid 
 GROUP BY M2A.movieid
)Female 
ON Male.movieid = Female.movieid WHERE FemaleActor > MaleActor;

#question 10
SELECT genre 
FROM (
 SELECT genre, AVG(rank) AS AverageRank 
 FROM imdb_movies2directors M2D 
 JOIN (
  SELECT movieid, rank 
  FROM imdb_ratings 
  WHERE votes >= 10000
 )R 
 ON M2D.movieid = R.movieid 
 GROUP BY genre
)List 
WHERE AverageRank = (
 SELECT MAX(AverageRank) 
 FROM (
  SELECT genre, AVG(rank) AS AverageRank 
  FROM imdb_movies2directors M2D 
  JOIN (
   SELECT movieid, rank 
   FROM imdb_ratings 
   WHERE votes >= 10000
  )R 
  ON M2D.movieid = R.movieid 
  GROUP BY genre
 )List
);

#question 11
SELECT name 
FROM imdb_actors 
WHERE actorid = (
 SELECT DISTINCT actorid 
 FROM imdb_movies2actors AS M2A, imdb_movies2directors AS M2D 
 WHERE M2A.movieid = M2D.movieid 
 GROUP BY actorid 
 HAVING COUNT(DISTINCT genre) >= 10
);

#question 12
SELECT COUNT(DISTINCT M2ADW.movieid) AS NumOfMovie 
FROM (
 SELECT DISTINCT M2A.movieid, M2A.actorid, M2D.directorid, M2W.writerid 
 FROM imdb_movies2actors M2A, imdb_movies2directors M2D, imdb_movies2writers M2W 
 WHERE M2A.movieid = M2D.movieid 
 AND M2D.movieid = M2W.movieid
)M2ADW 
JOIN ( 
 SELECT DISTINCT A.actorid, D.directorid, W.writerid 
 FROM imdb_actors A, imdb_directors D, imdb_writers W 
 WHERE A.name = D.name 
 AND D.name = W.name
)ADW 
ON ADW.actorid = M2ADW.actorid 
AND ADW.directorid = M2ADW.directorid 
AND ADW.writerid = M2ADW.writerid;

#question 13
SELECT FLOOR(List.Years) 
FROM (
 SELECT avg(T.rank) AS AverageRank, T.Years 
 FROM (
  SELECT rank,
  CASE WHEN year BETWEEN 1890 AND 1899 THEN '1890-1899' 
  WHEN year BETWEEN 1900 AND 1909 THEN '1900-1909' 
  WHEN year BETWEEN 1910 AND 1919 THEN '1910-1919' 
  WHEN year BETWEEN 1920 AND 1929 THEN '1920-1929' 
  WHEN year BETWEEN 1930 AND 1939 THEN '1930-1939' 
  WHEN year BETWEEN 1940 AND 1949 THEN '1940-1949' 
  WHEN year BETWEEN 1950 AND 1959 THEN '1950-1959' 
  WHEN year BETWEEN 1960 AND 1969 THEN '1960-1969' 
  WHEN year BETWEEN 1970 AND 1979 THEN '1970-1979' 
  WHEN year BETWEEN 1980 AND 1989 THEN '1980-1989' 
  WHEN year BETWEEN 1990 AND 1999 THEN '1990-1999' 
  WHEN year BETWEEN 2000 AND 2009 THEN '2000-2009' 
  WHEN year BETWEEN 2010 AND 2019 THEN '2010-2019' 
  ELSE 'Others' END AS Years 
  FROM imdb_movies AS M, imdb_ratings AS R 
  WHERE R.movieid = M.movieid 
 )T 
 GROUP BY T.Years
)List 
WHERE AverageRank = (SELECT MAX(AverageRank) 
FROM (
SELECT avg(T.rank) AS AverageRank, T.Years 
 FROM (
  SELECT rank, 
  CASE WHEN year BETWEEN 1890 AND 1899 THEN '1890-1899' 
  WHEN year BETWEEN 1900 AND 1909 THEN '1900-1909' 
  WHEN year BETWEEN 1910 AND 1919 THEN '1910-1919' 
  WHEN year BETWEEN 1920 AND 1929 THEN '1920-1929' 
  WHEN year BETWEEN 1930 AND 1939 THEN '1930-1939' 
  WHEN year BETWEEN 1940 AND 1949 THEN '1940-1949' 
  WHEN year BETWEEN 1950 AND 1959 THEN '1950-1959' 
  WHEN year BETWEEN 1960 AND 1969 THEN '1960-1969' 
  WHEN year BETWEEN 1970 AND 1979 THEN '1970-1979' 
  WHEN year BETWEEN 1980 AND 1989 THEN '1980-1989' 
  WHEN year BETWEEN 1990 AND 1999 THEN '1990-1999' 
  WHEN year BETWEEN 2000 AND 2009 THEN '2000-2009' 
  WHEN year BETWEEN 2010 AND 2019 THEN '2010-2019' 
  ELSE 'Others' END AS Years 
  FROM imdb_movies AS M, imdb_ratings AS R 
  WHERE R.movieid = M.movieid 
 )T 
 GROUP BY T.Years
)List 
);

#question 14
SELECT COUNT(DISTINCT movieid) AS MissingGenre 
FROM imdb_movies2directors 
WHERE genre IS NULL;

#question 15
SELECT COUNT(DISTINCT M2ADW.movieid) AS NumOfMovie 
FROM (
 SELECT DISTINCT M2A.movieid, M2A.actorid, M2D.directorid, M2W.writerid 
 FROM imdb_movies2actors M2A, imdb_movies2directors M2D, imdb_movies2writers M2W 
 WHERE M2A.movieid = M2D.movieid 
 AND M2D.movieid = M2W.movieid
)M2ADW 
JOIN ( 
 SELECT DISTINCT A.actorid, D.directorid, W.writerid 
 FROM imdb_actors A, imdb_directors D, imdb_writers W 
 WHERE A.name = D.name AND 
 D.name = W.name
)ADW 
ON ADW.actorid != M2ADW.actorid AND 
ADW.directorid = M2ADW.directorid AND 
ADW.writerid = M2ADW.writerid;
