--Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
--projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

WITH cz_economy AS (
	SELECT 
		year,
		gdp,
		LAG(gdp) OVER (ORDER BY year) AS previous_gdp,
		ROUND((((gdp - LAG(gdp) OVER (ORDER BY year)) / NULLIF(LAG(gdp) OVER (ORDER BY year), 0)) * 100)::numeric, 2) 
		AS percentage_change_gdp
	FROM 
		t_marketa_zarska_project_sql_secondary_final tmzpssf
	WHERE 
		country = 'Czech Republic'
),
wages_1 AS (
	SELECT
		payroll_year,
		ROUND(AVG(average_wage), 2) AS avg_average_wage
	FROM
		t_marketa_zarska_project_sql_primary_final tmzpspf
	GROUP BY
		payroll_year
),
prices_1 AS (
	SELECT
		price_year,
		ROUND(AVG(average_price), 2) AS avg_average_price
	FROM
		t_marketa_zarska_project_sql_primary_final tmzpspf
	WHERE
		price_category_code != '212101'
	GROUP BY
		price_year
), 
wages_2 AS (
	SELECT 
		payroll_year,
		avg_average_wage,
		LAG(avg_average_wage) OVER (ORDER BY payroll_year) AS previous_wage,
		ROUND(((avg_average_wage - LAG(avg_average_wage) OVER (ORDER BY payroll_year)) / NULLIF(LAG(avg_average_wage) 
		OVER (ORDER BY payroll_year), 0)) * 100, 2) AS percentage_change_wage
	FROM 
		wages_1
),
prices_2 AS (
	SELECT 
		price_year,
		avg_average_price,
		LAG(avg_average_price) OVER (ORDER BY price_year) AS previous_price,
		ROUND(((avg_average_price - LAG(avg_average_price) OVER (ORDER BY price_year)) / NULLIF(LAG(avg_average_price) 
		OVER (ORDER BY price_year), 0)) * 100, 2) AS percentage_change_price
	FROM 
		prices_1
),
wages_prices AS (
	SELECT
		w.payroll_year,
		w.avg_average_wage,
		w.percentage_change_wage,
		p.avg_average_price,
		p.percentage_change_price
	FROM 
		wages_2 w
	JOIN prices_2 p
		ON w.payroll_year = p.price_year
),
gdp_wages_prices AS (
	SELECT 
		e.year,
		e.percentage_change_gdp,
		wp.percentage_change_wage,
		LEAD(wp.percentage_change_wage) OVER (ORDER BY e.year) AS next_year_wage_change,
		wp.percentage_change_price,
		LEAD(wp.percentage_change_price) OVER (ORDER BY e.year) AS next_year_price_change
	FROM 
		cz_economy e
	JOIN wages_prices wp
		ON e.year = wp.payroll_year
)
SELECT
	ROUND(CORR(percentage_change_gdp, percentage_change_wage)::numeric, 2) AS corr_gdp_wage_same_year,
	ROUND(CORR(percentage_change_gdp, next_year_wage_change)::numeric, 2) AS corr_gdp_wage_next_year,
	ROUND(CORR(percentage_change_gdp, percentage_change_price)::numeric, 2) AS corr_gdp_price_same_year,
	ROUND(CORR(percentage_change_gdp, next_year_price_change)::numeric, 2) AS corr_gdp_price_next_year
FROM 
	gdp_wages_prices;
