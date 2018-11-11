SELECT table_name, CASE WHEN table_schema <> 'information_schema' THEN pg_relation_size(table_name) ELSE 0 END AS _size FROM information_schema.tables ORDER BY 2 DESC LIMIT 5;

DROP TABLE IF EXISTS public.user_movies_agg;

SELECT userID, array_agg(movieId) as user_views INTO public.user_movies_agg FROM ratings GROUP BY userID;

CREATE OR REPLACE FUNCTION cross_arr(bigint[], bigint[]) RETURNS bigint[] language sql as 'SELECT CASE WHEN $1 IS NULL THEN $2 WHEN $2 IS NULL THEN $1 ELSE array_agg(ans) END FROM (SELECT ans FROM unnest($1) a(ans) INTERSECT SELECT ans FROM unnest($2) a(ans)) sub';

CREATE OR REPLACE FUNCTION diff_arr(bigint[], bigint[]) RETURNS bigint[] language sql as 'SELECT CASE WHEN $1 IS NULL THEN $2 WHEN $2 IS NULL THEN $1 ELSE array_agg(ans) END FROM (SELECT ans FROM unnest($1) a(ans) EXCEPT SELECT ans FROM unnest($2) a(ans)) sub';

DROP TABLE IF EXISTS common_user_views;

WITH cr_t AS (SELECT T1.userid as u1, T1.user_views as r1, T2.userid as u2, T2.user_views as r2 FROM public.user_movies_agg AS T1 CROSS JOIN public.user_movies_agg AS T2 WHERE T1.userid <> T2.userid AND T2.userid < 100 AND T1.userid < 100)
SELECT u1, u2, cross_arr(r1, r2) AS cr INTO common_user_views FROM cr_t;

SELECT u1, u2, array_length(cr, 1) AS len FROM common_user_views WHERE array_length(cr,1) IS NOT NULL AND u1 < u2 ORDER BY 3 DESC limit 10;

SELECT u1, diff_arr(user_views, cr) FROM common_user_views INNER JOIN user_movies_agg ON userID = u2;
