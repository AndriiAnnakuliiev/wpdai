--
-- PostgreSQL database dump
--

-- Dumped from database version 15.6
-- Dumped by pg_dump version 15.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- Name: get_computer_components_info(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_computer_components_info(computer_id_input integer) RETURNS TABLE(computer_id integer, model_name character varying, component_name character varying, component_type character varying, specifications text)
    LANGUAGE plpgsql
    AS $$

BEGIN

    RETURN QUERY

        SELECT

            c.computerid,

            c.modelname,

            comp.name,

            comp.type,

            comp.specifications

        FROM

            public.computers c

                JOIN public.computercomponents cc ON c.computerid = cc.computerid

                JOIN public.components comp ON cc.componentid = comp.componentid

        WHERE

            c.computerid = computer_id_input;

END;

$$;


ALTER FUNCTION public.get_computer_components_info(computer_id_input integer) OWNER TO postgres;

--
-- Name: update_order_status(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_order_status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.TotalPrice > 0 THEN
        NEW.Status := 'Completed';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_order_status() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: components; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.components (
    componentid integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(50) NOT NULL,
    specifications text NOT NULL,
    supplierid integer
);


ALTER TABLE public.components OWNER TO postgres;

--
-- Name: computercomponents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.computercomponents (
    computerid integer NOT NULL,
    componentid integer NOT NULL
);


ALTER TABLE public.computercomponents OWNER TO postgres;

--
-- Name: computers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.computers (
    computerid integer NOT NULL,
    modelname character varying(255) NOT NULL,
    description text NOT NULL,
    price numeric(10,2) NOT NULL
);


ALTER TABLE public.computers OWNER TO postgres;

--
-- Name: ComputerDetails; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public."ComputerDetails" AS
 SELECT c.modelname,
    c.description,
    comp.name AS componentname,
    comp.type,
    comp.specifications
   FROM ((public.computers c
     JOIN public.computercomponents cc ON ((c.computerid = cc.computerid)))
     JOIN public.components comp ON ((cc.componentid = comp.componentid)));


ALTER TABLE public."ComputerDetails" OWNER TO postgres;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    orderid integer NOT NULL,
    userid integer NOT NULL,
    orderdate timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    totalprice numeric(10,2) NOT NULL,
    status character varying(50) DEFAULT 'Pending'::character varying
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    userid integer NOT NULL,
    name character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(255),
    role character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: OrdersSummary; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public."OrdersSummary" AS
 SELECT o.orderid,
    u.name AS username,
    o.orderdate,
    o.totalprice,
    o.status
   FROM (public.orders o
     JOIN public.users u ON ((o.userid = u.userid)));


ALTER TABLE public."OrdersSummary" OWNER TO postgres;

--
-- Name: components_componentid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.components_componentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.components_componentid_seq OWNER TO postgres;

--
-- Name: components_componentid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.components_componentid_seq OWNED BY public.components.componentid;


--
-- Name: componentvariants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.componentvariants (
    variantid integer NOT NULL,
    componentid integer NOT NULL,
    variantname character varying(255) NOT NULL,
    variantspecifications text NOT NULL,
    additionalprice numeric(10,2)
);


ALTER TABLE public.componentvariants OWNER TO postgres;

--
-- Name: componentvariants_variantid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.componentvariants_variantid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.componentvariants_variantid_seq OWNER TO postgres;

--
-- Name: componentvariants_variantid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.componentvariants_variantid_seq OWNED BY public.componentvariants.variantid;


--
-- Name: computers_computerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.computers_computerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.computers_computerid_seq OWNER TO postgres;

--
-- Name: computers_computerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.computers_computerid_seq OWNED BY public.computers.computerid;


--
-- Name: orders_orderid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_orderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_orderid_seq OWNER TO postgres;

--
-- Name: orders_orderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_orderid_seq OWNED BY public.orders.orderid;


--
-- Name: specialoffers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specialoffers (
    offerid integer NOT NULL,
    computerid integer NOT NULL,
    offerdescription text NOT NULL,
    discountpercent integer,
    CONSTRAINT specialoffers_discountpercent_check CHECK (((discountpercent >= 0) AND (discountpercent <= 100)))
);


ALTER TABLE public.specialoffers OWNER TO postgres;

--
-- Name: specialoffers_offerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.specialoffers_offerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.specialoffers_offerid_seq OWNER TO postgres;

--
-- Name: specialoffers_offerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.specialoffers_offerid_seq OWNED BY public.specialoffers.offerid;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    supplierid integer NOT NULL,
    name character varying(255) NOT NULL,
    address text NOT NULL,
    email character varying(255),
    phone character varying(20)
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- Name: suppliers_supplierid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suppliers_supplierid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.suppliers_supplierid_seq OWNER TO postgres;

--
-- Name: suppliers_supplierid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suppliers_supplierid_seq OWNED BY public.suppliers.supplierid;


--
-- Name: users_userid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_userid_seq OWNER TO postgres;

--
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.userid;


--
-- Name: components componentid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components ALTER COLUMN componentid SET DEFAULT nextval('public.components_componentid_seq'::regclass);


--
-- Name: componentvariants variantid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.componentvariants ALTER COLUMN variantid SET DEFAULT nextval('public.componentvariants_variantid_seq'::regclass);


--
-- Name: computers computerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computers ALTER COLUMN computerid SET DEFAULT nextval('public.computers_computerid_seq'::regclass);


--
-- Name: orders orderid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN orderid SET DEFAULT nextval('public.orders_orderid_seq'::regclass);


--
-- Name: specialoffers offerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialoffers ALTER COLUMN offerid SET DEFAULT nextval('public.specialoffers_offerid_seq'::regclass);


--
-- Name: suppliers supplierid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN supplierid SET DEFAULT nextval('public.suppliers_supplierid_seq'::regclass);


--
-- Name: users userid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);


--
-- Data for Name: components; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.components (componentid, name, type, specifications, supplierid) FROM stdin;
2	Graphics card	GPU	New/Factory recertified	1
1	Processor	CPU	New/Factory recertified	1
3	Memory	RAM	New/Factory recertified	2
5	Power supply	PSU	New/Factory recertified	3
4	SSD	Storage	New/Factory recertified	2
\.


--
-- Data for Name: componentvariants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.componentvariants (variantid, componentid, variantname, variantspecifications, additionalprice) FROM stdin;
1	1	Intel Core i5-12400	Socket 1700	749.00
2	1	Intel Core i7-14700k	Socket 1700	1949.00
3	1	Ryzen 5 5600X	Socket AM4	549.00
4	1	Ryzen 7 5800X3D	Socket AM4	1279.00
5	2	RTX 4080 16Gb	PCIe 4.0 x16	6399.00
6	2	RTX 4060Ti 16Gb	PCIe 4.0 x16	2199.50
7	2	RX 7900XT	PCIe 4.0 x16	4700.50
8	2	RX 7700Xt	PCIe 4.0 x16	2699.20
9	3	DDR5 96Gb (2x48Gb)	6000MHz CL32	1599.00
10	3	DDR5 32Gb (2x16Gb)	8000MHz CL36	1400.50
11	3	DDR4 32Gb (2x16Gb)	3200MHz CL14	929.50
12	3	DDR4 16Gb (2x18Gb)	3200MHz CL16	521.00
13	4	4TB M.2	PCIe Gen4 NVME	2019.00
14	4	2TB M.2	PCIe Gen4 NVME	1649.00
15	4	1TB M.2	PCIe Gen3 NVME	1121.50
16	4	512Gb	SATA3	554.50
17	5	1000W	90 PLUS GOLD	1110.50
18	5	750W	80 PLUS GOLD	783.00
19	5	550W	80 Plus Bronze	412.00
20	5	400W	80 Plus Bronze	322.50
\.


--
-- Data for Name: computercomponents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.computercomponents (computerid, componentid) FROM stdin;
1	1
1	2
2	3
2	4
3	5
3	1
4	2
4	3
5	4
5	5
\.


--
-- Data for Name: computers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.computers (computerid, modelname, description, price) FROM stdin;
5	Student	Just study...	10000.00
1	Gaming	R7 5800X3D + RTX 4080	9000.00
2	Streaming	R9 5950X + RTX 4090	6000.00
4	Graphics	I7 14700K + RTX 4090	11000.00
3	Work	I3,I5 + iGPU	2000.00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (orderid, userid, orderdate, totalprice, status) FROM stdin;
1	1	2023-01-01 13:00:00+01	1200.00	Pending
2	2	2023-01-02 14:00:00+01	1500.00	Shipped
3	3	2023-01-03 15:00:00+01	1000.00	Delivered
4	1	2023-01-04 16:00:00+01	1800.00	Pending
5	2	2023-01-05 17:00:00+01	2000.00	Cancelled
\.


--
-- Data for Name: specialoffers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.specialoffers (offerid, computerid, offerdescription, discountpercent) FROM stdin;
1	1	Discount Offer1	10
2	2	Discount Offer2	15
3	3	Discount Offer3	5
4	4	Discount Offer4	20
5	5	Discount Offer5	25
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (supplierid, name, address, email, phone) FROM stdin;
1	Supplier1	Address1	sup1@example.com	1234567890
2	Supplier2	Address2	sup2@example.com	0987654321
3	Supplier3	Address3	sup3@example.com	1122334455
4	Supplier4	Address4	sup4@example.com	2233445566
5	Supplier5	Address5	sup5@example.com	3344556677
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (userid, name, password, email, role) FROM stdin;
1	user1	pass1	user1@example.com	user
2	user2	pass2	user2@example.com	user
5	admin2	adminpass2	admin2@example.com	admin
3	user3	pass3	user3@example.com	user
4	admin1	adminpass1	admin1@example.com	admin
\.


--
-- Name: components_componentid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.components_componentid_seq', 5, true);


--
-- Name: componentvariants_variantid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.componentvariants_variantid_seq', 21, true);


--
-- Name: computers_computerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.computers_computerid_seq', 5, true);


--
-- Name: orders_orderid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_orderid_seq', 6, true);


--
-- Name: specialoffers_offerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.specialoffers_offerid_seq', 5, true);


--
-- Name: suppliers_supplierid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_supplierid_seq', 5, true);


--
-- Name: users_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_userid_seq', 7, true);


--
-- Name: components components_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_pkey PRIMARY KEY (componentid);


--
-- Name: componentvariants componentvariants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.componentvariants
    ADD CONSTRAINT componentvariants_pkey PRIMARY KEY (variantid);


--
-- Name: computercomponents computercomponents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computercomponents
    ADD CONSTRAINT computercomponents_pkey PRIMARY KEY (computerid, componentid);


--
-- Name: computers computers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computers
    ADD CONSTRAINT computers_pkey PRIMARY KEY (computerid);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orderid);


--
-- Name: specialoffers specialoffers_computerid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialoffers
    ADD CONSTRAINT specialoffers_computerid_key UNIQUE (computerid);


--
-- Name: specialoffers specialoffers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialoffers
    ADD CONSTRAINT specialoffers_pkey PRIMARY KEY (offerid);


--
-- Name: suppliers suppliers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_email_key UNIQUE (email);


--
-- Name: suppliers suppliers_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_phone_key UNIQUE (phone);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supplierid);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- Name: orders trigger_order_status_before_insert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_order_status_before_insert BEFORE INSERT OR UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.update_order_status();


--
-- Name: components components_supplierid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_supplierid_fkey FOREIGN KEY (supplierid) REFERENCES public.suppliers(supplierid);


--
-- Name: componentvariants componentvariants_componentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.componentvariants
    ADD CONSTRAINT componentvariants_componentid_fkey FOREIGN KEY (componentid) REFERENCES public.components(componentid);


--
-- Name: computercomponents computercomponents_componentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computercomponents
    ADD CONSTRAINT computercomponents_componentid_fkey FOREIGN KEY (componentid) REFERENCES public.components(componentid);


--
-- Name: computercomponents computercomponents_computerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computercomponents
    ADD CONSTRAINT computercomponents_computerid_fkey FOREIGN KEY (computerid) REFERENCES public.computers(computerid);


--
-- Name: componentvariants fk_componentid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.componentvariants
    ADD CONSTRAINT fk_componentid FOREIGN KEY (componentid) REFERENCES public.components(componentid) ON DELETE CASCADE;


--
-- Name: orders orders_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(userid);


--
-- Name: specialoffers specialoffers_computerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialoffers
    ADD CONSTRAINT specialoffers_computerid_fkey FOREIGN KEY (computerid) REFERENCES public.computers(computerid);


--
-- PostgreSQL database dump complete
--

