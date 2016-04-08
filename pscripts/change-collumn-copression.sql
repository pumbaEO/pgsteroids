ALTER TABLE <table-name> ALTER <column> SET STORAGE EXTENDED;

-- if the storage is main or extended,
-- it means the data in given column is compressed
-- (PostgreSQL uses very fast compression algorithm from the LZ family).
-- собственно PG сжимает данные, но не все и не всегда
