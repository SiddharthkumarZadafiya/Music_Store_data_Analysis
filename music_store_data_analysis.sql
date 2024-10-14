-- Q.1 Who is the senior most employee by job title??

Select *
from employee
order by levels desc
limit 1;

-- Q2 Which country has the most invoices?

select billing_country, count(billing_country) as total_count
from invoice
group by billing_country
order by total_count desc;

-- Q.3 What are top 3 values of total invoice?

select *
from invoice
order by total desc
limit 3;

-- Q.4 which city has the best customer? we would like to throw a promotional Music Festival in the city we made the most sale??

select  billing_city, sum(total) as total_sale
from invoice
group by billing_city
order by total_sale desc
limit 3;

-- Q.5 Who is the best customer? the customer who has spent most money

select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total_spent
from customer
join invoice
	on customer.customer_id = invoice.customer_id
group by customer.customer_id, customer.first_name, customer.last_name
order by total_spent desc
limit 1
;

-- Q.6 Write a query to return the email,first name , last name & genre of all rock music listeneres


with genre_track as
(
select genre.genre_id, genre.`name`, track.track_id
from genre
join track
	on genre.genre_id = track.genre_id
where genre.genre_id = 1
), track_invoice_line as
(
select genre_track.genre_id, genre_track.`name`, invoice_line.invoice_id
from genre_track
join invoice_line 
	on genre_track.track_id = invoice_line.track_id
)
select customer.email, customer.first_name, CUSTOMER.last_name
from track_invoice_line
join invoice
	on track_invoice_line.invoice_id = invoice.invoice_id
		join customer 
			on invoice.customer_id = customer.customer_id
group by customer.email, customer.first_name, CUSTOMER.last_name
order by 1
;

-- Q.7 Let's invote the artists who have written the most rock music in dataset. Write a query the artist name and total track count of top 10 rock bands

select artist.`name`, count(genre.genre_id) as total
from artist
join album2 
	on artist.artist_id = album2.artist_id
		join track
			on album2.album_id = track.album_id
				join genre
					on track.genre_id = genre.genre_id
                    where genre.genre_id = 1
group by artist.`name`
order by total desc
limit 10
;

-- Q.8 Return all the track names that have a song length longer than the avg song length. retuen the name and ms for each track

select `name`, milliseconds
from track 
where milliseconds > (
						select avg(milliseconds)
						from track
					)
order by milliseconds desc;


-- Q.9 Find how much amount spent by each customer on artists. write a query to return customer name artist name and total spent

select customer.customer_id, customer.first_name, customer.last_name, artist.`name`, sum(invoice_line.unit_price * invoice_line.quantity)
from customer
join invoice
	on customer.customer_id = invoice.customer_id
		join invoice_line
			on invoice.invoice_id = invoice_line.invoice_id
				join track
					on invoice_line.track_id = track.track_id
						join album2
							on track.album_id = album2.album_id
								join artist
									on album2.artist_id = artist.artist_id
group by 1,2,3,4
order by 1,5
;


-- Q.10 We want to find out the most popular music genre for each country.

with Genre_country_ranking(country,Genre_name,Count,Ranking) as
(select country, genre.`name`, count(genre.`name`),
dense_rank() over(partition by customer.country order by count(genre.`name`) desc) as ranking
from customer
join invoice
	on customer.customer_id = invoice.customer_id
		join invoice_line
			on invoice.invoice_id = invoice_line.invoice_id
				join track
					on invoice_line.track_id = track.track_id
						join genre 
							on track.genre_id = genre.genre_id
group by 1,2
)

select *
from Genre_country_ranking
where ranking = 1
;

