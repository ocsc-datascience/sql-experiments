-- In this exercise, I will not follow the upper-case convention.

use sakila;

-- 1a.
select first_name,last_name from actor;

-- 1b.
select concat(first_name,' ',last_name) as 'Actor Name' from actor;

-- 2a.
select actor_id,first_name,last_name from actor where first_name = 'Joe';

-- 2b.
select * from actor where last_name like '%GEN%';

-- 2c.
select * from actor where last_name like '%LI%' order by last_name,first_name;

-- 2d.
select country_id,country from country
where country in ('Afghanistan','Bangladesh','China');

-- 3a. -- a blob is a large, independent object that can hold a variable
-- amount of data. Varchar is limited to whatever we specify as its size.
alter table actor add description blob;

-- 3b.
alter table actor drop description;

-- 4a.
select last_name,count(last_name) from actor group by last_name;

-- 4b.
select last_name,count(last_name) from actor
group by last_name having count(*) > 1;

-- 4c.
update actor set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d.
update actor set first_name = 'GROUCHO' where first_name = 'HARPO';


-- 5a.
show create table address;

-- 6a.
-- NOTE: There appears to be something wrong with staff
-- there are only two staff members and there appears to be
-- binary garbage on selecting * from staff.
select s.first_name,s.last_name,a.address
from staff as s
join address as a
on (s.address_id = a.address_id);

-- 6b.
select s.first_name,s.last_name,sum(p.amount) from staff as s
join
payment as p
where (s.staff_id = p.staff_id) group by s.last_name,s.first_name;

-- 6c.
select f.title,count(fa.actor_id) from film as f
inner join
film_actor as fa on (f.film_id = fa.film_id) group by f.title;

-- 6d.
select count(inventory_id) from inventory where film_id in
(select film_id from film where title = 'Hunchback Impossible');

-- 6e.
select c.first_name,c.last_name,sum(p.amount) from customer as c
right join payment as p
on (c.customer_id = p.customer_id)
group by c.first_name,c.last_name
order by c.last_name;

-- 7a.
select title from film
where title like 'K%' or title like 'Q%'
and film_id in
(select film_id from film
where language_id =
(select language_id from language where name = 'English'));

-- 7b.
select first_name,last_name from actor where actor_id in
(select actor_id from film_actor
where film_id in (select film_id from film where title = 'Alone Trip'));

-- 7c.
select c.first_name,c.last_name,c.email from customer as c
inner join address as a on (c.address_id = a.address_id)
inner join city on (city.city_id = a.city_id)
inner join country on (city.country_id = country.country_id)
where country.country = "Canada";

-- 7d.
select title from film where film_id
in (select film_id from film_category where category_id
in (select category_id from category where name = 'Family'));

-- 7e.
select film.title,count(inv.film_id) as rentals from rental
left join inventory as inv on (rental.inventory_id = inv.inventory_id)
left join film on (inv.film_id = film.film_id)
group by inv.film_id,film.title
order by rentals desc;

-- 7f.
select * from sales_by_store;

-- 7g.
select s.store_id,c.city,country.country from store as s
inner join address as a on (s.address_id = a.address_id)
inner join city c on (a.city_id = c.city_id)
inner join country on (c.country_id = country.country_id);

-- 7h.
select c.name,sum(p.amount) as gross from category as c
inner join film_category as fc on (fc.category_id = c.category_id)
right join inventory as i on (i.film_id = fc.film_id)
right join rental as r on (r.inventory_id = i.inventory_id)
join payment as p on (r.rental_id = p.rental_id)
group by c.name
order by gross desc limit 5;

-- 8a.
create view top_five_genres as
select c.name,sum(p.amount) as gross from category as c
inner join film_category as fc on (fc.category_id = c.category_id)
right join inventory as i on (i.film_id = fc.film_id)
right join rental as r on (r.inventory_id = i.inventory_id)
join payment as p on (r.rental_id = p.rental_id)
group by c.name
order by gross
desc limit 5;

-- 8b.
select * from top_five_genres;

-- 8c.
drop view top_five_genres;
