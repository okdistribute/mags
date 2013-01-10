-- Database: "MAGS"

-- DROP DATABASE "MAGS";

CREATE DATABASE "MAGS"
  WITH OWNER = arcfide
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'en_US.UTF-8'
       LC_CTYPE = 'en_US.UTF-8'
       CONNECTION LIMIT = -1;

-- Table: "groups"

-- DROP TABLE "groups";

CREATE TABLE "groups"
(
  name text NOT NULL,
  CONSTRAINT groups_key PRIMARY KEY (name )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "groups"
  OWNER TO arcfide;

-- Table: instructors

-- DROP TABLE instructors;

CREATE TABLE instructors
(
  networkid text NOT NULL,
  firstname text NOT NULL,
  lastname text NOT NULL,
  CONSTRAINT instructors_key PRIMARY KEY (networkid )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE instructors
  OWNER TO arcfide;

-- Table: assignments

-- DROP TABLE assignments;

CREATE TABLE assignments
(
  name text NOT NULL,
  CONSTRAINT assignments_key PRIMARY KEY (name )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE assignments
  OWNER TO arcfide;

-- Table: problems

-- DROP TABLE problems;

CREATE TABLE problems
(
  name text NOT NULL,
  testsuite bytea[] NOT NULL,
  solution bytea[] NOT NULL,
  description text NOT NULL DEFAULT 'No description given.'::text,
  CONSTRAINT problems_key PRIMARY KEY (name )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE problems
  OWNER TO arcfide;

