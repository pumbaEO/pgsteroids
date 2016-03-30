SELECT c.oid,
  n.nspname,
  c.relname
FROM pg_catalog.pg_class c
     LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relname ~ '^(вставь имя таблицы)$'
  AND pg_catalog.pg_table_is_visible(c.oid)
ORDER BY 2, 3;
