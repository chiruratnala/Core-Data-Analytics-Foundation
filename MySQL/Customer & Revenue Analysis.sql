-- Q1: List each order with the customer's name and region.
SELECT o.order_id, o.order_date, c.customer_name, c.region
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Q2: Total revenue per customer, sorted highest to lowest.
SELECT
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_name
ORDER BY total_revenue DESC;

-- Q3: Customers who have never placed an order.
SELECT customer_id, customer_name
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM orders
);

SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Q4: Top 5 customers by total revenue, counting only 'Completed' orders.
SELECT
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_name
ORDER BY total_revenue DESC
LIMIT 5;
