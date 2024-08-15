--alterar tabela categories e adicionar coluna de margem de lucro
ALTER TABLE categories
ADD COLUMN margin DECIMAL(5,2);

--margem de lucro de acordo com o tipo de bicicleta
UPDATE categories
SET margin = CASE
				WHEN category_name = 'Children Bicycles' THEN 0.4
				WHEN category_name = 'Comfort Bicycles' THEN 0.35
				WHEN category_name = 'Cruisers Bicycles' THEN 0.325
				WHEN category_name = 'Cyclocross Bicycles' THEN 0.275
				WHEN category_name = 'Electric Bikes' THEN 0.225
				WHEN category_name = 'Mountain Bikes' THEN 0.275
				WHEN category_name = 'Road Bikes' THEN 0.25
			END;
SELECT *
FROM categories;

--verificando a tabela order_items
SELECT COUNT(order_id), COUNT(DISTINCT order_id)
FROM order_items;

SELECT 
	COUNT(*) AS numero_registros, 
	COUNT(order_id) AS numero_pedidos,
	COUNT(DISTINCT order_id) AS numero_pedidos_distintos
FROM orders;


--pedidos e vendas totais por maior preco
SELECT order_id, list_price * quantity
FROM orders
LEFT JOIN order_items
USING(order_id)
ORDER BY 2 DESC;

--total de receitas, produtos vendidos, custos e lucros totais e médios
WITH product_category_cost AS (
	SELECT 
		p.product_id, 
		p.product_name, 
		c.category_id, 
		p.list_price,
		c.margin,
		ROUND((p.list_price - (p.list_price * c.margin))::numeric, 2) AS cost,
		ROUND((p.list_price::numeric - 
			(p.list_price - (p.list_price * c.margin))::numeric), 2) AS profit
	FROM products AS p
	LEFT JOIN categories AS c
		ON p.category_id = c.category_id
)
SELECT 
	ROUND(SUM(p.list_price::numeric), 2) AS revenue,
	ROUND(SUM(quantity), 0) AS products_sold,
	ROUND(SUM(profit * quantity), 2) AS total_profit,
	ROUND(SUM(cost * quantity), 2) AS total_cost,
	ROUND(AVG(profit), 2) AS avg_profit,
	ROUND(AVG(cost), 2) AS avg_cost
FROM order_items AS o
INNER JOIN product_category_cost AS p
	ON o.product_id = p.product_id;

--receitas totais e quantidade vendida total por ano
WITH product_category_cost AS (
	SELECT 
		p.product_id, 
		p.product_name, 
		c.category_id, 
		p.list_price,
		c.margin,
		ROUND((p.list_price - (p.list_price * c.margin))::numeric, 2) AS cost,
		ROUND((p.list_price::numeric - 
			(p.list_price - (p.list_price * c.margin))::numeric), 2) AS profit
	FROM products AS p
	LEFT JOIN categories AS c
		ON p.category_id = c.category_id
)
SELECT 
	EXTRACT(year FROM order_date) AS year,
	SUM(profit * quantity) AS profit_year,
	ROUND(SUM(quantity), 2) AS total_quantity_year,
	ROUND(AVG(profit), 2) AS avg_profit_year,
	ROUND(AVG(cost), 2) AS avg_cost_year
FROM orders AS o
LEFT JOIN order_items AS i
	USING(order_id)
LEFT JOIN product_category_cost AS p
	ON i.product_id = p.product_id
GROUP BY 1
ORDER BY 1;

--lojas mais lucrativas
WITH product_category_cost AS (
	SELECT 
		p.product_id, 
		p.product_name, 
		c.category_id, 
		p.list_price,
		c.margin,
		ROUND((p.list_price - (p.list_price * c.margin))::numeric, 2) AS cost,
		ROUND((p.list_price::numeric - 
			(p.list_price - (p.list_price * c.margin))::numeric), 2) AS profit
	FROM products AS p
	LEFT JOIN categories AS c
		ON p.category_id = c.category_id
)
SELECT 
	city AS store_city,
	state AS store_state,
	EXTRACT(year FROM order_date) AS year,
	ROUND(SUM(quantity), 2) AS total_quantity_year,
	ROUND(AVG(profit), 2) AS avg_profit_year,
	ROUND(AVG(cost), 2) AS avg_cost_year,
	SUM(profit * quantity) AS profit_year,
	RANK() OVER (ORDER BY SUM(profit * quantity) DESC) AS ranking_lucro
FROM orders AS o
LEFT JOIN stores AS s
	ON o.store_id = s.store_id
LEFT JOIN order_items AS i
	ON i.order_id = o.order_id
LEFT JOIN product_category_cost AS p
	ON i.product_id = p.product_id
GROUP BY 1,2,3
ORDER BY 7 DESC;

--número de pedidos
SELECT 
	s.store_id, 
	state,
	COUNT(order_id) AS num_pedidos,
	COUNT(DISTINCT customer_id) AS num_clientes_distintos
FROM orders AS o
LEFT JOIN stores AS s
	ON o.store_id = s.store_id
GROUP BY 1,2
ORDER BY 3 DESC;

--distribuição anual
SELECT 
	EXTRACT(month FROM order_date),
	CASE 
		WHEN EXTRACT(month FROM order_date) = 1 THEN 'Janeiro'
		WHEN EXTRACT(month FROM order_date) = 2 THEN 'Fevereiro'
		WHEN EXTRACT(month FROM order_date) = 3 THEN 'Março'
		WHEN EXTRACT(month FROM order_date) = 4 THEN 'Abril'
		WHEN EXTRACT(month FROM order_date) = 5 THEN 'Maio'
		WHEN EXTRACT(month FROM order_date) = 6 THEN 'Junho'
		WHEN EXTRACT(month FROM order_date) = 7 THEN 'Julho'
		WHEN EXTRACT(month FROM order_date) = 8 THEN 'Agosto'
		WHEN EXTRACT(month FROM order_date) = 9 THEN 'Setembro'
		WHEN EXTRACT(month FROM order_date) = 10 THEN 'Outubro'
		WHEN EXTRACT(month FROM order_date) = 11 THEN 'Novembro'
		WHEN EXTRACT(month FROM order_date) = 12 THEN 'Dezembro' END,
	COUNT(order_id) AS num_pedidos
FROM orders
GROUP BY 1
ORDER BY 1 ASC;
-- os primeiros quatro meses do ano tem a maior quantidade de pedidos, 
-- talvez pela proximidade com o verão


