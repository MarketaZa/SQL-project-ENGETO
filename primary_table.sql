--Primární tabulka

CREATE TABLE t_marketa_zarska_project_SQL_primary_final AS 
	WITH cz_payroll AS (
		SELECT 
			cpay.payroll_year,
			cpay.industry_branch_code,
			cpib.name AS industry_name,
			round(avg(cpay.value)::NUMERIC) AS average_wage
		FROM
			czechia_payroll cpay
		LEFT JOIN czechia_payroll_industry_branch cpib
			ON cpay.industry_branch_code = cpib.code
		WHERE
			cpay.value_type_code = '5958'
			AND cpay.calculation_code = '200'
			AND cpay.industry_branch_code IS NOT NULL
		GROUP BY
			cpay.industry_branch_code,
			cpib.name,
			cpay.payroll_year
	),
	cz_price AS (
		SELECT
			cp.category_code AS price_category_code,
			cpc.name AS product,
			date_part('year', cp.date_from) AS price_year,
			round(avg(cp.value)::NUMERIC, 2) AS average_price
		FROM
			czechia_price cp
		LEFT JOIN czechia_price_category cpc
			ON cp.category_code = cpc.code
		WHERE
			cp.region_code IS NULL
		GROUP BY
			cp.category_code,
			cpc.name,
			date_part('year', cp.date_from)
	)
	SELECT 
		czpay.*,
		czpr.*
	FROM 
		cz_payroll czpay
	INNER JOIN cz_price czpr
		ON czpay.payroll_year = czpr.price_year;



