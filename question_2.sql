-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období 
--v dostupných datech cen a mezd?


WITH wage_price AS (
	SELECT *
	FROM 
		t_marketa_zarska_project_sql_primary_final tmzpspf
	WHERE
		average_wage IS NOT NULL
		AND average_price IS NOT NULL
),
first_last_year AS (
	SELECT 
		MIN(payroll_year) AS first_period,
		MAX(payroll_year) AS last_period
	FROM
		wage_price
),
first_last_selected AS (
SELECT 
	payroll_year,
	industry_branch_code,
	industry_name,
	average_wage,
	price_category_code,
	product,
	average_price
FROM
	wage_price wp
JOIN first_last_year faly ON wp.payroll_year = faly.first_period
	OR wp.payroll_year = faly.last_period
)
SELECT
	payroll_year,
	industry_branch_code,
	industry_name,
	average_wage,
	ROUND(average_wage / MAX(CASE WHEN price_category_code = '114201' THEN average_price END)) AS litres_of_milk,
	ROUND(average_wage / MAX(CASE WHEN price_category_code = '111301' THEN average_price END)) AS kg_of_bread
FROM
	first_last_selected
WHERE
	price_category_code IN ('114201', '111301')
GROUP BY
	payroll_year,
	industry_branch_code,
	industry_name,
	average_wage
ORDER BY
	industry_branch_code,
	payroll_year;



