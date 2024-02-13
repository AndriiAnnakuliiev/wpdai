--
-- PostgreSQL database dump
--

-- Dumped from database version 15.6
-- Dumped by pg_dump version 16.2

-- Started on 2024-02-13 04:01:43

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
-- TOC entry 2 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 3413 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 231 (class 1255 OID 16611)
-- Name: calculate_total_price(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_total_price(order_id integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    total_price NUMERIC;
BEGIN
    SELECT SUM(c.Price) * (1 - COALESCE(so.DiscountPercent, 0) / 100) INTO total_price
    FROM Orders o
    JOIN Computers c ON o.ComputerID = c.ComputerID
    LEFT JOIN SpecialOffers so ON c.ComputerID = so.ComputerID
    WHERE o.OrderID = order_id;
    RETURN total_price;
END;
$$;


ALTER FUNCTION public.calculate_total_price(order_id integer) OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 16609)
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
-- TOC entry 220 (class 1259 OID 16533)
-- Name: components; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.components (
    componentid integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(50) NOT NULL,
    specifications text NOT NULL,
    price numeric(10,2) NOT NULL,
    supplierid integer
);


ALTER TABLE public.components OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16569)
-- Name: computercomponents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.computercomponents (
    computerid integer NOT NULL,
    componentid integer NOT NULL
);


ALTER TABLE public.computercomponents OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16547)
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
-- TOC entry 229 (class 1259 OID 16605)
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


ALTER VIEW public."ComputerDetails" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16556)
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
-- TOC entry 216 (class 1259 OID 16508)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    userid integer NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(255),
    isadmin boolean DEFAULT false
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16601)
-- Name: OrdersSummary; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public."OrdersSummary" AS
 SELECT o.orderid,
    u.username,
    o.orderdate,
    o.totalprice,
    o.status
   FROM (public.orders o
     JOIN public.users u ON ((o.userid = u.userid)));


ALTER VIEW public."OrdersSummary" OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16532)
-- Name: components_componentid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.components_componentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.components_componentid_seq OWNER TO postgres;

--
-- TOC entry 3414 (class 0 OID 0)
-- Dependencies: 219
-- Name: components_componentid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.components_componentid_seq OWNED BY public.components.componentid;


--
-- TOC entry 221 (class 1259 OID 16546)
-- Name: computers_computerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.computers_computerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.computers_computerid_seq OWNER TO postgres;

--
-- TOC entry 3415 (class 0 OID 0)
-- Dependencies: 221
-- Name: computers_computerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.computers_computerid_seq OWNED BY public.computers.computerid;


--
-- TOC entry 223 (class 1259 OID 16555)
-- Name: orders_orderid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_orderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_orderid_seq OWNER TO postgres;

--
-- TOC entry 3416 (class 0 OID 0)
-- Dependencies: 223
-- Name: orders_orderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_orderid_seq OWNED BY public.orders.orderid;


--
-- TOC entry 227 (class 1259 OID 16585)
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
-- TOC entry 226 (class 1259 OID 16584)
-- Name: specialoffers_offerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.specialoffers_offerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.specialoffers_offerid_seq OWNER TO postgres;

--
-- TOC entry 3417 (class 0 OID 0)
-- Dependencies: 226
-- Name: specialoffers_offerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.specialoffers_offerid_seq OWNED BY public.specialoffers.offerid;


--
-- TOC entry 218 (class 1259 OID 16520)
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
-- TOC entry 217 (class 1259 OID 16519)
-- Name: suppliers_supplierid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suppliers_supplierid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.suppliers_supplierid_seq OWNER TO postgres;

--
-- TOC entry 3418 (class 0 OID 0)
-- Dependencies: 217
-- Name: suppliers_supplierid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suppliers_supplierid_seq OWNED BY public.suppliers.supplierid;


--
-- TOC entry 215 (class 1259 OID 16507)
-- Name: users_userid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_userid_seq OWNER TO postgres;

--
-- TOC entry 3419 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.userid;


--
-- TOC entry 3216 (class 2604 OID 16536)
-- Name: components componentid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components ALTER COLUMN componentid SET DEFAULT nextval('public.components_componentid_seq'::regclass);


--
-- TOC entry 3217 (class 2604 OID 16550)
-- Name: computers computerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computers ALTER COLUMN computerid SET DEFAULT nextval('public.computers_computerid_seq'::regclass);


--
-- TOC entry 3218 (class 2604 OID 16559)
-- Name: orders orderid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN orderid SET DEFAULT nextval('public.orders_orderid_seq'::regclass);


--
-- TOC entry 3221 (class 2604 OID 16588)
-- Name: specialoffers offerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialoffers ALTER COLUMN offerid SET DEFAULT nextval('public.specialoffers_offerid_seq'::regclass);


--
-- TOC entry 3215 (class 2604 OID 16523)
-- Name: suppliers supplierid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN supplierid SET DEFAULT nextval('public.suppliers_supplierid_seq'::regclass);


--
-- TOC entry 3213 (class 2604 OID 16511)
-- Name: users userid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);


--
-- TOC entry 3400 (class 0 OID 16533)
-- Dependencies: 220
-- Data for Name: components; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.components (componentid, name, type, specifications, price, supplierid) FROM stdin;
1	CPU1	CPU	Specs1	200.00	1
2	GPU1	GPU	Specs2	400.00	1
3	RAM1	RAM	Specs3	150.00	2
4	SSD1	Storage	Specs4	100.00	2
5	PSU1	PSU	Specs5	120.00	3
\.


--
-- TOC entry 3405 (class 0 OID 16569)
-- Dependencies: 225
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
-- TOC entry 3402 (class 0 OID 16547)
-- Dependencies: 222
-- Data for Name: computers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.computers (computerid, modelname, description, price) FROM stdin;
1	Model1	Desc1	1200.00
2	Model2	Desc2	1500.00
3	Model3	Desc3	1000.00
4	Model4	Desc4	1800.00
5	Model5	Desc5	2000.00
\.


--
-- TOC entry 3404 (class 0 OID 16556)
-- Dependencies: 224
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
-- TOC entry 3407 (class 0 OID 16585)
-- Dependencies: 227
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
-- TOC entry 3398 (class 0 OID 16520)
-- Dependencies: 218
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
-- TOC entry 3396 (class 0 OID 16508)
-- Dependencies: 216
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (userid, username, password, email, isadmin) FROM stdin;
1	user1	pass1	user1@example.com	f
2	user2	pass2	user2@example.com	f
3	user3	pass3	user3@example.com	f
4	admin1	adminpass1	admin1@example.com	t
5	admin2	adminpass2	admin2@example.com	t
\.


--
-- TOC entry 3420 (class 0 OID 0)
-- Dependencies: 219
-- Name: components_componentid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.components_componentid_seq', 5, true);


--
-- TOC entry 3421 (class 0 OID 0)
-- Dependencies: 221
-- Name: computers_computerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.computers_computerid_seq', 5, true);


--
-- TOC entry 3422 (class 0 OID 0)
-- Dependencies: 223
-- Name: orders_orderid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_orderid_seq', 6, true);


--
-- TOC entry 3423 (class 0 OID 0)
-- Dependencies: 226
-- Name: specialoffers_offerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.specialoffers_offerid_seq', 5, true);


--
-- TOC entry 3424 (class 0 OID 0)
-- Dependencies: 217
-- Name: suppliers_supplierid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_supplierid_seq', 5, true);


--
-- TOC entry 3425 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_userid_seq', 5, true);


--
-- TOC entry 3234 (class 2606 OID 16540)
-- Name: components components_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_pkey PRIMARY KEY (componentid);


--
-- TOC entry 3240 (class 2606 OID 16573)
-- Name: computercomponents computercomponents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computercomponents
    ADD CONSTRAINT computercomponents_pkey PRIMARY KEY (computerid, componentid);


--
-- TOC entry 3236 (class 2606 OID 16554)
-- Name: computers computers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computers
    ADD CONSTRAINT computers_pkey PRIMARY KEY (computerid);


--
-- TOC entry 3238 (class 2606 OID 16563)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orderid);


--
-- TOC entry 3242 (class 2606 OID 16595)
-- Name: specialoffers specialoffers_computerid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialoffers
    ADD CONSTRAINT specialoffers_computerid_key UNIQUE (computerid);


--
-- TOC entry 3244 (class 2606 OID 16593)
-- Name: specialoffers specialoffers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialoffers
    ADD CONSTRAINT specialoffers_pkey PRIMARY KEY (offerid);


--
-- TOC entry 3228 (class 2606 OID 16529)
-- Name: suppliers suppliers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_email_key UNIQUE (email);


--
-- TOC entry 3230 (class 2606 OID 16531)
-- Name: suppliers suppliers_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_phone_key UNIQUE (phone);


--
-- TOC entry 3232 (class 2606 OID 16527)
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supplierid);


--
-- TOC entry 3224 (class 2606 OID 16518)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3226 (class 2606 OID 16516)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- TOC entry 3250 (class 2620 OID 16610)
-- Name: orders trigger_order_status_before_insert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_order_status_before_insert BEFORE INSERT OR UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.update_order_status();


--
-- TOC entry 3245 (class 2606 OID 16541)
-- Name: components components_supplierid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_supplierid_fkey FOREIGN KEY (supplierid) REFERENCES public.suppliers(supplierid);


--
-- TOC entry 3247 (class 2606 OID 16579)
-- Name: computercomponents computercomponents_componentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computercomponents
    ADD CONSTRAINT computercomponents_componentid_fkey FOREIGN KEY (componentid) REFERENCES public.components(componentid);


--
-- TOC entry 3248 (class 2606 OID 16574)
-- Name: computercomponents computercomponents_computerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computercomponents
    ADD CONSTRAINT computercomponents_computerid_fkey FOREIGN KEY (computerid) REFERENCES public.computers(computerid);


--
-- TOC entry 3246 (class 2606 OID 16564)
-- Name: orders orders_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(userid);


--
-- TOC entry 3249 (class 2606 OID 16596)
-- Name: specialoffers specialoffers_computerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialoffers
    ADD CONSTRAINT specialoffers_computerid_fkey FOREIGN KEY (computerid) REFERENCES public.computers(computerid);


-- Completed on 2024-02-13 04:01:43

--
-- PostgreSQL database dump complete
--

