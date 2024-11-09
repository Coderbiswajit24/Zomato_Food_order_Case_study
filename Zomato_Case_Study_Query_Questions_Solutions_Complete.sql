/*Swiggy Case Study Questions*/

-- Task 1. Find customers who have never ordered
--Query:-
select
     user_id,
     user_name
from users 
    where user_id not in (select user_id from orders);
	
--Another Solution:-
select
     u.user_id as "User Id Number",
	 u.user_name as "User Name"
from users as u 
    where not exists (select 1 from orders as o where o.user_id = u.user_id);
	
-- Task 2. Average Price/dish
--Query:-
select
     f.food_id as "Food Id Number",
	 f.food_name as "Food Name",
	 round(avg(m.food_price),2) as "Average Price"
from foods as f
join menu as m on f.food_id = m.food_id
    group by f.food_id,f.food_name
	     order by avg(m.food_price) desc;
-- Task 3. Find the top restaurant in terms of the number of orders for a given month
--Query:- For Month May
select
    r.restaurant_id as "Restaurant Id Number",
	r.restaurant_name as "Restaurant Name",
    count(o.order_id) as "Total Number of Orders"
from restaurants as r
join orders as o on r.restaurant_id = o.restaurant_id
     where extract(month from o.order_date) = 5
          group by r.restaurant_id,r.restaurant_name
		       order by count(o.order_id)  desc
			        limit 1;
-- For Month June
select
    r.restaurant_id as "Restaurant Id Number",
	r.restaurant_name as "Restaurant Name",
    count(o.order_id) as "Total Number of Orders"
from restaurants as r
join orders as o on r.restaurant_id = o.restaurant_id
     where extract(month from o.order_date) = 6
          group by r.restaurant_id,r.restaurant_name
		       order by count(o.order_id)  desc
			        limit 1;
--For Month July
select
    r.restaurant_id as "Restaurant Id Number",
	r.restaurant_name as "Restaurant Name",
    count(o.order_id) as "Total Number of Orders"
from restaurants as r
join orders as o on r.restaurant_id = o.restaurant_id
     where extract(month from o.order_date) = 7
          group by r.restaurant_id,r.restaurant_name
		       order by count(o.order_id)  desc
			        limit 1;
	

-- Task 4. restaurants with monthly sales greater than 500.
--Query:-
select
     to_char(o.order_date,'Month') as "Order Month Name",
	 r.restaurant_name as "Restaurant Name",
	 sum(o.order_amount) as "Total Revenue"
from orders as o
join restaurants as r on o.restaurant_id = r.restaurant_id
    group by to_char(o.order_date,'Month'),r.restaurant_name
	     having sum(o.order_amount) > 500
	     order by to_char(o.order_date,'Month') asc ,r.restaurant_name asc;
-- Task 5. Show all orders with order details for a particular customer in a particular date range
--Query:-
select
     o.order_id as "Order Id Number",
	 r.restaurant_name as "Restaurants Name",
	 f.food_name as " Order Food Name",
	 o.order_amount as "Order Amount"
from orders as o
join restaurants as r on o.restaurant_id = r.restaurant_id
join menu as m on r.restaurant_id = m.restaurant_id
join foods as f on m.food_id = f.food_id
    where o.user_id = 2 and o.order_date between '2022-06-15' and '2022-07-15';
	
-- Task 6. Find restaurants with max repeated customers 
--Query:-
select
     r.restaurant_name as "Restaurant Name",
	 u.user_name as "User Id Number",
	 count(o.order_id) as "Total Orders Count"
from restaurants as r
join orders as o on r.restaurant_id = o.restaurant_id
join users as u on o.user_id = u.user_id
     group by r.restaurant_name,u.user_name
	       order by count(o.order_id) desc;

--Another Solution for this Query:-
SELECT
     t.*
FROM 
    (SELECT
         r.restaurant_name AS "Restaurant Name",
         u.user_name AS "User Id Number",
         COUNT(o.order_id) AS "Total Orders Count",
         ROW_NUMBER() OVER (PARTITION BY u.user_name ORDER BY COUNT(o.order_id) DESC) AS rownum
     FROM
         restaurants AS r
     JOIN orders AS o ON r.restaurant_id = o.restaurant_id
     JOIN users AS u ON o.user_id = u.user_id
     GROUP BY
         r.restaurant_name, u.user_name) AS t
WHERE 
    t.rownum = 1
ORDER BY 
    t."Restaurant Name", t."User Id Number";


-- Task 7. Month over month revenue growth of swiggy
--Query:-
select
    to_char(o.order_date,'Month') as "Month Name",
	sum(o.order_amount) as "Total Revenue Growth"
from orders  as o
    group by to_char(o.order_date,'Month')
	     order by sum(o.order_amount) desc;
-- Task 8.Find Customer - favorite food
select
    f.food_name as "Favorite Food",
	count(o.order_id) as "Total Orders Count"
from foods as f
join menu as m on f.food_id = m.food_id
join orders as o on m.restaurant_id = o.restaurant_id
    group by f.food_name
	    order by count(o.order_id) desc
		     limit 1;
	
	
-- Task 9. Find the most loyal customers for all restaurant
--Query:-
SELECT
    t.restaurant_name as "Restaurant Name",
    t.user_name as "Loyal Customers Name"
FROM 
    (SELECT
         r.restaurant_name AS restaurant_name,
         u.user_name AS user_name,
         COUNT(o.order_id) AS total_orders_count,
         ROW_NUMBER() OVER (PARTITION BY r.restaurant_name ORDER BY COUNT(o.order_id) DESC) AS rownum
     FROM
         restaurants AS r
     JOIN orders AS o ON r.restaurant_id = o.restaurant_id
     JOIN users AS u ON o.user_id = u.user_id
     GROUP BY
         r.restaurant_name, u.user_name) AS t
WHERE 
    t.rownum = 1
ORDER BY 
    t.restaurant_name, t.total_orders_count DESC;

-- Task 10. Month over month revenue growth of a restaurant
select
     to_char(o.order_date,'Month') as "Order Month Name",
	 r.restaurant_name as "Restaurant Name",
	 sum(o.order_amount) as "Monthly Revenue Growth"
from orders as o
join restaurants as r on o.restaurant_id = r.restaurant_id
    group by to_char(o.order_date,'Month'),r.restaurant_name
	     order by to_char(o.order_date,'Month'),r.restaurant_name;

-- Task 11. Most Paired Products