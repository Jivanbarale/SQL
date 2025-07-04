use musicanalysis;

# Q1: Who is the senior most employee based on job title?
select * from employee ;
select * from employee
order by levels desc
limit 1 ;

# Q2: Which countries have the most Invoices?
select count(*) as Counts,billing_country
 from invoice
 group by billing_country
 order by Counts desc;

# Q3: What are top 3 values of total invoice?
select * from invoice
order by total desc
limit 3;


 /* Q4: Write query to return the email, first name, last name, & Genre 
of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */
 SELECT DISTINCT email,first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;



/* Q5: Return all the track names that have a song length longer 
than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length 
with the longest songs listed first. */

SELECT  name,milliseconds FROM TRACK
where milliseconds>(
select avg(milliseconds) as AVG from track)
order by milliseconds desc;



/* Q6: Which city has the best customers? We would like to throw a promotional 
Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
select sum(total) as Invoice_total,billing_city
 from invoice
 group by billing_city
 order by Invoice_total desc
 limit 1;


/* Q7: We want to find out the most popular music Genre for each country. 
We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country 
along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, 
    genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 1 ASC
)
SELECT * FROM popular_genre WHERE RowNo <= 1




WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1
