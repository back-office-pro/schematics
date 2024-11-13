CREATE OR REPLACE FUNCTION immutable_unaccent(value text)
  RETURNS text
  LANGUAGE sql IMMUTABLE PARALLEL SAFE STRICT 
RETURN (SELECT unaccent('unaccent', value));

CREATE OR REPLACE FUNCTION immutable_unaccent(dict regdictionary, value text)
  RETURNS text
  LANGUAGE sql IMMUTABLE PARALLEL SAFE STRICT
RETURN (SELECT unaccent(dict, value));
