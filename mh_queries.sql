--****PLEASE ENTER YOUR DETAILS BELOW****
--mh-queries.sql

--Student ID: 32192673
--Student Name: Prachi Jaiswal
--Tutorial No: 23

/* Comments for your marker:




*/


/*
   Q1
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer

SELECT
    ht_nbr,
    emp_nbr,
    emp_lname,
    emp_fname,
    to_char(end_last_annual_review, 'Dy dd Mon yyyy') AS review_date
FROM
         mh.endorsement
    JOIN mh.employee USING ( emp_nbr )
WHERE
    end_last_annual_review > TO_DATE('31/Mar/2020', 'dd/Mon/yyyy')
ORDER BY
    end_last_annual_review;


/*
    Q2
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer

SELECT
    charter_nbr,
    client_nbr,
    client_lname,
    client_fname,
    charter_special_reqs
FROM
         mh.charter
    JOIN mh.client USING ( client_nbr )
WHERE
    charter_special_reqs IS NOT NULL
ORDER BY
    charter_nbr;


/*
    Q3
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer

SELECT
    charter_nbr,
    ltrim(rpad(client_fname
               || ' '
               || client_lname, 20, ' ')) AS fullname,
    charter_cost_per_hour
FROM
         mh.charter
    JOIN mh.client USING ( client_nbr )
    JOIN mh.charter_leg USING ( charter_nbr )
WHERE
        location_nbr_destination = (
            SELECT
                location_nbr
            FROM
                mh.location
            WHERE
                upper(location_name) = upper('Mount Doom')
        )
    AND ( charter_cost_per_hour < 1000
          OR charter_special_reqs IS NULL )
ORDER BY
    fullname DESC;


/*
    Q4
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer

SELECT
    ht_nbr,
    ht_name,
    COUNT(ht_nbr) AS helicopters_owned
FROM
         mh.helicopter_type
    JOIN mh.helicopter USING ( ht_nbr )
GROUP BY
    ht_nbr,
    ht_name
HAVING
    COUNT(ht_nbr) >= 2
ORDER BY
    helicopters_owned DESC;


/*
    Q5
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer

SELECT
    location_nbr,
    location_name,
    COUNT(location_nbr_origin) AS used_as_origin
FROM
         mh.location l
    JOIN mh.charter_leg c ON l.location_nbr = c.location_nbr_origin
GROUP BY
    location_nbr,
    location_name
HAVING
    COUNT(location_nbr_origin) > 1
ORDER BY
    used_as_origin;

/*
    Q6
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer

SELECT
    t.ht_nbr,
    ht_name,
    lpad(to_char(nvl(SUM(heli_hrs_flown), 0), '9990.99'), 10, ' ') AS flight_time_in_hrs
FROM
    mh.helicopter_type    t
    LEFT OUTER JOIN mh.helicopter         h ON t.ht_nbr = h.ht_nbr
GROUP BY
    t.ht_nbr,
    ht_name
ORDER BY
    flight_time_in_hrs;


/*
    Q7
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer

SELECT
    c.charter_nbr,
    lpad(to_char(l.cl_atd, 'dd-Mon-yyyy hh.mm.ss'), 25, ' ') AS departure_date_time
FROM
    mh.charter        c
    RIGHT OUTER JOIN mh.charter_leg    l ON ( c.charter_nbr = l.charter_nbr )
WHERE
    c.charter_nbr NOT IN (
        SELECT
            charter_nbr
        FROM
            mh.charter_leg
        WHERE
            cl_ata IS NULL
    )
    AND l.cl_leg_nbr = 1
    AND c.emp_nbr = (
        SELECT
            emp_nbr
        FROM
            mh.employee
        WHERE
                lower(emp_lname) = lower('Baggins')
            AND lower(emp_fname) = lower('Frodo')
    )
ORDER BY
    l.cl_atd DESC;


/*
    Q8
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer

SELECT
    charter_nbr,
    t1.client_nbr,
    client_lname,
    nvl(client_fname, '-')                            AS client_fname,
    lpad(to_char(cost, '$990.00'), 17, ' ')           AS totalchartercost
FROM
         (
        SELECT
            charter_nbr,
            client_nbr,
            SUM((cl_ata - cl_atd) * 24 * charter_cost_per_hour) AS cost
        FROM
                 mh.charter
            NATURAL JOIN mh.charter_leg
        WHERE
            charter_nbr NOT IN (
                SELECT
                    charter_nbr
                FROM
                    mh.charter_leg
                WHERE
                    cl_ata IS NULL
            )
        GROUP BY
            charter_nbr,
            client_nbr
    ) t1
    JOIN mh.client t ON t.client_nbr = t1.client_nbr
WHERE
    cost < (
        SELECT
            AVG(cost)
        FROM
            (
                SELECT
                    charter_nbr,
                    client_nbr,
                    SUM((cl_ata - cl_atd) * 24 * charter_cost_per_hour) AS cost
                FROM
                         mh.charter
                    NATURAL JOIN mh.charter_leg
                WHERE
                    charter_nbr NOT IN (
                        SELECT
                            charter_nbr
                        FROM
                            mh.charter_leg
                        WHERE
                            cl_ata IS NULL
                    )
                GROUP BY
                    charter_nbr,
                    client_nbr
            )
    )
ORDER BY
    totalchartercost DESC;
 

/*
    Q9
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer

SELECT
    charter_nbr,
    ltrim(rpad(emp_fname
               || ' '
               || emp_lname, 20, ' '))          AS pilotname,
    ltrim(rpad(client_fname
               || ' '
               || client_lname, 20, ' '))       AS clientname
FROM
         mh.charter
    JOIN mh.client USING ( client_nbr )
    JOIN mh.employee USING ( emp_nbr )
WHERE
    charter_nbr NOT IN (
        SELECT DISTINCT
            charter_nbr
        FROM
            mh.charter_leg
        WHERE
            cl_etd <> cl_atd
    )
ORDER BY
    charter_nbr;

/*
    Q10
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answe

SELECT
    client_nbr,
    clientname,
    location_name AS destination_name,
    times_visited
FROM
         (
        SELECT
            client_nbr,
            ltrim(rpad(client_fname
                       || ' '
                       || client_lname, 20, ' '))          AS clientname,
            location_nbr_destination,
            location_name,
            COUNT(location_nbr_destination)     AS times_visited
        FROM
                 mh.charter_leg
            NATURAL JOIN mh.charter
            NATURAL JOIN mh.client
            NATURAL JOIN mh.location
        WHERE
            cl_ata IS NOT NULL
            AND location_nbr_destination = location_nbr
        GROUP BY
            client_nbr,
            location_name,
            location_nbr_destination,
            ltrim(rpad(client_fname
                       || ' '
                       || client_lname, 20, ' '))
    ) p
    NATURAL JOIN (
        SELECT
            client_nbr,
            MAX(times_visited) AS maxcount
        FROM
            (
                SELECT
                    client_nbr,
                    location_nbr_destination,
                    COUNT(location_nbr_destination) AS times_visited
                FROM
                         mh.charter_leg
                    NATURAL JOIN mh.charter
                    NATURAL JOIN mh.client
                WHERE
                    cl_ata IS NOT NULL
                GROUP BY
                    client_nbr,
                    location_nbr_destination
            )
        GROUP BY
            client_nbr
    ) m
WHERE
        times_visited = maxcount
    AND client_nbr = client_nbr
GROUP BY
    client_nbr,
    location_name,
    times_visited,
    clientname
ORDER BY
    client_nbr,
    destination_name;