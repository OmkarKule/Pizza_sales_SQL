show databases;
Create database Pizza;
use Pizza;
show tables from Pizza;
select * from orders;

-- #Retrieve the total number of orders placed.
select * from orders;
select count(order_id) as NOP from orders;

-- Calculate the total revenue generated from pizza sales.
select round(sum(order_details.quantity *pizzas.price),0)as Revenu from order_details join pizzas on pizzas.pizza_id= order_details.pizza_id;

-- Identify the highest-priced pizza.
select pizza_types.name,pizzas.price from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;

-- Identify the most common pizza size ordered.
select quantity, count(order_details_id) as No_of_orders from order_details group by quantity;
select pizzas.size,count(order_details.order_details_id) as ODC from pizzas join order_details on pizzas.pizza_id= order_details.pizza_id group by pizzas.size order by ODC desc;

-- List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name,sum(order_details.quantity) as total_quantity from pizza_types 
JOIN pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details on order_details.pizza_id = pizzas.pizza_id group by pizza_types.name order by total_quantity desc limit 5;

-- SELECT pizza_types.name, SUM(order_details.quantity) AS total_quantity
-- FROM pizza_types
-- JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
-- JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
-- GROUP BY pizza_types.name
-- ORDER BY total_quantity DESC
-- LIMIT 5;

-- Find the Total Quantity of Each Pizza Category Ordered:
SELECT pizza_types.category, SUM(order_details.quantity) AS total_quantity
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.category;

-- Determine the distribution of orders by hour of the day.
SELECT HOUR(order_details.order_id) AS order_hour, COUNT(*) AS order_count
FROM order_details
GROUP BY order_hour
ORDER BY order_hour;

-- Category-Wise Distribution of Pizzas
SELECT pizza_types.category, pizza_types.name, SUM(order_details.quantity) AS total_quantity
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.category, pizza_types.name
ORDER BY total_quantity DESC;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT DATE(order_details.order_id) AS order_date, AVG(order_details.quantity) AS avg_quantity_per_day
FROM order_details
GROUP BY order_date
ORDER BY order_date;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT pizza_types.name, SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.name
ORDER BY total_revenue DESC
LIMIT 3;

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT pizza_types.name, 
       SUM(order_details.quantity * pizzas.price) AS total_revenue,
       (SUM(order_details.quantity * pizzas.price) / 
        (SELECT SUM(order_details.quantity * pizzas.price) 
         FROM order_details
         JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id) 
       ) * 100 AS percentage_contribution
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.name
ORDER BY total_revenue DESC;


-- Analyze the cumulative revenue generated over time.
SELECT DATE(order_details.order_id) AS order_date,
       SUM(order_details.quantity * pizzas.price) AS daily_revenue,
       SUM(SUM(order_details.quantity * pizzas.price)) OVER (ORDER BY DATE(order_details.order_id)) AS cumulative_revenue
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY order_date
ORDER BY order_date;

