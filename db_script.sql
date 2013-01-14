--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.2
-- Dumped by pg_dump version 9.2.2
-- Started on 2013-01-14 17:19:10 EST

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 2649 (class 1262 OID 16396)
-- Name: MAGS; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE "MAGS" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'en_US.UTF-8';


\connect "MAGS"

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 187 (class 3079 OID 12306)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2651 (class 0 OID 0)
-- Dependencies: 187
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_with_oids = false;

--
-- TOC entry 168 (class 1259 OID 16397)
-- Name: assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE assignments (
    name text NOT NULL
);


--
-- TOC entry 169 (class 1259 OID 16403)
-- Name: belongsto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE belongsto (
    assignment text NOT NULL,
    "group" text NOT NULL
);


--
-- TOC entry 170 (class 1259 OID 16409)
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories (
    name text NOT NULL
);


--
-- TOC entry 171 (class 1259 OID 16415)
-- Name: collaborated; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE collaborated (
    collaborator text NOT NULL,
    owner text NOT NULL,
    assignment text NOT NULL,
    date timestamp without time zone NOT NULL
);


--
-- TOC entry 172 (class 1259 OID 16421)
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE comments (
    comment_text text NOT NULL
);


--
-- TOC entry 173 (class 1259 OID 16427)
-- Name: commentson; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE commentson (
    comment text NOT NULL,
    problem text NOT NULL,
    com_start integer NOT NULL,
    com_end integer NOT NULL,
    owner text NOT NULL,
    assignment text NOT NULL,
    date timestamp without time zone NOT NULL
);


--
-- TOC entry 174 (class 1259 OID 16433)
-- Name: contains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contains (
    assignment text NOT NULL,
    problem text NOT NULL,
    number text NOT NULL
);


--
-- TOC entry 175 (class 1259 OID 16439)
-- Name: deadlines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE deadlines (
    type text NOT NULL,
    date timestamp without time zone NOT NULL
);


--
-- TOC entry 176 (class 1259 OID 16445)
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE groups (
    name text NOT NULL
);


--
-- TOC entry 177 (class 1259 OID 16451)
-- Name: hasdeadline; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hasdeadline (
    assignment text NOT NULL,
    type text NOT NULL,
    date timestamp without time zone NOT NULL
);


--
-- TOC entry 178 (class 1259 OID 16457)
-- Name: hastype; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hastype (
    assignment text NOT NULL,
    category text NOT NULL
);


--
-- TOC entry 179 (class 1259 OID 16463)
-- Name: instructors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE instructors (
    networkid text NOT NULL,
    firstname text NOT NULL,
    lastname text NOT NULL
);


--
-- TOC entry 186 (class 1259 OID 16650)
-- Name: memberof; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE memberof (
    "group" text NOT NULL,
    student text NOT NULL
);


--
-- TOC entry 180 (class 1259 OID 16469)
-- Name: problems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE problems (
    name text NOT NULL,
    description text DEFAULT 'No description given.'::text NOT NULL,
    grader text NOT NULL,
    grader_params text NOT NULL,
    testsuite text NOT NULL,
    solution text NOT NULL
);


--
-- TOC entry 181 (class 1259 OID 16476)
-- Name: submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE submissions (
    owner text NOT NULL,
    submittedfor text NOT NULL,
    date timestamp without time zone NOT NULL,
    isappeal boolean DEFAULT false NOT NULL,
    code bytea[] NOT NULL,
    report xml
);


--
-- TOC entry 182 (class 1259 OID 16483)
-- Name: submitters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE submitters (
    networkid text NOT NULL,
    firstname text NOT NULL,
    lastname text NOT NULL
);


--
-- TOC entry 183 (class 1259 OID 16489)
-- Name: teaches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE teaches (
    teacher text NOT NULL,
    "group" text NOT NULL
);


--
-- TOC entry 184 (class 1259 OID 16495)
-- Name: validates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE validates (
    validator text NOT NULL,
    assignment text NOT NULL,
    params text NOT NULL
);


--
-- TOC entry 185 (class 1259 OID 16501)
-- Name: validators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE validators (
    name text NOT NULL,
    command text NOT NULL
);


--
-- TOC entry 2585 (class 2606 OID 16508)
-- Name: assignments_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_key PRIMARY KEY (name);


--
-- TOC entry 2587 (class 2606 OID 16510)
-- Name: belongsto_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY belongsto
    ADD CONSTRAINT belongsto_key PRIMARY KEY (assignment, "group");


--
-- TOC entry 2589 (class 2606 OID 16512)
-- Name: categories_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_key PRIMARY KEY (name);


--
-- TOC entry 2591 (class 2606 OID 16514)
-- Name: collaborated_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collaborated
    ADD CONSTRAINT collaborated_key PRIMARY KEY (collaborator, owner, assignment, date);


--
-- TOC entry 2593 (class 2606 OID 16516)
-- Name: comments_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_key PRIMARY KEY (comment_text);


--
-- TOC entry 2595 (class 2606 OID 16518)
-- Name: commentson_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commentson
    ADD CONSTRAINT commentson_key PRIMARY KEY (comment, problem, com_start, com_end, owner, assignment, date);


--
-- TOC entry 2598 (class 2606 OID 16520)
-- Name: contains_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT contains_key PRIMARY KEY (assignment, problem);


--
-- TOC entry 2600 (class 2606 OID 16522)
-- Name: deadlines_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deadlines
    ADD CONSTRAINT deadlines_key PRIMARY KEY (type, date);


--
-- TOC entry 2602 (class 2606 OID 16524)
-- Name: groups_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_key PRIMARY KEY (name);


--
-- TOC entry 2604 (class 2606 OID 16526)
-- Name: hasdeadline_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hasdeadline
    ADD CONSTRAINT hasdeadline_key PRIMARY KEY (assignment, type, date);


--
-- TOC entry 2606 (class 2606 OID 16528)
-- Name: hastype_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hastype
    ADD CONSTRAINT hastype_key PRIMARY KEY (assignment, category);


--
-- TOC entry 2608 (class 2606 OID 16530)
-- Name: instructors_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY instructors
    ADD CONSTRAINT instructors_key PRIMARY KEY (networkid);


--
-- TOC entry 2622 (class 2606 OID 16657)
-- Name: memberof_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberof
    ADD CONSTRAINT memberof_key PRIMARY KEY ("group", student);


--
-- TOC entry 2610 (class 2606 OID 16532)
-- Name: problems_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY problems
    ADD CONSTRAINT problems_key PRIMARY KEY (name);


--
-- TOC entry 2612 (class 2606 OID 16534)
-- Name: submissions_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_key PRIMARY KEY (owner, submittedfor, date);


--
-- TOC entry 2614 (class 2606 OID 16536)
-- Name: submitters_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submitters
    ADD CONSTRAINT submitters_key PRIMARY KEY (networkid);


--
-- TOC entry 2616 (class 2606 OID 16538)
-- Name: teaches_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY teaches
    ADD CONSTRAINT teaches_key PRIMARY KEY (teacher, "group");


--
-- TOC entry 2618 (class 2606 OID 16540)
-- Name: validates_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY validates
    ADD CONSTRAINT validates_key PRIMARY KEY (validator, assignment, params);


--
-- TOC entry 2620 (class 2606 OID 16542)
-- Name: validators_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY validators
    ADD CONSTRAINT validators_key PRIMARY KEY (name);


--
-- TOC entry 2596 (class 1259 OID 16543)
-- Name: fki_commentson_contains_forkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_commentson_contains_forkey ON commentson USING btree (assignment, problem);


--
-- TOC entry 2623 (class 2606 OID 16544)
-- Name: belongsto_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY belongsto
    ADD CONSTRAINT belongsto_assignments_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- TOC entry 2624 (class 2606 OID 16549)
-- Name: belongsto_groups_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY belongsto
    ADD CONSTRAINT belongsto_groups_forkey FOREIGN KEY ("group") REFERENCES groups(name);


--
-- TOC entry 2625 (class 2606 OID 16554)
-- Name: collaborated_submissions_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collaborated
    ADD CONSTRAINT collaborated_submissions_forkey FOREIGN KEY (owner, assignment, date) REFERENCES submissions(owner, submittedfor, date);


--
-- TOC entry 2626 (class 2606 OID 16559)
-- Name: collaborated_submitters_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collaborated
    ADD CONSTRAINT collaborated_submitters_forkey FOREIGN KEY (collaborator) REFERENCES submitters(networkid);


--
-- TOC entry 2627 (class 2606 OID 16564)
-- Name: commentson_comments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commentson
    ADD CONSTRAINT commentson_comments_forkey FOREIGN KEY (comment) REFERENCES comments(comment_text);


--
-- TOC entry 2628 (class 2606 OID 16569)
-- Name: commentson_contains_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commentson
    ADD CONSTRAINT commentson_contains_forkey FOREIGN KEY (assignment, problem) REFERENCES contains(assignment, problem);


--
-- TOC entry 2629 (class 2606 OID 16574)
-- Name: commentson_problems_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commentson
    ADD CONSTRAINT commentson_problems_forkey FOREIGN KEY (problem) REFERENCES problems(name);


--
-- TOC entry 2630 (class 2606 OID 16579)
-- Name: commentson_submissions_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commentson
    ADD CONSTRAINT commentson_submissions_forkey FOREIGN KEY (owner, assignment, date) REFERENCES submissions(owner, submittedfor, date);


--
-- TOC entry 2631 (class 2606 OID 16584)
-- Name: contains_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT contains_assignments_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- TOC entry 2632 (class 2606 OID 16589)
-- Name: contains_problems_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contains
    ADD CONSTRAINT contains_problems_forkey FOREIGN KEY (problem) REFERENCES problems(name);


--
-- TOC entry 2633 (class 2606 OID 16594)
-- Name: hasdeadline_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hasdeadline
    ADD CONSTRAINT hasdeadline_assignments_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- TOC entry 2634 (class 2606 OID 16599)
-- Name: hasdeadline_deadlines_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hasdeadline
    ADD CONSTRAINT hasdeadline_deadlines_forkey FOREIGN KEY (type, date) REFERENCES deadlines(type, date);


--
-- TOC entry 2635 (class 2606 OID 16604)
-- Name: hastype_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hastype
    ADD CONSTRAINT hastype_assignments_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- TOC entry 2636 (class 2606 OID 16609)
-- Name: hastype_categories_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hastype
    ADD CONSTRAINT hastype_categories_forkey FOREIGN KEY (category) REFERENCES categories(name);


--
-- TOC entry 2643 (class 2606 OID 16658)
-- Name: memberof_groups_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberof
    ADD CONSTRAINT memberof_groups_forkey FOREIGN KEY ("group") REFERENCES groups(name);


--
-- TOC entry 2644 (class 2606 OID 16663)
-- Name: memberof_submitters_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberof
    ADD CONSTRAINT memberof_submitters_forkey FOREIGN KEY (student) REFERENCES submitters(networkid);


--
-- TOC entry 2637 (class 2606 OID 16614)
-- Name: submissions_assignments_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_assignments_forkey FOREIGN KEY (submittedfor) REFERENCES assignments(name);


--
-- TOC entry 2638 (class 2606 OID 16619)
-- Name: submissions_submitters_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_submitters_forkey FOREIGN KEY (owner) REFERENCES submitters(networkid);


--
-- TOC entry 2639 (class 2606 OID 16629)
-- Name: teaches_groups_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY teaches
    ADD CONSTRAINT teaches_groups_forkey FOREIGN KEY ("group") REFERENCES groups(name);


--
-- TOC entry 2640 (class 2606 OID 16634)
-- Name: teaches_instructors_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY teaches
    ADD CONSTRAINT teaches_instructors_forkey FOREIGN KEY (teacher) REFERENCES instructors(networkid);


--
-- TOC entry 2641 (class 2606 OID 16639)
-- Name: validates_assignment_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY validates
    ADD CONSTRAINT validates_assignment_forkey FOREIGN KEY (assignment) REFERENCES assignments(name);


--
-- TOC entry 2642 (class 2606 OID 16644)
-- Name: validates_validator_forkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY validates
    ADD CONSTRAINT validates_validator_forkey FOREIGN KEY (validator) REFERENCES validators(name);


-- Completed on 2013-01-14 17:19:10 EST

--
-- PostgreSQL database dump complete
--

