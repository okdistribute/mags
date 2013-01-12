--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.6
-- Dumped by pg_dump version 9.1.6
-- Started on 2013-01-11 20:02:03 EST

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 2593 (class 1262 OID 16424)
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
-- TOC entry 181 (class 3079 OID 12230)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2595 (class 0 OID 0)
-- Dependencies: 181
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_with_oids = false;

--
-- TOC entry 163 (class 1259 OID 16443)
-- Dependencies: 5
-- Name: assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE assignments (
    name text NOT NULL
);


--
-- TOC entry 176 (class 1259 OID 16630)
-- Dependencies: 5
-- Name: belongsto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE belongsto (
    assignment text NOT NULL,
    "group" text NOT NULL
);


--
-- TOC entry 167 (class 1259 OID 16495)
-- Dependencies: 5
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories (
    name text NOT NULL
);


--
-- TOC entry 178 (class 1259 OID 16666)
-- Dependencies: 5
-- Name: collaborated; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE collaborated (
    submission integer NOT NULL,
    collaborator text NOT NULL
);


--
-- TOC entry 170 (class 1259 OID 16519)
-- Dependencies: 5
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE comments (
    comment_text text NOT NULL
);


--
-- TOC entry 180 (class 1259 OID 16697)
-- Dependencies: 5
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
-- TOC entry 177 (class 1259 OID 16648)
-- Dependencies: 5
-- Name: contains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contains (
    assignment text NOT NULL,
    problem text NOT NULL,
    number text NOT NULL
);


--
-- TOC entry 168 (class 1259 OID 16503)
-- Dependencies: 5
-- Name: deadlines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE deadlines (
    type text NOT NULL,
    date timestamp without time zone NOT NULL,
    deadlineid integer NOT NULL
);


--
-- TOC entry 175 (class 1259 OID 16610)
-- Dependencies: 168 5
-- Name: deadlines_deadlineid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deadlines_deadlineid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2596 (class 0 OID 0)
-- Dependencies: 175
-- Name: deadlines_deadlineid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE deadlines_deadlineid_seq OWNED BY deadlines.deadlineid;


--
-- TOC entry 161 (class 1259 OID 16425)
-- Dependencies: 5
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE groups (
    name text NOT NULL
);


--
-- TOC entry 174 (class 1259 OID 16595)
-- Dependencies: 5
-- Name: hasdeadline; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hasdeadline (
    assignment text NOT NULL,
    deadline integer NOT NULL
);


--
-- TOC entry 173 (class 1259 OID 16563)
-- Dependencies: 5
-- Name: hastype; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hastype (
    assignment text NOT NULL,
    category text NOT NULL
);


--
-- TOC entry 162 (class 1259 OID 16433)
-- Dependencies: 5
-- Name: instructors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE instructors (
    networkid text NOT NULL,
    firstname text NOT NULL,
    lastname text NOT NULL
);


--
-- TOC entry 164 (class 1259 OID 16454)
-- Dependencies: 2525 5
-- Name: problems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE problems (
    name text NOT NULL,
    testsuite bytea[] NOT NULL,
    solution bytea[] NOT NULL,
    description text DEFAULT 'No description given.'::text NOT NULL,
    grader text NOT NULL,
    grader_params text NOT NULL
);


--
-- TOC entry 166 (class 1259 OID 16476)
-- Dependencies: 2526 5
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
-- TOC entry 179 (class 1259 OID 16674)
-- Dependencies: 5 166
-- Name: submissions_submissionid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE submissions_submissionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2597 (class 0 OID 0)
-- Dependencies: 179
-- Name: submissions_submissionid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE submissions_submissionid_seq OWNED BY submissions.submissionid;


--
-- TOC entry 165 (class 1259 OID 16463)
-- Dependencies: 5
-- Name: submitters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE submitters (
    networkid text NOT NULL,
    firstname text NOT NULL,
    lastname text NOT NULL,
    memberof text NOT NULL
);


--
-- TOC entry 172 (class 1259 OID 16545)
-- Dependencies: 5
-- Name: teaches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE teaches (
    teacher text NOT NULL,
    "group" text NOT NULL
);


--
-- TOC entry 171 (class 1259 OID 16527)
-- Dependencies: 5
-- Name: validates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE validates (
    validator text NOT NULL,
    assignment text NOT NULL,
    params text NOT NULL
);


--
-- TOC entry 169 (class 1259 OID 16511)
-- Dependencies: 5
-- Name: validators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE validators (
    name text NOT NULL,
    command text NOT NULL
);


--
-- TOC entry 2528 (class 2604 OID 16612)
-- Dependencies: 175 168
-- Name: deadlineid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY deadlines ALTER COLUMN deadlineid SET DEFAULT nextval('deadlines_deadlineid_seq'::regclass);


--
-- TOC entry 2527 (class 2604 OID 16676)
-- Dependencies: 179 166
-- Name: submissionid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions ALTER COLUMN submissionid SET DEFAULT nextval('submissions_submissionid_seq'::regclass);


--
-- TOC entry 2534 (class 2606 OID 16450)
-- Dependencies: 163 163 2590
-- Name: assignments_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_key PRIMARY KEY (name);


--
-- TOC entry 2562 (class 2606 OID 16637)
-- Dependencies: 176 176 176 2590
-- Name: belongsto_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY belongsto
    ADD CONSTRAINT belongsto_key PRIMARY KEY (assignment, "group");


--
-- TOC entry 2544 (class 2606 OID 16502)
-- Dependencies: 167 167 2590
-- Name: categories_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_key PRIMARY KEY (name);


--
-- TOC entry 2566 (class 2606 OID 16673)
-- Dependencies: 178 178 178 2590
-- Name: collaborated_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collaborated
    ADD CONSTRAINT collaborated_key PRIMARY KEY (submission, collaborator);


--
-- TOC entry 2552 (class 2606 OID 16526)
-- Dependencies: 170 170 2590
-- Name: comments_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_key PRIMARY KEY (comment_text);


--
-- TOC entry 2568 (class 2606 OID 16704)
-- Dependencies: 180 180 180 180 180 180 2590
-- Name: commentson_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commentson
    ADD CONSTRAINT commentson_key PRIMARY KEY (comment, submission, problem, com_start, com_end);


--
-- TOC entry 2564 (class 2606 OID 16655)
-- Dependencies: 177 177 177 2590
-- Name: contains_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT contains_key PRIMARY KEY (assignment, problem);


--
-- TOC entry 2546 (class 2606 OID 16620)
-- Dependencies: 168 168 2590
-- Name: deadlines_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deadlines
    ADD CONSTRAINT deadlines_key PRIMARY KEY (deadlineid);


--
-- TOC entry 2548 (class 2606 OID 16622)
-- Dependencies: 168 168 168 2590
-- Name: deadlines_natural; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deadlines
    ADD CONSTRAINT deadlines_natural UNIQUE (type, date);


--
-- TOC entry 2530 (class 2606 OID 16442)
-- Dependencies: 161 161 2590
-- Name: groups_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_key PRIMARY KEY (name);


--
-- TOC entry 2560 (class 2606 OID 16624)
-- Dependencies: 174 174 174 2590
-- Name: hasdeadline_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hasdeadline
    ADD CONSTRAINT hasdeadline_key PRIMARY KEY (assignment, deadline);


--
-- TOC entry 2558 (class 2606 OID 16570)
-- Dependencies: 173 173 173 2590
-- Name: hastype_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hastype
    ADD CONSTRAINT hastype_key PRIMARY KEY (assignment, category);


--
-- TOC entry 2532 (class 2606 OID 16440)
-- Dependencies: 162 162 2590
-- Name: instructors_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY instructors
    ADD CONSTRAINT instructors_key PRIMARY KEY (networkid);


--
-- TOC entry 2536 (class 2606 OID 16462)
-- Dependencies: 164 164 2590
-- Name: problems_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY problems
    ADD CONSTRAINT problems_key PRIMARY KEY (name);


--
-- TOC entry 2540 (class 2606 OID 16684)
-- Dependencies: 166 166 2590
-- Name: submissions_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_key PRIMARY KEY (submissionid);


--
-- TOC entry 2542 (class 2606 OID 16686)
-- Dependencies: 166 166 166 166 2590
-- Name: submissions_natural; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_natural UNIQUE (owner, submittedfor, date);


--
-- TOC entry 2538 (class 2606 OID 16470)
-- Dependencies: 165 165 2590
-- Name: submitters_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submitters
    ADD CONSTRAINT submitters_key PRIMARY KEY (networkid);


--
-- TOC entry 2556 (class 2606 OID 16552)
-- Dependencies: 172 172 172 2590
-- Name: teaches_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY teaches
    ADD CONSTRAINT teaches_key PRIMARY KEY (teacher, "group");


--
-- TOC entry 2554 (class 2606 OID 16534)
-- Dependencies: 171 171 171 171 2590
-- Name: validates_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY validates
    ADD CONSTRAINT validates_key PRIMARY KEY (validator, assignment, params);


--
-- TOC entry 2550 (class 2606 OID 16518)
-- Dependencies: 169 169 2590
-- Name: validators_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY validators
    ADD CONSTRAINT validators_key PRIMARY KEY (name);


--
-- TOC entry 2580 (class 2606 OID 16638)
-- Dependencies: 2533 163 176 2590
-- Name: belongsto_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY belongsto
    ADD CONSTRAINT belongsto_assignments_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- TOC entry 2581 (class 2606 OID 16643)
-- Dependencies: 2529 176 161 2590
-- Name: belongsto_groups_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY belongsto
    ADD CONSTRAINT belongsto_groups_forkey FOREIGN KEY ("group") REFERENCES groups(name);


--
-- TOC entry 2584 (class 2606 OID 16687)
-- Dependencies: 2539 178 166 2590
-- Name: collaborated_submissions_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collaborated
    ADD CONSTRAINT collaborated_submissions_forkey FOREIGN KEY (submission) REFERENCES submissions(submissionid);


--
-- TOC entry 2585 (class 2606 OID 16692)
-- Dependencies: 165 178 2537 2590
-- Name: collaborated_submitters_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collaborated
    ADD CONSTRAINT collaborated_submitters_forkey FOREIGN KEY (collaborator) REFERENCES submitters(networkid);


--
-- TOC entry 2586 (class 2606 OID 16705)
-- Dependencies: 2551 170 180 2590
-- Name: commentson_comments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commentson
    ADD CONSTRAINT commentson_comments_forkey FOREIGN KEY (comment) REFERENCES comments(comment_text);


--
-- TOC entry 2588 (class 2606 OID 16715)
-- Dependencies: 180 2535 164 2590
-- Name: commentson_problems_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commentson
    ADD CONSTRAINT commentson_problems_forkey FOREIGN KEY (problem) REFERENCES problems(name);


--
-- TOC entry 2587 (class 2606 OID 16710)
-- Dependencies: 180 2539 166 2590
-- Name: commentson_submissions_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commentson
    ADD CONSTRAINT commentson_submissions_forkey FOREIGN KEY (submission) REFERENCES submissions(submissionid);


--
-- TOC entry 2582 (class 2606 OID 16656)
-- Dependencies: 163 177 2533 2590
-- Name: contains_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT contains_assignments_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- TOC entry 2583 (class 2606 OID 16661)
-- Dependencies: 164 177 2535 2590
-- Name: contains_problems_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT contains_problems_forkey FOREIGN KEY (problem) REFERENCES problems(name);


--
-- TOC entry 2578 (class 2606 OID 16603)
-- Dependencies: 2533 163 174 2590
-- Name: hasdeadline_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hasdeadline
    ADD CONSTRAINT hasdeadline_assignments_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- TOC entry 2579 (class 2606 OID 16625)
-- Dependencies: 174 2545 168 2590
-- Name: hasdeadline_deadlines_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hasdeadline
    ADD CONSTRAINT hasdeadline_deadlines_forkey FOREIGN KEY (deadline) REFERENCES deadlines(deadlineid);


--
-- TOC entry 2576 (class 2606 OID 16571)
-- Dependencies: 163 2533 173 2590
-- Name: hastype_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hastype
    ADD CONSTRAINT hastype_assignments_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- TOC entry 2577 (class 2606 OID 16576)
-- Dependencies: 173 167 2543 2590
-- Name: hastype_categories_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hastype
    ADD CONSTRAINT hastype_categories_forkey FOREIGN KEY (category) REFERENCES categories(name);


--
-- TOC entry 2571 (class 2606 OID 16490)
-- Dependencies: 163 2533 166 2590
-- Name: submissions_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_assignments_forkey FOREIGN KEY (submittedfor) REFERENCES assignments(name);


--
-- TOC entry 2570 (class 2606 OID 16485)
-- Dependencies: 166 165 2537 2590
-- Name: submissions_submitters_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_submitters_forkey FOREIGN KEY (owner) REFERENCES submitters(networkid);


--
-- TOC entry 2569 (class 2606 OID 16471)
-- Dependencies: 2529 165 161 2590
-- Name: submitter_group_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submitters
    ADD CONSTRAINT submitter_group_forkey FOREIGN KEY (memberof) REFERENCES groups(name);


--
-- TOC entry 2575 (class 2606 OID 16558)
-- Dependencies: 172 161 2529 2590
-- Name: teaches_groups_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY teaches
    ADD CONSTRAINT teaches_groups_forkey FOREIGN KEY ("group") REFERENCES groups(name);


--
-- TOC entry 2574 (class 2606 OID 16553)
-- Dependencies: 162 2531 172 2590
-- Name: teaches_instructors_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY teaches
    ADD CONSTRAINT teaches_instructors_forkey FOREIGN KEY (teacher) REFERENCES instructors(networkid);


--
-- TOC entry 2573 (class 2606 OID 16540)
-- Dependencies: 163 171 2533 2590
-- Name: validates_assignment_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY validates
    ADD CONSTRAINT validates_assignment_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- TOC entry 2572 (class 2606 OID 16535)
-- Dependencies: 169 2549 171 2590
-- Name: validates_validator_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY validates
    ADD CONSTRAINT validates_validator_forkey FOREIGN KEY (validator) REFERENCES validators(name);


-- Completed on 2013-01-11 20:02:04 EST

--
-- PostgreSQL database dump complete
--

