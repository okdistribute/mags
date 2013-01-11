--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: MAGS; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE "MAGS" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


\connect "MAGS"

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_with_oids = false;

--
-- Name: assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE assignments (
    name text NOT NULL
);


--
-- Name: belongsto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE belongsto (
    assignment text NOT NULL,
    "group" text NOT NULL
);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories (
    name text NOT NULL
);


--
-- Name: collaborated; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE collaborated (
    submission integer NOT NULL,
    collaborator text NOT NULL
);


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE comments (
    comment_text text NOT NULL
);


--
-- Name: commentson; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE commentson (
    comment text NOT NULL,
    submission integer NOT NULL,
    problem text NOT NULL,
    com_start integer NOT NULL,
    com_end integer NOT NULL
);


--
-- Name: contains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contains (
    assignment text NOT NULL,
    problem text NOT NULL,
    number text NOT NULL
);


--
-- Name: deadlines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE deadlines (
    type text NOT NULL,
    date timestamp without time zone NOT NULL,
    deadlineid integer NOT NULL
);


--
-- Name: deadlines_deadlineid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deadlines_deadlineid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deadlines_deadlineid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE deadlines_deadlineid_seq OWNED BY deadlines.deadlineid;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE groups (
    name text NOT NULL
);


--
-- Name: hasdeadline; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hasdeadline (
    assignment text NOT NULL,
    deadline integer NOT NULL
);


--
-- Name: hastype; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hastype (
    assignment text NOT NULL,
    category text NOT NULL
);


--
-- Name: instructors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE instructors (
    networkid text NOT NULL,
    firstname text NOT NULL,
    lastname text NOT NULL
);


--
-- Name: problems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE problems (
    name text NOT NULL,
    testsuite bytea[] NOT NULL,
    solution bytea[] NOT NULL,
    description text DEFAULT 'No description given.'::text NOT NULL
);


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE submissions (
    owner text NOT NULL,
    submittedfor text NOT NULL,
    date timestamp without time zone NOT NULL,
    isappeal boolean DEFAULT false NOT NULL,
    code bytea[] NOT NULL,
    report xml,
    submissionid integer NOT NULL
);


--
-- Name: submissions_submissionid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE submissions_submissionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_submissionid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE submissions_submissionid_seq OWNED BY submissions.submissionid;


--
-- Name: submitters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE submitters (
    networkid text NOT NULL,
    firstname text NOT NULL,
    lastname text NOT NULL,
    memberof text NOT NULL
);


--
-- Name: teaches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE teaches (
    teacher text NOT NULL,
    "group" text NOT NULL
);


--
-- Name: validates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE validates (
    validator text NOT NULL,
    assignment text NOT NULL,
    params text NOT NULL
);


--
-- Name: validators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE validators (
    name text NOT NULL,
    command text NOT NULL
);


--
-- Name: deadlineid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY deadlines ALTER COLUMN deadlineid SET DEFAULT nextval('deadlines_deadlineid_seq'::regclass);


--
-- Name: submissionid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions ALTER COLUMN submissionid SET DEFAULT nextval('submissions_submissionid_seq'::regclass);


--
-- Name: assignments_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_key PRIMARY KEY (name);


--
-- Name: belongsto_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY belongsto
    ADD CONSTRAINT belongsto_key PRIMARY KEY (assignment, "group");


--
-- Name: categories_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_key PRIMARY KEY (name);


--
-- Name: collaborated_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collaborated
    ADD CONSTRAINT collaborated_key PRIMARY KEY (submission, collaborator);


--
-- Name: comments_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_key PRIMARY KEY (comment_text);


--
-- Name: commentson_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commentson
    ADD CONSTRAINT commentson_key PRIMARY KEY (comment, submission, problem, com_start, com_end);


--
-- Name: contains_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT contains_key PRIMARY KEY (assignment, problem);


--
-- Name: deadlines_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deadlines
    ADD CONSTRAINT deadlines_key PRIMARY KEY (deadlineid);


--
-- Name: deadlines_natural; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deadlines
    ADD CONSTRAINT deadlines_natural UNIQUE (type, date);


--
-- Name: groups_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_key PRIMARY KEY (name);


--
-- Name: hasdeadline_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hasdeadline
    ADD CONSTRAINT hasdeadline_key PRIMARY KEY (assignment, deadline);


--
-- Name: hastype_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hastype
    ADD CONSTRAINT hastype_key PRIMARY KEY (assignment, category);


--
-- Name: instructors_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY instructors
    ADD CONSTRAINT instructors_key PRIMARY KEY (networkid);


--
-- Name: problems_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY problems
    ADD CONSTRAINT problems_key PRIMARY KEY (name);


--
-- Name: submissions_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_key PRIMARY KEY (submissionid);


--
-- Name: submissions_natural; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_natural UNIQUE (owner, submittedfor, date);


--
-- Name: submitters_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submitters
    ADD CONSTRAINT submitters_key PRIMARY KEY (networkid);


--
-- Name: teaches_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY teaches
    ADD CONSTRAINT teaches_key PRIMARY KEY (teacher, "group");


--
-- Name: validates_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY validates
    ADD CONSTRAINT validates_key PRIMARY KEY (validator, assignment, params);


--
-- Name: validators_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY validators
    ADD CONSTRAINT validators_key PRIMARY KEY (name);


--
-- Name: belongsto_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY belongsto
    ADD CONSTRAINT belongsto_assignments_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- Name: belongsto_groups_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY belongsto
    ADD CONSTRAINT belongsto_groups_forkey FOREIGN KEY ("group") REFERENCES groups(name);


--
-- Name: collaborated_submissions_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collaborated
    ADD CONSTRAINT collaborated_submissions_forkey FOREIGN KEY (submission) REFERENCES submissions(submissionid);


--
-- Name: collaborated_submitters_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collaborated
    ADD CONSTRAINT collaborated_submitters_forkey FOREIGN KEY (collaborator) REFERENCES submitters(networkid);


--
-- Name: commentson_comments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commentson
    ADD CONSTRAINT commentson_comments_forkey FOREIGN KEY (comment) REFERENCES comments(comment_text);


--
-- Name: commentson_problems_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commentson
    ADD CONSTRAINT commentson_problems_forkey FOREIGN KEY (problem) REFERENCES problems(name);


--
-- Name: commentson_submissions_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commentson
    ADD CONSTRAINT commentson_submissions_forkey FOREIGN KEY (submission) REFERENCES submissions(submissionid);


--
-- Name: contains_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT contains_assignments_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- Name: contains_problems_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT contains_problems_forkey FOREIGN KEY (problem) REFERENCES problems(name);


--
-- Name: hasdeadline_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hasdeadline
    ADD CONSTRAINT hasdeadline_assignments_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- Name: hasdeadline_deadlines_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hasdeadline
    ADD CONSTRAINT hasdeadline_deadlines_forkey FOREIGN KEY (deadline) REFERENCES deadlines(deadlineid);


--
-- Name: hastype_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hastype
    ADD CONSTRAINT hastype_assignments_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- Name: hastype_categories_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hastype
    ADD CONSTRAINT hastype_categories_forkey FOREIGN KEY (category) REFERENCES categories(name);


--
-- Name: submissions_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_assignments_forkey FOREIGN KEY (submittedfor) REFERENCES assignments(name);


--
-- Name: submissions_submitters_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_submitters_forkey FOREIGN KEY (owner) REFERENCES submitters(networkid);


--
-- Name: submitter_group_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submitters
    ADD CONSTRAINT submitter_group_forkey FOREIGN KEY (memberof) REFERENCES groups(name);


--
-- Name: teaches_groups_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY teaches
    ADD CONSTRAINT teaches_groups_forkey FOREIGN KEY ("group") REFERENCES groups(name);


--
-- Name: teaches_instructors_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY teaches
    ADD CONSTRAINT teaches_instructors_forkey FOREIGN KEY (teacher) REFERENCES instructors(networkid);


--
-- Name: validates_assignment_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY validates
    ADD CONSTRAINT validates_assignment_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- Name: validates_validator_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY validates
    ADD CONSTRAINT validates_validator_forkey FOREIGN KEY (validator) REFERENCES validators(name);


--
-- PostgreSQL database dump complete
--

