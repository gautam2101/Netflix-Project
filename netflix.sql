﻿-- Show all data from table 

select * from netflix_titles
go

-- Count the number of Movies vs TV Shows

select distinct type from netflix_titles
go

select type , count(*) as Total_customer from netflix_titles
group by type
go

-- Find the most common rating for movies and TV shows

select * from netflix_titles
go
             
with comman_rating as (
select type, rating, DENSE_RANK() over(partition by type order by rating desc) rnk
from netflix_titles where rating is not null )
select distinct  * from comman_rating where rnk = 1
go


-- List all movies released between 2017 to 2021 in a specific year

select distinct release_year from netflix_titles order by release_year desc
go


select * from netflix_titles where release_year between 2017 and 2021 and type = 'Movie'
go


-- count the number of movies and TV shows released each year from 2011 onward?

select type, release_year, count(*) Realeased from netflix_titles
where release_year between 2011 and 2021
group by type, release_year
order by release_year

-- Find the top 5 countries with the most content on Netflix
select * from netflix_titles
go

with count_top_10 as (
select (LTRIM(rtrim(value))) AS COUNTRY FROM	netflix_titles
cross apply string_split(country,',')
),
ranks as (
select COUNTRY, count(*) No_of_time from count_top_10
group by COUNTRY) ,
final_output as (
select *, DENSE_RANK() over(order by No_of_time desc) rnk from ranks )

select * from final_output where rnk < = 10
go

-- Identify the longest movie 

select * from netflix_titles
go

with most_longest as (
select *, DENSE_RANK() over(order by duration desc) as rnk from (
select type, title, cast(replace(duration,'min','') AS  int)  duration from netflix_titles 
where type = 'Movie' and 
duration is not null 
) a ) select * from most_longest where rnk =  1
go

-- Find all the movies/TV shows by director 'Adam Salky'
select * from netflix_titles
go

select * from netflix_titles where director = 'Adam Salky'

-- Identifying the Directors with the Most Movie Productions on Netflix

select director, count(*) No_of_movie_directed from netflix_titles
where type <> 'TV Show' and director is not null
group by director
order by No_of_movie_directed desc
go


-- Identifying the Directors with the Most TV show Productions on Netflix

select director, count(*) No_of_tv_show_directed from netflix_titles
where type <> 'Movie' and director is not null
group by director
order by No_of_tv_show_directed desc
go

-- List all the movies by director 'Rajiv Chilaka'


select * from netflix_titles
go

select * from netflix_titles where director = 'Rajiv Chilaka'
go

-- List all TV shows with more than 5 seasons

select * from (
select type, title, (case 
when duration like '%Seasons' then cast(REPLACE(duration,' Seasons','') AS int)
when duration like '%Season' then cast ( REPLACE(duration,' Season','') as int )
end) as duration
from netflix_titles where type = 'Tv Show'
) a where duration > 5
order by duration desc

go
-- Count the number of content items in each genre

select Gener,count(1) No_of_content from (
select LTRIM(Rtrim(value)) as Gener from netflix_titles
cross apply string_split(listed_in,',')) a
group by Gener
go

-- Find each year and the total numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!

with country as (
select type, release_year, Country_list as Country from(
select *, ltrim(rtrim(value)) as Country_list from netflix_titles 
cross apply string_split(country,',') 
)a where Country_list = 'india'
) ,
count_movies as (
select release_year, count(*) No_of_count from country 
group by release_year
), 
ranks as (
select *, DENSE_RANK() over(order by No_of_count desc) rnk  from count_movies
) select * from ranks where rnk <= 5
go

-- List all movies that are documentaries
select * from netflix_titles
go

select type, title,Genere from (
select *, LTRIM(rtrim(value)) Genere from netflix_titles
cross apply string_split(listed_in,',')
)a where Genere = 'Documentaries'
go

-- F all content without a director

select * from netflix_titles where director is null
go






















                                                                                                                                                                                                                             