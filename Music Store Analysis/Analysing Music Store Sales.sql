--	Business Question 1: Who is the most senior employee based on their level?

--	Explanation:
--	To find the most senior employee, I used a SELECT query to retrieve the employee's details. 
--	The results are ordered by the levels column in descending order to place the most senior employee at the top. 
--	I then used the LIMIT function to return only the top result.

	select employee_id, last_name, first_name, title
	from public.employee
	order by levels desc
	limit 1

--	Business Question 2: Which countries have the most number of invoices?

--	Explanation:
--	To answer this query, I used the COUNT aggregate function to find the total number of invoices for each country.
--	The GROUP BY clause is used to aggregate the data by country, and the results are ordered in descending order
--	to show the countries with the most invoices at the top.

	select invoice.billing_country, count(*) as number_of_invoices
	from invoice
	group by invoice.billing_country
	order by number_of_invoices desc

--	Business Question 3: What are the top 3 total values of invoices?

--	Explanation:
--	The total invoice values are already present in the dataset. 
--	I used the LIMIT function to restrict the output to only the top 3 highest values, ordering the results in descending order.

	select invoice.invoice_id, total
	from invoice
	order by total desc
	limit 3

--	Business Question 4: Which city has the best customers based on the invoice value?

--	Explanation:
--	To determine which city has the best customers based on invoice value, I used the SUM aggregate function 
--	to calculate the total invoice value for each city. The GROUP BY clause aggregates the data by city and country, 
--	and the results are ordered by total invoice value in descending order. 
--	The LIMIT function restricts the result to the top city.

	Select invoice.billing_city, invoice.billing_country, sum(invoice.total) as total_invoice_value
	from invoice
	group by invoice.billing_city, invoice.billing_country
	order by total_invoice_value desc
	limit 1

--	Business Question 5: Who is the best customer based on the money spent?

--	Explanation:
--	To identify the best customer based on total money spent, I joined the invoice and customer tables 
--	and used the SUM function to calculate the total amount spent per customer. The results are grouped 
--	by customer and ordered in descending order by total spending. The LIMIT function is used to return 
--	only the top customer.

	select  invoice.customer_id, customer.first_name, customer.last_name, sum(total) as total_invoice_value
	from invoice
	inner join customer
	on customer.customer_id = invoice.customer_id
	group by invoice.customer_id, customer.first_name, customer.last_name
	order by total_invoice_value desc
	limit 1

--	Business Question 6: What are the personal details of all the rock listeners in alphabetical order?

--	Explanation:
--	To find the personal details of all rock listeners, I joined multiple tables (customer, invoice, 
--	invoice_line, track, and genre). I filtered the results for customers who listen to rock music and 
--	used DISTINCT to avoid duplicates. The results are ordered alphabetically by the customers' first and last names.

	select distinct(customer.customer_id), customer.first_name, customer.last_name, customer.address, 
		track.genre_id, genre.name
	from customer
	join invoice
		on invoice.customer_id = customer.customer_id
	join invoice_line
		on invoice_line.invoice_id = invoice.invoice_id
	join track
		on invoice_line.track_id = track.track_id
	join genre
		on genre.genre_id = track.genre_id
	where genre.name = 'Rock'
	order by customer.first_name, customer.last_name

--	Business Question 7: Who are the top 10 rock music artists with the highest track count?

--	Explanation:
--	To find the top 10 rock music artists with the highest number of tracks, I joined the artist, 
--	album, track, and genre tables. I filtered for rock genre tracks and used the COUNT function 
--	to determine the number of tracks per artist. The results are grouped by artist and ordered in 
--	descending order by track count. The LIMIT function restricts the results to the top 10 artists.

	select distinct (artist.name), count(*) as number_of_tracks
	from artist
	join album on album.artist_id = artist.artist_id
	join track on album.album_id = track.album_id
	join genre on genre.genre_id = track.genre_id
	where genre.name = 'Rock'
	group by artist.name
	order by number_of_tracks desc
	limit 10

--	Business Question 8: What are the songs that are longer than the average song length?

--	Explanation:
--	To find songs longer than the average length, I used a subquery to calculate the average song length 
--	and compared each song’s length against this average. The results are ordered by song length in ascending order.

	select name, milliseconds
	from track
	where milliseconds > (select avg(milliseconds) from track)
	order by milliseconds

-- Business Question 9: How much is spent by each customer on artists?

-- Explanation:
-- To determine how much each customer has spent on artists, I joined the `customer`, `invoice`, `invoice_line`, 
-- `track`, `album`, and `artist` tables. I used the `SUM` function to calculate the total amount spent by 
-- multiplying `unit_price` and `quantity` from the `invoice_line` table. The results are grouped by customer 
-- and artist using the `GROUP BY` clause and ordered in descending order of total spent with the `ORDER BY` clause.

	select c.customer_id, c.first_name, c.last_name, ar.name as artist, sum(il.unit_price * il.quantity) as total_spent
	from customer c
	join invoice i on c.customer_id = i.customer_id
	join invoice_line il on il.invoice_id = i.invoice_id
	join track t on t.track_id = il.track_id
	join album a on t.album_id = a.album_id
	join artist ar on a.artist_id = ar.artist_id
	group by c.customer_id, ar.name
	order by total_spent desc

-- Business Question 10: What is the most popular genre for each country based on the number of purchases? 
-- Return all genres if the maximum number of purchases are the same.

-- Explanation:
-- To find the most popular genre for each country, I used a Common Table Expression (CTE) with the `RANK` function. 
-- The `RANK` function partitions the results by country and orders them by the number of purchases in descending order. 
-- The CTE is then queried to return genres with the highest rank (i.e., the most purchases) for each country. 
-- This approach ensures that all genres with the maximum number of purchases are included.


	select *
	from
	
	With popoluargenre as (
	select c.country, g.name, sum(il.quantity) as Number_of_purchases,
			rank() over (partition by c.country order by sum(quantity) desc) as rnk
	from customer c
	join invoice i on c.customer_id = i.customer_id
	join invoice_line il on i.invoice_id = il.invoice_id
	join track t on t.track_id = il.track_id
	join genre g on t.genre_id = g.genre_id
	group by c.country, g.name
	order by Number_of_purchases desc
	)
	select * from popoluargenre
	where rnk = 1

-- Business Question 11: Who are the customers that have spent the most on music in each country?

-- Explanation:
-- To find the customers who have spent the most on music in each country, I used a Common Table Expression (CTE) with the `RANK` function. 
-- The `RANK` function partitions the results by country and orders them by the total spending in descending order. 
-- The CTE calculates the total amount spent by each customer and ranks them within their respective country. 
-- The final query selects customers with the highest rank (i.e., the most spending) in each country.

	select *
	from customer
	select *
	from invoice
	
	with bigmusicspenders as (
	select c.customer_id, c.first_name, c.last_name, c.country, sum(i.total) as total_spend,
		rank() over (partition by c.country order by sum(i.total) desc) as rank_on_spend
	from customer c
	join invoice i on c.customer_id = i.customer_id
	group by c.customer_id
	order by total_spend desc
	)
	select * from bigmusicspenders
	where rank_on_spend = 1