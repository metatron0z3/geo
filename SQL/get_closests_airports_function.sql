CREATE FUNCTION get_closest_airports(countrya text, countryb text) RETURNS TABLE(city1 character varying, iata1 character varying, city2 character varying, iata2 character varying, distance double precision)\
    LANGUAGE plpgsql STABLE
    AS $_$
    BEGIN
      RETURN QUERY
      SELECT 
        a.city, 
        a.iata_faa,
        b.city,
        b.iata_faa,
        md.min_distance
      FROM
        airports AS a, airports AS b,
        (
            SELECT 
              aa.point,
              ab.point,
              min(st_distance(aa.point,ab.point))  AS min_distance
            FROM
              airports AS aa, 
              airports AS ab 
            WHERE
              aa.country = $1 AND ab.country = $2
            GROUP BY 1,2
            ORDER BY aa.point <-> ab.point::geometry limit 1
        ) AS md 
         
      WHERE
        a.country = $1 AND b.country = $2 AND 
        st_distance(a.point, b.point) = md.min_distance
      GROUP BY 1,2,3,4,5
      ;
    END;
  $_$;


ALTER FUNCTION public.get_closest_airports(countrya text, countryb text) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;}