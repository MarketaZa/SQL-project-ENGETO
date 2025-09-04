# SQL-project-ENGETO
# ZADÁNÍ

Úvod do projektu
Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.
Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.
Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.
﻿
Výzkumné otázky
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

# Primární tabulka
Primární tabulka byla vytvořena pomocí následujících 4 datových sad:
1. czechia_payroll
- data mezi lety 2000-2021
- v tabulce jsou prohozené hodnoty unit_code a value_type_code, k hodnotě value_type_code 5958 (průměrná hrubá mzda na zaměstnance) je uvedena unit_code 200 (tis. osob) a u value_type_ode 316 (průměrný počet zamětnaných osob) je unit_code 80403 (Kč) - chyba, která nemá vliv na naše data
2. czechia_payroll_industry_branch - přidělení názvu odvětví průmyslu ke kódu pro přehlednost
3. czechia_price
- data mezi lety 2006-2018, výjimku tvoří víno, které má dostupná data až od roku 2015
4. czechia_price_category - přidělení názvu zboží ke kódu pro přehlednost

1. První CTE
Filtrování hodnot
- value_type_code 5958 - průměrná hrubá mzda na zaměstnance
- calculation_code 200 - přepočtený
- industry_branch_code IS NOT NULL - ignoruji záznamy bez přiděleného odvětví protože nevím, k čemu tyto hodnoty patří
Vypočítání průměrné mzdy za rok - záznamy jsou uvedené v kvartálech, potřebujeme srovnatelné období s tabulkou czechia_price

2. Druhé CTE
Filtrování hodnoty
- region_code IS NULL - potřebujeme pouze informace pro celou Českou republiku, nikoliv rozdělení do krajů
Vypočítání průměrné ceny za rok - srovnatelné období s tab. czechia_payroll, potřeba vyselektovat pouze rok ze sloupce date_from (timestamp)

3. spojení obou CTE na základě roku, použit INNER JOIN, protože chceme pouze stejná porovnatelná období (2006-2018)

# Sekundární tabulka
Sekundární tabulka byla vytvořená pomocí datových sad
1. economies
2. countries

1. první a druhé CTE
Filtrování hodnot z tabulky economies a countries
- pouze unikátní hodnoty - v obou tabulkách jsou všechny hodnoty zdvojené
- pouze srovnatelné období s primární tabulkou - tj. období mezi lety 2006 - 2018

2. spojení obou CTE na základě názvu státu pomocí left join a vyselektování údajů, které by mohly být zajímavé pro konferenci.

# OTÁZKY A ODPOVĚDI
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

Ve všech odvětvích pravidelně roste mzda. Pouze u dvou odvětví byly zaznamenány poklesy mezd ve více než dvou letech - v odvětví B (Těžba a dobývání) v letech 2009, 2013, 2014, 2016 a v odvětví D (Výroba a rozvod elektřiny..) v letech 2011, 2013, 2015.
V ostatní odvětvích jsou záznamy o 0 - 2 letech, kdy došlo k poklesu mezd a to mezi léty 2009-2013, což má pravděpodobně souvislost s tehdejší ekonomickou krizí.
Největší pokles o necelých 9 %  byl zaznamenán v odvětví peněžnictví a pojišťovnictví v roce 2013.
Naopak největší nárust mezd byl v roce 2008 ve dvou odvětvích - odvětví Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu a odvětví Těžba a dobývání. Nárůst mezd byl více než 13 %.

2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

Lidé pracující v jednotlivých odvětvích si mohli dovolit koupit průměrně o 200 litrů mléka méně v roce 2006 než v roce 2018. Většinou se celkové množství litrů mléka pohybovalo mezi 1000-2000 litry v obou těchto obdobích. Nejmenší kupní sílu pak měli lidé pracující v pohostinství, kteří nedosáhli na 1000 litrů mléka ani v jednom z porovnávaných období. Nejvíce si polepšili lidé pracující ve zdravotní a sociální péči.
Chleba si mohli lidé z jednotlivých odvětvích koupit průměrně o 50 kg více v roce 2018 než v roce 2006. Většinou se celkové množství kg chleba pohybovalo mezi 1000-2000 kg v obou těchto obdobích. Pokles kupní síly byl zaznamenán v odvětví peněžnictví a pojišťovnictví, kteří se však stále pohybují výrazně nad průměrnou kupní silou většiny ostatních odvětvích.

3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

Nejpomaleji zdražuje cukr krystal, který dokonce zlevňuje a jeho celková změna v ceně za období 2006-2018 činí -1,92 %. Jediná další potravina která celkově zlevňuje jsou rajská jablka. Největší zdražení pak zaznamenaly papriky (více než 7 %).

4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

Mezi lety 2007 - 2018 neexistuje rok, kde by byl meziroční nárůst cen potravin o více než 10 % vyšší než nárůst mezd. Nejvyšší hodnota byla zaznamenána v roce 2013, kde průměrná cena potravin vzrostla o více než 5 %, zatímco mzdy lehce klesly (0 1,5 %) a rozdíl tak činil 6,66 %.
Nejvýraznější rozdíl mezi růstem cenou potravin a mezd lze vidět v roce 2009, kde je však opačný trend, neboť došlo k výraznému poklesu cen potravin a lehkému nárust mezd a rozdíl tak činil 9,5 %.

5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

Výsledkem jsou čtyři hodnoty:
1. korelace HDP s průměrnou mzdou tentýž rok: 0,44 - středně silná pozitivní korelace.
2. korelace HDP s průměrnou mzdou následující rok: 0,68 - silnější pozitvní korelace než předchozí hodnota.
3. korelace HDP s průměrnou cenou potravin tentýž rok: 0,41 - středně silná pozitivní korelace.
4. korelace HDP s průměrnou cenou potravin následující rok: -0,04 - nulová korelace.

Výsledky ukazují, že HDP má středně silný pozitivní vztah k průměrné mzdě, přičemž v následujícím roce je tento vztah ještě výraznější, což naznačuje zpožděný dopad růstu HDP na mzdy. U cen potravin se také objevuje středně silná pozitivní korelace ve stejném roce, která však v roce následujícím zaniká.
