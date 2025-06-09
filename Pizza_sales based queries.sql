-- Q1. Retrieve the total number of orders placed.
SELECT 
    COUNT(*) AS total_no_of_order_placed
FROM
    orders;

-- Q2. Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(p.price * od.quantity), 2) AS total_revenue
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id;

-- Q3. Identify the highest-priced pizza.
SELECT 
    pizzas.price, pizza_types.name
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- Q4. List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS total_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY total_quantity DESC
LIMIT 5;

-- Q5. Identify the most common pizza size ordered.

SELECT 
    pizzas.size, COUNT(order_details.oder_details_id)
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size;


-- Q6. Determine the distribution of orders by hour of the day.
SELECT 
    COUNT(order_id), HOUR(order_time)
FROM
    orders
GROUP BY HOUR(order_time);  

-- Q7. Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS total_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY total_quantity DESC;


-- Q8. Join relevant tables to find the category-wise distribution of pizzas.
SELECT category, COUNT(name)
FROM pizza_types
GROUP BY category;

-- Q9.Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    AVG(quantity)
FROM
    (SELECT 
        orders.order_date, ROUND(SUM(order_details.quantity),0) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS sub_data;
    
    
-- Q10. Determine the top 3 most ordered pizza types based on revenue.
SELECT pizza_types.name, SUM(order_details.quantity*pizzas.price) as revenue
FROM pizzas JOIN pizza_types 
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name 
ORDER BY revenue desc limit 3 ;

-- Q11. Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    SUM(order_details.quantity * pizzas.price) / (SELECT 
            ROUND(SUM(pizzas.price * order_details.quantity),
                        2) AS total_revenue
        FROM
            pizzas
                JOIN
            order_details ON pizzas.pizza_id = order_details.pizza_id) * 100 AS revenue
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;

-- Q12. Show the number of orders per pizza size.
SELECT 
    pizzas.size, COUNT(*) AS total_order
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size;

-- Q13. Find the average number of pizzas per order. 
SELECT 
    orders.order_id,
    AVG(order_details.quantity) AS avg_quantity_per_item
FROM
    orders
        JOIN
    order_details ON orders.order_id = order_details.order_id
GROUP BY orders.order_id;


-- 	Q14. Identify the least popular pizza category.

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS total_ordered
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY total_ordered ASC
LIMIT 1;

-- Q15. Calculate cumulative revenue over time.

SELECT date(o.order_date) AS order_date, 
ROUND(SUM(p.price * od.quantity),2) AS total_revenue, 
ROUND(SUM(SUM(p.price * od.quantity)) OVER (ORDER BY DATE(o.order_date)),2) AS cumulative
FROM orders o JOIN order_details od ON
o.order_id = od.order_id
JOIN pizzas p ON
p.pizza_id = od.pizza_id
GROUP BY DATE(o.order_date);