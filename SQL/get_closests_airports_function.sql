{\rtf1\ansi\ansicpg1252\cocoartf1348\cocoasubrtf170
{\fonttbl\f0\fmodern\fcharset0 CourierNewPSMT;}
{\colortbl;\red255\green255\blue255;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural

\f0\fs28 \cf0 \
CREATE FUNCTION get_closest_airports(countrya text, countryb text) RETURNS TABLE(city1 character varying, iata1 character varying, city2 character varying, iata2 character varying, distance double precision)\
    LANGUAGE plpgsql STABLE\
    AS $_$\
    BEGIN\
      RETURN QUERY\
      SELECT \
        a.city, \
        a.iata_faa,\
        b.city,\
        b.iata_faa,\
        md.min_distance\
      FROM\
        airports AS a, airports AS b,\
        (\
            SELECT \
              aa.point,\
              ab.point,\
              min(st_distance(aa.point,ab.point))  AS min_distance\
            FROM\
              airports AS aa, \
              airports AS ab \
            WHERE\
              aa.country = $1 AND ab.country = $2\
            GROUP BY 1,2\
            ORDER BY aa.point <-> ab.point::geometry limit 1\
        ) AS md \
         \
      WHERE\
        a.country = $1 AND b.country = $2 AND \
        st_distance(a.point, b.point) = md.min_distance\
      GROUP BY 1,2,3,4,5\
      ;\
    END;\
  $_$;\
\
\
ALTER FUNCTION public.get_closest_airports(countrya text, countryb text) OWNER TO postgres;\
\
SET default_tablespace = '';\
\
SET default_with_oids = false;}