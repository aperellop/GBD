use imdb_small;
#ejercicio 1
select id, first_name, last_name, gender
from actors
where last_name = 'Willis';

#ejercicio 2
select id, name
from movies
where name like '%Kill%' or name like '%Pirates%' or name like '%War%' or name like '%Man%'
order by name;

#ejercicio 3
select name
from movies
where movies.id in
(select movie_id
from movies_directors
where movies_directors.director_id =
(select directors.id
from directors
where first_name = 'Ethan' and last_name = 'Coen'))
order by name;

#Ejercicio 4
select name, year
from movies
where movies.year > '1996' and movies.id in
(select movie_id
from movies_directors
where movies_directors.director_id =
(select directors.id
from directors
where first_name = 'Ethan' and last_name = 'Coen'))
order by year;

#Ejercicio 5
select movies.id, movies.name, movies.year
from movies
where movies.id not in
(
select movies_directors.movie_id
from movies_directors)
order by name;

#Ejercicio 6
#la tabla "roles" tiene actores y movies
#dos subselects hermanas de roles y movies_directors

#este subselect es solo para director name
(select CONCAT(directors.first_name, ' ', directors.last_name) as director_name
from directors
where directors.id =
(select movies_directors.director_id
from movies_directors
where movies_directors.movie_id =
(select movies.id
from movies
where movies.name = 'Lost in Translation')));

select role,
(select CONCAT(directors.first_name, ' ', directors.last_name) as director_name
    from directors
    where directors.id = (
        select movies_directors.director_id
        from movies_directors
        where movies_directors.movie_id = (
            select movies.id
            from movies
            where movies.name = 'Lost in Translation'))) as director_name, #solo para el directors name
(select movies.name
    from movies
    where movies.name = 'Lost in Translation') as movie_title, #titulo de la peli
(select movies.year
    from movies
    where movies.name like 'Lost in Translation') as year, #esto es el año de la peli
 (select CONCAT(actors.first_name, ' ', actors.last_name) as actor_name
    from actors
    where actors.id = roles.actor_id) as actors_name#nombre de los actores
from roles
where movie_id =(
    select movies.id
    from movies
    where movies.name = 'Lost in Translation'
    )
order by actors_name asc;

#Ejer 7
select M.name, M.year, CONCAT(D.first_name, ' ', D.last_name)
from directors as D, movies as M, actors as A,
     movies_directors as MD, roles as R
where D.id = MD.director_id and
      A.id = R.actor_id and
      M.id = MD.movie_id and
      M.id = R.movie_id and
      D.first_name = A.first_name and
      D.last_name = A.last_name
order by CONCAT(D.first_name, ' ', D.last_name);

#Ejer 8
select CONCAT(A1.first_name, ' ', A1.last_name) as actor_name, M.name, M.year
from actors as A1, movies as M, roles as R
where A1.id = R.actor_id and
      M.id = R.movie_id and
      R.actor_id not in (
          select actors.id
          from actors
          where actors.first_name = 'Uma' and
                actors.last_name = 'Thurman'
      ) and
      R.movie_id in (
          select roles.movie_id
          from roles
          where roles.actor_id = (
              select actors.id
              from actors
              where actors.first_name = 'Uma' and
                actors.last_name = 'Thurman'

              )
      );

#Ejer 9
select distinct CONCAT(D.first_name, ' ', D.last_name) as director_name
from directors as D, movies as M, actors as A,
     movies_directors as MD, roles as R
where D.id = MD.director_id and
      A.id = R.actor_id and
      M.id = MD.movie_id and
      M.id = R.movie_id and
      (D.first_name != A.first_name and
      D.last_name != A.last_name)
order by CONCAT(D.first_name, ' ', D.last_name);

#Ejer 10
select CONCAT(D.first_name, ' ', D.last_name) as  director_name, COUNT(M.name) as 'count(*)'
from directors as D, movies as M, movies_directors as MD
where D.id = MD.director_id and
      M.id = MD.movie_id
group by CONCAT(D.first_name, ' ', D.last_name)
order by CONCAT(D.first_name, ' ', D.last_name);

#Ejer 11
select A.first_name, A.last_name, count(R.movie_id) as movie_id
from actors as A, roles as R
where A.id = R.actor_id and
      A.last_name like 'P%'
group by A.first_name, A.last_name
order by count(R.movie_id) desc;

#Ejer 12
#We can, because these two tables has the same values (and c'mon, everybody has a gender, directors arent objects or some-leftist-shit like non-binary stuff)
#we can generalize these two tables in "ActorDirectors" and their role will change if their id is in the "roles" table
#meaning that they are actors or if their id its in the "movies_directors" table, meaning that they are directors,
#and we can save some redundant information btw.

#Ejer 13
#Yes as explained above, some directors are actors and vice versa,
#with this logic we have "James Cameron" who is director and actor, and he occupies two tables with the same values
#this doesnt make sense as explained above in exercise 12.
