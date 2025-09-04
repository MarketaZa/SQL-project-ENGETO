-- Úkol č. 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

WITH prices_1 AS (
	SELECT DISTINCT
		price_category_code,
		product,
		price_year,
		average_price
	FROM
		t_marketa_zarska_project_sql_primary_final tmzpspf
	WHERE
		price_category_code IS NOT NULL
),
prices_2 AS (
	SELECT 
		price_category_code,
		product,
		price_year,
		average_price,
		LAG(average_price) OVER (PARTITION BY price_category_code ORDER BY price_year) AS previous_avg_price,
		average_price - LAG(average_price) OVER (PARTITION BY price_category_code ORDER BY price_year) AS price_difference
	FROM
		prices_1
),
prices_3 AS (
	SELECT 
		product,
		price_year,
		average_price,
		previous_avg_price,
		price_difference,
		CASE 
			WHEN previous_avg_price IS NULL THEN NULL
			WHEN previous_avg_price = 0 THEN NULL
			ELSE ROUND((price_difference::NUMERIC / previous_avg_price::NUMERIC) * 100, 2)
		END AS percentage_change
	FROM
		prices_2
)
SELECT
	product,
	ROUND(AVG(percentage_change), 2) AS average_percental_change
FROM
	prices_3
WHERE
	percentage_change IS NOT NULL
GROUP BY
	product
ORDER BY
	average_percental_change;



