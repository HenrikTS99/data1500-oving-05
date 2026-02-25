## Oppgavesett 2.1: Introduksjon til SQL-spørringer

### Oppsett

1.  **Lag en mappe** for oppgavesettet, f.eks. `data1500-oving-2-1`.
2.  **Opprett undermapper:** `init-scripts` og `test-scripts`.
3.  **Last ned `hobbyhuset.sql`** og plasser den i `init-scripts`.
4.  **Lag en `docker-compose.yml`**-fil i rotmappen (se eksempel under).
5.  **Lag en fil `besvarelse.sql`** i `test-scripts` for SQL-oppgavene.

**Kommentar til alle oppgavene**: noen av spørringene vil returnere ingen rader, så beskriv gjerne hvordan du kan bevise at spørringen din er logisk korrekt (husk logisk ekvivalente spørringer vi snakket om på forelesning 25.2.26). 

**Eksempel `docker-compose.yml`:**
```yaml
services:
  postgres:
    image: postgres:15-alpine
    container_name: hobbyhuset
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: admin123
      POSTGRES_DB: hobbyhuset
    ports:
      - "5432:5432"
    volumes:
      - postgres_data_hobbyhuset:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d
      - ./test-scripts:/test-scripts
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U admin -d hobbyhuset"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  postgres_data_hobbyhuset:
    driver: local

networks:
  data1500-hobbyhuset-network:
    driver: bridge
```

### Oppgave 1: Grunnleggende Spørringer mot Én Tabell

#### Del 1: Forklar SQL-spørringene (skriv i `besvarelse-sql-analyse.md`)

1.  `SELECT * FROM Vare;`
2.  `SELECT VNr, Betegnelse FROM Vare;`
3.  `SELECT DISTINCT KatNr FROM Vare;
4.  `SELECT Fornavn, Etternavn, Stilling AS Jobbtittel FROM Ansatt;`

#### Del 2: Lag SQL-spørringer (skriv i `besvarelse.sql`)

1.  Finn alle data om alle kunder. Vis kun de 20 siste fra resultatrelasjonen (tips: bruke delspørring).
2.  Finn fornavn og etternavn til alle ansatte. Vis kun de 10 første radene fra resultatrelasjonen.
3.  Finn alle unike stillinger som finnes i `Ansatt`-tabellen.
4.  Finn varenummer, betegnelse og pris for alle varer.
5.  Finn navn og kategori-nummer for alle kategorier, men døp om kolonnene til `Kategorinavn` og `KategoriID`.
6.  Finn ut hvor mange rader vil en kryssprodukt mellom kunder og ordrer ha.

### Oppgave 2: WHERE-klausulen og Betingelser

#### Del 1: Forklar SQL-spørringene (skriv i `besvarelse-sql-analyse.md`)

1.  `SELECT * FROM Vare WHERE Pris > 500;`
2.  `SELECT * FROM Ansatt WHERE Stilling = 'Kundebehandler' AND Årslønn > 480000 AND Kjønn = 'K';`f
3.  `SELECT Fornavn, Etternavn FROM Kunde WHERE PostNr = '0015' OR PostNr = '0952';` 1
4.  `SELECT Betegnelse FROM Vare WHERE NOT KatNr = 1;`

#### Del 2: Lag SQL-spørringer (skriv i `besvarelse.sql`)

1.  Finn alle varer som koster mellom 200 og 500 (inkludert).
2.  Finn alle ansatte som er 'Lagermedarbeider' eller 'Innkjøper'.
3.  Finn alle kunder som bor i postnummer '3199' eller '1711' og hvis fornavn starter med 'A'.
4.  Finn alle varer som ikke er i kategori 1 og som har mer enn 600 på lager.
5.  Finn alle ordrer som ble sendt, men ikke betalt.
6.  Finn alle ansatte hvis etternavn inneholder 'sen' (ikke case-sensitivt).

### Oppgave 3: Gruppering, Sortering og Aggregering

#### Del 1: Forklar SQL-spørringene (skriv i `besvarelse-sql-analyse.md`)

1.  `SELECT * FROM Vare ORDER BY Pris DESC;`
2.  `SELECT KatNr, COUNT(*) FROM Vare GROUP BY KatNr;`
3.  `SELECT Stilling, AVG(Årslønn) FROM Ansatt GROUP BY Stilling;`
4.  `SELECT KatNr, SUM(Antall) FROM Vare GROUP BY KatNr HAVING SUM(Antall) > 500;`

#### Del 2: Lag SQL-spørringer (skriv i `besvarelse.sql`)

1.  Finn antall kunder per postnummer.
2.  Finn gjennomsnittlig pris for hver kategori.
3.  Finn den dyreste varen i hver kategori.
4.  List opp alle stillinger og antall ansatte i hver stilling, sortert synkende etter antall.
5.  Finn totalt antall varer på lager for hver kategori, men vis kun kategorier med mer enn 1000 varer totalt.
6.  Finn den eldste og yngste ansatte.

### Oppgave 4: Spørringer mot Flere Tabeller og Joins

#### Del 1: Forklar SQL-spørringene (skriv i `besvarelse-sql-analyse.md`)

1.  `SELECT V.Betegnelse, K.Navn FROM Vare V JOIN Kategori K ON V.KatNr = K.KatNr;`
2.  `SELECT O.OrdreNr, K.Fornavn, K.Etternavn FROM Ordre O LEFT JOIN Kunde K ON O.KNr = K.KNr;`
3.  `SELECT A1.Fornavn, A2.Fornavn FROM Ansatt A1, Ansatt A2 WHERE A1.PostNr = A2.PostNr AND A1.AnsNr < A2.AnsNr;`
4.  `SELECT V.Betegnelse FROM Vare V WHERE V.VNr NOT IN (SELECT VNr FROM Ordrelinje);`

#### Del 2: Lag SQL-spørringer (skriv i `besvarelse.sql`)

1.  Finn navn på alle kunder og poststedet de bor i. Vis kun de første 20 rader fra resultatrelasjon. 
2.  Finn navn på alle varer og navnet på kategorien de tilhører. Vis kun de første 20 rader fra resultatrelasjon. 
3.  Finn alle ordrer med kundenavn og ordredato. Vis kun de første 20 rader fra resultatrelasjon. 
4.  Finn alle varer som aldri har blitt solgt (dvs. ikke finnes i `Ordrelinje`).
5.  Finn totalt antall solgte enheter for hver vare (bruk `Ordrelinje`).
6.  Finn navnet på alle ansatte som bor i Bø i Telemark.


OBS! For å kunne løse oppgavene 5 og 6, må man utvide databaseskjema for hobbyhuset og legge inn noen testdata. Det kan gjøres med følgende kommandoen fra mappen hvor denne filen ligger:
```bash
docker-compose exec postgres psql -U admin -d hobbyhuset -f test-scripts/hobbyhuset_utvidet_05-6.sql
```


### Oppgave 5: NULL-verdier og Aggregeringsfunksjoner

I denne oppgaven skal vi utforske hvordan SQL håndterer `NULL`-verdier, spesielt i kombinasjon med aggregeringsfunksjoner som `COUNT`, `SUM`, og `AVG`.

#### Del 1: Forklar SQL-spørringene

Forklar hva følgende SQL-spørringer gjør, og hvorfor resultatene blir som de blir. Vær spesielt oppmerksom på hvordan `NULL` påvirker resultatet.

1.  **Spørring:**
    ```sql
    SELECT COUNT(*), COUNT(Bonus) FROM Ansatt;
    ```
2.  **Spørring:**
    ```sql
    SELECT AVG(Bonus) FROM Ansatt;
    ```
3.  **Spørring:**
    ```sql
    SELECT Fornavn, Etternavn, COALESCE(Bonus, 0) AS JustertBonus FROM Ansatt;
    ```
4.  **Spørring:**
    ```sql
    SELECT Stilling, SUM(Årslønn + Bonus) FROM Ansatt GROUP BY Stilling;
    ```

### Del 2: Lag SQL-spørringer

Skriv SQL-spørringer for å hente ut følgende informasjon fra `hobbyhuset`-databasen.

1.  Finn antall ansatte som **ikke** har fått bonus.
2.  Beregn gjennomsnittlig bonus for alle ansatte, men behandle de som ikke har fått bonus som om de har 0 i bonus.
3.  List opp alle kunder som **ikke** har registrert et telefonnummer.
4.  Finn den totale lønnskostnaden (Årslønn + Bonus) for alle ansatte. Pass på at ansatte uten bonus også blir med i den totale summen.
5.  List opp alle stillinger og antall ansatte i hver stilling som har en bonus registrert.
6.  Finn den laveste bonusen som er gitt ut (ignorer de som ikke har fått bonus).

### Oppgave 6: Tre-verdi Logikk (TRUE, FALSE, UNKNOWN)

SQLs logikk er ikke bare `TRUE` eller `FALSE`. Når `NULL` er involvert, får vi en tredje tilstand: `UNKNOWN`. Denne oppgaven utforsker hvordan dette påvirker `WHERE`-klausuler.

#### Del 1: Forklar SQL-spørringene

Forklar resultatet av følgende SQL-spørringer. Hvorfor returnerer de det de gjør?

1.  **Spørring:**
    ```sql
    SELECT COUNT(*) FROM Ordre WHERE ErBetalt = TRUE;
    ```
2.  **Spørring:**
    ```sql
    SELECT COUNT(*) FROM Ordre WHERE ErBetalt = FALSE;
    ```
3.  **Spørring:**
    ```sql
    SELECT COUNT(*) FROM Ordre WHERE ErBetalt = TRUE OR ErBetalt = FALSE;
    ```
4.  **Spørring:**
    ```sql
    SELECT COUNT(*) FROM Ordre WHERE ErBetalt IS UNKNOWN;
    ```

#### Del 2: Lag SQL-spørringer

Skriv SQL-spørringer for å hente ut følgende informasjon.

1.  Finn alle ordrer som **verken** er bekreftet betalt eller bekreftet ikke-betalt (dvs. de hvor logikken er `UNKNOWN`).
2.  List opp alle ansatte som har en bonus som er enten `NULL` eller mindre enn 6000.
3.  Finn antall kunder som **ikke** har telefonnummer `41234567` (pass på å inkludere de med `NULL` telefonnummer i tellingen).
4.  List opp alle ordrer som er betalt (`ErBetalt = TRUE`), men hvor `SendtDato` er `NULL`.



