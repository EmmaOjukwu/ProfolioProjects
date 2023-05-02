


Select Real_name, art_name
From artists ;

--changing the blank spaces in the art name to the real name of the artist 

UPDATE artists
SET art_name = Real_name
WHERE art_name IS NULL;




Select *
From artists

--changing id to the primary key 

ALTER TABLE artists
ADD PRIMARY KEY (id);



--location

Select id, art_name, country, city, zip_code
from artists

--Year of Birth

Select id, art_name, year_of_birth
from artists

--Role

Select id, art_name, role
From artists


--Age / minus the year of birth from today's year (2023)


SELECT art_name, year_of_birth, YEAR(GETDATE()) - year_of_birth AS age
FROM artists



Select *
From albums

-- Album Sales 

SELECT aa.id, aa.art_name, ab.album_title, ab.artist_id, ab.num_of_sales, ab.year_of_pub
FROM artists aa
FULL JOIN albums ab
ON aa.id = artist_id
WHERE aa.id IS NOT NULL AND ab.id IS NOT NULL
AND aa.real_name IS NOT NULL AND aa.art_name IS NOT NULL;



--Genre

SELECT aa.id, aa.art_name, ab.album_title, ab.genre, ab.artist_id, ab.num_of_sales, ab.year_of_pub
FROM artists aa
FULL JOIN albums ab
ON aa.id = ab.artist_id
WHERE aa.id IS NOT NULL AND ab.id IS NOT NULL
AND aa.real_name IS NOT NULL AND aa.art_name IS NOT NULL;



--Age of publish

SELECT aa.id, aa.art_name, ab.album_title, ab.year_of_pub, ab.year_of_pub - aa.year_of_birth AS age_at_publish
FROM artists aa
Full JOIN albums ab
ON aa.id = ab.artist_id
WHERE aa.id IS NOT NULL AND ab.id IS NOT NULL
AND aa.real_name IS NOT NULL AND aa.art_name IS NOT NULL;



--Age of Publish again but it uses left join

SELECT aa.id, aa.real_name, aa.art_name, ab.album_title, ab.year_of_pub, ab.year_of_pub - aa.year_of_birth AS age_at_publish
FROM artists aa
LEFT JOIN albums ab
ON aa.id = ab.artist_id
WHERE aa.id IS NOT NULL AND ab.id IS NOT NULL
AND aa.real_name IS NOT NULL AND aa.art_name IS NOT NULL;

--Critic 

SELECT aa.id, aa.art_name, ab.album_title, num_of_sales,genre, rolling_stone_critic,mtv_critic, music_maniac_critic, year_of_pub
FROM artists aa
Full JOIN albums ab
ON aa.id = ab.artist_id
WHERE aa.id IS NOT NULL AND ab.id IS NOT NULL
AND aa.real_name IS NOT NULL AND aa.art_name IS NOT NULL;




--Full Join a few columns from artists table and albums tables         Album Sales with real name 

Select aa.id, aa.real_name, aa.art_name, ab.id, ab.album_title, ab.artist_id, ab.num_of_sales, ab.year_of_pub
From artists aa
	Full Join
albums ab
ON aa.id = ab.id;

--Remove the Nulls from the Full Join 

SELECT aa.id, aa.real_name, aa.art_name, ab.id, ab.album_title, ab.artist_id, ab.num_of_sales, ab.year_of_pub
FROM artists aa
FULL JOIN albums ab
ON aa.id = ab.id
WHERE aa.id IS NOT NULL AND ab.id IS NOT NULL
AND aa.real_name IS NOT NULL AND aa.art_name IS NOT NULL;








Select *
From BestSellingAlbums

--highest ranked albums by genre according to 

SELECT t1.artist, t1.album, t1.genre, t1.year, t1.ranking
FROM BestSellingAlbums t1
INNER JOIN (
  SELECT genre, MAX(ranking) AS max_rank
  FROM BestSellingAlbums
  GROUP BY genre
) t2 ON t1.genre = t2.genre AND t1.ranking = t2.max_rank






--Best Selling Albums by Genre

SELECT t1.artist, t1.album, t1.genre, t1.year, t1.Worldwide_sales_est
FROM BestSellingAlbums t1
INNER JOIN (
  SELECT genre, MAX(Worldwide_sales_est) AS max_sales
  FROM BestSellingAlbums
  GROUP BY genre
) t2 ON t1.genre = t2.genre AND t1.Worldwide_sales_est = t2.max_sales







