class AddTSearchToQuestion2 < ActiveRecord::Migration
  def self.up
    execute(<<-'eosql'.strip)
      ALTER TABLE questions ADD COLUMN tsv tsvector;

      CREATE FUNCTION questions_generate_tsvector() RETURNS trigger AS $$
        begin
          new.tsv :=
            setweight(to_tsvector('pg_catalog.english', coalesce(new.title,'')), 'A') ||
            setweight(to_tsvector('pg_catalog.english', coalesce(new.details,'')), 'B');
          return new;
        end
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER tsvector_questions_upsert_trigger BEFORE INSERT OR UPDATE
        ON questions
        FOR EACH ROW EXECUTE PROCEDURE questions_generate_tsvector();

      UPDATE questions SET tsv =
        setweight(to_tsvector('pg_catalog.english', coalesce(title,'')), 'A') ||
        setweight(to_tsvector('pg_catalog.english', coalesce(details,'')), 'B');

      CREATE INDEX questions_tsv_idx ON questions USING gin(tsv);
    eosql
  end

  def self.down
    execute(<<-'eosql'.strip)
      DROP INDEX IF EXISTS questions_tsv_idx;
      DROP TRIGGER IF EXISTS tsvector_questions_upsert_trigger ON questions;
      DROP FUNCTION IF EXISTS questions_generate_tsvector();
      ALTER TABLE questions DROP COLUMN tsv;
    eosql
  end
end
