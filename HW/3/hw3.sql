SELECT 
  userid,
  movieid,
  CASE
    WHEN (max(rating) OVER (PARTITION BY userid) - min(rating) OVER (PARTITION BY userid)) > 0
      THEN ((rating - min(rating) OVER (PARTITION BY userid))/(max(rating) OVER (PARTITION BY userid) - min(rating) OVER (PARTITION BY userid)))
      ELSE 1 
  END AS normed_rating,
  avg(rating) OVER (PARTITION BY userid)
FROM ratings
LIMIT 30;


DROP TABLE IF EXISTS keywords;
CREATE TABLE keywords(
  movieId bigint,
  tags text
);

\copy keywords FROM '/data/keywords.csv' DELIMITER ',' CSV HEADER;

SELECT count(*) FROM keywords;

DROP TABLE IF EXISTS top_rated_tags;
WITH top_rated AS (SELECT movieid, avg(rating) AS avg_rating FROM ratings GROUP BY movieid HAVING count(*) > 50 ORDER BY 2 DESC, 1 LIMIT 150)
SELECT top_rated.movieid, tags INTO top_rated_tags FROM top_rated INNER JOIN keywords ON top_rated.movieid = keywords.movieId;

\copy (SELECT * FROM top_rated_tags) TO '/data/tags.csv' DELIMITER E'\t';

DROP TABLE IF EXISTS top_rated_tags2;
WITH top_rated AS (SELECT movieid, avg(rating) AS avg_rating FROM ratings GROUP BY movieid HAVING count(*) > 50 ORDER BY 2 DESC, 1 LIMIT 150)
SELECT top_rated.movieid, tags INTO top_rated_tags2 FROM top_rated LEFT JOIN keywords ON top_rated.movieid = keywords.movieId;

\copy (SELECT * FROM top_rated_tags2) TO '/data/tags2.csv' DELIMITER E'\t';
