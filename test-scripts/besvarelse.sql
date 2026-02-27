-- Finn alle data om alle kunder. Vis kun de 20 siste fra resultatrelasjonen (tips: bruke delspørring).
SELECT * FROM kunde ORDER BY knr DESC LIMIT 20;


-- Finn fornavn og etternavn til alle ansatte. Vis kun de 10 første radene fra resultatrelasjonen.
SELECT fornavn, etternavn FROM ansatt ORDER BY fornavn LIMIT 10;


-- Finn alle unike stillinger som finnes i Ansatt-tabellen.
SELECT DISTINCT stilling FROM ansatt;


-- Finn varenummer, betegnelse og pris for alle varer.
SELECT vnr, betegnelse, pris FROM vare;


-- Finn navn og kategori-nummer for alle kategorier, men døp om kolonnene til Kategorinavn og KategoriID.
SELECT katnr AS kategoriID, navn AS kategorinavn FROM kategori;


-- Finn ut hvor mange rader vil en kryssprodukt mellom kunder og ordrer ha.
SELECT COUNT(*) FROM kunde, ordre

-- Del 2

-- Finn alle varer som koster mellom 200 og 500 (inkludert).
SELECT * FROM vare WHERE pris >= 200 AND pris <= 500 ORDER BY pris;


-- Finn alle ansatte som er 'Lagermedarbeider' eller 'Innkjøper'.
SELECT * FROM ansatt WHERE stilling IN('Lagermedarbeider', 'Innkjøper');


-- Finn alle kunder som bor i postnummer '3199' eller '1711' og hvis fornavn starter med 'A'.
SELECT * FROM kunde WHERE postnr IN ('3199', '1711') AND fornavn LIKE ('A%');


-- Finn alle varer som ikke er i kategori 1 og som har mer enn 600 på lager.
SELECT * FROM vare WHERE katnr NOT IN (1) AND antall > 600;


-- Finn alle ordrer som ble sendt, men ikke betalt.
SELECT * FROM ordre WHERE sendtdato IS NOT NULL AND betaltdato IS NULL;


-- Finn alle ansatte hvis etternavn inneholder 'sen' (ikke case-sensitivt).
SELECT * FROM ansatt WHERE etternavn ILIKE ('%sen');

-- Del 3

-- Finn antall kunder per postnummer.
SELECT postnr, COUNT(*) FROM kunde GROUP BY postnr ORDER BY COUNT DESC;



-- Finn gjennomsnittlig pris for hver kategori.
SELECT v.katnr,
    k.navn,
    AVG(v.pris) AS gjenomsnitt
FROM vare v
JOIN kategori k ON k.katnr = v.katnr
GROUP BY v.katnr, k.navn
ORDER BY gjenomsnitt DESC;


-- Finn den dyreste varen i hver kategori.
SELECT v.katnr,
    k.navn,
    MAX(v.pris) AS dyreste
FROM vare v
JOIN kategori k ON k.katnr = v.katnr
GROUP BY v.katnr, k.navn
ORDER BY dyreste DESC;


-- List opp alle stillinger og antall ansatte i hver stilling, sortert synkende etter antall.
SELECT stilling, COUNT(stilling)
FROM ansatt
GROUP BY stilling
ORDER BY COUNT DESC;


-- Finn totalt antall varer på lager for hver kategori, men vis kun kategorier med mer enn 1000 varer totalt.
SELECT v.navn, v.katnr, SUM(antall) AS total_antall 
FROM vare v
JOIN kategori k ON k.katnr = v.katnr
GROUP BY v.katnr, k.navn
HAVING SUM(antall) > 1000
ORDER BY total_antall DESC;


-- Finn den eldste og yngste ansatte.
SELECT * FROM ansatt
WHERE fødselsdato =
    (SELECT MAX(fødselsdato) FROM ansatt)
OR fødselsdato =
    (SELECT MIN(fødselsdato) FROM ansatt);


-- Del 4


-- Finn navn på alle kunder og poststedet de bor i. Vis kun de første 20 rader fra resultatrelasjon.

-- Finn navn på alle varer og navnet på kategorien de tilhører. Vis kun de første 20 rader fra resultatrelasjon.

-- Finn alle ordrer med kundenavn og ordredato. Vis kun de første 20 rader fra resultatrelasjon.

-- Finn alle varer som aldri har blitt solgt (dvs. ikke finnes i Ordrelinje).

-- Finn totalt antall solgte enheter for hver vare (bruk Ordrelinje).

-- Finn navnet på alle ansatte som bor i Bø i Telemark.

