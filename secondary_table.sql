--Sekundární tabulka
CREATE TABLE t_marketa_zarska_project_SQL_secondary_final AS
	WITH economy_new AS (
		SELECT DISTINCT *
		FROM
			economies e
		WHERE
			YEAR BETWEEN 2006 AND 2018
	),
	country_new AS (
		SELECT DISTINCT *
		FROM
			countries c
	)
	SELECT 
		en.country,
		en.year,
		en.gdp,
		en.population,
		en.gini,
		cn.abbreviation,
		cn.capital_city,
		cn.continent,
		cn.currency_name,
		cn.population_density
	FROM
		economy_new en
	LEFT JOIN country_new cn
		ON en.country = cn.country
