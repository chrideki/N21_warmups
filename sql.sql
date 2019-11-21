-- For each product in the database, calculate how many more orders where placed in 
-- each month compared to the previous month.

-- IMPORTANT! This is going to be a 2-day warmup! FOR NOW, assume that each product
-- has sales every month. Do the calculations so that you're comparing to the previous 
-- month where there were sales.
-- For example, product_id #1 has no sales for October 1996. So compare November 1996
-- to September 1996 (the previous month where there were sales):
-- So if there were 27 units sold in November and 20 in September, the resulting 
-- difference should be 27-7 = 7.
-- (Later on we will work towards filling in the missing months.)

-- BIG HINT: Look at the expected results, how do you convert the dates to the 
-- correct format (year and month)?

WITH order_per_month AS(
    SELECT
        product_id,
        to_char(order_date, 'YYYY-MM') AS year_month_order,
        SUM(quantity) AS unit_sold_per_month
    FROM orders
    JOIN order_details USING(order_id)
    GROUP BY product_id, year_month_order
    ORDER BY product_id, year_month_order DESC    
), previous_month_order AS(
    SELECT
        *,
        LEAD(unit_sold_per_month, 1) OVER(PARTITION BY product_id ORDER BY year_month_order DESC) AS previous_month
    FROM order_per_month
    )   SELECT
            *,
            unit_sold_per_month - previous_month AS DIFFERENCE
        FROM previous_month_order;

  