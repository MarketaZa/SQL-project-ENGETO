-- ukol 1

WITH wages_1 AS (
	SELECT DISTINCT 
		average_wage,
		industry_branch_code,
		industry_name,
		payroll_year
	FROM
		t_marketa_zarska_project_sql_primary_final tmzpspf
),
wages_2 AS (
	SELECT
		average_wage,
		industry_branch_code,
		industry_name,
		payroll_year,
		LAG(average_wage) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) AS previous_wage,
		average_wage - LAG(average_wage) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) AS difference
	FROM
		wages_1
)
SELECT 
	industry_branch_code,
	industry_name,
	payroll_year,
	average_wage,
	previous_wage,
	difference,
	CASE
		WHEN difference > 0 THEN 'increase'
		WHEN difference < 0 THEN 'decrease'
		WHEN difference IS NULL THEN 'initial value'
		ELSE 'stagnation'
	END AS conclusion,
	CASE
		WHEN previous_wage IS NULL THEN NULL
		WHEN previous_wage = 0 THEN NULL
		ELSE ROUND((difference::NUMERIC / previous_wage::NUMERIC) * 100, 2)
	END AS percentage_change
FROM
	wages_2
ORDER BY
	industry_branch_code,
	payroll_year;

