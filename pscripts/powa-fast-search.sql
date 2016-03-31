SELECT qualid, powa_statements.queryid, query, powa_statements.dbid, to_json(quals) AS quals, sum(execution_count) AS execution_count, sum(occurences) AS occurences, sum(nbfiltered) / sum(occurences) AS avg_filter, CASE WHEN (sum(execution_count) = 0) THEN 0 ELSE (sum(nbfiltered) / CAST(sum(execution_count) AS NUMERIC)) * 100 END AS filter_ratio
FROM
(
SELECT queryid, qualid, (unnested.records).*
FROM (
    SELECT pqnh.qualid, pqnh.queryid, pqnh.dbid, pqnh.userid, pqnh.coalesce_range, unnest(records) as records
    FROM powa_qualstats_quals_history pqnh
    /*WHERE coalesce_range  && tstzrange(?, ?, ?)*/
) AS unnested
/*WHERE tstzrange(?, ?, ?) @> (records).ts*/
UNION ALL
SELECT queryid, qualid, pqnc.ts, pqnc.occurences, pqnc.execution_count, pqnc.nbfiltered
FROM powa_qualstats_quals_history_current pqnc
/*WHERE tstzrange(?, ?, ?) @> pqnc.ts*/
) h
JOIN powa_qualstats_quals pqnh USING (queryid, qualid)
 JOIN powa_statements ON powa_statements.queryid = pqnh.queryid
/*WHERE powa_statements.queryid = ? */
GROUP BY qualid, powa_statements.queryid, powa_statements.dbid, powa_statements.query, quals
