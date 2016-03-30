SELECT a.attname,                                                                                                                                          pg_catalog.format_type(a.atttypid, a.atttypmod),
  (SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128)
   FROM pg_catalog.pg_attrdef d
   WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef),
  a.attnotnull, a.attnum,
  (SELECT c.collname FROM pg_catalog.pg_collation c, pg_catalog.pg_type t
   WHERE c.oid = a.attcollation AND t.oid = a.atttypid AND a.attcollation <> t.typcollation) AS attcollation,
  NULL AS indexdef,
  NULL AS attfdwoptions,
  a.attstorage,
  CASE WHEN a.attstattarget=-1 THEN NULL ELSE a.attstattarget END AS attstattarget, pg_catalog.col_description(a.attrelid, a.attnum)
FROM pg_catalog.pg_attribute a
WHERE a.attrelid = 'здесьIDтаблицы' AND a.attnum > 0 AND NOT a.attisdropped
ORDER BY a.attnum;

#if the storage is main or extended, it means the data in given column is compressed (PostgreSQL uses very fast compression algorithm from the LZ family).
