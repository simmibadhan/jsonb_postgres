-- Create table
CREATE TABLE cards (
  id integer NOT NULL,
  board_id integer NOT NULL,
  data jsonb
);

-- Inserting values
INSERT INTO cards VALUES (1, 1, '{"name": "Paint house", "tags": ["Improvements", "Office"], "finished": true}');
INSERT INTO cards VALUES (2, 1, '{"name": "Wash dishes", "tags": ["Clean", "Kitchen"], "finished": false}');
INSERT INTO cards VALUES (3, 1, '{"name": "Cook lunch", "tags": ["Cook", "Kitchen", "Tacos"], "ingredients": ["Tortillas", "Guacamole"], "finished": false}');
INSERT INTO cards VALUES (4, 1, '{"name": "Vacuum", "tags": ["Clean", "Bedroom", "Office"], "finished": false}');
INSERT INTO cards VALUES (5, 1, '{"name": "Hang paintings", "tags": ["Improvements", "Office"], "finished": false}');

-- Select statement for column in json
SELECT data->>'name' AS name FROM cards;

-- Conditional select statement for json column
SELECT * FROM cards WHERE data->>'finished' = 'true';

-- Number of rows having a column in json
SELECT count(*) FROM cards WHERE data ? 'ingredients';

-- Shows multiple rows for json column having array of strings
SELECT
  jsonb_array_elements_text(data->'tags') as tag
FROM cards
WHERE id = 1;

-- Creating index reduces the query time by half
EXPLAIN (
SELECT count(*) FROM cards WHERE data->>'finished' = 'true');

CREATE INDEX idxfinished ON cards ((data->>'finished'));

EXPLAIN ANALYZE
(SELECT count(*) FROM cards
WHERE
  data->'tags' ? 'Clean'
  AND data->'tags' ? 'Kitchen');

CREATE INDEX idxgintags ON cards USING gin ((data->'tags'));

CREATE INDEX idxgindata ON cards USING gin (data);

EXPLAIN ANALYZE
SELECT count(*) FROM cards
WHERE
  data @> '{"tags": ["Clean", "Kitchen"]}';