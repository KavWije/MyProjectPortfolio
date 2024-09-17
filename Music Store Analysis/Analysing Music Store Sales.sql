--Business Question 1: Who is the most senior employee based on their level?

--Explanation:
--To find the most senior employee, I used a SELECT query to retrieve the employee's details. 
--The results are ordered by the levels column in descending order to place the most senior employee at the top. 
--I then used the LIMIT function to return only the top result.

SELECT
	EMPLOYEE_ID,
	LAST_NAME,
	FIRST_NAME,
	TITLE
FROM
	PUBLIC.EMPLOYEE
ORDER BY
	LEVELS DESC
LIMIT
	1

--Business Question 2: Which countries have the most number of invoices?

--Explanation:
--To answer this query, I used the COUNT aggregate function to find the total number of invoices for each country.
--The GROUP BY clause is used to aggregate the data by country, and the results are ordered in descending order
--to show the countries with the most invoices at the top.

SELECT
	INVOICE.BILLING_COUNTRY,
	COUNT(*) AS NUMBER_OF_INVOICES
FROM
	INVOICE
GROUP BY
	INVOICE.BILLING_COUNTRY
ORDER BY
	NUMBER_OF_INVOICES DESC

--Business Question 3: What are the top 3 total values of invoices?

--Explanation:
--The total invoice values are already present in the dataset. 
--I used the LIMIT function to restrict the output to only the top 3 highest values, ordering the results in descending order.

SELECT
	INVOICE.INVOICE_ID,
	TOTAL
FROM
	INVOICE
ORDER BY
	TOTAL DESC
LIMIT
	3

--Business Question 4: Which city has the best customers based on the invoice value?

--Explanation:
--To determine which city has the best customers based on invoice value, I used the SUM aggregate function 
--to calculate the total invoice value for each city. The GROUP BY clause aggregates the data by city and country, 
--and the results are ordered by total invoice value in descending order. 
--The LIMIT function restricts the result to the top city.

SELECT
	INVOICE.BILLING_CITY,
	INVOICE.BILLING_COUNTRY,
	SUM(INVOICE.TOTAL) AS TOTAL_INVOICE_VALUE
FROM
	INVOICE
GROUP BY
	INVOICE.BILLING_CITY,
	INVOICE.BILLING_COUNTRY
ORDER BY
	TOTAL_INVOICE_VALUE DESC LIMIT
	1

--Business Question 5: Who is the best customer based on the money spent?

--Explanation:
--To identify the best customer based on total money spent, I joined the invoice and customer tables 
--and used the SUM function to calculate the total amount spent per customer. The results are grouped 
--by customer and ordered in descending order by total spending. The LIMIT function is used to return 
--only the top customer.

SELECT
	INVOICE.CUSTOMER_ID,
	CUSTOMER.FIRST_NAME,
	CUSTOMER.LAST_NAME,
	SUM(TOTAL) AS TOTAL_INVOICE_VALUE
FROM
	INVOICE
	INNER JOIN CUSTOMER ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
GROUP BY
	INVOICE.CUSTOMER_ID,
	CUSTOMER.FIRST_NAME,
	CUSTOMER.LAST_NAME
ORDER BY
	TOTAL_INVOICE_VALUE DESC
LIMIT
	1

--Business Question 6: What are the personal details of all the rock listeners in alphabetical order?

--Explanation:
--To find the personal details of all rock listeners, I joined multiple tables (customer, invoice, 
--invoice_line, track, and genre). I filtered the results for customers who listen to rock music and 
--used DISTINCT to avoid duplicates. The results are ordered alphabetically by the customers' first and last names.

SELECT
	C.CUSTOMER_ID,
	C.FIRST_NAME,
	C.LAST_NAME,
	AR.NAME AS ARTIST,
	SUM(IL.UNIT_PRICE * IL.QUANTITY) AS TOTAL_SPENT
FROM
	CUSTOMER C
	JOIN INVOICE I ON C.CUSTOMER_ID = I.CUSTOMER_ID
	JOIN INVOICE_LINE IL ON IL.INVOICE_ID = I.INVOICE_ID
	JOIN TRACK T ON T.TRACK_ID = IL.TRACK_ID
	JOIN ALBUM A ON T.ALBUM_ID = A.ALBUM_ID
	JOIN ARTIST AR ON A.ARTIST_ID = AR.ARTIST_ID
GROUP BY
	C.CUSTOMER_ID,
	AR.NAME
ORDER BY
	TOTAL_SPENTWho are the top 10 rock music artists with the highest track count?

--Explanation:
--To find the top 10 rock music artists with the highest number of tracks, I joined the artist, 
--album, track, and genre tables. I filtered for rock genre tracks and used the COUNT function 
--to determine the number of tracks per artist. The results are grouped by artist and ordered in 
--descending order by track count. The LIMIT function restricts the results to the top 10 artists.

SELECT
	C.CUSTOMER_ID,
	C.FIRST_NAME,
	C.LAST_NAME,
	AR.NAME AS ARTIST,
	SUM(IL.UNIT_PRICE * IL.QUANTITY) AS TOTAL_SPENT
FROM
	CUSTOMER C
	JOIN INVOICE I ON C.CUSTOMER_ID = I.CUSTOMER_ID
	JOIN INVOICE_LINE IL ON IL.INVOICE_ID = I.INVOICE_ID
	JOIN TRACK T ON T.TRACK_ID = IL.TRACK_ID
	JOIN ALBUM A ON T.ALBUM_ID = A.ALBUM_ID
	JOIN ARTIST AR ON A.ARTIST_ID = AR.ARTIST_ID
GROUP BY
	C.CUSTOMER_ID,
	AR.NAME
ORDER BY
	TOTAL_SPENTID = A.ALBUM_ID
	JOIN ARTIST AR ON A.ARTIST_ID = AR.ARTIST_ID
GROUP BY
	C.CUSTOMER_ID,
	AR.NAME
ORDER BY
	TOTAL_SPENT DESC

--Business Question 8: What are the songs that are longer than the average song length?

--Explanation:
--To find songs longer than the average length, I used a subquery to calculate the average song length 
--and compared each song’s length against this average. The results are ordered by song length in ascending order.

SELECT
	C.CUSTOMER_ID,
	C.FIRST_NAME,
	C.LAST_NAME,
	AR.NAME AS ARTIST,
	SUM(IL.UNIT_PRICE * IL.QUANTITY) AS TOTAL_SPENT
FROM
	CUSTOMER C
	JOIN INVOICE I ON C.CUSTOMER_ID = I.CUSTOMER_ID
	JOIN INVOICE_LINE IL ON IL.INVOICE_ID = I.INVOICE_ID
	JOIN TRACK T ON T.TRACK_ID = IL.TRACK_ID
	JOIN ALBUM A ON T.ALBUM_ID = A.ALBUM_ID
	JOIN ARTIST AR ON A.ARTIST_ID = AR.ARTIST_ID
GROUP BY
	C.CUSTOMER_ID,
	AR.NAME
ORDER BY
	TOTAL_SPENTFROM
	CUSTOMER C
	JOIN INVOICE I ON C.CUSTOMER_ID = I.CUSTOMER_ID
	JOIN INVOICE_LINE IL ON IL.INVOICE_ID = I.INVOICE_ID
	JOIN TRACK T ON T.TRACK_ID = IL.TRACK_ID
	JOIN ALBUM A ON T.ALBUM_ID = A.ALBUM_ID
	JOIN ARTIST AR ON A.ARTIST_ID = AR.ARTIST_ID
GROUP BY
	C.CUSTOMER_ID,
	AR.NAME
ORDER BY
	TOTAL_SPENT DESC

--Business Question 9: How much is spent by each customer on artists?

--Explanation:
--To determine how much each customer has spent on artists, I joined the `customer`, `invoice`, `invoice_line`, 
--`track`, `album`, and `artist` tables. I used the `SUM` function to calculate the total amount spent by 
--multiplying `unit_price` and `quantity` from the `invoice_line` table. The results are grouped by customer 
--and artist using the `GROUP BY` clause and ordered in descending order of total spent with the `ORDER BY` clause.

SELECT
	C.CUSTOMER_ID,
	C.FIRST_NAME,
	C.LAST_NAME,
	AR.NAME AS ARTIST,
	SUM(IL.UNIT_PRICE * IL.QUANTITY) AS TOTAL_SPENT
FROM
	CUSTOMER C
	JOIN INVOICE I ON C.CUSTOMER_ID = I.CUSTOMER_ID
	JOIN INVOICE_LINE IL ON IL.INVOICE_ID = I.INVOICE_ID
	JOIN TRACK T ON T.TRACK_ID = IL.TRACK_ID
	JOIN ALBUM A ON T.ALBUM_ID = A.ALBUM_ID
	JOIN ARTIST AR ON A.ARTIST_ID = AR.ARTIST_ID
GROUP BY
	C.CUSTOMER_ID,
	AR.NAME
ORDER BY
	TOTAL_SPENT DESC

--Business Question 10: What is the most popular genre for each country based on the number of purchases? 
--Return all genres if the maximum number of purchases are the same.

--Explanation:
--To find the most popular genre for each country, I used a Common Table Expression (CTE) with the `RANK` function. 
--The `RANK` function partitions the results by country and orders them by the number of purchases in descending order. 
--The CTE is then queried to return genres with the highest rank (i.e., the most purchases) for each country. 
--This approach ensures that all genres with the maximum number of purchases are included.
	
SELECT
	*
FROM
	CUSTOMER
SELECT
	*
FROM
	INVOICE
WITH
	BIGMUSICSPENDERS AS (
		SELECT
			C.CUSTOMER_ID,
			C.FIRST_NAME,
			C.LAST_NAME,
			C.COUNTRY,
			SUM(I.TOTAL) AS TOTAL_SPEND,
			RANK() OVER (
				PARTITION BY
					C.COUNTRY
				ORDER BY
					SUM(I.TOTAL) DESC
			) AS RANK_ON_SPEND
		FROM
			CUSTOMER C
			JOIN INVOICE I ON C.CUSTOMER_ID = I.CUSTOMER_ID
		GROUP BY
			C.CUSTOMER_ID
		ORDER BY
			TOTAL_SPEND DESC
	) SELE1

--Business Question 11: Who are the customers that have spent the most on music in each country?

--Explanation:
--To find the customers who have spent the most on music in each country, I used a Common Table Expression (CTE) with the `RANK` function. 
--The `RANK` function partitions the results by country and orders them by the total spending in descending order. 
--The CTE calculates the total amount spent by each customer and ranks them within their respective country. 
--The final query selects customers with the highest rank (i.e., the most spending) in each country.

SELECT
	*
FROM
	CUSTOMER
SELECT
	*
FROM
	INVOICE
WITH
	BIGMUSICSPENDERS AS (
		SELECT
			C.CUSTOMER_ID,
			C.FIRST_NAME,
			C.LAST_NAME,
			C.COUNTRY,
			SUM(I.TOTAL) AS TOTAL_SPEND,
			RANK() OVER (
				PARTITION BY
					C.COUNTRY
				ORDER BY
					SUM(I.TOTAL) DESC
			) AS RANK_ON_SPEND
		FROM
			CUSTOMER C
			JOIN INVOICE I ON C.CUSTOMER_ID = I.CUSTOMER_ID
		GROUP BY
			C.CUSTOMER_ID
		ORDER BY
			TOTAL_SPEND DESC
	) SELECT
	*
FROM
	BIGMUSICSPENDERS
WHERE
	RANK_ON_SPEND = 1