-- Q5: Total units sold and total revenue per product, sorted by revenue descending.
SELECT
    p.product_name,
    SUM(oi.quantity) AS total_units,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Q6: Products with above-average revenue.
SELECT product_name, total_revenue
FROM (
    SELECT
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_name
) AS product_totals
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM (
        SELECT SUM(oi.quantity * oi.unit_price) AS total_revenue
        FROM order_items oi
        GROUP BY oi.product_id
    ) AS sub
);

-- Q7: For each category, find the single best-selling product by revenue.
SELECT category, product_name, product_revenue
FROM (
    SELECT
        p.category,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS product_revenue,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS rnk
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category, p.product_name
) ranked
WHERE rnk = 1;

-- Q8: Rank customers by total revenue, without collapsing rows.
SELECT
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS revenue_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_name;

-- Q9: Running total of revenue by order date.
SELECT
    o.order_date,
    SUM(oi.quantity * oi.unit_price) AS daily_revenue,
    SUM(SUM(oi.quantity * oi.unit_price)) OVER (ORDER BY o.order_date) AS running_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_date
ORDER BY o.order_date;
