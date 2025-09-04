-- Úkol 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH wages_1 AS (
	SELECT DISTINCT
		payroll_year,
		industry_branch_code,
		industry_name,
		average_wage
	FROM
		t_marketa_zarska_project_sql_primary_final tmzpspf
	WHERE
		product IS NOT NULL
),
wages_2 AS (
	SELECT
		payroll_year,
		ROUND(AVG(average_wage), 2) AS avg_average_wage
	FROM
		wages_1
	GROUP BY
		payroll_year
),
prices_1 AS (
	SELECT DISTINCT
		price_category_code,
		product,
		price_year,
		average_price
	FROM
		t_marketa_zarska_project_sql_primary_final tmzpspf
	WHERE
		product IS NOT NULL
		AND price_category_code != '212101'
),
prices_2 AS (
	SELECT
		price_year,
		ROUND(AVG(average_price), 2) AS avg_average_price
	FROM
		prices_1
	GROUP BY
		price_year
), 
wages_3 AS (
	SELECT 
		payroll_year,
		avg_average_wage,
		LAG(avg_average_wage) OVER (ORDER BY payroll_year) AS previous_wage,
		ROUND(((avg_average_wage - LAG(avg_average_wage) OVER (ORDER BY payroll_year)) / LAG(avg_average_wage) 
		OVER (ORDER BY payroll_year)) * 100, 2) AS percentage_change_wage
	FROM 
		wages_2
),
prices_3 AS (
	SELECT 
		price_year,
		avg_average_price,
		LAG(avg_average_price) OVER (ORDER BY price_year) AS previous_price,
		ROUND(((avg_average_price - LAG(avg_average_price) OVER (ORDER BY price_year)) / LAG(avg_average_price) 
		OVER (ORDER BY price_year)) * 100, 2) AS percentage_change_price
	FROM 
		prices_2
),
wages_prices AS (
	SELECT
		w.payroll_year,
		w.percentage_change_wage,
		p.percentage_change_price
	FROM 
		wages_3 w
	JOIN prices_3 p
		ON w.payroll_year = p.price_year
)
SELECT 
	payroll_year AS year,
	percentage_change_wage,
	percentage_change_price,
	percentage_change_price - percentage_change_wage AS difference
FROM 
	wages_prices
WHERE 
	percentage_change_wage is not null
	AND percentage_change_price is not null;






	
