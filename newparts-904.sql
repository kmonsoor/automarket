--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL,
    discount integer,
    CONSTRAINT auth_group_discount_check CHECK ((discount >= 0))
);


--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_group_id_seq', 2, true);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_message; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE auth_message (
    id integer NOT NULL,
    user_id integer NOT NULL,
    message text NOT NULL
);


--
-- Name: auth_message_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auth_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: auth_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auth_message_id_seq OWNED BY auth_message.id;


--
-- Name: auth_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_message_id_seq', 657, true);


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_permission_id_seq', 45, true);


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE auth_user (
    id integer NOT NULL,
    username character varying(30) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(75) NOT NULL,
    password character varying(128) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    is_superuser boolean NOT NULL,
    last_login timestamp with time zone NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 142, true);


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_user_id_seq', 114, true);


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 6, true);


--
-- Name: data_area; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE data_area (
    id integer NOT NULL,
    title character varying(255) NOT NULL
);


--
-- Name: data_area_brands; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE data_area_brands (
    id integer NOT NULL,
    area_id integer NOT NULL,
    brand_id integer NOT NULL
);


--
-- Name: data_area_brands_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE data_area_brands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: data_area_brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE data_area_brands_id_seq OWNED BY data_area_brands.id;


--
-- Name: data_area_brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('data_area_brands_id_seq', 701, true);


--
-- Name: data_area_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE data_area_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: data_area_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE data_area_id_seq OWNED BY data_area.id;


--
-- Name: data_area_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('data_area_id_seq', 97, true);


--
-- Name: data_brand; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE data_brand (
    id integer NOT NULL,
    title character varying(255) NOT NULL
);


--
-- Name: data_brand_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE data_brand_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: data_brand_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE data_brand_id_seq OWNED BY data_brand.id;


--
-- Name: data_brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('data_brand_id_seq', 114, true);


--
-- Name: data_brandgroup; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE data_brandgroup (
    id integer NOT NULL,
    direction_id integer NOT NULL,
    title character varying(10) NOT NULL,
    description text,
    delivery double precision NOT NULL,
    add_brand_to_comment boolean NOT NULL
);


--
-- Name: data_brandgroup_area; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE data_brandgroup_area (
    id integer NOT NULL,
    brandgroup_id integer NOT NULL,
    area_id integer NOT NULL
);


--
-- Name: data_brandgroup_area_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE data_brandgroup_area_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: data_brandgroup_area_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE data_brandgroup_area_id_seq OWNED BY data_brandgroup_area.id;


--
-- Name: data_brandgroup_area_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('data_brandgroup_area_id_seq', 721, true);


--
-- Name: data_brandgroup_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE data_brandgroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: data_brandgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE data_brandgroup_id_seq OWNED BY data_brandgroup.id;


--
-- Name: data_brandgroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('data_brandgroup_id_seq', 9, true);


--
-- Name: data_direction; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE data_direction (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    po character varying(255) NOT NULL
);


--
-- Name: data_direction_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE data_direction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: data_direction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE data_direction_id_seq OWNED BY data_direction.id;


--
-- Name: data_direction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('data_direction_id_seq', 4, true);


--
-- Name: data_discount; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE data_discount (
    id integer NOT NULL,
    user_id integer NOT NULL,
    area_id integer NOT NULL,
    discount double precision NOT NULL
);


--
-- Name: data_discount_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE data_discount_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: data_discount_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE data_discount_id_seq OWNED BY data_discount.id;


--
-- Name: data_discount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('data_discount_id_seq', 1, true);


--
-- Name: data_ordereditem; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE data_ordereditem (
    id integer NOT NULL,
    brandgroup_id integer NOT NULL,
    area_id integer NOT NULL,
    brand_id integer NOT NULL,
    ponumber integer,
    part_number character varying(255) NOT NULL,
    part_number_superseded character varying(255),
    comment_customer text,
    comment_supplier text,
    quantity integer,
    price_invoice double precision,
    total_w_ship double precision,
    client_id integer NOT NULL,
    client_order_id integer,
    manager_id integer NOT NULL,
    description_ru text,
    description_en text,
    price_base double precision,
    price_sale double precision,
    price_discount double precision,
    weight double precision,
    delivery double precision,
    cost double precision,
    total_cost double precision,
    status character varying(50) NOT NULL,
    status_modified timestamp with time zone,
    previous_status character varying(50),
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    invoice_code character varying(255) NOT NULL,
    CONSTRAINT data_ordereditem_quantity_check CHECK ((quantity >= 0))
);


--
-- Name: data_ordereditem_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE data_ordereditem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: data_ordereditem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE data_ordereditem_id_seq OWNED BY data_ordereditem.id;


--
-- Name: data_ordereditem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('data_ordereditem_id_seq', 1597, true);


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    content_type_id integer,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE django_admin_log_id_seq OWNED BY django_admin_log.id;


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 1075, true);


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_content_type_id_seq', 15, true);


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


--
-- Name: django_site; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE django_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE django_site_id_seq OWNED BY django_site.id;


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_site_id_seq', 1, true);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE auth_message ALTER COLUMN id SET DEFAULT nextval('auth_message_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE data_area ALTER COLUMN id SET DEFAULT nextval('data_area_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE data_area_brands ALTER COLUMN id SET DEFAULT nextval('data_area_brands_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE data_brand ALTER COLUMN id SET DEFAULT nextval('data_brand_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE data_brandgroup ALTER COLUMN id SET DEFAULT nextval('data_brandgroup_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE data_brandgroup_area ALTER COLUMN id SET DEFAULT nextval('data_brandgroup_area_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE data_direction ALTER COLUMN id SET DEFAULT nextval('data_direction_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE data_discount ALTER COLUMN id SET DEFAULT nextval('data_discount_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE data_ordereditem ALTER COLUMN id SET DEFAULT nextval('data_ordereditem_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE django_site ALTER COLUMN id SET DEFAULT nextval('django_site_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_group (id, name, discount) FROM stdin;
1	Пользователи	0
2	Розница	0
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_message; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_message (id, user_id, message) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add permission	1	add_permission
2	Can change permission	1	change_permission
3	Can delete permission	1	delete_permission
4	Can add group	2	add_group
5	Can change group	2	change_group
6	Can delete group	2	delete_group
7	Can add user	3	add_user
8	Can change user	3	change_user
9	Can delete user	3	delete_user
10	Can add message	4	add_message
11	Can change message	4	change_message
12	Can delete message	4	delete_message
13	Can add content type	5	add_contenttype
14	Can change content type	5	change_contenttype
15	Can delete content type	5	delete_contenttype
16	Can add session	6	add_session
17	Can change session	6	change_session
18	Can delete session	6	delete_session
19	Can add site	7	add_site
20	Can change site	7	change_site
21	Can delete site	7	delete_site
22	Can add log entry	8	add_logentry
23	Can change log entry	8	change_logentry
24	Can delete log entry	8	delete_logentry
25	Can add Направление	9	add_direction
26	Can change Направление	9	change_direction
27	Can delete Направление	9	delete_direction
28	Can add Группа поставщиков	10	add_brandgroup
29	Can change Группа поставщиков	10	change_brandgroup
30	Can delete Группа поставщиков	10	delete_brandgroup
31	Can add Поставщик	11	add_area
32	Can change Поставщик	11	change_area
33	Can delete Поставщик	11	delete_area
34	Can add Бренд	12	add_brand
35	Can change Бренд	12	change_brand
36	Can delete Бренд	12	delete_brand
37	Can add Заказанная позиция	13	add_ordereditem
38	Can change Заказанная позиция	13	change_ordereditem
39	Can delete Заказанная позиция	13	delete_ordereditem
43	Can add Скидка	15	add_discount
44	Can change Скидка	15	change_discount
45	Can delete Скидка	15	delete_discount
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_user (id, username, first_name, last_name, email, password, is_staff, is_active, is_superuser, last_login, date_joined) FROM stdin;
5	vk	Кирилл			sha1$ddb80$e61d2165fba9751dda13b359e037fcdc5df7052d	f	t	f	2011-02-02 19:34:27+01	2011-02-02 19:34:27+01
7	sx	Александр			sha1$ddb80$3bf60245ce0693cca42a4799d5ff04007ca171e2	f	t	f	2011-02-02 19:37:05+01	2011-02-02 19:37:05+01
10	iv	Игорь			sha1$80e59$d4a9ec3f95a90fdc8dc769feea5a208878df2ddf	f	t	f	2011-02-02 19:42:09+01	2011-02-02 19:42:09+01
3	aps	Александр Моисеевич			sha1$286ce$59acb886874391060e77aa84f087ec44675c08c1	f	t	f	2011-04-04 19:03:01.566177+02	2011-01-28 00:28:31+01
18	v3181444	v3181444			sha1$cc950$e31bbbcd4dc481d23c3ca8a2485c2527beb8a91a	f	t	f	2011-02-17 15:09:27+01	2011-02-17 15:09:27+01
19	v6606055	Олег Александрович			sha1$1cb48$86fc820d20c9addff3d5257a21860756fde18b33	f	t	f	2011-02-17 15:10:04+01	2011-02-17 15:10:04+01
20	v7787898	v7787898			sha1$db7f7$3fafc84fb5e25f8190765b5a36619e7752de28f9	f	t	f	2011-02-17 15:10:57+01	2011-02-17 15:10:57+01
21	v6572563	v6572563			sha1$a324f$519d6c9e95dca847c8f4483c9e397823adf317de	f	t	f	2011-02-17 15:11:40+01	2011-02-17 15:11:40+01
27	vp	Виталий			sha1$5e81a$7a99aec0a8db5909054167cc02a8f28e490b5e2a	f	t	f	2011-02-22 21:22:50+01	2011-02-22 21:22:50+01
28	v3363133	v3363133  			sha1$8cf19$f79e631b7bd04ff743fba194e72df9b73d888ba5	f	t	f	2011-02-22 21:48:02+01	2011-02-22 21:48:02+01
49	v6501818				sha1$5cddf$cf1ca21b225c6d4efab72b5b2eb2391ed2d4574c	f	t	f	2011-03-08 16:16:28+01	2011-03-08 16:16:28+01
29	v3177961	v3177961			sha1$73b14$3059543adabf5210b79cdbf0f8cc9034068681d6	f	t	f	2011-02-22 21:48:56+01	2011-02-22 21:48:56+01
30	m5754272	m5754272			sha1$aec11$faa763af99cdceb3c2b3716e2e4e8b5a496d3c95	f	t	f	2011-02-22 21:50:08+01	2011-02-22 21:50:08+01
40	rsxrename				sha1$71a7f$18c4bf17e1698c38805ffc3b7adf671483ee1204	f	t	f	2011-03-03 21:27:17+01	2011-03-03 21:27:17+01
31	nr	Валерий			sha1$24af2$eb9c7b670cc11ff4885af264b8ff62ae7fe96115	f	t	f	2011-02-23 15:29:24+01	2011-02-23 15:29:24+01
22	v1344777	v1344777			sha1$11065$18558709a181040c784f816417e1a50d2ac77191	f	t	f	2011-02-17 17:19:38+01	2011-02-17 17:19:38+01
41	ed	Эдик			sha1$7c071$20c105c38415c88ec97cdc933621dd310f633de5	f	t	f	2011-03-03 21:29:06+01	2011-03-03 21:29:06+01
32	v6192154	v6192154			sha1$31767$263570738a5d2eb478e32ae9698c9da141597a57	f	t	f	2011-02-23 16:02:46+01	2011-02-23 16:02:46+01
42	tl				sha1$a4ba5$ef4705cc979e6cc73fa0a918569940d1616e622a	f	t	f	2011-03-03 22:04:46+01	2011-03-03 22:04:46+01
17	v6531911	V6531911			sha1$62252$ebafcf131321d8f0df138eb77517eddcc52d5afb	f	t	f	2011-02-17 12:34:48+01	2011-02-17 12:34:48+01
25	retail				sha1$c0e1d$8555ef1ee3d23d515d87dcca482c14eed14f2c25	f	t	f	2011-04-06 20:34:57.940298+02	2011-02-17 21:47:05+01
16	v6633927	v6633927			sha1$5cc82$74d85f9762b20396c9837d20404e311b108c6f49	f	t	f	2011-02-17 12:34:00+01	2011-02-17 12:34:00+01
15	v6684658	v6684658			sha1$c0f29$0d352c0531e7d025a107b326d40e020d28aa735b	f	t	f	2011-02-17 12:32:58+01	2011-02-17 12:32:58+01
33	v6712494	v6712494			sha1$bd2d3$2e0c3872b138909ac609520152e8d2b9b40b99e3	f	t	f	2011-02-23 19:25:14+01	2011-02-23 19:25:14+01
34	v6325623	v6325623			sha1$4150e$94d22ad76bb80e8603b97ba55beab4e3b1a537d0	f	t	f	2011-02-23 19:33:34+01	2011-02-23 19:33:34+01
50	v3085238	Dodge Durango			sha1$3882c$154443169cd8ee7d9222cf68e409894524c5b829	f	t	f	2011-03-21 16:14:34+01	2011-03-21 16:14:34+01
13	sg	Сергей			sha1$ddb80$a5e2d326b5346aa65bc95cb39ef23c7e7eb6c8dc	f	t	f	2011-02-21 12:30:11.678232+01	2011-02-02 21:34:48+01
35	v6628036	v6628036			sha1$a3e8e$276a20e101298c045a5c242a03805a20501827b5	f	t	f	2011-02-23 19:44:40+01	2011-02-23 19:44:40+01
39	v6232706	v6232706			sha1$8dddf$eae08e29726feb32e9197824d5073bb6ad457e08	f	t	f	2011-02-24 22:55:36+01	2011-02-24 22:55:36+01
36	mi	Михаил			sha1$5646b$65674697ea6b34dd85790f1fdc99c2ebe24e5ebf	f	t	f	2011-02-23 19:57:22+01	2011-02-23 19:57:22+01
37	v6270092	v6270092			sha1$0b30d$0b763f28aa2993e6b12c9056e89cf17ba27ed71d	f	t	f	2011-02-23 20:05:41+01	2011-02-23 20:05:41+01
38	m7153689	m7153689			sha1$3a346$e85566ec68bf1908c99e2e8dd33643cc8ce1e734	f	t	f	2011-02-23 20:32:21+01	2011-02-23 20:32:21+01
43	ukr	Слава			sha1$3d43a$577246d739e87580f3983a2a99f3bec94e43c2ad	f	t	f	2011-03-08 14:19:13+01	2011-03-08 14:19:13+01
51	v6460263	Nissan Sentra			sha1$de9ce$71a1d92cbf8f13d26e1c0749a524db47d106419d	f	t	f	2011-03-21 16:48:07+01	2011-03-21 16:48:07+01
44	v3349017	Игорь			sha1$d4b6b$40cf7d8246d688d5473bebed92f06064cb7fdb85	f	t	f	2011-03-08 15:26:35+01	2011-03-08 15:26:35+01
45	vbr	Вова			sha1$f0985$82f5c615fb10c6afffc8045bfe1cd6fec77c0f37	f	t	f	2011-03-08 15:41:45+01	2011-03-08 15:41:45+01
57	m7042483				sha1$c9296$e4a2fb7aa647de64b7a94ee483d037356cf3ff2b	f	t	f	2011-03-21 17:18:43+01	2011-03-21 17:18:43+01
52	pi	Сергей			sha1$c5db8$4c6e56305ca0af6cbdd18ad5ce55fc3263e7cd77	f	t	f	2011-03-21 16:51:31+01	2011-03-21 16:51:31+01
46	v3363134				sha1$2c824$76d6d07138087f9e999fae31ce312243ccf62d09	f	t	f	2011-03-08 15:54:46+01	2011-03-08 15:54:46+01
60	v3846372				sha1$c1079$85c6a110f22e15bb7e388670f6064dfb61b41c20	f	t	f	2011-03-21 18:19:33+01	2011-03-21 18:19:33+01
47	mbr	Макат			sha1$e8326$3c3778067b62f9d8de5d39d8c00b9cc0594c2aa4	f	t	f	2011-03-08 15:55:21+01	2011-03-08 15:55:21+01
48	v6657189	Cadillac SRX			sha1$e671e$6dab035f642c3c90d1fd222a04ef570481a2ea9c	f	t	f	2011-03-08 15:56:58+01	2011-03-08 15:56:58+01
53	v3263556	Ford Mustang			sha1$3e2b0$5034b91eddf556950145cb22968c22335a6db553	f	t	f	2011-03-21 17:14:07+01	2011-03-21 17:14:07+01
54	v3726769	v3726769			sha1$2ce12$c91c458825f712d5d4cd27a3dabd20094abbac71	f	t	f	2011-03-21 17:15:35+01	2011-03-21 17:15:35+01
55	v3263557				sha1$7762a$4137d388df68cf8501f96ad4feacf145b433035c	f	t	f	2011-03-21 17:16:58+01	2011-03-21 17:16:58+01
62	v6061421				sha1$03dc7$fe2798aced63f300b5fee21d38943d143170e6c6	f	t	f	2011-03-21 18:29:29+01	2011-03-21 18:29:29+01
26	7p	Дмитрий			sha1$34bba$9a2953a9519a184d43116e7b528fa8baabbf711d	f	t	f	2011-03-28 23:36:19.192792+02	2011-02-22 21:21:19+01
56	v6863266				sha1$eff19$96ddfa8ded316fa0ffcf1511491f918f09e60e59	f	t	f	2011-03-21 17:17:55+01	2011-03-21 17:17:55+01
58	v7621389				sha1$86044$dab9e63d74415e630aa2d202234cb5783b5d7793	f	t	f	2011-03-21 17:56:44+01	2011-03-21 17:56:44+01
59	v6262262	Юра			sha1$1acc2$f29b6caf9c1f2e217b25630195a66669a3179b15	f	t	f	2011-03-21 18:06:05+01	2011-03-21 18:06:05+01
2	manager				sha1$df2d8$a1d7fd7cbb5984696514e77fb72da769098f051b	t	t	f	2011-04-08 17:48:41.380596+02	2011-01-26 23:06:24+01
61	v7690095				sha1$8e96e$e0fc99da7cca955a063bfba21f3749a1b3261f66	f	t	f	2011-03-21 18:24:44+01	2011-03-21 18:24:44+01
63	v6505474				sha1$fd02d$c7c69685d1c0425512c0bd4874cd874e8f5d40d0	f	t	f	2011-03-25 12:25:50+01	2011-03-25 12:25:50+01
1	admin			admin@admin.com	sha1$086ae$25886355d6bd8dec52e30ea4bb6411314c1e26ba	t	t	t	2011-04-09 16:13:48.722544+02	2011-01-27 20:59:18.656846+01
64	v6061423				sha1$87a16$9c8043534437260d79934d7510eb31e8d939ed69	f	t	f	2011-03-25 12:26:31+01	2011-03-25 12:26:31+01
65	v1955818	Андрей			sha1$a8ea7$132cb3d29cc23e2af941d7175fc6a7f93b49b5d1	f	t	f	2011-03-25 14:15:36+01	2011-03-25 14:15:36+01
66	v6667175	Mitsubishi Galant			sha1$79c96$7fb2536cd2734305221cd81d3fee9442ff276776	f	t	f	2011-03-25 14:18:22+01	2011-03-25 14:18:22+01
67	v3595692	Виталий Escalade			sha1$ae9b3$83810968c08ff7543d521e6a668f8a0cb7433c12	f	t	f	2011-03-25 14:19:47+01	2011-03-25 14:19:47+01
68	v6766268	Chrysler 300C			sha1$e5ed1$8a16e93b84606c5d3f3bb2401abe50e8e9c6cc15	f	t	f	2011-03-25 14:21:11+01	2011-03-25 14:21:11+01
69	saka	Дмитрий			sha1$3d6b9$00b75620cb0617344f0e9cec818c1b6a01e28da3	f	t	f	2011-03-25 14:29:15+01	2011-03-25 14:29:15+01
6	kp	Константин			wrx	f	t	f	2011-02-02 19:36:05+01	2011-02-02 19:36:05+01
4	dp	Дмитрий			sha1$909cf$a790efd7f7623bceaeca53d418a2062fe068f6d3	f	t	f	2011-04-09 13:29:37.032553+02	2011-02-02 19:32:24+01
70	v6221214	Jeep Liberty			sha1$49bea$d51534c6c655e1d7f334d30010b5c0e4d9b22065	f	t	f	2011-03-25 15:01:59+01	2011-03-25 15:01:59+01
71	l9877361				sha1$b2ba8$7ae702a2fc2a0255c9a4a9d6719e622b66c03297	f	t	f	2011-03-25 21:24:40+01	2011-03-25 21:24:40+01
72	v6223820	Максим			sha1$be46b$fec7dde805b986aedea3152002b42f5d8ab6ff21	f	t	f	2011-03-25 21:43:12+01	2011-03-25 21:43:12+01
73	v6591403				sha1$d705e$b11a23adb712dea47c6d8d59876aa77f203e672c	f	t	f	2011-03-25 22:14:01+01	2011-03-25 22:14:01+01
74	v1818366				sha1$c0089$536451b8da2caa03aa6bf7e59c436fa24e4d4c76	f	t	f	2011-03-28 19:34:49+02	2011-03-28 19:34:49+02
75	v6580334				sha1$13ee1$e9a32606e4ca04433ead08a44dce0ae986164cd9	f	t	f	2011-03-28 19:41:17+02	2011-03-28 19:41:17+02
76	v3444909				sha1$dc2da$6b0680846cf792bbb1996ca5d832043d863c3f4e	f	t	f	2011-03-28 20:01:19+02	2011-03-28 20:01:19+02
101	sl	Алексей			sha1$f741b$5c47d5394365f6d68615b33603c37b5a0cb02481	f	t	f	2011-04-04 17:59:52+02	2011-04-04 17:59:52+02
78	v6716736	Ford E350			sha1$b937d$c1a53270ac3c2414f850e5be064a4301ac120276	f	t	f	2011-03-28 23:50:23+02	2011-03-28 23:50:23+02
77	m2746754	Ford Escape			sha1$fb51d$16120fac68a778e475a6adf193c5afc8db07a685	f	t	f	2011-03-28 23:49:23+02	2011-03-28 23:49:23+02
79	v6599513				sha1$1ffb5$afc8ff754467277753f441a8ed16be151f6ebd0f	f	t	f	2011-03-29 00:01:03+02	2011-03-29 00:01:03+02
80	v6041857				sha1$7cae6$52188ef0997abb51e79beb378e72448ba6200aba	f	t	f	2011-03-29 10:59:29+02	2011-03-29 10:59:29+02
81	v3181445				sha1$38b00$db982d37e08e4323436009193bdbc13ebd9598da	f	t	f	2011-03-29 12:00:57+02	2011-03-29 12:00:57+02
82	v6756191				sha1$915bf$1f6caa79eff667b77cbb2732d22d702b90c28d9c	f	t	f	2011-03-29 12:06:36+02	2011-03-29 12:06:36+02
83	v6533731	Jeep Commander			sha1$7bf79$8260453063154bfeb648fbdee25fa57ac1943b85	f	t	f	2011-03-29 14:25:27+02	2011-03-29 14:25:27+02
84	v6926906				sha1$8b080$78c1d59fc468867f2c67c779900c75f0ae33f3cf	f	t	f	2011-03-29 14:27:44+02	2011-03-29 14:27:44+02
85	v6452070				sha1$a74c0$965c6c3df322612599a330432d7bafd423cff66e	f	t	f	2011-03-29 14:42:10+02	2011-03-29 14:42:10+02
86	v5830207				sha1$a0068$3e60a1da290df037b263888478a47aceff20e86e	f	t	f	2011-03-30 14:17:31+02	2011-03-30 14:17:31+02
87	v6056056				sha1$58a7b$b82284d605c8097fb3afc52e2dbc22760199a791	f	t	f	2011-03-30 14:18:50+02	2011-03-30 14:18:50+02
88	v6550588				sha1$581f2$42043dc1505c630c696551700f0eab49f301739c	f	t	f	2011-03-30 14:29:29+02	2011-03-30 14:29:29+02
89	vl				sha1$49b35$7a692db4f0eb5ac6d3516b7de3ce4bee807bf733	f	t	f	2011-03-30 14:38:42+02	2011-03-30 14:38:42+02
90	v6500758				sha1$56fb7$871f78edb9c6b880bc9d317f53767eb20ea822f0	f	t	f	2011-03-30 14:52:55+02	2011-03-30 14:52:55+02
91	v7003071				sha1$8b9c7$a1381455a2b3aea63c96027b0ec90137118a1151	f	t	f	2011-03-30 15:44:51+02	2011-03-30 15:44:51+02
92	v7026886				sha1$c602f$5440a48ea476f5906be51292c8452bc7733ef8cf	f	t	f	2011-03-30 15:45:59+02	2011-03-30 15:45:59+02
93	v6298480				sha1$69c20$2de0f1e966f32bf35e40aa9ffd9a9b3ef8c36f0e	f	t	f	2011-03-30 15:46:48+02	2011-03-30 15:46:48+02
94	m7003071				sha1$0238c$684054b4a10bb928838403eac38c01e49898a8d5	f	t	f	2011-03-30 15:48:26+02	2011-03-30 15:48:26+02
95	v6017021				sha1$9fa42$59a040c168a0a2bf1253a75bd99421f76ae9ef19	f	t	f	2011-03-30 16:08:47+02	2011-03-30 16:08:47+02
96	v3485164				sha1$480bb$541a2f740a5e74824eb5287b37ca22c153aa2b17	f	t	f	2011-03-30 18:11:42+02	2011-03-30 18:11:42+02
97	v6657190				sha1$dd372$5cdbc88c60ad1e015c9e183e3f4dc0aa43101ddb	f	t	f	2011-03-30 18:12:57+02	2011-03-30 18:12:57+02
98	v7468052				sha1$5b894$0187d53b0d76af37fa6bc3f06b8fea65e64293f9	f	t	f	2011-03-30 19:33:38+02	2011-03-30 19:33:38+02
99	v3222220				sha1$0616c$1accbffbb33c1a9b534500c875390d613fe112d3	f	t	f	2011-03-30 21:52:14+02	2011-03-30 21:52:14+02
100	v6642642				sha1$f32c8$e4ed49f670d603a48fe329502d960c21ad5a8955	f	t	f	2011-03-30 21:54:02+02	2011-03-30 21:54:02+02
102	kos	Константин			sha1$6d247$0910f5b9e46796d1f51eea691d27b6285989e3f8	f	t	f	2011-04-05 13:21:19+02	2011-04-05 13:21:19+02
103	us	Александр			sha1$7ad34$a7473ca722b908c637e42e223a3eab97b384610e	f	t	f	2011-04-05 14:32:26+02	2011-04-05 14:32:26+02
104	v6635020	Lexus RX330			sha1$e97a2$62a1cb4d965c509ed9f2ece52d932754a4508804	f	t	f	2011-04-05 14:34:26+02	2011-04-05 14:34:26+02
105	v5848448				sha1$afffc$554609cfc124221bb4362a79fffd43d841817686	f	t	f	2011-04-05 17:30:50+02	2011-04-05 17:30:50+02
107	m7766950				sha1$e8a27$d6ca968a32d92e9e665e60e44b138a641b82dc9c	f	t	f	2011-04-06 19:20:13+02	2011-04-06 19:20:13+02
108	v1727318	Mitsubishi Eclipse	Мария		sha1$516b3$fd273426e2e1bd2769ff72cc31ecc73c26543703	f	t	f	2011-04-07 15:07:29+02	2011-04-07 15:07:29+02
109	v3358598				sha1$6387d$73ee9d9fb930aa21a5813298f693d4b6e48b779c	f	t	f	2011-04-07 16:19:28+02	2011-04-07 16:19:28+02
110	v3417576				sha1$7e8df$57c8523d9d93fe55b9a67f79d605076bd9b58967	f	t	f	2011-04-07 16:20:03+02	2011-04-07 16:20:03+02
111	v6974360				sha1$0bace$5669a0eab4ace801ea143b99c57bbaeb746668b0	f	t	f	2011-04-07 17:56:31+02	2011-04-07 17:56:31+02
112	m7559944	Ford Windstar			sha1$70d2a$1174f67584843a997430564505aefc83a89f3d07	f	t	f	2011-04-08 13:41:35+02	2011-04-08 13:41:35+02
113	v1563022				sha1$03ffe$7083d19b8f7561b382018fc22be4b68402718f1a	f	t	f	2011-04-08 14:32:56+02	2011-04-08 14:32:56+02
114	v1449022				sha1$f6ba5$364ab78b59b7f5d3ad1b6c50833485b221075829	f	t	f	2011-04-08 18:15:28+02	2011-04-08 18:15:28+02
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
5	5	1
7	7	1
11	10	1
19	13	1
34	17	1
36	16	1
37	15	1
38	18	1
39	19	1
40	20	1
41	21	1
42	22	1
46	26	1
47	27	1
48	28	1
49	29	1
50	30	1
51	31	1
52	32	1
53	33	1
54	34	1
55	35	1
56	36	1
57	37	1
58	38	1
59	3	1
61	39	1
62	40	1
63	41	1
64	42	1
65	43	1
66	44	1
67	45	1
68	46	1
69	47	1
70	48	1
71	49	1
72	50	1
73	51	1
74	52	1
75	53	1
76	54	1
77	55	1
78	56	1
79	57	1
80	58	1
81	59	1
82	60	1
83	61	1
84	62	1
85	63	1
86	64	1
87	65	1
88	66	1
89	67	1
90	68	1
91	69	1
92	70	1
93	71	1
94	72	1
95	73	1
96	74	1
97	75	1
98	76	1
99	25	1
101	78	1
102	77	1
103	79	1
104	80	1
105	81	1
106	82	1
107	83	1
108	84	1
109	85	1
110	86	1
111	87	1
112	88	1
113	89	1
114	90	1
115	91	1
116	92	1
117	93	1
118	94	1
119	95	1
121	2	1
122	96	1
123	97	1
124	4	1
125	98	1
126	99	1
127	100	1
128	101	1
129	102	1
130	103	1
131	104	1
132	105	1
134	107	1
135	108	1
136	109	1
137	110	1
138	111	1
139	112	1
140	113	1
141	114	1
142	6	1
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
3	2	8
4	2	34
5	2	35
6	2	7
\.


--
-- Data for Name: data_area; Type: TABLE DATA; Schema: public; Owner: -
--

COPY data_area (id, title) FROM stdin;
3	Audi
5	Buick
6	Cadillac
7	Chevrolet/geo
8	Chrysler
9	Dodge
10	Eagle
16	Isuzu
18	Jeep
20	Land rover
22	Lincoln
24	Mercury
27	Oldsmobile
28	Plymouth
29	Pontiac
32	Saturn
36	Volkswagen
37	Volvo
38	Scion
39	Mercedes-benz
40	Daewoo
41	Hummer
42	Mini
57	Summit
55	Weathertech
74	Erv : склад 1
12	Gm
23	Mazda
47	Mopar
2	Acura
13	Honda
34	Suzuki
21	Lexus
33	Subaru
15	Infiniti
26	Nissan
14	Hyundai
11	Ford
35	Toyota
61	Empireauto
46	Nexpart
64	Эмираты 8
50	Pu
25	Mitsubishi
31	Saab
48	Ebay
49	Tr
77	Ame
52	Magnum
45	Ekeystone
19	Kia
80	Rum
70	Ave
68	Berlin
72	Hoz1
65	Ame1
73	Ahon
81	Германия 2
63	Kta
82	Japan5
78	Tti
84	Склад 4
85	Acs
83	Mja5
30	Porsche
17	Jaguar
87	Usa1
67	Склад 34
88	Mmm1
89	Dmn
86	Jc
53	Other
90	As
43	Turboii
58	Ronayers
91	Asm
93	Склад 8
94	Kot1
4	Bmw
66	Pls
79	Ex
71	Эмираты f : nll
95	Склад 5
92	Piv
96	Эмираты 5
51	Wop
97	Asva2
62	Rockauto
\.


--
-- Data for Name: data_area_brands; Type: TABLE DATA; Schema: public; Owner: -
--

COPY data_area_brands (id, area_id, brand_id) FROM stdin;
387	52	89
388	52	71
389	52	95
16	57	11
17	57	12
18	57	13
22	55	47
500	79	2
501	79	3
502	79	4
503	79	5
504	79	6
505	79	7
59	12	32
60	12	5
61	12	6
62	12	7
63	12	27
64	12	29
65	23	23
66	47	8
67	47	9
68	47	10
69	47	47
70	47	18
71	47	28
73	2	2
74	13	13
75	34	34
76	21	21
77	33	33
78	15	15
79	26	26
80	14	14
81	11	24
82	11	11
83	11	22
84	35	35
506	79	8
507	79	9
87	61	60
88	46	61
89	46	62
508	79	10
509	79	11
510	79	12
511	79	13
512	79	14
513	79	15
514	79	16
515	79	17
516	79	18
102	64	13
517	79	19
518	79	20
519	79	21
520	79	22
521	79	23
522	79	24
523	79	25
110	25	25
524	79	26
412	45	64
413	45	97
307	43	69
115	48	59
308	43	80
309	43	81
310	43	84
311	43	58
312	43	90
313	58	34
314	58	13
315	58	78
525	79	27
526	79	28
527	79	29
528	79	30
529	79	31
530	79	32
531	79	33
532	79	34
533	79	35
534	79	36
414	45	58
535	79	37
536	79	38
415	45	63
416	45	71
139	70	76
537	79	39
142	68	4
143	68	13
144	72	13
145	65	26
146	65	68
147	65	63
148	73	13
538	79	40
539	79	41
540	79	42
541	79	47
542	79	55
543	79	56
544	79	58
545	79	61
546	79	62
547	79	63
548	79	64
549	79	67
550	79	68
551	79	69
552	79	71
553	79	72
554	79	73
555	79	74
556	79	76
557	79	77
558	79	78
559	79	80
440	19	19
560	79	81
561	79	82
562	79	83
441	80	63
442	81	13
443	63	3
444	63	2
356	74	26
357	74	13
563	79	84
359	50	79
183	30	30
184	17	17
445	63	35
446	63	26
360	31	31
447	82	26
362	49	94
363	77	11
364	77	62
365	77	63
564	79	85
448	78	84
449	78	93
565	79	86
451	84	99
452	85	100
566	79	89
567	79	90
453	83	11
454	83	35
456	87	13
457	67	74
458	67	101
459	88	8
460	89	26
461	86	26
462	86	35
463	53	102
466	90	103
467	91	26
469	93	104
470	94	4
472	4	4
473	66	106
474	66	61
475	66	93
568	79	91
569	79	92
570	79	93
571	79	95
572	79	96
573	79	97
574	79	98
575	79	99
576	79	100
577	79	101
578	79	103
579	79	104
580	79	105
581	79	106
582	79	107
583	71	26
584	95	105
585	95	108
586	92	4
587	92	109
613	96	33
614	96	34
615	96	35
616	96	40
617	96	13
618	96	14
619	96	19
620	96	23
621	96	25
622	96	26
674	51	112
675	97	113
676	62	58
677	62	63
678	62	64
679	62	69
680	62	70
681	62	71
682	62	72
683	62	73
684	62	77
685	62	81
686	62	82
687	62	83
688	62	84
689	62	85
690	62	86
691	62	87
692	62	88
693	62	89
694	62	90
695	62	91
696	62	92
697	62	96
698	62	98
699	62	107
700	62	110
701	62	114
\.


--
-- Data for Name: data_brand; Type: TABLE DATA; Schema: public; Owner: -
--

COPY data_brand (id, title) FROM stdin;
2	Acura
3	Audi
4	Bmw
5	Buick
6	Cadillac
8	Chrysler
9	Dodge
10	Eagle
11	Ford
13	Honda
14	Hyundai
15	Infiniti
16	Isuzu
17	Jaguar
18	Jeep
19	Kia
20	Land rover
21	Lexus
22	Lincoln
23	Mazda
24	Mercury
25	Mitsubishi
26	Nissan
27	Oldsmobile
28	Plymouth
29	Pontiac
30	Porsche
31	Saab
32	Saturn
33	Subaru
34	Suzuki
35	Toyota
36	Volkswagen
37	Volvo
38	Scion
39	Mercedes-benz
40	Daewoo
41	Hummer
42	Mini
47	Mopar
53	Other
55	Weathertech
56	Bentley
58	Dorman
59	Ebay
60	Taiwan
61	Acdelco
62	Motorcraft
63	Raybestos
64	Anchor
12	Gm
67	Gmc
68	Sh auto parts
7	Chevrolet
69	Tyc
70	Rock products
71	Fel-pro
73	Atp
72	Bendix
74	Signeda
76	Bosch
77	Cardone
78	Kawasaki
80	Centric
81	Timken
79	Pu
82	Gates
83	Wix
84	Moog
85	Wills
86	Airtex
87	Various
88	Sherman
89	Sealed power
90	Standard
91	Ultrapower
92	National
93	Monroe
94	Tr
95	Clevite
96	Pci
97	K&N
98	Fram
99	Bodyparts
100	Termal
101	Api
104	Textar
105	Swag
106	Wagner
103	Delta autotechnik
107	Aup
108	Akebono
109	Dayco
102	Drivetrain.com
110	Denso
112	Bombardier
113	Febest
114	Stant
\.


--
-- Data for Name: data_brandgroup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY data_brandgroup (id, direction_id, title, description, delivery, add_brand_to_comment) FROM stdin;
5	2	AFTMARK		13	t
1	1	EXAP		0	f
6	2	MOTO		13	f
2	1	DOCAP		0	f
7	2	ONLINE		13.5	f
4	2	OEM		0	f
\.


--
-- Data for Name: data_brandgroup_area; Type: TABLE DATA; Schema: public; Owner: -
--

COPY data_brandgroup_area (id, brandgroup_id, area_id) FROM stdin;
624	6	49
625	6	50
626	6	51
627	6	58
628	2	4
629	2	63
630	2	64
631	2	65
632	2	66
633	2	67
634	2	68
635	2	70
702	4	33
703	4	2
704	4	35
705	4	40
706	4	15
707	4	11
708	4	12
709	4	34
710	4	14
711	4	13
712	4	17
713	4	19
714	4	20
715	4	21
716	4	23
717	4	25
718	4	26
719	4	47
720	4	30
721	4	31
636	2	71
637	2	72
638	2	73
639	2	74
640	2	77
641	2	78
642	2	80
643	2	81
644	2	82
645	2	83
646	2	84
647	2	85
648	2	86
649	2	87
650	2	88
651	2	89
652	2	90
653	2	91
654	2	92
655	2	93
656	2	94
657	2	95
658	2	96
192	5	43
193	5	45
194	5	46
195	5	52
196	5	61
197	5	62
659	2	97
660	7	48
661	7	53
211	1	79
\.


--
-- Data for Name: data_direction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY data_direction (id, title, po) FROM stdin;
2	US	SP
1	MSK	MP
\.


--
-- Data for Name: data_discount; Type: TABLE DATA; Schema: public; Owner: -
--

COPY data_discount (id, user_id, area_id, discount) FROM stdin;
\.


--
-- Data for Name: data_ordereditem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY data_ordereditem (id, brandgroup_id, area_id, brand_id, ponumber, part_number, part_number_superseded, comment_customer, comment_supplier, quantity, price_invoice, total_w_ship, client_id, client_order_id, manager_id, description_ru, description_en, price_base, price_sale, price_discount, weight, delivery, cost, total_cost, status, status_modified, previous_status, created, modified, invoice_code) FROM stdin;
272	4	47	47	1	4609106	4609106AB			1	6.0999999999999996	6.0999999999999996	4	1	1	Концевик двери	Door jamb switch	8.5999999999999996	7.7400000000000002	\N	0.01	0.13	7.8700000000000001	7.8700000000000001	issued	2011-02-24 19:34:48.065319+01	superseded	2011-02-17 15:34:23.90775+01	2011-02-24 19:34:48.070237+01	#93
279	4	2	2	1	11910PR3010	\N			1	40.649999999999999	40.649999999999999	4	1	1	Кронштейн	BRACKET	53.57	48.210000000000001	\N	1.2050000000000001	15.665000000000001	63.875	63.875	issued	2011-02-23 23:40:48.7275+01	received_office	2011-02-17 15:34:23.956212+01	2011-02-23 23:53:24.572025+01	#93
297	4	11	11	1	8L8Z17K707A	\N			1	23.82	23.82	4	1	1	Стекло зеркала	Mirror glass	32.979999999999997	29.68	\N	0.37	4.8099999999999996	34.490000000000002	34.490000000000002	issued	2011-04-06 12:14:34.806952+02	received_office	2011-02-17 15:34:24.06773+01	2011-04-06 12:14:34.811918+02	#94
304	4	23	23	3	LF0114320A9U	\N			1	12.17	12.17	3	1	1	крышка фильтра	filter civer	17.149999999999999	14.07	14.07	0.17000000000000001	2.21	16.280000000000001	16.280000000000001	issued	2011-04-01 12:46:56.501246+02	received_office	2011-02-17 15:36:10.67941+01	2011-04-06 12:14:28.933093+02	#94
275	4	13	13	1	72141TA5A11	\N			1	9.4299999999999997	9.4299999999999997	4	1	1	Ручка двери	Handle outside	12.65	11.390000000000001	\N	0.115	1.4950000000000001	12.885000000000002	12.885000000000002	issued	2011-04-06 12:15:05.907668+02	received_office	2011-02-17 15:34:23.928419+01	2011-04-06 12:15:05.912763+02	#94
273	4	13	13	1	17220RGLA00	\N			1	17.800000000000001	17.800000000000001	4	1	1	Фильтр воздушный	Air filter	23.879999999999999	21.489999999999998	\N	0.47499999999999998	6.1749999999999998	27.664999999999999	27.664999999999999	issued	2011-04-06 12:15:09.519957+02	received_office	2011-02-17 15:34:23.914679+01	2011-04-06 12:15:09.525006+02	#94
276	4	13	13	1	72142TA5A01	\N			1	12.119999999999999	12.119999999999999	4	1	1	Ручка двери	Base	16.27	14.640000000000001	\N	0.17999999999999999	2.3399999999999999	16.98	16.98	issued	2011-04-06 12:15:04.402362+02	received_office	2011-02-17 15:34:23.935208+01	2011-04-06 12:15:04.40716+02	#94
299	4	23	23	3	L50110230	\N			1	16.809999999999999	16.809999999999999	3	1	1	прокладка клапанной крышки	valve cover gasket	23.890000000000001	19.59	\N	0.065000000000000002	0.84499999999999997	20.434999999999999	20.434999999999999	issued	2011-02-23 23:40:29.008448+01	received_office	2011-02-17 15:36:10.6318+01	2011-02-23 23:56:57.054353+01	#93
302	4	23	23	3	LFH115940A	\N			1	37.32	37.32	3	1	1	ролик обводной	idler pulley	53.490000000000002	43.869999999999997	\N	0.33500000000000002	4.3550000000000004	48.224999999999994	48.224999999999994	issued	2011-02-23 23:40:22.085517+01	received_office	2011-02-17 15:36:10.665326+01	2011-02-24 00:08:01.473149+01	#93
277	4	13	13	1	72143TA5A11	\N			1	7.1100000000000003	7.1100000000000003	4	1	1	Заглушка ручки	Cover	9.5299999999999994	8.5800000000000001	\N	0.035000000000000003	0.45500000000000007	9.0350000000000001	9.0350000000000001	issued	2011-04-06 12:15:02.315038+02	received_office	2011-02-17 15:34:23.942165+01	2011-04-06 12:15:02.31985+02	#94
282	4	21	21	1	177110P022	\N			1	48.810000000000002	48.810000000000002	4	1	1	Корпус фильтра	CASE AIR CLEANER	63.049999999999997	56.75	\N	2.9249999999999998	38.024999999999999	94.775000000000006	94.775000000000006	issued	2011-02-23 23:40:36.827819+01	received_office	2011-02-17 15:34:23.980022+01	2011-02-23 23:48:22.650453+01	#93
278	4	13	13	1	72144TA5A11	\N			1	2.77	2.77	4	1	1	Прокладка	Holder	3.7200000000000002	3.3500000000000001	\N	0.02	0.26000000000000001	3.6100000000000003	3.6100000000000003	issued	2011-04-06 12:15:00.369767+02	received_office	2011-02-17 15:34:23.949092+01	2011-04-06 12:15:00.374675+02	#94
283	4	34	34	1	5580078J03	\N			1	75.099999999999994	75.099999999999994	4	1	1	Колодки тормозные	Brake pads	90.599999999999994	81.540000000000006	\N	1.1899999999999999	15.469999999999999	97.010000000000005	97.010000000000005	issued	2011-04-06 12:14:56.860259+02	received_office	2011-02-17 15:34:23.987932+01	2011-04-06 12:14:56.865092+02	#94
284	4	13	13	1	80341SNEA01	\N			1	96.909999999999997	96.909999999999997	4	1	1	Трубка кондиционера	Ac line	130.05000000000001	117.05	\N	0.14999999999999999	1.95	119	119	issued	2011-04-06 12:14:55.060893+02	received_office	2011-02-17 15:34:23.994925+01	2011-04-06 12:14:55.065766+02	#94
285	4	13	13	1	80316SNEA01	\N			1	34.950000000000003	34.950000000000003	4	1	1	Трубка кондиционера	Discharge hose	46.899999999999999	42.210000000000001	\N	0.22	2.8599999999999999	45.07	45.07	issued	2011-04-06 12:14:52.098614+02	received_office	2011-02-17 15:34:24.001972+01	2011-04-06 12:14:52.103459+02	#94
286	4	13	13	1	84437SWA003ZA	\N			1	3.3999999999999999	3.3999999999999999	4	1	1	Пластик	Access cover	4.5700000000000003	4.1100000000000003	\N	0.025000000000000001	0.32500000000000001	4.4350000000000005	4.4350000000000005	issued	2011-04-06 12:14:50.458989+02	received_office	2011-02-17 15:34:24.008999+01	2011-04-06 12:14:50.463866+02	#94
296	4	13	13	1	83753SNXA01ZA	\N			1	119.42	119.42	4	1	1	Обшивка двери	LNG, L. RR. NH167L	160.25	144.22	\N	3.415	44.395000000000003	188.61500000000001	188.61500000000001	issued	2011-04-06 12:14:36.34264+02	received_office	2011-02-17 15:34:24.063255+01	2011-04-06 12:14:36.347666+02	#94
295	4	13	13	1	08P08SNA100R1	\N			1	32.450000000000003	32.450000000000003	4	1	1	Брызговики	Mud guard - Sedan 	47.229999999999997	42.509999999999998	\N	0.52000000000000002	6.7599999999999998	49.269999999999996	49.269999999999996	issued	2011-04-06 12:14:37.916805+02	received_office	2011-02-17 15:34:24.058822+01	2011-04-06 12:14:37.921918+02	#94
301	4	47	47	3	4743713AB	\N			1	40.990000000000002	40.990000000000002	3	1	1	крышка диска	сenter cap	57.700000000000003	47.32	\N	0.23000000000000001	2.9900000000000002	50.310000000000002	50.310000000000002	issued	2011-02-23 23:40:24.427891+01	received_office	2011-02-17 15:36:10.658172+01	2011-02-24 00:07:28.944798+01	#93
291	4	26	26	1	284B1CA511	\N			1	263.08999999999997	263.08999999999997	4	1	1	контроллер	CONTROLLER ASSY	354.10000000000002	318.69	\N	0.45500000000000002	5.915	324.60500000000002	324.60500000000002	issued	2011-04-06 12:14:43.69148+02	received_office	2011-02-17 15:34:24.041489+01	2011-04-06 12:14:43.696451+02	#94
293	4	14	14	1	924010W050	\N			1	126.90000000000001	126.90000000000001	4	1	1	Фонарь задний	Tail lamp assy Left 	167.31999999999999	150.59	\N	1.3999999999999999	18.199999999999999	168.78999999999999	168.78999999999999	issued	2011-04-06 12:14:39.522102+02	received_office	2011-02-17 15:34:24.05014+01	2011-04-06 12:14:39.527152+02	#94
287	4	13	13	1	81634STKA01ZE	\N			1	9.6699999999999999	9.6699999999999999	4	1	1	Пластик	Trim cover 	12.98	11.68	\N	0.029999999999999999	0.39000000000000001	12.07	12.07	issued	2011-04-06 12:14:48.753634+02	received_office	2011-02-17 15:34:24.015787+01	2011-04-06 12:14:48.759862+02	#94
292	4	14	14	1	770030W010	770032B030			1	482.02999999999997	482.02999999999997	4	1	1	Дверь задняя	PANEL ASSY-RR DR LH	691.33000000000004	622.20000000000005	\N	17.609999999999999	228.93000000000001	851.13000000000011	851.13000000000011	issued	2011-04-06 12:14:41.677326+02	received_office	2011-02-17 15:34:24.045901+01	2011-04-06 12:14:41.682167+02	#94
289	4	33	33	1	28393AG00C	\N			1	107.90000000000001	107.90000000000001	6	1	1	ШРУС	cv JOINT	147.97	125.77	\N	1.73	22.489999999999998	148.25999999999999	148.25999999999999	issued	2011-04-06 12:14:45.496985+02	received_office	2011-02-17 15:34:24.031772+01	2011-04-06 12:14:45.50214+02	#94
298	5	43	58	2	905505	\N			2	25.039999999999999	50.079999999999998	7	2	1	cайлентблок плавающий	Knuckle Bushing	19.98	32.5	31.300000000000001	0.38500000000000001	5.0049999999999999	36.305	72.609999999999999	issued	2011-02-23 22:20:20.903597+01	received_office	2011-02-17 15:35:42.579096+01	2011-02-24 19:33:55.300668+01	#92
300	4	23	23	3	L3K9124X0C	\N			1	87.480000000000004	87.480000000000004	3	1	1	актуатор	actuator 	127.38	104.45999999999999	\N	0.92000000000000004	11.960000000000001	116.41999999999999	116.41999999999999	issued	2011-02-23 23:40:26.660834+01	received_office	2011-02-17 15:36:10.651326+01	2011-02-24 00:06:17.541162+01	#93
290	4	15	15	1	H0564JG00A	\N			1	16.039999999999999	16.039999999999999	6	1	1	ключ	key blank	20.949999999999999	17.809999999999999	\N	0.014999999999999999	0.19500000000000001	18.004999999999999	18.004999999999999	issued	2011-02-23 23:40:34.287562+01	received_office	2011-02-17 15:34:24.037024+01	2011-02-23 23:56:17.7717+01	#93
271	4	2	2	1	08L33STX2C0R1	\N			1	24.550000000000001	24.550000000000001	4	1	1	Заглушки	END CAP SET	44.219999999999999	39.799999999999997	\N	1.5349999999999999	19.954999999999998	59.754999999999995	59.754999999999995	issued	2011-02-23 23:40:45.650319+01	received_office	2011-02-17 15:34:23.895026+01	2011-02-23 23:47:49.675092+01	#93
294	4	35	35	1	8879022131	\N			1	11.949999999999999	11.949999999999999	4	1	1	Датчик	Ambient temp sensor	16.309999999999999	14.68	\N	0.014999999999999999	0.19500000000000001	14.875	14.875	issued	2011-02-23 23:40:32.071345+01	received_office	2011-02-17 15:34:24.054424+01	2011-02-23 23:52:06.003007+01	#93
280	4	47	47	1	68001696AA	68078861AA 			1	51.350000000000001	51.350000000000001	7	1	1	Датчик давления шин	Tire pressure sensor 	55.450000000000003	55.450000000000003	\N	0.040000000000000001	0.52000000000000002	55.970000000000006	55.970000000000006	issued	2011-02-24 19:34:44.724039+01	superseded	2011-02-17 15:34:23.964724+01	2011-02-24 19:34:44.728892+01	#93
303	4	23	23	3	ZZC027238	\N			2	12.529999999999999	25.059999999999999	3	1	1	сальник полуоси	oil seal	17.649999999999999	14.470000000000001	\N	0.050000000000000003	0.65000000000000002	15.120000000000001	30.240000000000002	issued	2011-02-23 23:40:20.038213+01	received_office	2011-02-17 15:36:10.672288+01	2011-02-24 00:08:46.40465+01	#93
347	4	2	2	7	71198STKA01	\N			1	1.47	1.47	5	1	1	крепление бампера бок лев	bracket	1.9299999999999999	1.8600000000000001	\N	0.089999999999999997	1.1699999999999999	3.0300000000000002	3.0300000000000002	issued	2011-02-23 23:39:13.376718+01	received_office	2011-02-17 15:55:09.494994+01	2011-02-24 19:20:40.597865+01	#93
345	4	2	2	7	71190STKA00	\N			1	10.41	10.41	5	1	1	крепление бампера верх лев	bracket	13.720000000000001	13.26	\N	0.26500000000000001	3.4450000000000003	16.704999999999998	16.704999999999998	issued	2011-02-23 23:39:17.34692+01	received_office	2011-02-17 15:55:09.481719+01	2011-02-24 19:20:05.401488+01	#93
306	4	23	23	3	ZZCA27165	\N			1	12.48	12.48	3	1	1	сальник полуоси	oil seal	17.59	14.43	\N	0.055	0.71499999999999997	15.145	15.145	issued	2011-02-23 23:40:16.337276+01	received_office	2011-02-17 15:36:10.693619+01	2011-02-23 23:58:56.353058+01	#93
332	7	48	59	9	270676970734	310286002039			1	\N	\N	5	1	1	радиатор	radiator	190.31999999999999	281.48000000000002	\N	\N	\N	\N	\N	superseded	2011-04-06 13:37:16.170322+02	in_processing	2011-02-17 15:55:09.396359+01	2011-04-06 13:37:16.175562+02	#95
309	4	23	23	3	EC0143980D	\N			4	9.3599999999999994	37.439999999999998	3	1	1	шланг тормозной	brake hose	14.65	12.015000000000001	\N	0.12	1.5600000000000001	13.575000000000001	54.300000000000004	issued	2011-02-23 23:40:12.189721+01	received_office	2011-02-17 15:36:10.71622+01	2011-02-24 00:00:51.513215+01	#93
307	4	23	23	3	AC0127238	\N			2	6.2300000000000004	12.460000000000001	3	1	1	сальник полуоси	oil seal	6.2300000000000004	8	\N	0.025000000000000001	0.32500000000000001	8.3249999999999993	16.649999999999999	issued	2011-02-23 23:40:14.027403+01	received_office	2011-02-17 15:36:10.701025+01	2011-02-24 00:03:43.224988+01	#93
310	4	11	11	3	YF1Z6268AA	\N			3	44.670000000000002	134.00999999999999	3	1	1	цепь грм	timing chain	58.920000000000002	48.310000000000002	\N	0.61499999999999999	7.9950000000000001	56.305	168.91499999999999	issued	2011-02-23 23:40:10.347124+01	received_office	2011-02-17 15:36:10.723034+01	2011-02-24 00:01:48.552581+01	#93
312	4	23	23	3	L3K912201A	\N			1	29.050000000000001	29.050000000000001	3	1	1	цепь грм	timing chain	39.759999999999998	32.609999999999999	\N	0.41999999999999998	5.46	38.07	38.07	issued	2011-02-23 23:40:04.196867+01	received_office	2011-02-17 15:36:10.740969+01	2011-02-24 00:05:29.026795+01	#93
338	4	26	26	7	H0152JM0MA	\N			1	99.680000000000007	99.680000000000007	13	1	1	накладка двери передней правой	door shell	99.680000000000007	136.78999999999999	\N	4.9000000000000004	63.700000000000003	200.49000000000001	200.49000000000001	issued	2011-04-06 12:13:59.299395+02	received_office	2011-02-17 15:55:09.435794+01	2011-04-06 12:13:59.314601+02	#94
343	4	2	2	7	60650STKA00ZZ	\N			1	75.269999999999996	75.269999999999996	5	1	1	внутренняя часть крыла правая	appron	99.170000000000002	95.849999999999994	\N	6.415	83.394999999999996	179.245	179.245	issued	2011-04-06 12:13:56.160226+02	received_office	2011-02-17 15:55:09.468945+01	2011-04-06 12:13:56.165387+02	#94
314	4	13	13	4	72270TE0A01	\N	V6684658		1	9.8200000000000003	9.8200000000000003	15	1	2	направляющая стекла передняя лев	Sash channel	13.550000000000001	14	\N	0.065000000000000002	0.84499999999999997	14.845000000000001	14.845000000000001	issued	2011-04-06 12:14:17.160611+02	received_office	2011-02-17 15:39:41.375034+01	2011-04-06 12:14:17.165598+02	#94
319	4	2	2	4	71598TK4A00	\N	V6531911		1	5.4699999999999998	5.4699999999999998	17	1	2	кронштейн    	retainer Left	7.2199999999999998	7	\N	0.125	1.625	8.625	8.625	issued	2011-02-23 23:39:56.436926+01	received_office	2011-02-17 15:39:41.402989+01	2011-02-24 18:46:35.480481+01	#93
321	4	2	2	4	51360TK4A01	\N	V6531911	уточнить по весу !!!	1	197.93000000000001	197.93000000000001	17	1	2	рычаг нижний левый	control arm	260.76999999999998	248.77000000000001	\N	4	52	300.76999999999998	300.76999999999998	issued	2011-02-23 23:39:51.648107+01	received_office	2011-02-17 15:39:41.412285+01	2011-02-24 19:15:20.873275+01	#93
318	4	2	2	4	71198TK4A00	\N	V6531911		1	4.3700000000000001	4.3700000000000001	17	1	2	держатель крыла	Retainer	5.75	6	\N	0.085000000000000006	1.105	7.1050000000000004	7.1050000000000004	issued	2011-02-23 23:39:59.897895+01	received_office	2011-02-17 15:39:41.397634+01	2011-02-24 18:45:39.829017+01	#93
316	4	13	13	4	72150TE0A11	\N	V6684658		1	34.450000000000003	34.450000000000003	15	1	2	замок двери лев	Lock assy Left	47.539999999999999	50	\N	0.61499999999999999	7.9950000000000001	57.994999999999997	57.994999999999997	issued	2011-04-06 12:14:05.268029+02	received_office	2011-02-17 15:39:41.383768+01	2011-04-06 12:14:05.272816+02	#94
330	4	2	2	7	38615RWCA01	\N			1	23.68	23.68	5	1	1	диффузор вентилятора правый	shroud	31.199999999999999	30.149999999999999	\N	1.28	16.640000000000001	46.789999999999999	46.789999999999999	issued	2011-02-23 23:39:31.518328+01	received_office	2011-02-17 15:55:09.382903+01	2011-02-24 19:23:28.380037+01	#93
315	4	13	13	4	72271TE0A01	\N	V6684658		1	3.46	3.46	15	1	2	направляющая стекла задняя лев	Sash channel	4.7800000000000002	5	\N	0.14499999999999999	1.8849999999999998	6.8849999999999998	6.8849999999999998	issued	2011-04-06 12:14:06.791711+02	received_office	2011-02-17 15:39:41.379385+01	2011-04-06 12:14:06.796586+02	#94
322	4	47	47	5	4721010AA	\N			1	183.59999999999999	183.59999999999999	10	1	2	ступица переднияя	hub assy front	259	259	\N	4.4000000000000004	57.200000000000003	316.19999999999999	316.19999999999999	issued	2011-02-23 23:39:48.517431+01	received_office	2011-02-17 15:41:38.516682+01	2011-02-24 18:43:52.821349+01	#93
329	4	2	2	7	71122STKA01ZA	\N			1	46.530000000000001	46.530000000000001	5	1	1	решётка радиатора	grille base	61.299999999999997	59.25	\N	0.34999999999999998	4.5499999999999998	63.799999999999997	63.799999999999997	issued	2011-02-23 23:39:33.288715+01	received_office	2011-02-17 15:55:09.376197+01	2011-02-24 19:22:58.405828+01	#93
324	5	61	60	6	T7162	\N			1	108.09999999999999	108.09999999999999	10	1	2	бампер задний	bumper rear	94	160	\N	5	65	225	225	issued	2011-02-23 23:39:44.167611+01	received_office	2011-02-17 15:41:38.547178+01	2011-02-24 19:24:36.992011+01	#93
326	4	2	2	7	71185STKA00ZZ	\N			1	14.56	14.56	5	1	1	крепление усилителя бампера лев	bracket	19.18	18.530000000000001	\N	0.70999999999999996	9.2300000000000004	27.760000000000002	27.760000000000002	issued	2011-02-23 23:39:40.437268+01	received_office	2011-02-17 15:55:09.362628+01	2011-02-24 19:21:27.465881+01	#93
328	4	2	2	7	71121STKA01ZA	\N			1	15.66	15.66	5	1	1	основа решётки радиатора	grille base	20.629999999999999	19.940000000000001	\N	0.62	8.0600000000000005	28	28	issued	2011-02-23 23:39:36.03927+01	received_office	2011-02-17 15:55:09.371912+01	2011-02-24 19:22:28.119882+01	#93
336	4	2	2	7	75120STKA01	\N			2	38.460000000000001	76.920000000000002	5	1	1	молдинг капота	moulding	50.670000000000002	48.979999999999997	\N	0.155	2.0150000000000001	50.994999999999997	101.98999999999999	issued	2011-02-23 23:39:26.034093+01	received_office	2011-02-17 15:55:09.421918+01	2011-02-24 19:17:21.731085+01	#93
317	4	15	15	4	40202CG11B	40202EJ70B	V6633927		1	137.16	137.16	16	1	2	ступица переднияя	hub assy front	179.15000000000001	180	\N	3.4300000000000002	44.590000000000003	224.59	224.59	issued	2011-02-24 19:34:52.235568+01	superseded	2011-02-17 15:39:41.389484+01	2011-02-24 19:34:52.240683+01	#93
333	4	47	47	7	68003216AG	\N			1	\N	\N	5	1	1	спиральный кабель	Clockspring	249	235.13999999999999	\N	\N	\N	\N	\N	in_processing	2011-02-17 15:55:35.890311+01	\N	2011-02-17 15:55:09.402827+01	2011-02-17 15:55:35.893493+01	
334	4	47	47	7	6502738	\N			5	\N	\N	5	1	1	гайка колёсная	wheel nut	7.4500000000000002	1.4099999999999999	\N	\N	\N	\N	\N	in_processing	2011-02-17 15:55:35.89925+01	\N	2011-02-17 15:55:09.40955+01	2011-02-17 15:55:35.902206+01	
335	4	47	47	7	5076777AD	\N			1	\N	\N	5	1	1	капот	hood	582	517.27999999999997	\N	\N	\N	\N	\N	in_processing	2011-02-17 15:55:35.906809+01	\N	2011-02-17 15:55:09.415746+01	2011-02-17 15:55:35.909716+01	
346	4	2	2	7	71193STKA01	\N			1	1.47	1.47	5	1	1	крепление бампера бок прав	bracket	1.9299999999999999	1.8600000000000001	\N	0.089999999999999997	1.1699999999999999	3.0300000000000002	3.0300000000000002	issued	2011-02-23 23:39:15.396459+01	received_office	2011-02-17 15:55:09.488321+01	2011-02-24 19:20:45.566698+01	#93
337	4	47	47	7	5116279AD	\N			1	\N	\N	5	1	1	подкрылок левый	fender liner	51.450000000000003	48.579999999999998	\N	\N	\N	\N	\N	in_processing	2011-02-17 15:55:35.922093+01	\N	2011-02-17 15:55:09.428068+01	2011-02-17 15:55:35.92508+01	
308	4	14	14	3	924022C720	\N			1	168.12	168.12	3	1	1	фонарь задний	taillight	221.68000000000001	188.43000000000001	\N	2.0049999999999999	26.064999999999998	214.495	214.495	issued	2011-04-01 12:47:01.510485+02	received_office	2011-02-17 15:36:10.707951+01	2011-04-01 12:47:01.515671+02	#94
340	5	62	58	8	P7698P	\N			1	\N	\N	7	3	1	цилиндрик супорта	Caliper Piston	9.7899999999999991	18.219999999999999	\N	\N	\N	\N	\N	in_processing	2011-02-17 15:56:19.076012+01	\N	2011-02-17 15:55:09.45006+01	2011-02-17 15:56:19.07893+01	
390	5	62	71	21	SS72923	\N			2	\N	\N	28	1	2	колпачки маслосъемные	valve stem seal	23.670000000000002	19.5	\N	\N	\N	\N	\N	in_processing	2011-02-22 22:00:02.021402+01	\N	2011-02-22 21:58:59.517475+01	2011-03-08 16:35:55.428509+01	#95
342	4	2	2	7	71135STKA00ZZ	\N			2	14.56	29.120000000000001	5	1	1	крепление усилителя бампера прав	bracket	19.18	18.539999999999999	\N	0.70499999999999996	9.1649999999999991	27.704999999999998	55.409999999999997	issued	2011-02-23 23:39:21.766667+01	received_office	2011-02-17 15:55:09.462423+01	2011-02-24 19:19:04.561244+01	#93
370	4	13	13	15	28260RPC004				1	174.09	174.09	15	4	2	соленоид	SOLENOID	233.62	250	\N	0.96999999999999997	12.609999999999999	262.61000000000001	262.61000000000001	issued	2011-02-23 23:38:51.378168+01	received_office	2011-02-22 21:10:37.497661+01	2011-02-24 19:32:18.770391+01	#93
373	4	47	9	16	4721310AC	4721310AE			1	14.1	14.1	4	2	1	трос ручника	CABLE PARKING BRAKE	18.850000000000001	16.579999999999998	\N	0.66500000000000004	8.6449999999999996	25.224999999999998	25.224999999999998	issued	2011-02-24 19:35:10.433846+01	superseded	2011-02-22 21:28:57.446508+01	2011-02-24 19:35:10.438851+01	#93
349	5	46	61	11	A697C	\N	V3181444		1	6.2300000000000004	6.2300000000000004	18	1	2	фильтр воздушный	air filter	5.4199999999999999	25	\N	0.75	9.75	34.75	34.75	issued	2011-02-23 23:39:10.296648+01	received_office	2011-02-17 15:58:24.921187+01	2011-02-24 19:25:29.702304+01	#93
385	4	12	6	19	12598155				1	106.5	106.5	28	1	2	комплект прокладок	kit gasket	159.05000000000001	169	\N	0.91500000000000004	11.895	180.89500000000001	180.89500000000001	issued	2011-04-06 12:13:35.292574+02	received_office	2011-02-22 21:58:59.488935+01	2011-04-06 12:13:35.297456+02	#94
356	2	65	26	1	54613CG024	\N			2	\N	\N	16	2	2	Втулка стабилизатора	bushing	4.7599999999999998	8	\N	\N	\N	\N	\N	issued	2011-04-05 12:01:14.10899+02	in_processing	2011-02-17 16:47:39.340129+01	2011-04-05 12:01:14.114593+02	143
358	2	63	26	1	43210WL000	\N			1	\N	\N	16	2	2	Подшипник	bearing	62.420000000000002	87	\N	\N	\N	\N	\N	issued	2011-04-05 11:47:21.916822+02	in_processing	2011-02-17 16:47:39.361159+01	2011-04-05 11:47:21.922057+02	142
359	2	65	68	2	SH85082	\N	Рычаг передний левый		1	\N	\N	17	2	2	Рычаг передний левый	arm	26.84	38	\N	\N	\N	\N	\N	issued	2011-04-05 12:01:38.787361+02	in_processing	2011-02-17 16:56:18.905302+01	2011-04-05 12:01:38.792449+02	143
384	4	12	6	19	12585677				12	2.9700000000000002	35.640000000000001	28	1	2	вкладыш шатунный	bearing rod	4.3899999999999997	5	\N	0.074999999999999997	0.97499999999999998	5.9749999999999996	71.699999999999989	issued	2011-04-06 12:13:44.397721+02	received_office	2011-02-22 21:58:59.481603+01	2011-04-06 12:13:44.402728+02	#94
365	4	47	9	13	5116279AD	\N			1	36.549999999999997	36.549999999999997	5	2	1	подкрылок левый	fender liner	51.450000000000003	48.579999999999998	\N	0.67500000000000004	8.7750000000000004	57.354999999999997	57.354999999999997	issued	2011-02-23 23:38:59.008202+01	received_office	2011-02-17 17:33:51.346606+01	2011-02-24 19:29:28.971959+01	#93
375	5	62	64	17	2841	\N	ANCHOR 	ANCHOR 	1	\N	\N	7	5	1	подушка двигателя 	Motor Mount 	35.789999999999999	58.460000000000001	\N	\N	\N	\N	\N	in_processing	2011-02-22 21:42:18.670645+01	\N	2011-02-22 21:41:34.035386+01	2011-02-22 21:42:18.674154+01	
361	4	12	7	13	15691887	\N			3	\N	\N	20	1	1	габарит	side marker	15.32	6.6600000000000001	\N	\N	\N	\N	\N	in_processing	2011-02-17 17:34:31.486147+01	\N	2011-02-17 17:33:51.311788+01	2011-02-17 17:34:31.489134+01	
360	4	23	23	13	GP7A50C11				1	14.82	14.82	19	1	1	заглушка	cover	20.289999999999999	20.289999999999999	\N	0.085000000000000006	1.105	21.395	21.395	issued	2011-02-23 23:39:07.787072+01	received_office	2011-02-17 17:33:51.291602+01	2011-02-24 19:27:06.099943+01	#93
364	4	47	9	13	5076777AD	5076777AC			1	413.38999999999999	413.38999999999999	5	2	1	капот	hood	582	517.27999999999997	\N	14.1	183.29999999999998	700.57999999999993	700.57999999999993	issued	2011-02-24 19:35:05.48629+01	superseded	2011-02-17 17:33:51.339116+01	2011-02-24 19:35:05.491253+01	#93
369	5	45	63	14	56328R	\N			2	51.689999999999998	103.38	21	1	2	диск тормозной	brake rotor	44.950000000000003	115	\N	13	169	284	568	issued	2011-02-23 23:38:54.647258+01	received_office	2011-02-22 21:10:37.460117+01	2011-02-24 19:31:12.690868+01	#93
363	4	47	9	13	6502738	\N			5	5.2699999999999996	26.349999999999998	5	2	1	гайка колёсная	wheel nut	7.4500000000000002	1.3999999999999999	\N	0.040000000000000001	0.52000000000000002	1.9199999999999999	9.5999999999999996	issued	2011-02-23 23:39:03.357198+01	received_office	2011-02-17 17:33:51.328822+01	2011-02-24 19:28:21.594555+01	#93
371	4	14	14	16	31110-1U000	\N			1	\N	\N	27	1	1	насос топливный	fuel pump	292.94	249	\N	\N	\N	\N	\N	in_processing	2011-02-22 21:29:20.016501+01	\N	2011-02-22 21:28:57.434609+01	2011-02-22 21:29:20.020062+01	
382	4	23	23	18	L30512201				1	68.049999999999997	68.049999999999997	3	2	1	цепь грм	timing chain	93.140000000000001	76.379999999999995	76.379999999999995	0.40999999999999998	5.3300000000000001	81.709999999999994	81.709999999999994	issued	2011-04-01 12:47:19.622589+02	received_office	2011-02-22 21:41:34.077736+01	2011-04-06 12:15:28.957172+02	#94
372	4	25	25	16	4410A320				1	1044.45	1044.45	3	1	1	рейка рулевая	rack pinion	1331.9400000000001	1132.1500000000001	\N	7.7599999999999998	100.88	1233.0300000000002	1233.0300000000002	issued	2011-04-01 12:47:06.131564+02	received_office	2011-02-22 21:28:57.441133+01	2011-04-01 12:47:06.136785+02	#94
376	5	62	69	17	11583600	\N	TYC	TYC	1	80.120000000000005	80.120000000000005	7	5	1	фонарь задний	Tail Lamp Assembly	64.790000000000006	100.15000000000001	\N	1.6950000000000001	22.035	122.185	122.185	issued	2011-04-06 12:13:48.007169+02	received_office	2011-02-22 21:41:34.043894+01	2011-04-06 12:13:48.015538+02	#94
348	7	48	59	10	190438342627	\N	V6684658		1	82.450000000000003	82.450000000000003	15	2	2	стекло левое 	glass left	74.950000000000003	138	\N	5.1200000000000001	66.560000000000002	204.56	204.56	issued	2011-04-06 12:13:54.648395+02	received_office	2011-02-17 15:58:24.91354+01	2011-04-06 12:13:54.663524+02	#94
388	7	48	59	20	370467483163		ЗАКАЗАНО		1	20.899999999999999	20.899999999999999	30	1	2	ручка задняя левая	handle	19	28.5	\N	0.25	3.25	31.75	31.75	issued	2011-04-06 12:13:33.595436+02	received_office	2011-02-22 21:58:59.507144+01	2011-04-06 12:13:33.600455+02	#94
378	4	35	35	18	5311106220	\N			1	108.09	108.09	3	2	1	Решётка	Grille	147.61000000000001	129.88999999999999	\N	0.79500000000000004	10.335000000000001	140.22499999999999	140.22499999999999	issued	2011-04-01 12:47:10.020051+02	received_office	2011-02-22 21:41:34.055158+01	2011-04-01 12:47:10.028058+02	#94
379	4	35	35	18	8156006320	\N			1	109.7	109.7	3	2	1	Фонарь	Combo lamp assy	149.81	131.83000000000001	\N	3.3100000000000001	43.030000000000001	174.86000000000001	174.86000000000001	issued	2011-04-01 12:47:12.161486+02	received_office	2011-02-22 21:41:34.06127+01	2011-04-01 12:47:12.167144+02	#94
381	4	35	35	18	8917052780				1	107.38	107.38	3	2	1	блок управления	sdm module	125.95999999999999	103.29000000000001	\N	0.34999999999999998	4.5499999999999998	107.84	107.84	issued	2011-04-01 12:47:16.632333+02	received_office	2011-02-22 21:41:34.072258+01	2011-04-01 12:47:16.637753+02	#94
357	2	64	13	1	72250TE0A12	\N			1	\N	\N	15	3	2	Стеклоподъемник	glass motor	165.25	227.21000000000001	\N	\N	\N	\N	\N	in_processing	2011-02-17 16:48:02.143021+01	\N	2011-02-17 16:47:39.356772+01	2011-04-06 12:47:35.236036+02	#95
383	4	47	9	18	53021719AD				1	4.9100000000000001	4.9100000000000001	4	3	1	индикатор	INDICATOR ENGINE OIL	6.9500000000000002	6.1100000000000003	\N	0.059999999999999998	0.78000000000000003	6.8900000000000006	6.8900000000000006	issued	2011-04-06 12:13:46.133697+02	received_office	2011-02-22 21:41:34.0846+01	2011-04-06 12:13:46.138633+02	#94
377	4	35	35	18	8113006420	\N			1	196.36000000000001	196.36000000000001	3	2	1	Фара	Lens and housing	268.16000000000003	235.97999999999999	\N	4.0199999999999996	52.259999999999991	288.24000000000001	288.24000000000001	issued	2011-04-01 12:47:08.037923+02	received_office	2011-02-22 21:41:34.050017+01	2011-04-01 12:47:08.04295+02	#94
386	4	2	2	19	50820-TL4-A01	\N			1	\N	\N	17	3	2	подушка ДВС	mount	93.780000000000001	93.780000000000001	\N	\N	\N	\N	\N	in_processing	2011-02-22 21:59:43.641954+01	\N	2011-02-22 21:58:59.494882+01	2011-02-22 21:59:43.644985+01	
387	7	48	59	20	140499716551	\N	ЗАКАЗАНО		1	\N	\N	29	1	2	фонари задние	rear lamp	70.939999999999998	110	\N	\N	\N	\N	\N	in_processing	2011-02-22 21:59:51.39317+01	\N	2011-02-22 21:58:59.501306+01	2011-02-22 21:59:51.396838+01	
391	5	62	70	21	PR3136	\N			1	\N	\N	28	1	2	кольца поршневые	piston ring	87.560000000000002	140	\N	\N	\N	\N	\N	in_processing	2011-02-22 22:00:02.032989+01	\N	2011-02-22 21:58:59.52354+01	2011-02-22 22:00:02.036091+01	
325	4	2	2	7	67510STKA90ZZ	\N			1	499.97000000000003	499.97000000000003	5	1	1	дверь задняя правая/RDX синий	rear door	658.73000000000002	592	\N	18.390000000000001	239.06999999999999	831.06999999999994	831.06999999999994	issued	2011-02-23 23:39:42.387535+01	received_office	2011-02-17 15:55:09.35623+01	2011-02-24 19:16:23.682335+01	#93
420	7	48	59	24	230534181165	\N			1	\N	\N	33	1	1	решётка радиатора	grille	95	130.5	\N	2	26	156.5	156.5	issued	2011-04-06 12:39:21.599475+02	in_processing	2011-02-23 19:26:42.579779+01	2011-04-06 12:39:21.605177+02	#95
393	4	33	33	22	28393-AG00C	\N			2	\N	\N	6	2	1	ШРУС	cv JOINT	147.97	125.77	\N	\N	\N	\N	\N	in_processing	2011-02-22 22:15:28.563345+01	\N	2011-02-22 22:14:22.70309+01	2011-03-08 16:36:41.141863+01	#95
422	4	11	11	25	YL8Z7A508AA				1	37.299999999999997	37.299999999999997	3	3	1	цилиндр рабочий	slave cylinder	49.189999999999998	40.340000000000003	\N	0.185	2.4049999999999998	42.745000000000005	42.745000000000005	issued	2011-04-01 12:47:24.67577+02	received_office	2011-02-23 19:29:54.180323+01	2011-04-01 12:47:24.680676+02	#94
430	4	2	2	26	71599SEPA01	\N			1	6.4699999999999998	6.4699999999999998	34	1	2	держатель заднего бампера левый	spacer left	8.5299999999999994	40.340000000000003	\N	0.080000000000000002	1.04	41.380000000000003	41.380000000000003	issued	2011-04-06 12:13:16.737205+02	received_office	2011-02-23 19:35:20.818637+01	2011-04-06 12:13:16.744774+02	#94
396	5	62	73	23	Z166 	\N	atp		1	\N	\N	7	6	1	маховик 	Flexplate	36.890000000000001	65.290000000000006	\N	\N	\N	\N	\N	in_processing	2011-02-22 22:15:34.631529+01	\N	2011-02-22 22:14:22.722167+01	2011-04-06 12:35:41.883885+02	#95
408	2	68	4	5	11317694426	\N			1	\N	\N	31	2	1	Приводная цепь	-	43.899999999999999	49	\N	\N	\N	\N	\N	issued	2011-04-05 11:39:57.934352+02	in_processing	2011-02-23 15:50:29.103829+01	2011-04-05 12:02:54.031264+02	146
400	2	67	74	4	RA68113	\N			1	\N	\N	31	1	1	\tРадиатор	-	75.930000000000007	84	\N	\N	\N	\N	\N	issued	2011-04-05 12:02:28.445748+02	in_processing	2011-02-23 15:31:42.334968+01	2011-04-05 12:02:28.450676+02	143
401	2	68	4	5	11317694427	\N			1	\N	\N	31	2	1	Приводная цепь	-	46.789999999999999	52	\N	\N	\N	\N	\N	issued	2011-04-05 12:04:36.547464+02	in_processing	2011-02-23 15:50:29.06997+01	2011-04-05 12:04:36.552948+02	146
402	2	68	4	5	11311341291	\N			2	\N	\N	31	2	1	Направляющая	-	9.5600000000000005	11	\N	\N	\N	\N	\N	issued	2011-04-05 12:07:15.103807+02	in_processing	2011-02-23 15:50:29.07569+01	2011-04-05 12:07:15.108704+02	146
403	2	68	4	5	11311341295	\N			1	\N	\N	31	2	1	Натяжитель	-	10.9	12	\N	\N	\N	\N	\N	issued	2011-04-05 12:06:41.383846+02	in_processing	2011-02-23 15:50:29.08038+01	2011-04-05 12:06:41.389036+02	146
404	2	68	4	5	11311341296	\N			1	\N	\N	31	2	1	Натяжитель	-	10.67	12	\N	\N	\N	\N	\N	issued	2011-04-05 12:06:00.081636+02	in_processing	2011-02-23 15:50:29.084945+01	2011-04-05 12:06:00.086433+02	146
405	2	68	4	5	11311341293	\N			1	\N	\N	31	2	1	Направляющая	-	5.9100000000000001	7	\N	\N	\N	\N	\N	issued	2011-04-05 12:05:27.177834+02	in_processing	2011-02-23 15:50:29.089496+01	2011-04-05 12:05:27.185465+02	146
406	2	68	4	5	11317677666	\N			1	\N	\N	31	2	1	Натяжитель цепи	-	5.9100000000000001	7	\N	\N	\N	\N	\N	issued	2011-04-05 11:39:52.076334+02	in_processing	2011-02-23 15:50:29.094096+01	2011-04-05 12:04:53.902668+02	146
409	2	68	4	5	33172311091	\N			1	\N	\N	31	2	1	Подшипник	-	25.43	29	\N	\N	\N	\N	\N	issued	2011-04-05 11:39:59.954606+02	in_processing	2011-02-23 15:50:29.108536+01	2011-04-05 12:03:16.247249+02	146
407	2	68	4	5	11317694427	\N			1	\N	\N	31	2	1	Приводная цепь	-	46.789999999999999	52	\N	\N	\N	\N	\N	issued	2011-04-05 11:39:54.985859+02	in_processing	2011-02-23 15:50:29.098627+01	2011-04-05 12:04:29.942973+02	146
412	2	68	4	8	61312306015	\N			1	\N	\N	31	4	1	Задняя часть стартера	-	28.199999999999999	32	\N	\N	\N	\N	\N	issued	2011-04-05 11:40:03.729805+02	in_processing	2011-02-23 16:15:22.028625+01	2011-04-05 12:08:37.593346+02	146
414	2	72	13	9	34451S7AG01	\N			1	\N	\N	31	5	1	Фонарь заднего хода	-	77.129999999999995	85	\N	\N	\N	\N	\N	issued	2011-04-05 11:40:10.576541+02	in_processing	2011-02-23 16:29:48.74548+01	2011-04-05 12:09:35.813181+02	144
411	2	71	26	7	479101NF0B	\N			1	\N	\N	32	1	2	Датчик абс	-	135.84999999999999	146	\N	\N	\N	\N	\N	issued	2011-04-05 12:08:14.417994+02	in_processing	2011-02-23 16:04:31.642065+01	2011-04-05 12:08:14.423117+02	144
419	2	73	13	11	44300SJKJ01	\N			2	\N	\N	31	6	1	Подшипник	-	89.780000000000001	100	\N	\N	\N	\N	\N	issued	2011-04-05 11:40:24.362962+02	in_processing	2011-02-23 19:21:42.988186+01	2011-04-05 12:10:46.50754+02	145
413	2	68	13	9	08P09S7A601A	\N			1	\N	\N	31	5	1	Крыло	-	57.030000000000001	64	\N	\N	\N	\N	\N	issued	2011-04-05 11:40:07.16088+02	in_processing	2011-02-23 16:29:48.721149+01	2011-04-05 12:09:53.537471+02	146
415	2	72	13	9	83113S6A003ZD	\N			1	\N	\N	31	5	1	Фиксатор	-	5.9000000000000004	7	\N	\N	\N	\N	\N	issued	2011-04-05 11:40:13.928799+02	in_processing	2011-02-23 16:29:48.751385+01	2011-04-05 12:09:15.097149+02	144
431	4	2	2	26	72410SEPA01ZA	\N			1	42.380000000000003	42.380000000000003	34	1	2	молдинг правый	molding right	55.829999999999998	132.19	\N	0.255	3.3149999999999999	135.505	135.505	issued	2011-04-06 12:13:14.147779+02	received_office	2011-02-23 19:35:20.825625+01	2011-04-06 12:13:14.152753+02	#94
416	2	65	63	10	PGD52M	\N			1	\N	\N	21	2	2	колодки тормозные	-	24	33	\N	\N	\N	\N	\N	issued	2011-04-05 12:10:23.967561+02	in_processing	2011-02-23 16:47:23.017365+01	2011-04-05 12:10:23.972894+02	144
417	2	73	13	11	45022SHJA50	\N			1	\N	\N	31	6	1	Колодки тормозные	-	92.430000000000007	102	\N	\N	\N	\N	\N	issued	2011-04-05 11:40:17.726162+02	in_processing	2011-02-23 19:21:42.97746+01	2011-04-05 12:11:24.799786+02	145
418	2	73	13	11	43022S9A010	\N			1	\N	\N	31	6	1	Колодки барабанные	-	62.5	69	\N	\N	\N	\N	\N	issued	2011-04-05 11:40:21.228255+02	in_processing	2011-02-23 19:21:42.984026+01	2011-04-05 12:11:06.265177+02	145
410	2	70	76	6	3397118934	\N			1	\N	\N	31	3	1	Щетка стеклоочистителя	-	28.84	32	\N	\N	\N	\N	\N	issued	2011-04-05 11:40:01.993026+02	in_processing	2011-02-23 15:54:24.294622+01	2011-04-05 12:07:38.994828+02	143
394	4	47	9	22	56029084AA				1	30.739999999999998	30.739999999999998	4	4	1	датчик	SENSOR OXYGEN	43.25	38.060000000000002	\N	0.125	1.625	39.685000000000002	39.685000000000002	issued	2011-04-06 12:13:29.851613+02	received_office	2011-02-22 22:14:22.709683+01	2011-04-06 12:13:29.857252+02	#94
421	4	23	23	25	EC0241380C				1	20.449999999999999	20.449999999999999	3	3	1	шланг тормозной	brake hose	27.989999999999998	22.960000000000001	22.960000000000001	0.14000000000000001	1.8200000000000003	24.780000000000001	24.780000000000001	issued	2011-04-01 12:47:21.847935+02	received_office	2011-02-23 19:29:54.174478+01	2011-04-06 12:15:40.891543+02	#94
426	4	23	23	25	GY0918140	\N			1	63.43	63.43	3	3	1	провода высоковольтные	ignition wire set	86.819999999999993	71.200000000000003	71.200000000000003	0.84999999999999998	11.049999999999999	82.25	82.25	issued	2011-04-01 12:47:33.467766+02	received_office	2011-02-23 19:29:54.202294+01	2011-04-06 12:16:11.573432+02	#94
398	4	2	2	22	60100TK4A90ZZ				1	518.36000000000001	518.36000000000001	17	4	1	капот	hood	682.95000000000005	682.95000000000005	\N	10.585000000000001	137.60500000000002	820.55500000000006	820.55500000000006	issued	2011-04-06 12:13:26.319916+02	received_office	2011-02-22 22:14:22.731544+01	2011-04-06 12:13:26.325124+02	#94
427	4	23	23	25	EC013438XA	\N			2	6.5899999999999999	13.18	3	3	1	подшипник опорно-поворотный	strut bearing	9.0199999999999996	7.4000000000000004	7.4000000000000004	0.029999999999999999	0.39000000000000001	7.79	15.58	issued	2011-04-01 12:47:35.715453+02	received_office	2011-02-23 19:29:54.2072+01	2011-04-06 12:16:30.570337+02	#94
428	4	23	23	25	T03239020B	\N			1	21.82	21.82	3	3	1	кронштейн подушки акпп	mount bracket	29.859999999999999	24.489999999999998	24.489999999999998	0.94499999999999995	12.285	36.774999999999999	36.774999999999999	issued	2011-04-01 12:47:40.172403+02	received_office	2011-02-23 19:29:54.213126+01	2011-04-06 12:16:36.85524+02	#94
392	4	33	33	22	20464-AG02A	\N			6	\N	\N	6	2	1	втулка стабилизатора	bushing	2.3999999999999999	2.04	\N	\N	\N	\N	\N	in_processing	2011-02-22 22:15:28.554001+01	\N	2011-02-22 22:14:22.673176+01	2011-04-06 12:33:14.026648+02	#95
425	4	23	23	25	GK2A28156A	\N			10	1.0600000000000001	10.600000000000001	3	3	1	втулка стабилизатора	bushing	1.45	1.1899999999999999	1.1899999999999999	0.044999999999999998	0.58499999999999996	1.7749999999999999	17.75	issued	2011-04-01 12:47:31.172035+02	received_office	2011-02-23 19:29:54.196038+01	2011-04-06 12:15:52.760123+02	#94
432	4	47	47	26	5178051AC	\N			1	\N	\N	4	5	1	стекло	glass	250	220	\N	\N	\N	\N	\N	in_processing	2011-02-23 19:40:29.032195+01	\N	2011-02-23 19:36:23.24813+01	2011-02-23 19:40:29.036034+01	
433	5	62	77	27	141416	\N		cardone	1	\N	\N	34	2	2	скоба суппорта	caliper bracket	22.75	44	\N	\N	\N	\N	\N	received_office	2011-04-06 12:40:07.577844+02	in_processing	2011-02-23 19:40:02.467379+01	2011-04-06 12:40:07.582909+02	#95
770	4	2	2	75	90101S5A003	\N			2	\N	\N	10	4	2	шуруп	screw	1.27	0.63500000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:37.939059+01	\N	2011-03-25 14:26:19.096236+01	2011-03-25 14:26:37.943181+01	
395	5	62	72	23	PRT5617 	\N	bendix		2	\N	\N	7	6	1	диск тормозной 	BRAKE ROTOR\r\n	32.890000000000001	58.840000000000003	\N	\N	\N	\N	\N	in_processing	2011-02-22 22:15:34.609509+01	\N	2011-02-22 22:14:22.717921+01	2011-04-06 12:35:22.974114+02	#95
437	5	46	61	28	501243	\N		ЗАКАЗАНО acdelco	1	52.68	52.68	35	1	2	подушка амортизатора	strut mount	45.810000000000002	74	\N	1.3100000000000001	17.030000000000001	91.030000000000001	91.030000000000001	issued	2011-04-06 12:13:10.46049+02	received_office	2011-02-23 19:52:10.341372+01	2011-04-06 12:13:10.465281+02	#94
441	6	58	78	29	14091-0469	\N		kawasaki	1	\N	\N	36	1	1	крышка двигателя	cover	127.56	180.16999999999999	\N	\N	\N	\N	\N	in_processing	2011-02-23 20:01:44.865758+01	\N	2011-02-23 20:01:27.208439+01	2011-02-23 20:01:44.870044+01	
442	6	58	78	29	92210-0152	\N		kawasaki	1	\N	\N	36	1	1	гайка	nut	3.7999999999999998	6.4400000000000004	\N	\N	\N	\N	\N	in_processing	2011-02-23 20:01:44.875048+01	\N	2011-02-23 20:01:27.215057+01	2011-02-23 20:01:44.877978+01	
443	6	58	78	29	92045-1053	\N		kawasaki	1	\N	\N	36	1	1	подшипник	bearing	10.56	17.899999999999999	\N	\N	\N	\N	\N	in_processing	2011-02-23 20:01:44.882522+01	\N	2011-02-23 20:01:27.220611+01	2011-02-23 20:01:44.885712+01	
457	5	61	60	34	AM332				1	194.34999999999999	194.34999999999999	5	4	2	радиатор 	radiator	169	249.95099999999999	\N	6.21	80.730000000000004	330.68099999999998	330.68099999999998	issued	2011-04-06 12:12:46.619841+02	received_office	2011-02-23 22:11:28.103058+01	2011-04-06 12:12:46.6251+02	#94
444	4	2	2	31	50820TK4A01				1	93.370000000000005	93.370000000000005	17	5	2	подушка ДВС	mount	93.780000000000001	93.780000000000001	\N	1.4099999999999999	18.329999999999998	112.11	112.11	issued	2011-04-06 12:13:03.088155+02	received_office	2011-02-23 20:03:18.362588+01	2011-04-06 12:13:03.093024+02	#94
438	4	35	35	30	8917006201	\N			1	190.44999999999999	190.44999999999999	27	2	1	датчик удара	restraint  ыутыщк	223.40000000000001	189.88999999999999	\N	0.42499999999999999	5.5249999999999995	195.41499999999999	195.41499999999999	issued	2011-04-06 12:13:08.780052+02	received_office	2011-02-23 20:01:27.190772+01	2011-04-06 12:13:08.784905+02	#94
440	6	58	13	29	35101-MCJ-A00			honda	1	32.289999999999999	32.289999999999999	36	1	1	контакт пара	contact	29.579999999999998	45.579999999999998	\N	0.14999999999999999	1.95	47.530000000000001	47.530000000000001	issued	2011-04-06 12:13:04.850741+02	received_office	2011-02-23 20:01:27.203631+01	2011-04-06 12:13:04.85559+02	#94
447	4	11	11	33	7T4Z16707A	\N			1	\N	\N	33	2	1	основание замка капота	support 	48.18	45.498783000000003	\N	\N	\N	\N	\N	in_processing	2011-02-23 20:10:51.092484+01	\N	2011-02-23 20:10:41.915599+01	2011-04-06 12:42:36.975338+02	#95
448	4	11	11	33	7A1Z8A284A	\N			1	\N	\N	33	2	1	накладка над радиаторами	reinforsment	126.53	119.48860550000001	\N	\N	\N	\N	\N	in_processing	2011-02-23 20:10:51.10194+01	\N	2011-02-23 20:10:41.926053+01	2011-04-06 12:43:00.65924+02	#95
449	4	11	11	33	AT4Z17757A	\N			1	\N	\N	33	2	1	усилитель бампера	reinforsment	128.66999999999999	121.50951449999999	\N	\N	\N	\N	\N	in_processing	2011-02-23 20:10:51.109803+01	\N	2011-02-23 20:10:41.940412+01	2011-04-06 12:43:22.124704+02	#95
450	4	11	11	33	7A1Z15A201A	\N			1	\N	\N	33	2	1	световозвращатель бампера правый	side marker	34.420000000000002	32.504527000000003	\N	\N	\N	\N	\N	in_processing	2011-02-23 20:10:51.117338+01	\N	2011-02-23 20:10:41.947569+01	2011-04-06 12:44:06.643242+02	#95
451	4	11	11	33	7T4Z6A949A	\N			1	\N	\N	33	2	1	крышка мотора	cover	77.920000000000002	73.583752000000004	\N	\N	\N	\N	\N	in_processing	2011-02-23 20:10:51.125852+01	\N	2011-02-23 20:10:41.954558+01	2011-04-06 12:44:17.696488+02	#95
452	4	11	11	33	8F1Z6766A	\N			1	\N	\N	33	2	1	пробка маслозаливной горловины	cap	12.08	11.407748	\N	\N	\N	\N	\N	in_processing	2011-02-23 20:10:51.134295+01	\N	2011-02-23 20:10:41.963155+01	2011-04-06 12:44:33.266547+02	#95
453	4	11	11	33	7A1Z17K945A	\N			1	\N	\N	33	2	1	решётка бампера	grille	32.700000000000003	30.880244999999999	\N	\N	\N	\N	\N	in_processing	2011-02-23 20:10:51.142497+01	\N	2011-02-23 20:10:41.969799+01	2011-04-06 12:44:50.622892+02	#95
445	4	13	13	32	77900SWAA81				1	28.98	28.98	37	1	1	спиральный кабель	clock spring	40	32	\N	0.13500000000000001	1.7550000000000001	33.755000000000003	33.755000000000003	issued	2011-04-06 12:13:01.34009+02	received_office	2011-02-23 20:06:17.175351+01	2011-04-06 12:13:01.344916+02	#94
459	5	61	60	34	A0579			не получено, но выставлено	1	\N	\N	5	4	2	подкрылок левый	fender liner	33	48.807000000000002	\N	\N	\N	\N	\N	back_order	2011-02-24 20:33:11.184092+01	in_processing	2011-02-23 22:11:28.128379+01	2011-02-25 16:39:55.971329+01	#94
455	5	61	60	34	A5631			2002 Acura RSX	1	25.300000000000001	25.300000000000001	38	1	1	подкрылок	fender liner	22	35	\N	0.65000000000000002	8.4500000000000011	43.450000000000003	43.450000000000003	issued	2011-04-06 12:12:49.938012+02	received_office	2011-02-23 20:34:11.836328+01	2011-04-06 12:12:49.942911+02	#94
434	5	62	63	27	H15105	\N		raybestos	1	\N	\N	34	2	2	направляющая суппорта	caliper bolt	10	15	\N	\N	\N	\N	\N	in_processing	2011-02-23 19:40:35.625918+01	\N	2011-02-23 19:40:02.486015+01	2011-04-06 12:41:04.899098+02	#95
458	5	61	60	34	A3600	\N			1	\N	\N	5	4	2	радиатор кондиционера	condencer	139	205.58099999999999	\N	\N	\N	\N	\N	in_processing	2011-02-23 22:11:37.330495+01	\N	2011-02-23 22:11:28.123314+01	2011-02-23 22:11:37.333542+01	
454	5	61	60	34	A0160			2007 Acura RDX	1	58.649999999999999	58.649999999999999	5	3	1	усилитель бампера	reinforcement	51	37.715000000000003	\N	3.25	42.25	79.965000000000003	79.965000000000003	issued	2011-04-06 12:12:51.896449+02	received_office	2011-02-23 20:34:11.828133+01	2011-04-06 12:12:51.901574+02	#94
344	4	2	2	7	71140STKA00	\N			1	10.41	10.41	5	1	1	крепление бампера верх прав	bracket	13.720000000000001	13.26	\N	0.25600000000000001	3.3280000000000003	16.588000000000001	16.588000000000001	issued	2011-02-23 23:39:19.586621+01	received_office	2011-02-17 15:55:09.475315+01	2011-02-24 19:19:54.774026+01	#93
327	4	2	2	7	74125STKA00	\N			1	4.9699999999999998	4.9699999999999998	5	1	1	накладка замка капота	latch cover	6.5499999999999998	6.3300000000000001	\N	0.13500000000000001	1.7550000000000001	8.0850000000000009	8.0850000000000009	issued	2011-02-23 23:39:38.113064+01	received_office	2011-02-17 15:55:09.366828+01	2011-02-24 19:21:56.491522+01	#93
331	4	2	2	7	19015RWCA01	\N			1	31.039999999999999	31.039999999999999	5	1	1	диффузор вентилятора левый	shroud	40.899999999999999	39.530000000000001	\N	1.3300000000000001	17.289999999999999	56.82	56.82	issued	2011-02-23 23:39:29.367992+01	received_office	2011-02-17 15:55:09.388857+01	2011-02-24 19:23:54.720813+01	#93
368	5	62	58	12	P7698P	\N	DORMAN 		1	14.58	14.58	7	4	1	цилиндрик супорта	Caliper Piston	9.7899999999999991	18.219999999999999	\N	0.31	4.0300000000000002	22.25	22.25	issued	2011-02-23 23:38:57.136244+01	received_office	2011-02-17 17:33:51.372401+01	2011-02-24 19:29:56.693935+01	#93
305	4	23	23	3	GK2A44410C	\N			2	28.98	57.960000000000001	3	1	1	трос ручного тормоза	parking brake lever	40.159999999999997	32.93	\N	1.115	14.494999999999999	47.424999999999997	94.849999999999994	issued	2011-02-23 23:40:18.159324+01	received_office	2011-02-17 15:36:10.686327+01	2011-02-23 23:58:00.091866+01	#93
311	4	23	23	3	000018BP01	\N			40	2.6400000000000001	105.60000000000001	3	1	1	свеча зажигания	spark plug	4.0300000000000002	3.2999999999999998	\N	0.047	0.61099999999999999	3.9109999999999996	156.44	issued	2011-02-23 23:40:06.576995+01	received_office	2011-02-17 15:36:10.731484+01	2011-02-24 00:04:54.822048+01	#93
460	2	74	13	12	45251STXA00	\N			1	\N	\N	5	5	1	Диск тормозной передний	-	182	276.60000000000002	\N	\N	\N	\N	\N	received_office	2011-04-05 15:00:01.427487+02	in_processing	2011-02-24 18:39:19.202527+01	2011-04-05 15:00:01.432786+02	146
323	4	47	47	5	68078768AA	\N			1	41.520000000000003	41.520000000000003	10	1	2	датчик давления колеса	sensor pressure	58.450000000000003	58.450000000000003	\N	0.050000000000000003	0.65000000000000002	59.100000000000001	59.100000000000001	issued	2011-02-23 23:39:46.518212+01	received_office	2011-02-17 15:41:38.542453+01	2011-02-24 18:45:01.039755+01	#93
341	4	2	2	7	60400STKA00ZZ	\N			2	289.25999999999999	578.51999999999998	5	1	1	рамка крепления радиаторов	support	381.10000000000002	342.95999999999998	\N	6.5	84.5	427.45999999999998	854.91999999999996	issued	2011-02-23 23:39:23.881276+01	received_office	2011-02-17 15:55:09.456217+01	2011-02-24 19:18:21.759533+01	#93
362	4	47	9	13	68003216AG	5156106AA			1	176.49000000000001	176.49000000000001	5	2	1	спиральный кабель	Clockspring	249	235.13999999999999	\N	0.41999999999999998	5.46	240.59999999999999	240.59999999999999	issued	2011-02-24 19:35:00.281494+01	superseded	2011-02-17 17:33:51.321144+01	2011-02-24 19:35:00.286401+01	#93
461	7	48	59	35	250760748975	\N			1	\N	\N	39	1	1	бампер	bumper	200	261	\N	\N	\N	\N	\N	in_processing	2011-02-24 22:56:29.39051+01	\N	2011-02-24 22:56:24.80586+01	2011-02-24 22:56:29.393996+01	
435	5	46	62	28	RT1131	\N		ЗАКАЗАНО motorcraft	1	13.029999999999999	13.029999999999999	3	4	1	термостат	thermostat	11.33	15.630000000000001	\N	0.095000000000000001	1.2350000000000001	16.865000000000002	16.865000000000002	issued	2011-04-01 12:47:42.059167+02	received_office	2011-02-23 19:43:43.241687+01	2011-04-01 12:47:42.06454+02	#94
446	4	11	11	33	7A1Z16856A	\N			1	\N	\N	33	2	1	молдинг капота	molding	212.69999999999999	200.86324500000001	\N	\N	\N	\N	\N	in_processing	2011-02-23 20:10:51.08311+01	\N	2011-02-23 20:10:41.896974+01	2011-04-06 12:42:13.514891+02	#95
467	6	50	79	36	0640-0064	\N			1	\N	\N	36	2	1	зеркало	mirror	18.949999999999999	18.949999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-03 21:56:57.085632+01	\N	2011-03-03 21:56:19.107456+01	2011-03-03 21:56:57.089107+01	
429	4	2	2	26	71594SEPA01	\N			1	6.4699999999999998	6.4699999999999998	34	1	2	держатель заднего бампера правый	spacer right	8.5299999999999994	22.960000000000001	\N	0.085000000000000006	1.105	24.065000000000001	24.065000000000001	issued	2011-04-06 12:13:19.074297+02	received_office	2011-02-23 19:35:20.793553+01	2011-04-06 12:13:19.079254+02	#94
397	4	2	2	22	28820RWE003	\N			1	33.670000000000002	33.670000000000002	4	4	1	датчик	sensor	44.369999999999997	39.039999999999999	\N	0.025000000000000001	0.32500000000000001	39.365000000000002	39.365000000000002	issued	2011-04-06 12:13:27.988925+02	received_office	2011-02-22 22:14:22.72632+01	2011-04-06 12:13:27.993876+02	#94
456	5	61	60	34	A0241				1	149.5	149.5	5	4	2	усилитель бампера	reinforcement	130	192.27000000000001	\N	5.2999999999999998	68.899999999999991	261.17000000000002	261.17000000000002	issued	2011-04-06 12:12:48.150464+02	received_office	2011-02-23 22:11:28.090774+01	2011-04-06 12:12:48.155639+02	#94
424	4	23	23	25	GK2A34156	\N			10	0	10.6	3	3	1	втулка стабилизатора	bushing	2.0699999999999998	1.7	1.2749999999999999	0.059999999999999998	0.78000000000000003	2.0549999999999997	20.549999999999997	issued	2011-04-01 12:47:29.037232+02	received_office	2011-02-23 19:29:54.190582+01	2011-04-01 12:55:30.555253+02	#98
281	4	34	34	1	5520078J01	\N			1	76.370000000000005	76.370000000000005	4	1	1	Колодки тормозные	Brake pads	84.510000000000005	76.060000000000002	\N	2.2149999999999999	28.794999999999998	104.855	104.855	issued	2011-04-06 12:14:58.372631+02	received_office	2011-02-17 15:34:23.972454+01	2011-04-06 12:14:58.377646+02	#94
389	7	48	59	20	250744213690		ЗАКАЗАНО		1	20.899999999999999	20.899999999999999	30	1	2	ручка задняя правая	handle	19	28.5	\N	0.25	3.25	31.75	31.75	issued	2011-04-06 12:13:31.813859+02	received_office	2011-02-22 21:58:59.512078+01	2011-04-06 12:13:31.822233+02	#94
274	4	13	13	1	71140TE0A00	\N			1	12.49	12.49	4	1	1	Ресница бампера	Side support	16.77	15.09	\N	0.32500000000000001	4.2250000000000005	19.315000000000001	19.315000000000001	issued	2011-04-06 12:15:07.739041+02	received_office	2011-02-17 15:34:23.921626+01	2011-04-06 12:15:07.743882+02	#94
374	4	33	33	16	38300AC220	\N		уточеить у саши цену	1	707.33000000000004	707.33000000000004	4	2	1	задний редуктор	Difrntal assy	755.80999999999995	665.11000000000001	\N	21.550000000000001	280.15000000000003	945.25999999999999	945.25999999999999	issued	2011-04-06 12:13:49.291199+02	received_office	2011-02-22 21:28:57.452234+01	2011-04-06 12:13:49.29608+02	#94
423	4	23	23	25	000018BP01	\N			40	2.9500000000000002	118	3	3	1	свеча зажигания	spark plug	4.0300000000000002	3.2999999999999998	3.2999999999999998	0.048000000000000001	0.624	3.9239999999999999	156.96000000000001	issued	2011-04-01 12:47:26.90196+02	received_office	2011-02-23 19:29:54.184665+01	2011-04-06 12:15:46.129743+02	#94
320	4	2	2	4	50810TK4A01	50810TK4A02	V6531911		1	119.40000000000001	119.40000000000001	17	1	2	подушка двигателя	Rear mount	157.31999999999999	157	\N	2.5449999999999999	33.085000000000001	190.08500000000001	190.08500000000001	issued	2011-04-06 12:17:04.996912+02	superseded	2011-02-17 15:39:41.407437+01	2011-04-06 12:17:05.001936+02	#94
367	5	62	64	12	2841	\N	ANCHOR		1	46.770000000000003	46.770000000000003	7	4	1	подушка двигателя 	 Motor Mount	35.789999999999999	58.460000000000001	\N	1.425	18.525000000000002	76.984999999999999	76.984999999999999	issued	2011-04-06 12:13:52.627841+02	received_office	2011-02-17 17:33:51.364049+01	2011-04-06 12:13:52.632817+02	#94
339	5	62	64	8	2841	\N			1	46.770000000000003	46.770000000000003	7	3	1	подушка двигателя 	 Motor Mount	35.789999999999999	46.770000000000003	\N	1.425	18.525000000000002	65.295000000000002	65.295000000000002	issued	2011-04-06 12:13:57.751385+02	received_office	2011-02-17 15:55:09.443843+01	2011-04-06 12:13:57.75618+02	#94
472	5	45	63	38	BH382322	\N	RAYBESTOS	RAYBESTOS	1	\N	\N	7	7	1	шланг тормозной	HydraulicHose	18.039999999999999	33.939999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-03 21:57:49.483223+01	\N	2011-03-03 21:56:19.136256+01	2011-04-06 12:45:23.395201+02	#95
313	4	13	13	4	73860TE0A01	\N	V6684658		1	7.0999999999999996	7.0999999999999996	15	1	2	молдинг стекла четверти левого	Seal Left 	9.8000000000000007	10	\N	0.070000000000000007	0.91000000000000014	10.91	10.91	issued	2011-04-06 12:14:10.328829+02	received_office	2011-02-17 15:39:41.362166+01	2011-04-06 12:14:10.343907+02	#94
288	4	13	13	1	77900STKA02	\N			1	41.789999999999999	41.789999999999999	4	1	1	Датчик в руль	Clockspring	56.079999999999998	50.469999999999999	\N	0.14999999999999999	1.95	52.420000000000002	52.420000000000002	issued	2011-04-06 12:14:47.248986+02	received_office	2011-02-17 15:34:24.022834+01	2011-04-06 12:14:47.253807+02	#94
462	6	50	79	36	0640-0065	\N			1	\N	\N	36	2	1	зеркало	mirror	18.949999999999999	18.949999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-03 21:56:57.074293+01	\N	2011-03-03 21:56:19.078886+01	2011-03-03 21:56:57.077799+01	
468	6	50	79	36	0610-0050	\N			1	\N	\N	36	2	1	рукоятки	grips	39.950000000000003	39.950000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-03 21:56:57.095231+01	\N	2011-03-03 21:56:19.112299+01	2011-03-03 21:56:57.099198+01	
469	7	48	59	37	400182301035	\N		RSX +	1	\N	\N	40	1	1	бампер	bumper	165	254.59999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-03 21:57:07.590317+01	\N	2011-03-03 21:56:19.119012+01	2011-03-03 21:57:07.593628+01	
470	7	48	59	37	230448594984	\N			1	\N	\N	41	1	1	зеркало	mirror	70	87.5	\N	\N	\N	\N	\N	in_processing	2011-03-03 21:57:07.598747+01	\N	2011-03-03 21:56:19.125375+01	2011-03-03 21:57:07.601747+01	
471	7	48	59	37	170583706969	\N			1	\N	\N	41	1	1	зеркало	mirror	70	87.5	\N	\N	\N	\N	\N	in_processing	2011-03-03 21:57:07.60649+01	\N	2011-03-03 21:56:19.131151+01	2011-03-03 21:57:07.609801+01	
463	5	62	82	38	39072	\N	GATES	GATES	1	\N	\N	7	7	1	натяжитель ремня	Belt Tensioner	39.789999999999999	60.140000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-03 21:57:49.421485+01	\N	2011-03-03 21:56:19.087606+01	2011-03-03 21:57:49.425149+01	
464	5	62	58	38	H620145	\N	DORMAN 	DORMAN 	1	\N	\N	7	7	1	шланг тормозной	Hydraulic Hose	15.06	24.59	\N	\N	\N	\N	\N	in_processing	2011-03-03 21:57:49.441364+01	\N	2011-03-03 21:56:19.092223+01	2011-03-03 21:57:49.444477+01	
465	5	62	58	38	H620146	\N	DORMAN	DORMAN	1	\N	\N	7	7	1	шланг тормозной	Hydraulic Hose	15.06	24.59	\N	\N	\N	\N	\N	in_processing	2011-03-03 21:57:49.449592+01	\N	2011-03-03 21:56:19.097003+01	2011-03-03 21:57:49.452663+01	
466	5	43	80	38	11108090	\N	ЗАКАЗАНО: CENTRIC	ЗАКАЗАНО: CENTRIC	1	\N	\N	7	7	1	колодки ручника	Parking Brake Shoe 	16.48	28.68	\N	\N	\N	\N	\N	in_processing	2011-03-03 21:57:49.474974+01	\N	2011-03-03 21:56:19.102611+01	2011-04-06 12:45:38.778033+02	#95
473	5	62	64	38	3010	\N	ANCHOR	ANCHOR	1	\N	\N	7	7	1	подушка двигателя  	Motor Mount \r\n	57.789999999999999	100.16500000000001	\N	\N	\N	\N	\N	in_processing	2011-03-03 21:57:49.491683+01	\N	2011-03-03 21:56:19.141623+01	2011-03-03 21:57:49.494607+01	
474	5	62	58	38	H620142	\N	DORMAN	DORMAN	1	\N	\N	7	7	1	шланг тормозной	Hydraulic Hose	20.789999999999999	32.829999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-03 21:57:49.499398+01	\N	2011-03-03 21:56:19.147294+01	2011-03-03 21:57:49.502719+01	
477	7	48	59	39	150535800561	\N	4x4 +	4x4 +	1	\N	\N	42	1	1	фара головного света правая	headlight	97	126	\N	\N	\N	\N	\N	in_processing	2011-03-08 13:52:25.238845+01	\N	2011-03-08 13:49:30.930052+01	2011-03-08 13:52:25.242315+01	
478	7	48	59	39	260457514352	\N	4x4 +	4x4 +	1	\N	\N	42	1	1	рукоятка правая	lever	15.9	20.670000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-08 13:52:25.24748+01	\N	2011-03-08 13:49:30.94702+01	2011-03-08 13:52:25.250484+01	
479	7	48	59	39	390277962126	\N	RDX +	RDX +	1	\N	\N	5	6	1	подушка безопаподушка	airbag	359.99000000000001	430	\N	\N	\N	\N	\N	in_processing	2011-03-08 13:52:25.254969+01	\N	2011-03-08 13:49:30.953253+01	2011-03-08 13:52:25.257934+01	
480	7	48	59	39	370476706588	\N	MDX +	MDX +	1	\N	\N	5	6	1	подушка безопаподушка	airbag	359.99000000000001	430	\N	\N	\N	\N	\N	in_processing	2011-03-08 13:52:25.262537+01	\N	2011-03-08 13:49:30.95811+01	2011-03-08 13:52:25.265628+01	
481	2	74	13	13	17220RCAA00	\N			1	\N	\N	31	7	1	Фильтр воздушный	-	26.149999999999999	30	\N	\N	\N	\N	\N	issued	2011-04-05 11:40:31.094236+02	in_processing	2011-03-08 13:56:16.13733+01	2011-04-05 12:12:21.901902+02	147
380	4	47	9	18	68000023AA	\N			1	21.559999999999999	21.559999999999999	3	2	1	стекло зеркала	GLASS MIRROR REPLACE	30.350000000000001	26.699999999999999	\N	0.28999999999999998	3.7699999999999996	30.469999999999999	30.469999999999999	issued	2011-04-01 12:47:14.390286+02	received_office	2011-02-22 21:41:34.066727+01	2011-04-01 12:47:14.396062+02	#94
439	4	35	35	30	7396006150	\N			1	561.46000000000004	561.46000000000004	27	2	1	подушка безопастности пассажирская	inflator module	765.91999999999996	651.02999999999997	\N	3.3250000000000002	43.225000000000001	694.255	694.255	issued	2011-04-06 12:13:06.927936+02	received_office	2011-02-23 20:01:27.19785+01	2011-04-06 12:13:06.932927+02	#94
483	5	62	69	40	3656	\N	TYC	TYC	1	\N	\N	33	3	1	радиатор кондиционера	condencer	104.09	242.55600000000001	\N	\N	\N	\N	\N	in_processing	2011-03-08 13:59:44.66416+01	\N	2011-03-08 13:58:31.547478+01	2011-03-08 13:59:44.670168+01	
484	7	48	59	41	130430311002	\N	MKX +	MKX +	1	\N	\N	33	4	1	бампер	bumper	110	143.55000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:14:16.074933+01	\N	2011-03-08 14:11:42.476852+01	2011-03-08 14:14:16.078443+01	
485	7	48	59	41	180607498602	\N	MKX +	MKX +	1	\N	\N	33	4	1	модуль вентиляторов	cooling fun module	151.66	204.66	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:14:16.093353+01	\N	2011-03-08 14:11:42.493846+01	2011-03-08 14:14:16.09881+01	
486	7	48	59	41	400182283000	\N	RDX +	RDX +	1	\N	\N	5	7	1	бампер передний низ	bumper	109	142.25	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:14:16.10482+01	\N	2011-03-08 14:11:42.49897+01	2011-03-08 14:14:16.107681+01	
487	7	48	59	41	200546760467	\N	Sienna +	Sienna +	2	\N	\N	5	8	2	подушка безопастности	airbag	309.94	370	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:14:16.113049+01	\N	2011-03-08 14:13:49.150828+01	2011-03-08 14:14:16.1159+01	
489	4	33	33	42	901000159	\N			1	\N	\N	43	1	1	болт 	bolt	2	2	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:21:02.93132+01	\N	2011-03-08 14:20:52.460342+01	2011-03-08 14:21:02.934626+01	
490	4	33	33	42	22641AA32A	\N			1	\N	\N	6	3	1	датчик кислородный	oxygen sensor	179.94999999999999	152.94999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:21:02.939828+01	\N	2011-03-08 14:20:52.464938+01	2011-03-08 14:21:02.942807+01	
491	4	33	33	42	16608KA000 	\N			1	\N	\N	43	1	1	прокладка инжектора  	gasket	2.6699999999999999	2.6699999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:21:02.947149+01	\N	2011-03-08 14:20:52.469211+01	2011-03-08 14:21:02.950121+01	
492	4	33	33	42	59110SA002 	\N			1	\N	\N	43	1	1	подкрылок правый 	fender liner	47	47	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:21:02.955932+01	\N	2011-03-08 14:20:52.473601+01	2011-03-08 14:21:02.960587+01	
493	4	33	33	42	57728AC090 	\N			1	\N	\N	43	1	1	клипса 	pin	2	2	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:21:02.967683+01	\N	2011-03-08 14:20:52.478881+01	2011-03-08 14:21:02.972515+01	
494	4	33	33	42	46064AE000 	\N			1	\N	\N	43	1	1	клипса 	pin	1	1	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:21:02.979396+01	\N	2011-03-08 14:20:52.484552+01	2011-03-08 14:21:02.984044+01	
495	4	33	33	42	59122FA010 	\N			1	\N	\N	43	1	1	клипса 	pin	2	2	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:21:02.99408+01	\N	2011-03-08 14:20:52.488871+01	2011-03-08 14:21:02.997936+01	
496	4	33	33	42	909140007	\N			1	\N	\N	43	1	1	клипса 	pin	2	2	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:21:03.0037+01	\N	2011-03-08 14:20:52.493139+01	2011-03-08 14:21:03.007502+01	
497	4	33	33	42	41040AE010 	\N			1	\N	\N	43	1	1	подушка 	mount	39	39	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:21:03.0137+01	\N	2011-03-08 14:20:52.497349+01	2011-03-08 14:21:03.016568+01	
498	4	33	33	42	56410SA070 	\N			1	\N	\N	43	1	1	защита  	cover	94	94	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:21:03.021145+01	\N	2011-03-08 14:20:52.502122+01	2011-03-08 14:21:03.024317+01	
488	4	33	33	42	28191SA000				1	\N	\N	6	3	1	клапан	valve	5.9299999999999997	5.04	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:21:02.922191+01		2011-03-08 14:20:52.443212+01	2011-03-08 14:23:58.028589+01	#96
519	4	2	2	46	08L33STX2C0R3	\N			1	\N	\N	4	6	1	заглушка	END CAP SET, R. RR.	30.149999999999999	26.530000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:59:47.047819+01	\N	2011-03-08 14:59:38.935914+01	2011-04-06 12:47:59.417528+02	#95
517	5	61	60	43	D0274	\N		ЗАКАЗАНО	1	\N	\N	10	2	2	передний бампер	bumper front	156	238	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:48:03.534741+01	\N	2011-03-08 14:47:26.079759+01	2011-03-08 14:48:03.537801+01	
511	5	46	62	43	MCSOE95	\N		ЗАКАЗАНО: motorcraft	1	\N	\N	33	5	1	рычаг нижний правый	arm	107.51000000000001	179.91999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:48:03.560099+01	\N	2011-03-08 14:47:05.262874+01	2011-04-06 12:47:04.393312+02	#95
509	5	61	60	43	A0654	\N			1	\N	\N	5	9	1	капот CAPA	hood	286	330	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:48:03.542752+01	\N	2011-03-08 14:47:05.238539+01	2011-04-06 12:46:44.972761+02	#95
516	5	61	60	43	A0173	\N		ЗАКАЗАНО	1	\N	\N	17	6	2	передний бампер	bumper front	120	160	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:48:03.515785+01	\N	2011-03-08 14:47:26.075097+01	2011-04-06 12:47:19.329949+02	#95
513	5	62	69	43	13076	\N			2	\N	\N	5	10	2	радиатор	radiator	155.99000000000001	288.40499999999997	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:48:03.568583+01	\N	2011-03-08 14:47:26.058107+01	2011-03-08 14:48:03.571608+01	
514	5	62	69	43	3284	\N			2	\N	\N	5	10	2	радиатор кондиционера	condencer	80.790000000000006	177.47999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:48:03.57634+01	\N	2011-03-08 14:47:26.063687+01	2011-03-08 14:48:03.579387+01	
518	4	13	13	44	72250-TE0-A12	\N			1	\N	\N	15	5	2	стеклоподъемник левый	regulator right	258.32999999999998	260	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:51:39.17229+01	\N	2011-03-08 14:47:26.085494+01	2011-03-08 14:51:39.175638+01	
525	2	77	11	14	8L2Z2V200A	\N			1	\N	\N	44	1	2	Колодки тормозные	-	65.349999999999994	90	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:35:00.773343+01	\N	2011-03-08 15:34:49.209754+01	2011-04-05 12:12:39.692161+02	148
515	7	48	59	45	220724792698	\N		Altima +	1	\N	\N	10	2	2	бампер задний	bumper	130	169	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:52:22.872127+01	\N	2011-03-08 14:47:26.069234+01	2011-03-08 14:52:22.875438+01	
520	4	17	17	46	LNC4900CB	\N			1	\N	\N	4	6	1	фонарь	Tail lamp assy	212.09999999999999	212.09999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:59:47.05792+01	\N	2011-03-08 14:59:38.953493+01	2011-03-08 14:59:47.061217+01	
521	4	17	17	46	LNC5032AB	\N			1	\N	\N	4	6	1	рефлектор	Marker lamp assy Right	16.280000000000001	16.280000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:59:47.066574+01	\N	2011-03-08 14:59:38.958047+01	2011-03-08 14:59:47.070088+01	
522	4	23	23	46	L33L188G1E9U	\N			1	\N	\N	4	6	1	лямбда-зонд	SENSOR OXYGEN	132.74000000000001	116.81	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:59:47.075302+01	\N	2011-03-08 14:59:38.962744+01	2011-03-08 14:59:47.078713+01	
523	4	47	47	46	YE12BDAAC	\N			1	\N	\N	7	8	1	шторка в багажник	COVER,tonneau	242	217.80000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:59:47.083992+01	\N	2011-03-08 14:59:38.968574+01	2011-03-08 14:59:47.087412+01	
524	2	77	62	14	BRR102	\N			2	\N	\N	44	1	2	Диск тормозной задний	-	98.75	136	\N	\N	\N	\N	\N	issued	2011-04-05 12:13:03.275855+02	in_processing	2011-03-08 15:34:49.183976+01	2011-04-05 12:13:03.28079+02	148
510	5	61	60	43	A0654	\N			1	\N	\N	39	3	1	капот CAPA	hood	286	422.99400000000003	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:48:03.550759+01	\N	2011-03-08 14:47:05.255695+01	2011-04-06 12:46:39.779502+02	#95
526	4	11	11	47	6L2Z5484AA	\N			2	\N	\N	44	1	2	Втулка стабилизатора	Bushing	13.43	14	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:43:02.157607+01	\N	2011-03-08 15:34:49.214677+01	2011-03-08 15:43:02.16105+01	
533	4	47	47	48	4573560AB	\N	0	0	1	\N	\N	3	5	1	термостат	thermostat	12.1	9.9299999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:56.92542+01	\N	2011-03-08 15:46:36.483178+01	2011-03-08 15:46:56.928514+01	
534	4	23	23	48	EC0143980D	\N	0	0	2	\N	\N	3	5	1	шланг тормозной	brake hose	14.65	12.02	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:56.934482+01	\N	2011-03-08 15:46:36.489236+01	2011-03-08 15:46:56.937584+01	
535	4	23	23	48	EC0143980D	\N	0	0	4	\N	\N	3	5	1	шланг тормозной	brake hose	12.74	10.449999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:56.945222+01	\N	2011-03-08 15:46:36.493717+01	2011-03-08 15:46:56.950021+01	
536	4	23	23	48	GD7A3438X	\N	0	0	20	\N	\N	3	5	1	сайлентблок задний	bushing	2.9700000000000002	2.4399999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:56.962561+01	\N	2011-03-08 15:46:36.499235+01	2011-03-08 15:46:56.966856+01	
537	4	23	23	48	GK2A34156	\N	0	0	10	\N	\N	3	5	1	втулка стабилизатора	bushing	1.6599999999999999	1.3600000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:56.974608+01	\N	2011-03-08 15:46:36.50414+01	2011-03-08 15:46:56.97968+01	
538	4	23	23	48	EC0946500A	\N	0	0	1	\N	\N	3	5	1	трос переключения передач	shift cable	147.75	121.16	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:56.987171+01	\N	2011-03-08 15:46:36.509113+01	2011-03-08 15:46:56.990685+01	
539	4	23	23	48	FW5027238	\N	0	0	1	\N	\N	3	5	1	сальник	seal	7.9699999999999998	6.54	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:56.995852+01	\N	2011-03-08 15:46:36.514123+01	2011-03-08 15:46:56.998784+01	
512	4	30	30	44	95573104801				1	\N	\N	3	2	1	стекло зеркала	mirror glass	317.55000000000001	325	\N	\N	\N	\N	\N	in_processing	2011-03-08 14:51:39.191926+01		2011-03-08 14:47:05.282129+01	2011-03-28 23:40:15.236048+02	#
532	4	47	47	48	5149098AA	\N	0	0	2	\N	\N	3	5	1	датчик давления	oil pressure sending unit	18.600000000000001	15.26	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:56.916916+01	\N	2011-03-08 15:46:36.476425+01	2011-03-08 15:46:56.920083+01	
540	4	23	23	48	GY0110234	\N	0	0	6	\N	\N	3	5	1	кольцо свечного колодца	valve cover seal	3.21	2.6299999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:57.003398+01	\N	2011-03-08 15:46:36.519116+01	2011-03-08 15:46:57.006261+01	
541	4	23	23	48	GY0918140	\N	0	0	1	\N	\N	3	5	1	провода высоковольтные	ignition wire set	86.319999999999993	70.790000000000006	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:57.010782+01	\N	2011-03-08 15:46:36.524041+01	2011-03-08 15:46:57.01368+01	
531	4	23	23	48	L3K912201A	\N	0	0	1	\N	\N	3	5	1	цепь грм	timing chain	39.759999999999998	32.609999999999999	32.609999999999999	\N	\N	\N	\N	issued	2011-04-04 20:00:11.92995+02	in_processing	2011-03-08 15:46:36.457099+01	2011-04-06 12:51:33.78436+02	#95
543	4	23	23	48	AJ382050XB	\N	0	0	1	\N	\N	3	5	1	коллектор выпускной	exhaust manifold	908.48000000000002	744.96000000000004	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:57.027895+01	\N	2011-03-08 15:46:36.534943+01	2011-03-08 15:46:57.03131+01	
544	4	23	23	48	KLG415350C	\N	0	0	1	\N	\N	3	5	1	бачёк расширительный	reservoir 	79.75	65.400000000000006	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:57.036671+01	\N	2011-03-08 15:46:36.540073+01	2011-03-08 15:46:57.04016+01	
559	5	46	62	51	BRF936	\N	ЗАКАЗАНО motorcraft	ЗАКАЗАНО motorcraft	1	\N	\N	46	1	2	колодки задние	brake shoe	38.740000000000002	112	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:58:23.187309+01	\N	2011-03-08 15:57:28.478104+01	2011-04-06 12:48:31.19737+02	#95
542	4	23	23	48	AJ0313135	\N	0	0	6	\N	\N	3	5	1	прокладка впускного коллектора	plenum gasket	4.5800000000000001	3.7599999999999998	3.7599999999999998	\N	\N	\N	\N	issued	2011-04-04 20:00:05.705454+02	in_processing	2011-03-08 15:46:36.529028+01	2011-04-06 13:39:35.028491+02	#96
547	4	23	23	48	FW5027238	\N	0	0	2	\N	\N	3	5	1	сальник	seal	8.4700000000000006	6.9500000000000002	6.9500000000000002	\N	\N	\N	\N	issued	2011-04-04 19:59:58.991818+02	in_processing	2011-03-08 15:46:36.556598+01	2011-04-06 12:51:05.426146+02	#95
549	4	23	23	48	000018BP01	\N	0	0	40	\N	\N	3	5	1	свеча зажигания	spark plug	4.0300000000000002	3.2999999999999998	3.2999999999999998	\N	\N	\N	\N	issued	2011-04-04 19:59:52.931829+02	in_processing	2011-03-08 15:46:36.567728+01	2011-04-06 13:08:48.93212+02	#96
550	4	23	23	48	AJ0315980B	\N	0	0	1	\N	\N	3	5	1	натяжитель	tensioner	30.539999999999999	25.050000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:57.091534+01	\N	2011-03-08 15:46:36.573637+01	2011-03-08 15:46:57.09533+01	
551	4	47	47	48	5066756AA	\N	0	0	1	\N	\N	3	5	1	сальник коленвала	seal	65.950000000000003	54.079999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:57.101069+01	\N	2011-03-08 15:46:36.579121+01	2011-03-08 15:46:57.105041+01	
552	4	47	47	48	4781639AB	\N	0	0	1	\N	\N	3	5	1	прокладка клапанной крышки	valve cover gasket	16.449999999999999	13.49	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:57.110874+01	\N	2011-03-08 15:46:36.602243+01	2011-03-08 15:46:57.114654+01	
553	4	11	11	49	8L8Z7820125A	\N			1	\N	\N	45	1	2	левая пердняя дверь 	Door shell	590.82000000000005	590.82000000000005	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:47:11.931999+01	\N	2011-03-08 15:47:05.458049+01	2011-03-08 15:47:11.935477+01	
554	4	11	11	49	7L8Z7822801A	\N			1	\N	\N	45	1	2	петли двери передней верхняя	Upper hinge Left	27.649999999999999	27.649999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:47:11.940999+01	\N	2011-03-08 15:47:05.463479+01	2011-03-08 15:47:11.943994+01	
555	4	11	11	49	7L8Z7822811A	\N			1	\N	\N	45	1	2	петли двери передней нижняя	Lower hinge Left	24.75	24.75	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:47:11.949432+01	\N	2011-03-08 15:47:05.467683+01	2011-03-08 15:47:11.952367+01	
556	4	11	11	49	8L8Z7824701A	\N			1	\N	\N	45	1	2	железо левой задней двери	Outer panel Left	362.18000000000001	362.18000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:47:11.957141+01	\N	2011-03-08 15:47:05.47343+01	2011-03-08 15:47:11.960103+01	
557	4	47	47	50	4573560AB	\N	0	0	1	\N	\N	3	6	1	термостат	thermostat	12.1	9.9299999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:48:47.346754+01	\N	2011-03-08 15:48:31.404211+01	2011-03-08 15:48:47.352862+01	
558	5	61	60	51	F4095	\N	ЗАКАЗАНО	ЗАКАЗАНО	1	\N	\N	45	2	2	зеркало левое	Mirror assy left	48	75	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:58:23.175311+01	\N	2011-03-08 15:57:28.471112+01	2011-03-08 15:58:23.180173+01	
564	5	43	84	53	EV80645	\N		ЗАКАЗАНО moog	1	\N	\N	7	9	1	тяга рулевая	Tie Rod End	21.789999999999999	38.07	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:25:26.563917+01	\N	2011-03-08 16:24:11.870906+01	2011-04-06 12:49:08.829719+02	#95
546	4	23	23	48	000018F287	\N	0	0	30	\N	\N	3	5	1	свеча зажигания	spark plug	3.7000000000000002	3.0299999999999998	3.0299999999999998	\N	\N	\N	\N	issued	2011-04-04 20:00:01.870174+02	in_processing	2011-03-08 15:46:36.551263+01	2011-04-06 13:35:28.569431+02	#96
561	5	62	71	51	ES72274	\N	FEL-PRO	FEL-PRO	2	\N	\N	48	1	2	комплект болтов ГБЦ	head bolt set	30.940000000000001	25	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:58:23.208602+01	\N	2011-03-08 15:57:28.489591+01	2011-03-08 15:58:23.212314+01	
562	7	48	59	52	190396275531	\N	0	0	1	\N	\N	45	2	2	стекло перед лев	glass left front	74.950000000000003	122	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:58:31.590779+01	\N	2011-03-08 15:57:28.493881+01	2011-03-08 15:58:31.595027+01	
545	4	23	23	48	GS3L50711CUK		0	0	1	\N	\N	4	7	1	молдинг	Grille - White	47.829999999999998	42.090000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:46:57.045572+01		2011-03-08 15:46:36.545361+01	2011-03-08 16:14:02.366275+01	#96
571	5	43	81	53	512001	\N		ЗАКАЗАНО timken	1	\N	\N	49	1	2	ступица задняя	hub rear	88.5	146	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:25:26.62396+01	\N	2011-03-08 16:25:00.761505+01	2011-04-06 12:49:24.749676+02	#95
565	5	62	64	53	2959	\N		ANCHOR	1	\N	\N	7	9	1	подушка двигателя	Motor Mount 	18.289999999999999	32.18	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:25:26.57177+01	\N	2011-03-08 16:24:11.875584+01	2011-03-08 16:25:26.574748+01	
566	5	62	83	53	24483	\N		WIX 	1	\N	\N	7	9	1	фильтр салонный	Cabin Air Filter	9.9700000000000006	18.27	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:25:26.581918+01	\N	2011-03-08 16:24:11.880314+01	2011-03-08 16:25:26.584896+01	
567	5	62	64	53	2928	\N		ANCHOR	1	\N	\N	7	9	1	подушка двигателя	Transmission Mount	19	33.189999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:25:26.590463+01	\N	2011-03-08 16:24:11.885073+01	2011-03-08 16:25:26.59359+01	
568	5	62	58	53	H380337	\N		DORMAN 	1	\N	\N	7	9	1	шланг тормозной	Hydraulic Hose 	10.789999999999999	19.440000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:25:26.599971+01	\N	2011-03-08 16:24:11.891721+01	2011-03-08 16:25:26.603038+01	
569	5	62	63	53	BH380338	\N		RAYBESTO	1	\N	\N	7	9	1	шланг тормозной 	Hydraulic Hose 	11.73	20.809999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:25:26.608148+01	\N	2011-03-08 16:24:11.896508+01	2011-03-08 16:25:26.611237+01	
570	5	62	85	53	1S4938	\N		AIRTEX / WELLS	1	\N	\N	7	9	1	датчик заднего хода 	Back Up Lamp Switch	10.380000000000001	11.93	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:25:26.616098+01	\N	2011-03-08 16:24:11.903639+01	2011-03-08 16:25:26.619197+01	
560	5	43	81	51	HA591080	\N	ЗАКАЗАНО timken	ЗАКАЗАНО timken	1	\N	\N	47	1	2	ступица задняя	hub rear	140.97999999999999	226.37	\N	\N	\N	\N	\N	in_processing	2011-03-08 15:58:23.198927+01	\N	2011-03-08 15:57:28.483337+01	2011-04-06 12:49:37.657144+02	#95
573	4	47	47	54	4857639AD	\N			1	\N	\N	7	10	1	кронштейн бампера 	Mount bracket	25	19.539999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:29:50.092742+01	\N	2011-03-08 16:29:42.260421+01	2011-03-08 16:29:50.095654+01	
574	4	11	11	54	7A1Z17E810A	\N			1	\N	\N	33	6	1	заглушка в бампер правая	cover	53.020000000000003	50.069437000000001	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:29:50.101505+01	\N	2011-03-08 16:29:42.266641+01	2011-03-08 16:29:50.105269+01	
576	4	11	11	54	7A1Z17C882A	\N			1	\N	\N	33	6	1	пена бампера	absorber	107.97	101.96146950000001	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:29:50.120741+01	\N	2011-03-08 16:29:42.277467+01	2011-03-08 16:29:50.124534+01	
577	4	11	11	54	7T4Z17C972A	\N			1	\N	\N	33	6	1	кронштейн бампера правый	bracket	33.18	31.333532999999999	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:29:50.130408+01	\N	2011-03-08 16:29:42.282191+01	2011-03-08 16:29:50.134203+01	
578	4	11	11	54	7T4Z17C973A	\N			1	\N	\N	33	6	1	кронштейн бампера левый	bracket	21.199999999999999	20.020219999999998	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:29:50.14001+01	\N	2011-03-08 16:29:42.287036+01	2011-03-08 16:29:50.144008+01	
563	5	46	62	53	RT1131	\N		ЗАКАЗАНО motorcraft	1	\N	\N	3	7	1	термостат	thermostat	11.33	15.635400000000001	\N	0.095000000000000001	1.2350000000000001	16.8704	16.8704	issued	2011-04-01 12:58:56.222257+02	in_processing	2011-03-08 16:24:11.861864+01	2011-04-01 12:58:56.227211+02	#95
572	4	47	47	54	5156106AA	\N			1	\N	\N	7	10	1	подрулевой шлейф	Clockspring 2011 	249	194.13	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:29:50.081274+01	\N	2011-03-08 16:29:42.253828+01	2011-03-08 16:29:50.084614+01	
575	4	11	11	54	7A1Z17E811A	\N			1	\N	\N	33	6	1	заглушка в бампер левая	cover	53.869999999999997	50.872134500000001	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:29:50.111172+01	\N	2011-03-08 16:29:42.272742+01	2011-03-08 16:29:50.114974+01	
579	4	11	11	54	7A1Z17E814A	\N			1	\N	\N	33	6	1	усилитель бампера  правый	reinforsment	14.9	14.07	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:29:50.149775+01	\N	2011-03-08 16:29:42.292724+01	2011-03-08 16:29:50.15359+01	
580	4	11	11	54	7A1Z17E814B	\N			1	\N	\N	33	6	1	усилитель бампера  левый	reinforsment	14.9	14.07	\N	\N	\N	\N	\N	in_processing	2011-03-08 16:29:50.159645+01	\N	2011-03-08 16:29:42.297897+01	2011-03-08 16:29:50.163843+01	
583	4	47	47	55	68004466AC	\N			1	\N	\N	7	11	1	пластик сиденья 	KIT NONE 	51.450000000000003	39.280000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.710738+01	\N	2011-03-21 16:26:54.203094+01	2011-03-21 16:27:58.713793+01	
585	4	2	2	55	71185STKA00ZZ	\N			1	\N	\N	39	4	1	крепление усилителя бампера лев	bracket	19.18	18.539999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.726646+01	\N	2011-03-21 16:26:54.216797+01	2011-03-21 16:27:58.729773+01	
586	4	2	2	55	60120SHJA00ZZ	\N			1	\N	\N	39	4	1	петля капота прав	hingle	13.85	13.390000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.734968+01	\N	2011-03-21 16:26:54.221945+01	2011-03-21 16:27:58.738059+01	
587	4	2	2	55	60170SHJA00ZZ	\N			1	\N	\N	39	4	1	петля капота лев	hingle	13.85	13.390000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.742748+01	\N	2011-03-21 16:26:54.226809+01	2011-03-21 16:27:58.745812+01	
588	4	2	2	55	60400STKA00ZZ	\N			1	\N	\N	39	4	1	рамка крепления радиаторов	mounting panel	381.10000000000002	368.36000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.75092+01	\N	2011-03-21 16:26:54.232835+01	2011-03-21 16:27:58.754025+01	
589	4	2	2	55	75120STKA01	\N			1	\N	\N	39	4	1	молдинг капота	molding	50.670000000000002	48.979999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.758719+01	\N	2011-03-21 16:26:54.238376+01	2011-03-21 16:27:58.761802+01	
590	4	2	2	55	74111STKA00	\N			1	\N	\N	39	4	1	защита приводных ремней	cover	46.729999999999997	45.170000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.766417+01	\N	2011-03-21 16:26:54.243901+01	2011-03-21 16:27:58.769541+01	
591	4	2	2	55	75100STXA01ZD	\N			1	\N	\N	5	11	1	решётка радиатора	grille	185.80000000000001	179.59	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.774423+01	\N	2011-03-21 16:26:54.251587+01	2011-03-21 16:27:58.77752+01	
593	4	2	2	55	60120STXA00ZZ	\N			1	\N	\N	5	11	1	петля капота прав	hingle	18.600000000000001	17.98	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.789945+01	\N	2011-03-21 16:26:54.263001+01	2011-03-21 16:27:58.79332+01	
595	4	2	2	55	60170STXA00ZZ	\N			1	\N	\N	5	11	1	петля капота лев	hingle	18.600000000000001	17.98	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.797954+01	\N	2011-03-21 16:26:54.274826+01	2011-03-21 16:27:58.801265+01	
596	4	2	2	55	71145STXA00	\N			2	\N	\N	5	11	1	крепление бампера верхнее левое	bracket	16.57	16.02	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.805756+01	\N	2011-03-21 16:26:54.280943+01	2011-03-21 16:27:58.808891+01	
597	4	2	2	55	60400STXA01ZZ	\N			1	\N	\N	5	11	1	телевизор	mounting panel	400.56999999999999	387.18000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.813747+01	\N	2011-03-21 16:26:54.286703+01	2011-03-21 16:27:58.816715+01	
598	4	2	2	55	17230RYEA00	\N			2	\N	\N	5	11	1	резонатор возд фильтра	air resonator	48.219999999999999	46.609999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.82158+01	\N	2011-03-21 16:26:54.292865+01	2011-03-21 16:27:58.824699+01	
599	4	2	2	55	67050STXA90ZZ	\N			1	\N	\N	5	11	1	дверь левая передняя	door	920.63	828.48000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.829978+01	\N	2011-03-21 16:26:54.298907+01	2011-03-21 16:27:58.833098+01	
601	4	2	2	55	44306STXA02	\N			1	\N	\N	5	11	1	ШРУС лев передний	cv joint	475.75	459.85000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.846627+01	\N	2011-03-21 16:26:54.310924+01	2011-03-21 16:27:58.849842+01	
602	4	2	2	55	51320S0XC01	\N			1	\N	\N	5	11	1	стойка стабилизатора левая передняя	link	19.079999999999998	18.440000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.854957+01	\N	2011-03-21 16:26:54.315421+01	2011-03-21 16:27:58.857968+01	
603	4	2	2	55	51606STXA03	\N			1	\N	\N	5	11	1	амортизатор левый передний	shock	173.40000000000001	167.59999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.863621+01	\N	2011-03-21 16:26:54.320443+01	2011-03-21 16:27:58.866924+01	
604	4	2	2	55	53560STXA02	\N			1	\N	\N	5	11	1	наконечник левый	tiee rod end outer	31.280000000000001	30.23	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.87237+01	\N	2011-03-21 16:26:54.32528+01	2011-03-21 16:27:58.875806+01	
605	4	13	13	55	74591TK6A00	\N			1	\N	\N	4	8	1	защита	Splash shield Left	27.18	23.91	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.880978+01	\N	2011-03-21 16:26:54.330878+01	2011-03-21 16:27:58.884273+01	
606	4	2	2	55	60100STXA91ZZ	\N			1	\N	\N	5	11	1	капот	hood	956.98000000000002	861.20000000000005	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.889473+01	\N	2011-03-21 16:26:54.335537+01	2011-03-21 16:27:58.892869+01	
608	4	2	2	55	60711STXA00ZZ	\N			2	\N	\N	5	11	1	лонжерон боковой внутреннний лев	reinforsment	34.200000000000003	33.060000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.906301+01	\N	2011-03-21 16:26:54.345272+01	2011-03-21 16:27:58.909744+01	
609	4	2	2	55	60757STXA00ZZ	\N			2	\N	\N	5	11	1	перемычка к чашке аммортизатора	reinforsment	14.050000000000001	13.58	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.914323+01	\N	2011-03-21 16:26:54.35072+01	2011-03-21 16:27:58.917159+01	
610	4	2	2	55	50200STXA02	\N			1	\N	\N	5	11	1	подрамник	subframe	972.91999999999996	875.53999999999996	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.922353+01	\N	2011-03-21 16:26:54.355725+01	2011-03-21 16:27:58.925782+01	
611	4	2	2	55	04609STXA00ZZ	\N			1	\N	\N	5	11	1	перемычка к лонжерону внутр. лев	reinforsment	53.979999999999997	52.18	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.930792+01	\N	2011-03-21 16:26:54.360447+01	2011-03-21 16:27:58.933914+01	
612	4	2	2	55	50830STXA02	\N			1	\N	\N	5	11	1	подушка двигателя гидравлическая	engine mount	138.12	133.5	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.939113+01	\N	2011-03-21 16:26:54.365465+01	2011-03-21 16:27:58.942123+01	
613	4	2	2	55	74111STXA01	\N			1	\N	\N	5	11	1	защита под бампер	cover	25.850000000000001	24.989999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.946857+01	\N	2011-03-21 16:26:54.370723+01	2011-03-21 16:27:58.950181+01	
614	4	2	2	55	38513SC4672	\N			1	\N	\N	5	11	1	крышка бачка омывателя	cap	2.6299999999999999	2.54	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.955511+01	\N	2011-03-21 16:26:54.375748+01	2011-03-21 16:27:58.95886+01	
615	4	2	2	55	44300STXA01	\N			1	\N	\N	5	11	1	ступица передняя	hub	93.700000000000003	90.569999999999993	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.964429+01	\N	2011-03-21 16:26:54.380943+01	2011-03-21 16:27:58.967721+01	
616	4	13	13	55	71507TK6A01ZE	\N			1	\N	\N	4	8	1	спойлер	Spoiler	51.5	45.32	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.972757+01	\N	2011-03-21 16:26:54.38597+01	2011-03-21 16:27:58.976008+01	
618	4	2	2	55	01464STXA00	\N			1	\N	\N	5	11	1	шланг тормозной передний	brake hose	41.399999999999999	40.020000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.989271+01	\N	2011-03-21 16:26:54.396687+01	2011-03-21 16:27:58.992663+01	
619	4	2	2	55	57455STXA01	\N			1	\N	\N	5	11	1	датчик АБС передний левый	wheel sensor	33.329999999999998	32.219999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.99763+01	\N	2011-03-21 16:26:54.401964+01	2011-03-21 16:27:59.001223+01	
620	4	13	13	55	33150TK6A11	\N			1	\N	\N	4	8	1	фара 	Headlamp assy	300.39999999999998	264.35000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:59.006088+01	\N	2011-03-21 16:26:54.40696+01	2011-03-21 16:27:59.009145+01	
621	4	11	11	55	9T4Z5019A 	\N			1	\N	\N	33	7	1	усилитель передний	front member	142.83000000000001	134.88	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:59.01423+01	\N	2011-03-21 16:26:54.413916+01	2011-03-21 16:27:59.017078+01	
622	4	2	2	55	71140STKA00	\N			1	\N	\N	39	4	1	крепление бампера верх прав	bracket	13.720000000000001	13.26	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:59.022382+01	\N	2011-03-21 16:26:54.419142+01	2011-03-21 16:27:59.025622+01	
594	5	62	85	56	1S4976	\N	AIRTEX / WELLS 	AIRTEX / WELLS 	1	\N	\N	7	11	1	датчик заднего хода	Back Up Lamp Switch	15.550000000000001	34.109999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:28:17.069062+01	\N	2011-03-21 16:26:54.268885+01	2011-03-21 16:28:17.072628+01	
582	4	47	47	55	6503221				7	\N	\N	50	1	2	пистон 	pin	1.5	2	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.702859+01		2011-03-21 16:20:49.863297+01	2011-03-21 16:33:11.948665+01	#
581	4	47	47	55	XD14XXXAC	\N			1	\N	\N	50	1	2	юбка бампера	air dam	130	138	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.693419+01	\N	2011-03-21 16:20:49.793197+01	2011-03-21 16:27:58.697115+01	
584	4	2	2	55	71198STKA01	\N			1	\N	\N	39	4	1	крепление бампера бок лев	bracket	1.9299999999999999	1.8700000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.718757+01	\N	2011-03-21 16:26:54.211847+01	2011-03-21 16:27:58.721766+01	
592	4	2	2	55	71125STXA00	\N			1	\N	\N	5	11	1	пластик замка	cover	31.129999999999999	30.09	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.782297+01	\N	2011-03-21 16:26:54.257132+01	2011-03-21 16:27:58.785303+01	
600	4	2	2	55	51215STXA02	\N			1	\N	\N	5	11	1	кулак передний левый	knuckle	133.58000000000001	129.11000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.838572+01	\N	2011-03-21 16:26:54.304817+01	2011-03-21 16:27:58.841798+01	
607	4	2	2	55	60713STXA01ZZ	\N			2	\N	\N	5	11	1	лонжерон боковой наружный лев	reinforsment	69.469999999999999	67.150000000000006	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.898015+01	\N	2011-03-21 16:26:54.340195+01	2011-03-21 16:27:58.901321+01	
617	4	2	2	55	45255STXA00	\N			1	\N	\N	5	11	1	защита диска тормозного	cover	16.600000000000001	16.050000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:58.981076+01	\N	2011-03-21 16:26:54.391219+01	2011-03-21 16:27:58.984277+01	
623	4	2	2	55	71190STKA00	\N			1	\N	\N	39	4	1	крепление бампера верх лев	bracket	13.720000000000001	13.26	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:59.030577+01	\N	2011-03-21 16:26:54.424398+01	2011-03-21 16:27:59.033563+01	
624	4	2	2	55	71193STKA01	\N			1	\N	\N	39	4	1	крепление бампера бок прав	bracket	1.9299999999999999	1.8700000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:27:59.038293+01	\N	2011-03-21 16:26:54.430249+01	2011-03-21 16:27:59.041628+01	
625	4	47	47	57	5019447AA	\N			6	\N	\N	4	9	1	вкладыш	BEARING CONNECTING R	8.1999999999999993	7.54	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:35:29.588275+01	\N	2011-03-21 16:35:23.215992+01	2011-03-21 16:35:29.592883+01	
626	4	23	23	58	000018BP01	\N			40	\N	\N	3	8	1	свеча зажигания	spark plug	4.0300000000000002	3.2999999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:40:46.887162+01	\N	2011-03-21 16:38:58.996837+01	2011-03-21 16:40:46.890921+01	
627	4	11	11	58	XS4Z7A098AC	\N			2	\N	\N	3	8	1	фильтр АКПП	filter kit	28.620000000000001	23.469999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:40:46.921204+01	\N	2011-03-21 16:38:59.003135+01	2011-03-21 16:40:46.924433+01	
628	4	23	23	58	GK2H2615XA	\N			1	\N	\N	3	8	1	ступица	hub	62.43	51.200000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-21 16:40:46.934817+01	\N	2011-03-21 16:38:59.007649+01	2011-03-21 16:40:46.937988+01	
629	4	26	26	59	54050CK000	\N			1	\N	\N	52	1	2	пыльник амортизатора	Strut bumper	17.579999999999998	19	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:00:32.648787+01	\N	2011-03-21 17:00:24.700844+01	2011-03-21 17:00:32.652341+01	
631	4	11	11	60	XR3Z8A224AB				1	\N	\N	53	1	2	эмблема	Medallion	22.07	25	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:42:39.469403+01		2011-03-21 17:23:00.0445+01	2011-03-21 17:42:39.475591+01	#
647	7	48	59	62	280571451132	\N	RDX	RDX	1	\N	\N	5	12	1	фара противотуманная	foglight	78.959999999999994	102.65000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:53:57.339733+01	\N	2011-03-21 17:53:50.628217+01	2011-03-21 17:53:57.343337+01	
648	7	48	59	62	120678399271	\N	RDX	RDX	2	\N	\N	5	12	1	ключ	key	42.590000000000003	58.960000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:53:57.348836+01	\N	2011-03-21 17:53:50.634913+01	2011-03-21 17:53:57.352067+01	
633	4	13	13	60	53685TA0A01	\N			2	\N	\N	55	1	2	сайлентблок	Bushing	9.75	7.5	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:42:39.362274+01	\N	2011-03-21 17:23:00.057086+01	2011-03-21 17:42:39.368998+01	
634	4	12	7	60	10411526	\N			1	\N	\N	56	1	2	уплотнитель 	weatherstrip	20.359999999999999	25	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:42:39.378125+01	\N	2011-03-21 17:23:00.065481+01	2011-03-21 17:42:39.384031+01	
635	4	12	7	60	10335588	\N			1	\N	\N	56	1	2	трансмиттер	transmitter	71.930000000000007	76	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:42:39.39251+01	\N	2011-03-21 17:23:00.069988+01	2011-03-21 17:42:39.398603+01	
636	4	13	13	60	28650RAY004	\N			1	\N	\N	57	1	2	датчик	sensor	69.700000000000003	69.700000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:42:39.407897+01	\N	2011-03-21 17:23:00.075493+01	2011-03-21 17:42:39.414195+01	
637	4	13	13	60	80290S0XA01	\N			1	\N	\N	57	1	2	фильтр салона	Cabin air filter	27.670000000000002	27.670000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:42:39.423118+01	\N	2011-03-21 17:23:00.079948+01	2011-03-21 17:42:39.429259+01	
638	4	23	23	60	C23551731A	\N			1	\N	\N	19	2	2	эмблема решетки	Emblem	20.949999999999999	20.949999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:42:39.438781+01	\N	2011-03-21 17:23:00.086173+01	2011-03-21 17:42:39.445031+01	
632	4	11	11	60	F4ZZ16916A				1	\N	\N	54	1	2	трос капота	Release cable	34.479999999999997	37	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:42:39.454493+01		2011-03-21 17:23:00.050001+01	2011-03-21 17:42:39.460707+01	#
630	4	11	11	60	F89Z4676AA				1	\N	\N	53	1	2	сальник	seal	17	18	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:42:39.484501+01		2011-03-21 17:23:00.036789+01	2011-03-21 17:42:39.490392+01	#
639	4	2	2	60	08P21STX2M004	\N			1	\N	\N	4	10	1	расширитель	FENDER GARNISH, L.	65.329999999999998	57.490000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:42:39.499378+01	\N	2011-03-21 17:42:09.260327+01	2011-03-21 17:42:39.505808+01	
640	4	23	23	60	GK2A34156	\N			10	\N	\N	3	9	1	втулка стабилизатора	bushing	2.0699999999999998	1.7	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:42:39.515818+01	\N	2011-03-21 17:42:09.272078+01	2011-03-21 17:42:39.522028+01	
641	4	23	23	60	GK2A28156A	\N			10	\N	\N	3	9	1	втулка стабилизатора	bushing	1.45	1.1899999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:42:39.5309+01	\N	2011-03-21 17:42:09.277853+01	2011-03-21 17:42:39.537076+01	
642	4	23	23	60	EC0143980D	\N			4	\N	\N	3	9	1	шланг тормозной	brake hose	14.65	12.01	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:42:39.54594+01	\N	2011-03-21 17:42:09.282392+01	2011-03-21 17:42:39.552037+01	
643	4	35	35	61	04152YZZA1	\N			2	\N	\N	6	4	1	фильтр маслянный	oil filter	5.4100000000000001	4.5999999999999996	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:48:28.035518+01	\N	2011-03-21 17:47:37.324482+01	2011-03-21 17:48:28.039262+01	
644	4	33	33	61	22401AA670	\N			4	\N	\N	6	4	1	свеча зажигания	spark plug	15.949999999999999	13.550000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:48:28.045112+01	\N	2011-03-21 17:47:37.331617+01	2011-03-21 17:48:28.048067+01	
645	4	33	33	61	84201XA00A	\N			1	\N	\N	4	11	1	Фонарь	Tail lamp assy	169.94999999999999	149.56	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:48:28.052877+01	\N	2011-03-21 17:47:37.33803+01	2011-03-21 17:48:28.056016+01	
646	4	33	33	61	91112XA09CNN	\N			1	\N	\N	4	11	1	Молдинг	Finish molding	47.850000000000001	42.109999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-21 17:48:28.061476+01	\N	2011-03-21 17:47:37.342676+01	2011-03-21 17:48:28.064313+01	
650	7	48	59	63	130473760312 	\N			1	\N	\N	58	1	2	накладки на педали	cover pedal	44.990000000000002	63	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:00:46.504299+01	\N	2011-03-21 17:59:18.289694+01	2011-03-21 18:00:46.508041+01	
651	5	62	69	64	3284	\N	TYC	TYC	1	\N	\N	27	3	2	радиатор кондиционера	condenser	89.090000000000003	108	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:02:11.733234+01	\N	2011-03-21 18:02:01.929827+01	2011-03-21 18:02:11.736675+01	
652	4	13	13	65	52210SNHA00	\N			1	\N	\N	4	12	1	Кулак поворотный	Knuckle	143.80000000000001	126.54000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:12:21.020899+01	\N	2011-03-21 18:05:13.133681+01	2011-03-21 18:12:21.024887+01	
653	4	13	13	65	44310TA0A50	\N			1	\N	\N	10	3	2	ШРУС внутренний	JOINT	110.33	110.33	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:12:21.031131+01	\N	2011-03-21 18:08:14.433261+01	2011-03-21 18:12:21.034023+01	
654	4	13	13	65	71121TK6A01	\N			1	\N	\N	59	1	2	решетка радиатора	Grille	67.620000000000005	67.620000000000005	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:12:21.040764+01	\N	2011-03-21 18:08:14.469713+01	2011-03-21 18:12:21.044349+01	
655	4	13	13	65	75700TF0000	\N			1	\N	\N	59	1	2	эмблема	Emblem	17.719999999999999	17.719999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:12:21.049835+01	\N	2011-03-21 18:08:14.474397+01	2011-03-21 18:12:21.053508+01	
656	4	13	13	65	04602TK6A00ZZ	\N			1	\N	\N	59	1	2	планка верхняя телевизора	Upper tie bar	102.98	102.98	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:12:21.058773+01	\N	2011-03-21 18:08:14.479327+01	2011-03-21 18:12:21.062152+01	
657	4	13	13	65	38615RB0003	\N			1	\N	\N	59	1	2	диффузор вентилятора кондиционера	shroud	54.82	54.82	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:12:21.067354+01	\N	2011-03-21 18:08:14.48567+01	2011-03-21 18:12:21.070724+01	
658	4	13	13	65	75490TK6A00	\N			1	\N	\N	59	1	2	заглушка крыла правая	Corner molding Right	31.5	31.5	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:12:21.075997+01	\N	2011-03-21 18:08:14.492248+01	2011-03-21 18:12:21.079469+01	
659	4	13	13	65	84652TF0003ZA	\N			1	\N	\N	59	1	2	лючок стопа левый	cover	8.0700000000000003	8.0700000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:12:21.08492+01	\N	2011-03-21 18:08:14.496941+01	2011-03-21 18:12:21.088263+01	
660	4	35	35	65	8521406130 	\N			1	\N	\N	27	4	1	Резинка стеклоочисти	blade insert	3.7799999999999998	4.3799999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:12:21.093467+01	\N	2011-03-21 18:11:52.895879+01	2011-03-21 18:12:21.096916+01	
661	4	35	35	65	8521468020 	\N			1	\N	\N	27	4	1	Резинка стеклоочисти	blade insert	4.4500000000000002	5.1799999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:12:21.102312+01	\N	2011-03-21 18:11:52.903456+01	2011-03-21 18:12:21.105547+01	
662	4	13	13	65	76730SFA003 	\N			1	\N	\N	27	4	1	Щетка дворника	wiper blade	11.33	12.92	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:12:21.110879+01	\N	2011-03-21 18:11:52.907763+01	2011-03-21 18:12:21.114443+01	
663	4	13	13	65	76720SWA003 	\N			1	\N	\N	27	4	1	Поводок стеклоочистителя заднего	arm wiper blade	15.359999999999999	17.52	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:12:21.119874+01	\N	2011-03-21 18:11:52.912629+01	2011-03-21 18:12:21.12327+01	
664	4	23	23	66	C24328156D	\N			4	\N	\N	3	10	1	втулка стабилизатора	bushing	6.8399999999999999	5.6100000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.398344+01	\N	2011-03-21 18:19:03.52612+01	2011-03-21 18:21:12.401836+01	
665	4	2	2	66	74556STXA00	\N			1	\N	\N	4	13	1	Подкрылок	Wheelhouse liner	43.369999999999997	38.159999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.407472+01	\N	2011-03-21 18:19:03.549677+01	2011-03-21 18:21:12.410457+01	
666	4	2	2	66	71597STXA00	\N			1	\N	\N	4	13	1	Кронштейн	Upper spacer	3.8999999999999999	3.4300000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.415151+01	\N	2011-03-21 18:19:03.554636+01	2011-03-21 18:21:12.41808+01	
667	4	2	2	66	71593STXA00	\N			2	\N	\N	4	13	1	Кронштейн	Spacer	3.73	3.02	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.422689+01	\N	2011-03-21 18:19:03.569562+01	2011-03-21 18:21:12.425593+01	
668	4	2	2	66	71125STXA00	\N			1	\N	\N	4	13	1	Накладка	Sight shield	31.129999999999999	27.390000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.430161+01	\N	2011-03-21 18:19:03.576208+01	2011-03-21 18:21:12.43311+01	
669	4	2	2	66	33551STXA01	\N			1	\N	\N	4	13	1	Фонарь	Tail lamp assy	163.28	143.68000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.437916+01	\N	2011-03-21 18:19:03.584461+01	2011-03-21 18:21:12.440892+01	
670	4	2	2	66	34156STXA01	\N			1	\N	\N	4	13	1	Фонарь	Backup lamp	59	51.920000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.445958+01	\N	2011-03-21 18:19:03.590683+01	2011-03-21 18:21:12.448962+01	
671	4	23	23	66	EC0143980D	\N			6	\N	\N	3	10	1	шланг тормозной	brake hose	14.65	12.01	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.453767+01	\N	2011-03-21 18:19:03.599495+01	2011-03-21 18:21:12.456864+01	
672	4	23	23	66	GK2H2615XA	\N			2	\N	\N	3	10	1	ступица	hub	62.93	51.609999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.46162+01	\N	2011-03-21 18:19:03.611595+01	2011-03-21 18:21:12.464721+01	
673	4	23	23	66	AJ0311SG0	\N			1	\N	\N	3	10	1	вкладыш	engine bearing	45.630000000000003	37.420000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.46975+01	\N	2011-03-21 18:19:03.616376+01	2011-03-21 18:21:12.472628+01	
674	4	23	23	66	AJ0310155	\N			24	\N	\N	3	10	1	колпачки маслосъёмные	valve seals	2.4700000000000002	2.0299999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.477228+01	\N	2011-03-21 18:19:03.621021+01	2011-03-21 18:21:12.480118+01	
675	4	23	23	66	GS3L43990A	\N			1	\N	\N	4	13	1	шланг тормозной	Brake hose	48.789999999999999	42.93	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.484626+01	\N	2011-03-21 18:19:03.625712+01	2011-03-21 18:21:12.487593+01	
676	4	23	23	66	GS3L34350B	\N			1	\N	\N	4	13	1	рычаг	Lower control arm	203.86000000000001	179.38999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.49218+01	\N	2011-03-21 18:19:03.630066+01	2011-03-21 18:21:12.495169+01	
677	4	23	23	66	GS3L33047	\N			1	\N	\N	4	13	1	подшипник	Front wheel bearing	72.549999999999997	63.840000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.499524+01	\N	2011-03-21 18:19:03.634473+01	2011-03-21 18:21:12.50245+01	
678	4	35	35	66	8156135280	\N			1	\N	\N	4	13	1	Фонарь	Tail lamp Left	215.43000000000001	189.56999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:12.507117+01	\N	2011-03-21 18:19:03.639104+01	2011-03-21 18:21:12.510134+01	
679	5	61	60	67	H0856	\N	civic 2009 sedan	civic 2009 sedan	1	\N	\N	15	6	2	решетка	grille	52	84	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:21:28.167245+01	\N	2011-03-21 18:21:20.007497+01	2011-03-21 18:21:28.172088+01	
680	4	47	9	68	4797316	\N			1	\N	\N	7	12	1	шестерня	sprocket	11.85	10	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:26:52.645969+01	\N	2011-03-21 18:26:43.717669+01	2011-03-21 18:26:52.649505+01	
681	4	2	2	69	21813P5H000	\N			1	\N	\N	61	1	2	прокладка поддона АКПП	gasket	13.85	14	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:27:09.387467+01	\N	2011-03-21 18:27:00.668169+01	2011-03-21 18:27:09.390977+01	
682	4	2	2	69	52315SZ3E01	\N			2	\N	\N	61	1	2	втулка заднего стаб-ра	bushing	5.2699999999999996	3	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:27:09.402979+01	\N	2011-03-21 18:27:00.673804+01	2011-03-21 18:27:09.405997+01	
683	4	47	47	69	5074615AF	\N			1	\N	\N	60	1	2	усилитель 	bar upper	113	142	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:27:09.411336+01	\N	2011-03-21 18:27:00.679187+01	2011-03-21 18:27:09.414334+01	
684	4	47	47	69	5273372AE	\N			1	\N	\N	60	1	2	стакан щупа акпп	pipe	7.25	8	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:27:09.419125+01	\N	2011-03-21 18:27:00.68382+01	2011-03-21 18:27:09.422153+01	
685	4	47	47	69	4891715AB	\N			2	\N	\N	60	1	2	крышка декоративная	cover engine	40.75	21.5	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:27:09.42709+01	\N	2011-03-21 18:27:00.688112+01	2011-03-21 18:27:09.430063+01	
686	4	47	47	69	5105489AG	\N			2	\N	\N	60	1	2	подушка правая 	mount right	80.75	56	\N	\N	\N	\N	\N	in_processing	2011-03-21 18:27:09.434688+01	\N	2011-03-21 18:27:00.692827+01	2011-03-21 18:27:09.437674+01	
687	5	62	83	70	58615	\N	wix	wix	1	\N	\N	61	2	2	фильтр АКПП	filter trans	22.16	35	\N	\N	\N	\N	\N	in_processing	2011-03-21 19:10:26.709569+01	\N	2011-03-21 18:38:37.998588+01	2011-03-21 19:10:26.714916+01	
688	5	62	86	70	1S6539	\N	airtex	airtex	1	\N	\N	61	2	2	датчик давления масла ДВС	switch	6.25	10	\N	\N	\N	\N	\N	in_processing	2011-03-21 19:10:26.723382+01	\N	2011-03-21 18:38:38.007203+01	2011-03-21 19:10:26.72836+01	
689	5	62	77	70	664149	\N	cardone	cardone	1	\N	\N	61	2	2	полуось правая	drivershaft	58.380000000000003	98	\N	\N	\N	\N	\N	in_processing	2011-03-21 19:10:26.735638+01	\N	2011-03-21 18:38:38.013175+01	2011-03-21 19:10:26.740639+01	
690	5	62	58	70	520163	\N	dorman	dorman	1	\N	\N	62	1	2	рычаг левый передний	arm	74.269999999999996	130	\N	\N	\N	\N	\N	in_processing	2011-03-21 19:10:26.748144+01	\N	2011-03-21 18:38:38.018842+01	2011-03-21 19:10:26.753011+01	
691	5	62	87	70	HO1210127	\N	various	various	1	\N	\N	15	7	2	хром решетки радиатора	grille	74.180000000000007	120	\N	\N	\N	\N	\N	in_processing	2011-03-21 19:10:26.760496+01	\N	2011-03-21 18:38:38.025014+01	2011-03-21 19:10:26.765373+01	
693	5	62	64	70	2938	\N	anchor	anchor	2	\N	\N	7	13	1	подушка двигателя 	Motor Mount	22.789999999999999	35.93	\N	\N	\N	\N	\N	in_processing	2011-03-21 19:10:26.784642+01	\N	2011-03-21 19:10:06.044657+01	2011-03-21 19:10:26.78979+01	
692	5	62	58	70	C660256		dorman	dorman	3	\N	\N	7	13	1	трос ручника	Parking Brake Cable	18.239999999999998	28.329999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-21 19:10:26.77272+01		2011-03-21 19:10:06.035248+01	2011-03-25 12:07:36.376828+01	#
711	7	48	59	71	280562136176	\N			1	\N	\N	61	3	2	накладка руля	cover 	103.90000000000001	145	\N	\N	\N	\N	\N	in_processing	2011-03-25 12:43:26.345034+01	\N	2011-03-25 12:43:06.555797+01	2011-03-25 12:43:26.351762+01	
712	4	47	47	72	5066524AA	\N	0	0	1	\N	\N	63	1	2	трубка задней печки	tube heater	119	126	\N	\N	\N	\N	\N	in_processing	2011-03-25 12:44:52.386729+01	\N	2011-03-25 12:44:38.500402+01	2011-03-25 12:44:52.391776+01	
713	4	13	13	72	71140TK6A00	\N	0	0	1	\N	\N	64	1	2	держатель бампера	bracket	21.23	21.23	\N	\N	\N	\N	\N	in_processing	2011-03-25 12:44:52.402139+01	\N	2011-03-25 12:44:38.518287+01	2011-03-25 12:44:52.406298+01	
715	5	61	60	73	P7812	\N			1	\N	\N	62	2	2	подкрылок правый	fender liner	17	31	\N	\N	\N	\N	\N	in_processing	2011-03-25 12:46:06.673605+01	\N	2011-03-25 12:45:34.004976+01	2011-03-25 12:46:06.68015+01	
716	5	61	60	73	T0100	\N			1	\N	\N	59	2	2	бампер передний	bumper	84	182	\N	\N	\N	\N	\N	in_processing	2011-03-25 12:46:06.648104+01	\N	2011-03-25 12:45:34.011264+01	2011-03-25 12:46:06.653848+01	
714	5	61	60	73	P7813	\N			1	\N	\N	62	2	2	подкрылок левый	fender liner	17	31	\N	\N	\N	\N	\N	in_processing	2011-03-25 12:46:06.664958+01	\N	2011-03-25 12:45:33.992327+01	2011-03-25 12:46:06.669162+01	
726	4	47	9	74	YM13ABVAA	\N		7P	1	\N	\N	3	11	1	спойлер бампера	fascia	300	255	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:30.914822+01	\N	2011-03-25 14:06:36.528379+01	2011-03-25 14:10:30.919675+01	
727	4	2	2	74	33505STXA01	\N			1	\N	\N	4	14	1	рефлектор	Reflector Reflector Right	21.699999999999999	19.100000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:30.930591+01	\N	2011-03-25 14:06:36.536095+01	2011-03-25 14:10:30.937401+01	
728	4	23	23	74	GS3N501T1A	\N			1	\N	\N	4	14	1	решётка	MESH-FRONT BUMPER	39.689999999999998	34.93	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:30.941563+01	\N	2011-03-25 14:06:36.541263+01	2011-03-25 14:10:30.948624+01	
729	4	23	23	74	GS3L50C11C	\N			1	\N	\N	4	14	1	Заглушка	COVER R -LAMP	14.449999999999999	12.720000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:30.952503+01	\N	2011-03-25 14:06:36.545625+01	2011-03-25 14:10:30.959275+01	
730	4	23	23	74	GS3L50C21C	\N			1	\N	\N	4	14	1	Заглушка	COVER L -LAMP	14.449999999999999	12.720000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:30.962765+01	\N	2011-03-25 14:06:36.550185+01	2011-03-25 14:10:30.969224+01	
731	4	23	23	74	L51813Z40A	\N			1	\N	\N	4	14	1	Фильтр воздушный	ELEMENT-AIR CLEANER	21.82	19.199999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:30.974464+01	\N	2011-03-25 14:06:36.554552+01	2011-03-25 14:10:30.980873+01	
732	4	47	9	74	5085352AC	\N			1	\N	\N	60	2	2	амортизатор правый передний	strut right	88.700000000000003	67	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:30.984002+01	\N	2011-03-25 14:09:04.380355+01	2011-03-25 14:10:30.99077+01	
733	4	47	9	74	5085353AC	\N			1	\N	\N	60	2	2	амортиазатор левый передний	strut left	88.700000000000003	67	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:30.994859+01	\N	2011-03-25 14:09:04.395609+01	2011-03-25 14:10:31.001368+01	
734	4	47	9	74	5085408AC	\N			1	\N	\N	60	2	2	рычаг правый нижний	arm right	118	179	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.00445+01	\N	2011-03-25 14:09:04.400997+01	2011-03-25 14:10:31.011051+01	
735	4	23	23	74	L3K912201A	\N			1	\N	\N	3	12	1	цепь грм	timing chain	39.759999999999998	32.609999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.015834+01	\N	2011-03-25 14:10:08.352157+01	2011-03-25 14:10:31.022221+01	
736	4	23	23	74	GD7A34156	\N			2	\N	\N	3	12	1	втулка стабилизатора	bushing	6.2999999999999998	5.1699999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.025562+01	\N	2011-03-25 14:10:08.359406+01	2011-03-25 14:10:31.03209+01	
737	4	23	23	74	GS3L515E0B	\N			1	\N	\N	4	15	1	рефлектор	LAMP RT- TURN	8.2200000000000006	7.2300000000000004	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.037845+01	\N	2011-03-25 14:10:08.365454+01	2011-03-25 14:10:31.044716+01	
738	4	23	23	74	GS3L515F0B	\N			1	\N	\N	4	15	1	рефлектор	LAMP LT- TURN	8.2200000000000006	7.2300000000000004	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.049394+01	\N	2011-03-25 14:10:08.370534+01	2011-03-25 14:10:31.056312+01	
739	4	23	23	74	BR5S51180C	\N			1	\N	\N	4	15	1	Фонарь левый	LENS ( BODY L -RR CO	195.16	171.74000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.062294+01	\N	2011-03-25 14:10:08.375221+01	2011-03-25 14:10:31.069446+01	
740	4	13	13	74	52300SNAA01	\N			1	\N	\N	4	15	1	задний стабилизатор	Stabilizer bar	34.920000000000002	30.719999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.075022+01	\N	2011-03-25 14:10:08.380081+01	2011-03-25 14:10:31.082013+01	
741	4	11	11	74	1L2Z7821453AAA	\N			1	\N	\N	4	15	1	молдинг	Belt w strip	44.170000000000002	38.859999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.087234+01	\N	2011-03-25 14:10:08.384985+01	2011-03-25 14:10:31.094041+01	
742	4	11	11	74	1L2Z7825597AAA	\N			1	\N	\N	4	15	1	молдинг	Belt w strip	42.219999999999999	37.149999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.097342+01	\N	2011-03-25 14:10:08.389857+01	2011-03-25 14:10:31.104419+01	
743	4	2	2	74	72147SEPA62	\N			1	\N	\N	6	5	1	иммобилайзер	transmitter	88.900000000000006	75.560000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.109143+01	\N	2011-03-25 14:10:08.396872+01	2011-03-25 14:10:31.116237+01	
744	4	2	2	74	35113SECA01	\N			1	\N	\N	6	5	1	ключ	key	43.549999999999997	37.009999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.121786+01	\N	2011-03-25 14:10:08.401595+01	2011-03-25 14:10:31.128785+01	
745	4	23	23	74	FS1H18861A	\N			1	\N	\N	3	12	1	датчик кислородный	oxygen sensor	148.93000000000001	122.13	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.132451+01	\N	2011-03-25 14:10:08.406476+01	2011-03-25 14:10:31.13819+01	
746	4	23	23	74	AC0127238	\N			2	\N	\N	3	12	1	сальник полуоси	oil seal	9.7599999999999998	8.0050000000000008	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.140651+01	\N	2011-03-25 14:10:08.412958+01	2011-03-25 14:10:31.146873+01	
747	4	23	23	74	FSY1203009U	\N			1	\N	\N	3	12	1	клапан ЕГР	EGR valve	188.53999999999999	154.61000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.150232+01	\N	2011-03-25 14:10:08.417681+01	2011-03-25 14:10:31.156513+01	
748	4	47	9	74	5066756AA	\N			2	\N	\N	3	12	1	сальник коленвала	oil seal	65.950000000000003	54.079999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.159717+01	\N	2011-03-25 14:10:08.422506+01	2011-03-25 14:10:31.166025+01	
749	4	23	23	74	EC0244150C	\N			1	\N	\N	3	12	1	трос ручника	parking brake	46.990000000000002	38.539999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.169356+01	\N	2011-03-25 14:10:08.427432+01	2011-03-25 14:10:31.175617+01	
750	4	23	23	74	EC0344410A	\N			1	\N	\N	3	12	1	трос ручника	parking brake	69.25	56.789999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.178665+01	\N	2011-03-25 14:10:08.432327+01	2011-03-25 14:10:31.185044+01	
751	4	23	23	74	GD5522530A	\N			1	\N	\N	3	12	1	пыльник ШРУС наружный	outer boot	64.439999999999998	52.850000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.188424+01	\N	2011-03-25 14:10:08.437127+01	2011-03-25 14:10:31.193215+01	
752	4	14	14	74	924010W500	\N			1	\N	\N	3	12	1	фонарь задний левый	tail lamps	167.31999999999999	142.22999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.195816+01	\N	2011-03-25 14:10:08.442314+01	2011-03-25 14:10:31.200132+01	
753	4	23	23	74	LFH115940A	\N			1	\N	\N	3	12	1	ролик обводной	idler pulley	53.490000000000002	43.869999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.202574+01	\N	2011-03-25 14:10:08.447181+01	2011-03-25 14:10:31.206801+01	
754	4	23	23	74	C24328156D	\N			4	\N	\N	3	12	1	втулка стабилизатора	bushing	6.8399999999999999	5.6100000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.209151+01	\N	2011-03-25 14:10:08.452464+01	2011-03-25 14:10:31.21338+01	
755	4	11	11	74	8G1Z4N046A	\N			1	\N	\N	3	12	1	сальник полуоси	oil seal	17.079999999999998	14.01	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:10:31.215835+01	\N	2011-03-25 14:10:08.457154+01	2011-03-25 14:10:31.220129+01	
756	4	47	47	75	4806104AD	\N			1	\N	\N	68	1	2	юбка бампера	shield	69.099999999999994	73	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:37.958687+01	\N	2011-03-25 14:26:18.986587+01	2011-03-25 14:26:37.962735+01	
757	4	13	13	75	74207TA0A00	\N			1	\N	\N	65	1	2	пластик по крылу лев	built Left	5.6500000000000004	6	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:37.965039+01	\N	2011-03-25 14:26:19.002917+01	2011-03-25 14:26:37.969101+01	
759	4	2	2	75	71193SEA003	\N			1	\N	\N	10	4	2	крепление	spacer	8.9299999999999997	8.9299999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:37.97936+01	\N	2011-03-25 14:26:19.018243+01	2011-03-25 14:26:37.983962+01	
760	4	2	2	75	71198SEA003	\N			1	\N	\N	10	4	2	крепление	spacer	8.9299999999999997	8.9299999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:37.996264+01	\N	2011-03-25 14:26:19.025335+01	2011-03-25 14:26:38.002096+01	
761	4	2	2	75	9390325320	\N			6	\N	\N	10	4	2	шуруп	screw	0.46999999999999997	0.078333333333300004	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.005541+01	\N	2011-03-25 14:26:19.032158+01	2011-03-25 14:26:38.012428+01	
762	4	2	2	75	71140SEA000	\N			1	\N	\N	10	4	2	держатель правый	bracket Right	27.879999999999999	27.879999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.016151+01	\N	2011-03-25 14:26:19.039039+01	2011-03-25 14:26:38.023088+01	
763	4	2	2	75	71190SEA000	\N			1	\N	\N	10	4	2	деожатель левый	bracket Left	27.879999999999999	27.879999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.026644+01	\N	2011-03-25 14:26:19.046131+01	2011-03-25 14:26:38.033565+01	
764	4	2	2	75	90682SB0003	\N			2	\N	\N	10	4	2	зажим	grommet	0.22	0.11	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.037389+01	\N	2011-03-25 14:26:19.052809+01	2011-03-25 14:26:38.044304+01	
765	4	2	2	75	9390345380	\N			2	\N	\N	10	4	2	шуруп	screw	0.46999999999999997	0.23499999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.047823+01	\N	2011-03-25 14:26:19.061619+01	2011-03-25 14:26:38.054752+01	
766	4	2	2	75	91506S9A003	\N			2	\N	\N	10	4	2	пистон	 clip	2.1200000000000001	1.0600000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.059889+01	\N	2011-03-25 14:26:19.068414+01	2011-03-25 14:26:38.066801+01	
767	4	47	47	75	4692141AA	\N			5	\N	\N	68	1	2	реле	relay	4	1	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.07045+01	\N	2011-03-25 14:26:19.075278+01	2011-03-25 14:26:38.077492+01	
768	4	2	2	75	90682SB0003	\N			2	\N	\N	10	4	2	зажим	grommet	0.22	0.11	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:37.924628+01	\N	2011-03-25 14:26:19.082444+01	2011-03-25 14:26:37.92945+01	
769	4	2	2	75	934050601604	\N			10	\N	\N	10	4	2	болт	bolt	0.55000000000000004	0.055	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:37.932679+01	\N	2011-03-25 14:26:19.089362+01	2011-03-25 14:26:37.93665+01	
771	4	2	2	75	33105S5NC01	\N			2	\N	\N	10	4	2	гайка	nut	4.0300000000000002	2.0150000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:37.94559+01	\N	2011-03-25 14:26:19.103315+01	2011-03-25 14:26:37.94969+01	
772	4	2	2	75	74171S87A00	\N			1	\N	\N	10	4	2	крепление	bracket	6.1200000000000001	6.1200000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:37.952309+01	\N	2011-03-25 14:26:19.110219+01	2011-03-25 14:26:37.956375+01	
758	4	13	13	75	71123TA5A00	\N			1	\N	\N	65	1	2	пластик на замок капота	shield	20.719999999999999	22	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:37.972616+01	\N	2011-03-25 14:26:19.009838+01	2011-03-25 14:26:37.976782+01	
773	4	2	2	75	74171SECA00	\N			1	\N	\N	10	4	2	крепление	bracket Left	9.2200000000000006	9.2200000000000006	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.081087+01	\N	2011-03-25 14:26:19.117106+01	2011-03-25 14:26:38.087997+01	
774	4	2	2	75	71123SEA013	\N			1	\N	\N	10	4	2	накладка	upper cover	37.479999999999997	37.479999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.091533+01	\N	2011-03-25 14:26:19.124192+01	2011-03-25 14:26:38.098397+01	
775	4	2	2	75	91503SZ3003	\N			7	\N	\N	10	4	2	пистон	clip	3.0299999999999998	0.432857142857	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.101904+01	\N	2011-03-25 14:26:19.131081+01	2011-03-25 14:26:38.108902+01	
776	4	2	2	75	91512SX0003	\N			7	\N	\N	10	4	2	пистон	clip	1.3300000000000001	0.19	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.112407+01	\N	2011-03-25 14:26:19.138001+01	2011-03-25 14:26:38.119315+01	
777	4	2	2	75	74206SEA000	\N			1	\N	\N	10	4	2	накладка	trim right	23.649999999999999	23.649999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.122747+01	\N	2011-03-25 14:26:19.144804+01	2011-03-25 14:26:38.129667+01	
778	4	47	47	75	56021543	\N			1	\N	\N	68	1	2	реле	relay	5.7000000000000002	6	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.133099+01	\N	2011-03-25 14:26:19.151694+01	2011-03-25 14:26:38.140187+01	
779	4	2	2	75	74207SEA000	\N			1	\N	\N	10	4	2	накладка	trim left	23.649999999999999	23.649999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.143766+01	\N	2011-03-25 14:26:19.158702+01	2011-03-25 14:26:38.150801+01	
780	4	2	2	75	17255RBA010	\N			1	\N	\N	10	4	2	накладка	shield	10.050000000000001	10.050000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.15432+01	\N	2011-03-25 14:26:19.165529+01	2011-03-25 14:26:38.161421+01	
781	4	2	2	75	91505SL0003	\N			3	\N	\N	10	4	2	пистон	clip	3.6299999999999999	1.21	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.164824+01	\N	2011-03-25 14:26:19.172396+01	2011-03-25 14:26:38.17176+01	
782	4	2	2	75	76812S3N003	\N			1	\N	\N	10	4	2	шуруп	washer	10.130000000000001	10.130000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.175386+01	\N	2011-03-25 14:26:19.179976+01	2011-03-25 14:26:38.182556+01	
783	4	2	2	75	76820S6M003	\N			1	\N	\N	10	4	2	крепление	bracket	3.3799999999999999	3.3799999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.186174+01	\N	2011-03-25 14:26:19.187165+01	2011-03-25 14:26:38.191751+01	
784	4	2	2	75	934050601608	\N			1	\N	\N	10	4	2	болт	bolt	0.71999999999999997	0.71999999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.195492+01	\N	2011-03-25 14:26:19.192447+01	2011-03-25 14:26:38.20085+01	
785	4	2	2	75	77871SDAA90	\N			1	\N	\N	10	4	2	наклейка	label	4.2300000000000004	4.2300000000000004	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.203257+01	\N	2011-03-25 14:26:19.197198+01	2011-03-25 14:26:38.207263+01	
786	4	11	11	75	7A1Z17D957APTM	\N			1	\N	\N	33	8	2	бампер передний	bumper	487.48000000000002	487.48000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.209646+01	\N	2011-03-25 14:26:19.203509+01	2011-03-25 14:26:38.213844+01	
787	4	13	13	75	67450S0X305ZZ	\N			1	\N	\N	54	2	2	петля левой двери верхняя	hinge upper	21.32	23	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.216419+01	\N	2011-03-25 14:26:19.210158+01	2011-03-25 14:26:38.220699+01	
788	4	13	13	75	67410S0X305ZZ	\N			1	\N	\N	54	2	2	петля левой двери нижняя	hinge lower	22.32	23	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.22334+01	\N	2011-03-25 14:26:19.21586+01	2011-03-25 14:26:38.227958+01	
789	4	12	7	75	15066599	\N			1	\N	\N	67	1	2	значек задний	emblem	100.12	100	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.230476+01	\N	2011-03-25 14:26:19.221589+01	2011-03-25 14:26:38.234848+01	
790	4	47	9	75	5178410AB	\N			1	\N	\N	10	4	2	держатель	bracket	3.4500000000000002	4	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.237248+01	\N	2011-03-25 14:26:19.226655+01	2011-03-25 14:26:38.241953+01	
791	4	25	25	75	MR349655	\N			1	\N	\N	66	1	2	торсион багажника	torsion	17.699999999999999	19	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.244513+01	\N	2011-03-25 14:26:19.232318+01	2011-03-25 14:26:38.249136+01	
792	4	13	13	75	33150TA0A01	\N			1	\N	\N	65	1	2	фара левая	headlamp left	278.85000000000002	296	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.251683+01	\N	2011-03-25 14:26:19.237073+01	2011-03-25 14:26:38.257545+01	
793	4	13	13	75	60260TA0A90ZZ	\N			1	\N	\N	65	1	2	крыло левое	fender Left	264.10000000000002	280	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.260277+01	\N	2011-03-25 14:26:19.241653+01	2011-03-25 14:26:38.26478+01	
794	4	13	13	75	17201R40A00	\N			1	\N	\N	65	1	2	корпус фильтра нижн часть	lower housing	31.260000000000002	33	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.267304+01	\N	2011-03-25 14:26:19.2461+01	2011-03-25 14:26:38.271784+01	
795	4	13	13	75	71126TA5A00	\N			1	\N	\N	65	1	2	решетка рад	grille	129.68000000000001	137	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:26:38.274865+01	\N	2011-03-25 14:26:19.250802+01	2011-03-25 14:26:38.279384+01	
796	7	48	59	76	120674788238	\N			1	\N	\N	33	9	2	фара правая	headlamp right	174	226	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:30:32.641225+01	\N	2011-03-25 14:27:45.273302+01	2011-03-25 14:30:32.646329+01	
797	7	48	59	76	380309154721	\N			1	\N	\N	58	2	2	датчик давления	sensor	52	72.799999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:30:32.649651+01	\N	2011-03-25 14:27:45.280655+01	2011-03-25 14:30:32.6541+01	
798	7	48	59	76	120678400515	\N	OFFER: 40	OFFER: 40	2	\N	\N	69	1	1	иммобилайзер	transmitter	44.289999999999999	58.960000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:30:32.656542+01	\N	2011-03-25 14:30:27.804675+01	2011-03-25 14:30:32.660924+01	
799	5	46	62	77	YJ475	\N		ЗАКАЗАНО	1	\N	\N	5	13	2	радиатор кондиционера	condencer	141.25	227.44999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:39:13.631799+01	\N	2011-03-25 14:35:17.923424+01	2011-03-25 14:39:13.63655+01	
800	5	46	62	77	MCSOE153	\N			1	\N	\N	5	13	2	рычаг верхний правый	upper arm	81.939999999999998	140.37	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:39:13.639458+01	\N	2011-03-25 14:35:17.930174+01	2011-03-25 14:39:13.643536+01	
801	5	46	62	77	MCSOE99	\N			1	\N	\N	5	13	2	рычаг нижний правый	lower arm	160.72	275.27999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:39:13.645928+01	\N	2011-03-25 14:35:17.934301+01	2011-03-25 14:39:13.650038+01	
802	5	46	62	77	BT88	\N			1	\N	\N	5	13	2	натяжитель в сборе	tensioner	29.940000000000001	76.069999999999993	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:39:13.652318+01	\N	2011-03-25 14:35:17.939579+01	2011-03-25 14:39:13.656374+01	
803	5	46	62	77	JK6865B	\N			1	\N	\N	5	13	2	ремень приводной	Belt w strip	13.75	31.489999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:39:13.659115+01	\N	2011-03-25 14:35:17.944024+01	2011-03-25 14:39:13.663123+01	
804	5	46	62	77	KM4983	\N			1	\N	\N	5	13	2	патрубок нижний радиатора	hose	22.370000000000001	51.229999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:39:13.665425+01	\N	2011-03-25 14:35:17.948653+01	2011-03-25 14:39:13.669681+01	
805	5	46	62	77	PW458	\N			1	\N	\N	5	13	2	помпа 	water pump	86.159999999999997	181.5	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:39:13.672138+01	\N	2011-03-25 14:35:17.953087+01	2011-03-25 14:39:13.676596+01	
806	5	46	62	77	FA1695	\N			1	\N	\N	5	13	2	фильтр возд	air filter	10.029999999999999	24.140000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:39:13.678929+01	\N	2011-03-25 14:35:17.958053+01	2011-03-25 14:39:13.683215+01	
807	5	46	62	77	WG312	\N			1	\N	\N	5	13	2	мотор омывателя	washer motor	20.649999999999999	47.289999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:39:13.68556+01	\N	2011-03-25 14:35:17.962607+01	2011-03-25 14:39:13.690044+01	
826	4	2	2	79	19101RWCA00	\N			1	\N	\N	5	15	1	бачёк расширительный	reservoir 	18.030000000000001	17.43	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.06886+01	\N	2011-03-25 14:54:40.285502+01	2011-03-25 14:54:50.072959+01	
827	4	2	2	79	71190STKA00	\N			1	\N	\N	5	15	1	крепление бампера вехнее лев	bracket	13.720000000000001	13.26	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.07552+01	\N	2011-03-25 14:54:40.289923+01	2011-03-25 14:54:50.079847+01	
811	4	11	11	78	6L2Z8146B	\N			1	\N	\N	5	14	2	диффузор вентилятора	shoud	83.079999999999998	80.299999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:52:04.724445+01	\N	2011-03-25 14:51:50.442325+01	2011-03-25 14:52:04.729522+01	
812	4	11	11	78	1L2Z16C274AA	\N			1	\N	\N	5	14	2	усилитель правый наружный	reinforsment	133.91999999999999	129.44	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:52:04.740406+01	\N	2011-03-25 14:51:50.452445+01	2011-03-25 14:52:04.744668+01	
813	4	11	11	78	6L2Z8327AA	\N			1	\N	\N	5	14	2	дефлектор 	deflector	44.380000000000003	42.899999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:52:04.746954+01	\N	2011-03-25 14:51:50.459975+01	2011-03-25 14:52:04.751101+01	
814	4	11	11	78	8L2Z8C299A	\N			1	\N	\N	5	14	2	накладка	cover	83.420000000000002	80.629999999999995	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:52:04.753402+01	\N	2011-03-25 14:51:50.466939+01	2011-03-25 14:52:04.757686+01	
815	4	11	11	78	6L2Z8349AA	\N			1	\N	\N	5	14	2	дефлектор 	deflector	44.799999999999997	43.299999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:52:04.75996+01	\N	2011-03-25 14:51:50.473946+01	2011-03-25 14:52:04.764229+01	
816	4	11	11	78	6L2Z19E572BA	\N			1	\N	\N	5	14	2	уплотнитель нижний	seal	13.619999999999999	13.16	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:52:04.766613+01	\N	2011-03-25 14:51:50.481209+01	2011-03-25 14:52:04.771206+01	
817	4	11	11	78	6L2Z7A095A	\N			1	\N	\N	5	14	2	радиатор масла кпп	radiator	179.65000000000001	173.63999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:52:04.773629+01	\N	2011-03-25 14:51:50.488305+01	2011-03-25 14:52:04.778021+01	
818	4	11	11	78	6L2Z16038CAPTM	\N			1	\N	\N	5	14	2	накладка крыла прав	cover	201.68000000000001	194.94	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:52:04.780371+01	\N	2011-03-25 14:51:50.495121+01	2011-03-25 14:52:04.784694+01	
819	4	11	11	78	6L2Z8509AA	\N			1	\N	\N	5	14	2	шкив помпы	pulley	18.870000000000001	18.239999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:52:04.787579+01	\N	2011-03-25 14:51:50.502092+01	2011-03-25 14:52:04.791847+01	
820	4	11	11	78	1L2Z8507AA	\N			1	\N	\N	5	14	2	прокладка помпы	gasket	20	19.329999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:52:04.794581+01	\N	2011-03-25 14:51:50.509342+01	2011-03-25 14:52:04.798702+01	
821	4	11	11	78	3L2Z17618BA	\N			1	\N	\N	5	14	2	бачок омывателя 	washer tank	66	63.789999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:52:04.800883+01	\N	2011-03-25 14:51:50.516287+01	2011-03-25 14:52:04.805195+01	
822	4	11	11	78	8L2Z3D746B	\N			1	\N	\N	5	14	2	радиатор ГУР	cooler	118.53	114.56999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:52:04.807401+01	\N	2011-03-25 14:51:50.523291+01	2011-03-25 14:52:04.811527+01	
823	4	11	11	78	6L2Z9A600A	\N			1	\N	\N	5	14	2	коробк низ возд фильтра	air cleaner housing	234.80000000000001	226.94999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:52:04.813803+01	\N	2011-03-25 14:51:50.530417+01	2011-03-25 14:52:04.818068+01	
824	4	11	11	78	6L2Z16K006AA	\N			1	\N	\N	5	14	2	усилитель крыла внутр правый	reinforsment	44	42.530000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:52:04.820967+01	\N	2011-03-25 14:51:50.537825+01	2011-03-25 14:52:04.825121+01	
828	4	2	2	79	74122STKA00	\N			2	\N	\N	5	15	1	воздухозаборник радиатора прав	deflector	4.7999999999999998	4.6399999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.082323+01	\N	2011-03-25 14:54:40.295404+01	2011-03-25 14:54:50.086701+01	
829	4	2	2	79	74172STKA00	\N			2	\N	\N	5	15	1	воздухозаборник радиатора лев	deflector	4.7999999999999998	4.6399999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.089044+01	\N	2011-03-25 14:54:40.300077+01	2011-03-25 14:54:50.093453+01	
830	4	2	2	79	74111STKA00	\N			2	\N	\N	5	15	1	защита бампера нижн	cover	46.729999999999997	45.170000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.095828+01	\N	2011-03-25 14:54:40.306451+01	2011-03-25 14:54:50.100171+01	
831	4	2	2	79	71503S0X000YA	\N			4	\N	\N	5	15	1	заглушка крепления бампера задн	cap	4.3300000000000001	4.1900000000000004	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.102711+01	\N	2011-03-25 14:54:40.311612+01	2011-03-25 14:54:50.10718+01	
825	4	2	2	79	52371STKA00				1	\N	\N	5	15	1	продольный рычаг задний прав	arm	118.97	114.98999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.059075+01		2011-03-25 14:54:40.27967+01	2011-03-25 14:57:22.906766+01	#
832	4	2	2	79	33506STKA01	\N			4	\N	\N	5	15	1	заглушка крепления фонаря задн	cap	3.1699999999999999	3.0600000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.109501+01	\N	2011-03-25 14:54:40.317638+01	2011-03-25 14:54:50.113782+01	
833	4	2	2	79	50200STKA02	\N			1	\N	\N	5	15	1	подрамник	subframe	827.85000000000002	689.80999999999995	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.11755+01	\N	2011-03-25 14:54:40.322926+01	2011-03-25 14:54:50.122368+01	
834	4	2	2	79	39151STKA01	\N			1	\N	\N	5	15	1	антенна задняя	antenna	9.5299999999999994	9.2100000000000009	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.124831+01	\N	2011-03-25 14:54:40.32832+01	2011-03-25 14:54:50.129245+01	
835	4	2	2	79	60614STKA00ZZ	\N			1	\N	\N	5	15	1	панель крепления крыла прав	panel	19.530000000000001	18.879999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.13407+01	\N	2011-03-25 14:54:40.33436+01	2011-03-25 14:54:50.138948+01	
839	4	2	2	79	71185STKA00ZZ	\N			1	\N	\N	5	15	1	крепление усилителя бампера лев	bracket	19.18	18.539999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.166742+01	\N	2011-03-25 14:54:40.356451+01	2011-03-25 14:54:50.170995+01	
840	4	2	2	79	19713RWCA00	\N			2	\N	\N	5	15	1	воздухозаборник интеркуллера	air intake	67.969999999999999	65.700000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.1734+01	\N	2011-03-25 14:54:40.36199+01	2011-03-25 14:54:50.17765+01	
841	4	2	2	79	76841STKA01	\N			1	\N	\N	5	15	1	бачёк омывателя	washer tank	17.129999999999999	16.559999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.182203+01	\N	2011-03-25 14:54:40.367642+01	2011-03-25 14:54:50.186286+01	
842	4	2	2	79	76806STKA01	\N			1	\N	\N	5	15	1	моторчик бачка омывателя	washer motor	25.100000000000001	24.260000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.188662+01	\N	2011-03-25 14:54:40.373415+01	2011-03-25 14:54:50.193588+01	
843	4	2	2	79	53701STKA01	\N			1	\N	\N	5	15	1	бачёк гидроусилителя	power stering reservoir	17.050000000000001	16.48	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.196153+01	\N	2011-03-25 14:54:40.379403+01	2011-03-25 14:54:50.201119+01	
838	4	2	2	79	52210STKA01				1	\N	\N	5	15	1	кулак опорный задний правый	knukle	150.19	145.16999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.159949+01		2011-03-25 14:54:40.351086+01	2011-03-25 14:56:18.805145+01	#
837	4	2	2	79	52320STKA01				1	\N	\N	5	15	1	стойка стабилизатора задняя прав	link	17.329999999999998	16.75	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.152094+01		2011-03-25 14:54:40.345114+01	2011-03-25 14:56:40.936019+01	#
836	4	2	2	79	52355STKA00				1	\N	\N	5	15	1	поперечный рычаг верхний прав	arm	100.37	97.010000000000005	\N	\N	\N	\N	\N	in_processing	2011-03-25 14:54:50.142961+01		2011-03-25 14:54:40.339557+01	2011-03-25 14:57:01.551601+01	#
844	4	26	26	80	289101AA0A	\N			1	\N	\N	27	5	1	бачёк омывателя	washer tank	125.58	106.73999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 15:03:45.053583+01	\N	2011-03-25 15:00:11.506103+01	2011-03-25 15:03:45.058271+01	
845	4	26	26	80	165541AA0A	\N			1	\N	\N	27	5	1	воздуховод	inlet	70.769999999999996	60.149999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 15:03:45.061692+01	\N	2011-03-25 15:00:11.512231+01	2011-03-25 15:03:45.065699+01	
846	5	61	60	81	A035B	\N	jeep liberty  2007	ЗАКАЗАНО	1	\N	\N	70	1	2	панель фар	headlamp panel	146	263	\N	\N	\N	\N	\N	in_processing	2011-03-25 15:03:50.406724+01	\N	2011-03-25 15:03:21.456459+01	2011-03-25 15:03:50.411496+01	
847	5	62	69	82	2936	\N	TYC		1	\N	\N	33	10	1	радиатор	radiator	89.790000000000006	192.27000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:32:14.193539+01	\N	2011-03-25 21:17:48.868826+01	2011-03-25 21:32:14.198329+01	
848	5	62	69	82	3600	\N	TYC		1	\N	\N	5	16	1	радиатор кондиционера	condencer	109.79000000000001	205.58099999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:32:14.250172+01	\N	2011-03-25 21:17:48.920895+01	2011-03-25 21:32:14.254686+01	
849	5	62	87	82	AC1248123	\N	VARIOUS MFR		1	\N	\N	5	16	1	подкрылок левый	fender liner	21.789999999999999	48.807000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:32:14.257624+01	\N	2011-03-25 21:17:48.930166+01	2011-03-25 21:32:14.261821+01	
850	5	62	69	82	3592	\N	TYC		2	\N	\N	5	16	1	радиатор кондиционера	condencer	96.989999999999995	236.63999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:32:14.264152+01	\N	2011-03-25 21:17:48.937098+01	2011-03-25 21:32:14.268301+01	
851	5	62	88	82	CCC0013840	\N	SHERMAN		1	\N	\N	39	5	1	усилитель бампера	reinforcement	49.789999999999999	75.430000000000007	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:32:14.271649+01	\N	2011-03-25 21:17:48.944105+01	2011-03-25 21:32:14.27604+01	
852	5	62	69	82	2916	\N	TYC		2	\N	\N	39	5	1	радиатор	radiator	188	134.589	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:32:14.278552+01	\N	2011-03-25 21:17:48.953084+01	2011-03-25 21:32:14.282709+01	
853	5	62	69	82	13076	\N	TYC		1	\N	\N	27	6	1	радиатор	radiator	154	200	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:32:14.285074+01	\N	2011-03-25 21:17:48.961409+01	2011-03-25 21:32:14.290552+01	
859	5	62	87	82	SZ3010133	\N	VARIOUS MFR		1	\N	\N	10	5	2	радиатор	radiator	116.98999999999999	186	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:32:14.292908+01	\N	2011-03-25 21:31:24.81091+01	2011-03-25 21:32:14.29694+01	
860	5	62	89	82	HT2148	\N	sealed power		1	\N	\N	71	1	2	толкатель 	push rod	13.119999999999999	21	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:32:14.299261+01	\N	2011-03-25 21:31:24.818114+01	2011-03-25 21:32:14.303294+01	
861	5	62	71	82	HS9644PT	\N	fel-pro		1	\N	\N	71	1	2	прокладка под гбц комплект	gasket set	88.980000000000004	144	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:32:14.305609+01	\N	2011-03-25 21:31:24.823649+01	2011-03-25 21:32:14.310961+01	
862	5	62	77	82	662086	\N	cardone		1	\N	\N	48	2	2	шрус правый	shaft right	58.060000000000002	130	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:32:14.313499+01	\N	2011-03-25 21:31:24.828966+01	2011-03-25 21:32:14.317808+01	
863	5	62	81	82	3622S	\N	timken		1	\N	\N	48	2	2	сальник	seal	8.9499999999999993	15	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:32:14.320205+01	\N	2011-03-25 21:31:24.833317+01	2011-03-25 21:32:14.324255+01	
864	7	48	59	83	380313647462	\N			1	\N	\N	72	1	2	комплект фар	headlight	194.88999999999999	243.59999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:45:48.273193+01	\N	2011-03-25 21:45:31.537164+01	2011-03-25 21:45:48.278886+01	
865	7	48	59	83	380317441867	\N			1	\N	\N	72	1	2	комплект фар	headlight	142.97999999999999	178.72	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:45:48.281955+01	\N	2011-03-25 21:45:31.544548+01	2011-03-25 21:45:48.286047+01	
866	7	48	59	83	370485554348	\N			1	\N	\N	72	1	2	крыло	fender	134	167.49000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:45:48.288211+01	\N	2011-03-25 21:45:31.549777+01	2011-03-25 21:45:48.292293+01	
867	7	48	59	83	400191206090	\N			1	\N	\N	72	1	2	бампер	bumper	121.5	171.5	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:45:48.294499+01	\N	2011-03-25 21:45:31.554878+01	2011-03-25 21:45:48.299445+01	
868	7	48	59	83	230575429116	\N			1	\N	\N	72	1	2	решётка нижняя	grille	23.43	29.289999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:45:48.302142+01	\N	2011-03-25 21:45:31.560113+01	2011-03-25 21:45:48.306214+01	
869	7	48	59	83	260725480795	\N			1	\N	\N	72	1	2	решётка верхняя	grille	110.98	138.72	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:45:48.308404+01	\N	2011-03-25 21:45:31.564965+01	2011-03-25 21:45:48.312865+01	
870	7	48	59	83	230587250347	\N			1	\N	\N	72	1	2	зеркало	mirror	35.899999999999999	44.869999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:45:48.315103+01	\N	2011-03-25 21:45:31.570498+01	2011-03-25 21:45:48.319861+01	
871	7	48	59	83	380290795666	\N			1	\N	\N	72	1	2	крыло	fender	103.90000000000001	129.87	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:45:48.322198+01	\N	2011-03-25 21:45:31.57563+01	2011-03-25 21:45:48.326446+01	
872	7	48	59	83	400191202015	\N			1	\N	\N	72	1	2	бампер	bumper	103.27	153.27000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:45:48.32902+01	\N	2011-03-25 21:45:31.580822+01	2011-03-25 21:45:48.333241+01	
873	7	48	59	83	310296271024	\N			1	\N	\N	72	1	2	бампер	bumper	125	175	\N	\N	\N	\N	\N	in_processing	2011-03-25 21:45:48.335538+01	\N	2011-03-25 21:45:31.586037+01	2011-03-25 21:45:48.340365+01	
874	4	23	23	84	ZZC210272	\N			1	\N	\N	3	13	1	прокладка ГБЦ	head gasket	28.579999999999998	23.440000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:00:23.84587+01	\N	2011-03-25 22:00:05.670472+01	2011-03-25 22:00:23.851971+01	
875	4	23	23	84	EC0143980D	\N			6	\N	\N	3	13	1	шланг тормозной	brake hose	14.65	12.01	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:00:23.854793+01	\N	2011-03-25 22:00:05.677505+01	2011-03-25 22:00:23.858823+01	
876	4	11	11	84	YF1Z6148BA	\N			3	\N	\N	3	13	1	полукольцо	partial ring	51.219999999999999	42	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:00:23.861068+01	\N	2011-03-25 22:00:05.682521+01	2011-03-25 22:00:23.865422+01	
877	4	23	23	84	L33L13ZE0	\N			2	\N	\N	3	13	1	насос топливный	fuel pump	63.43	52.020000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:00:23.867882+01	\N	2011-03-25 22:00:05.688005+01	2011-03-25 22:00:23.87279+01	
879	4	26	26	85	738841AA0A	\N			2	\N	\N	4	16	1	заглушка	PLUG-END	4.8300000000000001	2.125	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.589438+01	\N	2011-03-25 22:07:27.566384+01	2011-03-25 22:23:46.594068+01	
878	4	23	23	85	JE0613210R0A	\N			1	\N	\N	3	14	1	расходомер	mass air flow sensor	226.43000000000001	185.68000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.557392+01	\N	2011-03-25 22:07:27.547214+01	2011-03-25 22:23:46.573029+01	
880	4	25	25	85	MD604555	\N			1	\N	\N	4	16	1	вакуумный контроллер	CONTROLLER,VACUUM	62.079999999999998	54.630000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.600747+01	\N	2011-03-25 22:07:27.570861+01	2011-03-25 22:23:46.605397+01	
881	4	13	13	85	35118TE0A10	\N			1	\N	\N	4	16	1	ключ	KEY	33.850000000000001	29.789999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.60931+01	\N	2011-03-25 22:07:27.575251+01	2011-03-25 22:23:46.613832+01	
882	4	47	8	85	68023330AA	\N			1	\N	\N	4	16	1	брекет	BRACKET FENDER FRONT	31.949999999999999	28.120000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.626067+01	\N	2011-03-25 22:07:27.581207+01	2011-03-25 22:23:46.631149+01	
883	4	2	2	85	7220RDJJ00	\N			1	\N	\N	4	16	1	фильтр	Air filter	24.149999999999999	21.25	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.639396+01	\N	2011-03-25 22:07:27.588046+01	2011-03-25 22:23:46.644173+01	
884	4	2	2	85	17220RDAA10	\N			1	\N	\N	4	16	1	фильтр	Air filter	27.57	24.260000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.651423+01	\N	2011-03-25 22:07:27.595609+01	2011-03-25 22:23:46.656272+01	
885	4	2	2	85	04711STKA91ZZ	\N			1	\N	\N	4	16	1	бампер	Bumper cover 	237.62	209.11000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.669539+01	\N	2011-03-25 22:07:27.602547+01	2011-03-25 22:23:46.674123+01	
886	4	2	2	85	04712STKA90ZZ	\N			1	\N	\N	4	16	1	бампер	Bumper cover	163.15000000000001	143.56999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.679307+01	\N	2011-03-25 22:07:27.609534+01	2011-03-25 22:23:46.683424+01	
887	4	13	13	85	47510S82A01	\N			1	\N	\N	4	16	1	трос ручника	Cable	30.23	26.600000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.689376+01	\N	2011-03-25 22:07:27.620601+01	2011-03-25 22:23:46.693819+01	
888	4	13	13	85	47560S82A01	\N			1	\N	\N	4	16	1	трос ручника	Cable	30.879999999999999	27.170000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.709442+01	\N	2011-03-25 22:07:27.627645+01	2011-03-25 22:23:46.71384+01	
889	4	35	35	85	5311408020	\N			1	\N	\N	4	16	1	элемент решётки радиатора	Upper grille	63.530000000000001	55.909999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.719367+01	\N	2011-03-25 22:07:27.637489+01	2011-03-25 22:23:46.723791+01	
890	4	35	35	85	8521206110	\N			1	\N	\N	4	16	1	дворник	Wiper blade	19.23	16.920000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.729394+01	\N	2011-03-25 22:07:27.645134+01	2011-03-25 22:23:46.735235+01	
891	4	47	9	85	4692139AA	\N			2	\N	\N	68	2	2	реле	relay	5.4500000000000002	3	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.749599+01	\N	2011-03-25 22:19:52.055528+01	2011-03-25 22:23:46.754222+01	
892	4	47	9	85	4692143AA	\N			1	\N	\N	68	2	2	реле	 breaker circuit	5.8499999999999996	6	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.759276+01	\N	2011-03-25 22:19:52.06224+01	2011-03-25 22:23:46.763898+01	
893	4	47	9	85	68004466AB	\N			1	\N	\N	50	2	2	пластик сиденья	kit none	51.450000000000003	55	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.779449+01	\N	2011-03-25 22:19:52.067694+01	2011-03-25 22:23:46.784538+01	
894	4	47	9	85	5JK04BD5AB	\N			1	\N	\N	50	2	2	заглушка сиденья	bezel	6.8499999999999996	8	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.787206+01	\N	2011-03-25 22:19:52.076978+01	2011-03-25 22:23:46.791579+01	
895	4	47	9	85	5136093AA	\N			1	\N	\N	50	2	2	зеркало левое стекло 	mirror glass	42.350000000000001	45	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.799422+01	\N	2011-03-25 22:19:52.081526+01	2011-03-25 22:23:46.803778+01	
896	4	12	29	85	88975651	\N			1	\N	\N	73	1	2	бампер передний	bumper front	332.97000000000003	353	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.819424+01	\N	2011-03-25 22:19:52.089211+01	2011-03-25 22:23:46.8243+01	
897	4	12	29	85	19183841	\N			1	\N	\N	73	1	2	стакан амортизатора	paneright	94.5	100	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.832441+01	\N	2011-03-25 22:19:52.093735+01	2011-03-25 22:23:46.837099+01	
898	4	12	29	85	88975654	\N			1	\N	\N	73	1	2	решетка радиатора правая	grille right	55.75	59	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.851243+01	\N	2011-03-25 22:19:52.098671+01	2011-03-25 22:23:46.855849+01	
899	4	12	29	85	19183836	\N			1	\N	\N	73	1	2	панель телевизора правая	panel right	84.129999999999995	89	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:23:46.859368+01	\N	2011-03-25 22:19:52.102981+01	2011-03-25 22:23:46.863432+01	
900	4	13	13	86	74880S82A01	\N			1	\N	\N	27	7	1	трос	lever	30.579999999999998	25.989999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:34:48.010222+01	\N	2011-03-25 22:34:36.286533+01	2011-03-25 22:34:48.014942+01	
901	4	13	13	86	17220RGWA00	\N			1	\N	\N	27	7	1	фильтр воздушный	air filter	26.300000000000001	22.359999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-25 22:34:48.027392+01	\N	2011-03-25 22:34:36.304861+01	2011-03-25 22:34:48.033654+01	
902	4	23	23	87	AC0127238	\N			2	\N	\N	3	15	1	сальник полуоси	oil seal	9.7599999999999998	8.0099999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.518094+02	\N	2011-03-28 19:07:20.662296+02	2011-03-28 19:20:32.522887+02	
903	4	33	33	87	J1010SC020	\N			1	\N	\N	6	6	1	комплект брызговиков	Mud guard	99.849999999999994	84.870000000000005	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.526518+02	\N	2011-03-28 19:07:20.67996+02	2011-03-28 19:20:32.532289+02	
904	4	35	35	87	04152YZZA1	\N			1	\N	\N	6	6	1	фильтр маслянный	oil filter	5.4100000000000001	4.5999999999999996	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.535724+02	\N	2011-03-28 19:07:20.686958+02	2011-03-28 19:20:32.542273+02	
905	4	23	23	87	C24328156D	\N			8	\N	\N	3	15	1	втулка стабилизатора	bushing	6.8399999999999999	2.8100000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.54541+02	\N	2011-03-28 19:07:20.693351+02	2011-03-28 19:20:32.551838+02	
906	4	11	11	87	1S7Z6K254AA	\N			2	\N	\N	3	15	1	натяжитель	tensioner	66.650000000000006	54.659999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.555123+02	\N	2011-03-28 19:07:20.699163+02	2011-03-28 19:20:32.561718+02	
907	4	23	23	87	BC1M67362	\N			1	\N	\N	3	15	1	рычаг счётки	link rod	37.840000000000003	31.030000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.564816+02	\N	2011-03-28 19:07:20.703981+02	2011-03-28 19:20:32.570922+02	
908	4	11	11	87	4L8Z6K255AA	\N			4	\N	\N	3	15	1	рычаг натяжителя	tensioner arm	24.98	20.489999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.574126+02	\N	2011-03-28 19:07:20.708604+02	2011-03-28 19:20:32.580494+02	
909	4	11	11	87	YL8Z9H486AA	\N			6	\N	\N	3	15	1	прокладка впускного коллектора	manifold gasket 	3.0499999999999998	2.5	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.583766+02	\N	2011-03-28 19:07:20.71318+02	2011-03-28 19:20:32.589597+02	
910	4	23	23	87	AJ5710513	\N			1	\N	\N	3	15	1	прокладка передней крышки	front cover gasket	6.1200000000000001	5.0199999999999996	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.592912+02	\N	2011-03-28 19:07:20.721379+02	2011-03-28 19:20:32.598905+02	
911	4	23	23	87	AJ5710523	\N			1	\N	\N	3	15	1	прокладка крышки ГРМ	cover gasket	6.4000000000000004	5.25	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.602655+02	\N	2011-03-28 19:07:20.727605+02	2011-03-28 19:20:32.606745+02	
912	4	11	11	87	YF1Z6L266BA	\N			4	\N	\N	3	15	1	натяжитель	tensioner	56.649999999999999	46.460000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.60969+02	\N	2011-03-28 19:07:20.733483+02	2011-03-28 19:20:32.614505+02	
913	4	11	11	87	3L2Z2A637AA	\N			1	\N	\N	3	16	1	натяжитель	adjuster 	21.98	18.030000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.61731+02	\N	2011-03-28 19:20:02.057927+02	2011-03-28 19:20:32.622111+02	
914	4	47	8	87	5066756AA	\N			2	\N	\N	3	16	1	сальник коленвала	crankshaft seal	65.950000000000003	54.079999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.624575+02	\N	2011-03-28 19:20:02.074506+02	2011-03-28 19:20:32.629356+02	
915	4	23	23	87	GP0222540	\N			2	\N	\N	3	16	1	пыльник ШРУС внутренний	boot inner	34.960000000000001	28.670000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.631605+02	\N	2011-03-28 19:20:02.079323+02	2011-03-28 19:20:32.635583+02	
916	4	23	23	87	ZZC134156	\N			2	\N	\N	3	16	1	втулка стабилизатора	bushing	11.67	9.5700000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.638693+02	\N	2011-03-28 19:20:02.08641+02	2011-03-28 19:20:32.642769+02	
917	4	23	23	87	000018150A	\N			1	\N	\N	3	16	1	провода высоковольтные	wire set	146.38	120.04000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:20:32.64523+02	\N	2011-03-28 19:20:02.09346+02	2011-03-28 19:20:32.649504+02	
919	5	43	84	88	K500063	\N	ЗАКАЗАНО moog	ЗАКАЗАНО	2	\N	\N	7	14	1	шаровая опора 	Ball Joint	39.789999999999999	59	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:44:23.297108+02	\N	2011-03-28 19:39:10.194734+02	2011-03-28 19:44:23.301536+02	
920	5	62	73	88	B222	\N	ATP	ЗАКАЗАНО	2	\N	\N	7	14	1	фильтр АКПП	Transmission-Automatic : Filter	22.890000000000001	37.240000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:44:23.30495+02	\N	2011-03-28 19:39:10.199741+02	2011-03-28 19:44:23.309135+02	
921	5	62	87	88	MI3010150	\N	VARIOUS	ЗАКАЗАНО	1	\N	\N	7	14	1	радиатор	Radiator 	89.989999999999995	136.59999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:44:23.312787+02	\N	2011-03-28 19:39:10.204366+02	2011-03-28 19:44:23.317145+02	
918	5	43	81	88	HA590002	\N	ЗАКАЗАНО timken	ЗАКАЗАНО	1	\N	\N	7	14	1	ступица	Axle Bearing and Hub Assembly 	123.98999999999999	185.68000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:44:23.288625+02	\N	2011-03-28 19:39:10.186806+02	2011-03-28 19:44:23.294106+02	
922	5	62	90	88	TPM23	\N	standard	ЗАКАЗАНО	1	\N	\N	74	1	1	датчик давления колеса	pressure sensor	44.399999999999999	70	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:44:23.319693+02	\N	2011-03-28 19:39:10.210025+02	2011-03-28 19:44:23.325181+02	
923	5	62	69	88	20590700	\N	TYC	ЗАКАЗАНО	1	\N	\N	7	14	1	фара	Headlamp Assembly	40.789999999999999	71.010000000000005	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:44:23.329924+02	\N	2011-03-28 19:39:10.2167+02	2011-03-28 19:44:23.337951+02	
924	5	62	87	88	NI1200190 	\N	VARIOUS	ЗАКАЗАНО	1	\N	\N	7	14	1	решетка	Grille 	16.09	42.450000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:44:23.341734+02	\N	2011-03-28 19:39:10.221777+02	2011-03-28 19:44:23.347445+02	
925	5	62	91	88	UP90391S	\N	ULTRAPOWER		1	\N	\N	75	1	2	комплект ГРМ	timing set	132.91	220	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:44:23.349944+02	\N	2011-03-28 19:44:04.276791+02	2011-03-28 19:44:23.355064+02	
926	5	62	63	88	713121	\N	RAYBESTOS		1	\N	\N	35	2	2	ступица передняя	hub front	67.719999999999999	110	\N	\N	\N	\N	\N	in_processing	2011-03-28 19:44:23.357659+02	\N	2011-03-28 19:44:04.312467+02	2011-03-28 19:44:23.362713+02	
927	4	13	13	89	28260-PRP-014	\N			1	\N	\N	76	1	1	соленоид	solenoid	257.82999999999998	245	\N	\N	\N	\N	\N	in_processing	2011-03-28 20:26:15.463311+02	\N	2011-03-28 20:12:27.258181+02	2011-03-28 20:26:15.468388+02	
928	4	13	13	89	50820-SEP-A01	\N			1	\N	\N	34	3	1	подушка правая 	mount	68.670000000000002	73	\N	\N	\N	\N	\N	in_processing	2011-03-28 20:26:15.476259+02	\N	2011-03-28 20:12:27.271702+02	2011-03-28 20:26:15.480625+02	
929	4	11	11	89	7T4Z16138B	\N			1	\N	\N	4	17	1	Суппорт радиатора	 Radiator support	197.66999999999999	173.94	\N	\N	\N	\N	\N	in_processing	2011-03-28 20:26:15.483223+02	\N	2011-03-28 20:12:27.277202+02	2011-03-28 20:26:15.487445+02	
930	4	2	2	89	71190S6M010	\N			1	\N	\N	4	17	1	Кронштейн	BEAM	22.399999999999999	19.710000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-28 20:26:15.48978+02	\N	2011-03-28 20:12:27.283201+02	2011-03-28 20:26:15.49402+02	
931	4	2	2	89	75710S6MA11	\N			1	\N	\N	4	17	1	эмблемма	Emblem assy	33.780000000000001	29.73	\N	\N	\N	\N	\N	in_processing	2011-03-28 20:26:15.496487+02	\N	2011-03-28 20:12:27.28892+02	2011-03-28 20:26:15.501054+02	
932	4	47	8	89	4894894AA	\N			1	\N	\N	4	17	1	направляющая	BRACKET FENDER MOUNT	11.25	9.9000000000000004	\N	\N	\N	\N	\N	in_processing	2011-03-28 20:26:15.503386+02	\N	2011-03-28 20:12:27.295287+02	2011-03-28 20:26:15.507727+02	
933	4	35	35	89	8946706100	\N			1	\N	\N	4	17	1	датчик	SENSOR AIR FUEL	213.18000000000001	187.59999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 20:26:15.510392+02	\N	2011-03-28 20:12:27.301225+02	2011-03-28 20:26:15.514852+02	
934	5	43	90	90	TPM23	\N	standard	ЗАКАЗАНО	3	\N	\N	74	2	1	датчик давления колеса	pressure sensor	41.619999999999997	70	\N	\N	\N	\N	\N	in_processing	2011-03-28 20:53:50.315674+02	\N	2011-03-28 20:48:14.771573+02	2011-03-28 20:53:50.320477+02	
936	5	61	60	90	H1364	\N		ЗАКАЗАНО	1	\N	\N	15	8	2	подкрылок правый	liner right	22	35	\N	\N	\N	\N	\N	in_processing	2011-03-28 20:53:50.332174+02	\N	2011-03-28 20:53:22.207261+02	2011-03-28 20:53:50.336225+02	
937	5	61	60	90	H1365	\N		ЗАКАЗАНО	1	\N	\N	15	8	2	подкрылок левый	liner left	22	35	\N	\N	\N	\N	\N	in_processing	2011-03-28 20:53:50.338568+02	\N	2011-03-28 20:53:22.225192+02	2011-03-28 20:53:50.344787+02	
935	7	48	59	91	250764926560	\N			1	\N	\N	74	3	1	хомут	band	60	100	\N	\N	\N	\N	\N	in_processing	2011-03-28 20:54:10.611063+02	\N	2011-03-28 20:50:46.94255+02	2011-03-28 20:54:10.615851+02	
938	4	26	26	92	460207Y000	\N			1	\N	\N	4	18	1	крышка	CAP OIL RESERVO	6.1799999999999997	5.4299999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.5272+02	\N	2011-03-28 21:06:01.314013+02	2011-03-28 21:06:32.532178+02	
939	4	13	13	92	67864SXSA01	\N			1	\N	\N	19	3	1	наклейка	Sticker	9.0199999999999996	9.0199999999999996	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.534989+02	\N	2011-03-28 21:06:01.323683+02	2011-03-28 21:06:32.539209+02	
940	4	13	13	92	83222SXSA01ZB	\N			1	\N	\N	19	3	1	заглушка	Cover	3.0299999999999998	3.0299999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.541464+02	\N	2011-03-28 21:06:01.328623+02	2011-03-28 21:06:32.545775+02	
941	4	33	33	92	57704AG02A	\N			1	\N	\N	4	18	1	бампер	Bumper cover	239.97	211.16999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.548114+02	\N	2011-03-28 21:06:01.333396+02	2011-03-28 21:06:32.552261+02	
942	4	2	2	92	75332STKA01ZB	\N			1	\N	\N	4	18	1	накладка	Lower cladding	130.05000000000001	114.44	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.554471+02	\N	2011-03-28 21:06:01.339202+02	2011-03-28 21:06:32.558703+02	
943	4	2	2	92	74165STKA01ZB	\N			1	\N	\N	4	18	1	молдинг	Trim molding	31.219999999999999	27.469999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.561267+02	\N	2011-03-28 21:06:01.343981+02	2011-03-28 21:06:32.565273+02	
944	4	23	23	92	LN0327397	\N			1	\N	\N	3	17	1	Сальник	seal	5.5300000000000002	4.5300000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.567502+02	\N	2011-03-28 21:06:01.350227+02	2011-03-28 21:06:32.571715+02	
945	4	23	23	92	LN0227238 	\N			1	\N	\N	3	17	1	Сальник	seal	6.5999999999999996	5.4000000000000004	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.574408+02	\N	2011-03-28 21:06:01.355322+02	2011-03-28 21:06:32.578733+02	
946	4	23	23	92	LN0127398 	\N			1	\N	\N	3	17	1	Сальник	seal	12.369999999999999	10.140000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.58114+02	\N	2011-03-28 21:06:01.360066+02	2011-03-28 21:06:32.585081+02	
947	4	23	23	92	LN0127394	\N			1	\N	\N	3	17	1	Сальник	seal	1.52	1.25	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.5875+02	\N	2011-03-28 21:06:01.364608+02	2011-03-28 21:06:32.591646+02	
948	4	23	23	92	T06026169A 	\N			1	\N	\N	3	17	1	Штифт	seal	1.3799999999999999	1.1299999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.594103+02	\N	2011-03-28 21:06:01.369174+02	2011-03-28 21:06:32.598201+02	
949	4	35	35	92	690900C040	\N			1	\N	\N	4	18	1	ручка	Handle	100.11	88.090000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.600424+02	\N	2011-03-28 21:06:01.373933+02	2011-03-28 21:06:32.620323+02	
950	4	35	35	92	657170C051	\N			1	\N	\N	4	18	1	Предохранитель	PROTECTOR TAIL GATE	120.89	106.38	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.627392+02	\N	2011-03-28 21:06:01.380182+02	2011-03-28 21:06:32.631522+02	
951	4	35	35	92	661400C010	\N			1	\N	\N	4	18	1	Кронштейн	Support Tail gate	93.879999999999995	82.609999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.637411+02	\N	2011-03-28 21:06:01.384991+02	2011-03-28 21:06:32.641563+02	
952	4	35	35	92	661020C020	\N			1	\N	\N	4	18	1	Шарнир	HINGE SUB-ASSY, TAIL	46.07	40.539999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.647339+02	\N	2011-03-28 21:06:01.389926+02	2011-03-28 21:06:32.651722+02	
953	4	35	35	92	661010C020	\N			1	\N	\N	4	18	1	Шарнир	HINGE SUB-ASSY, TAIL	46.07	40.539999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.654261+02	\N	2011-03-28 21:06:01.396095+02	2011-03-28 21:06:32.658441+02	
954	4	33	33	92	165541AA0A	\N			1	\N	\N	19	3	1	воздухозаборник	Air inlet duct	70.769999999999996	70.769999999999996	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.660672+02	\N	2011-03-28 21:06:01.400783+02	2011-03-28 21:06:32.66473+02	
955	4	33	33	92	140411AA1A	\N			1	\N	\N	19	3	1	накладка	Cover	128.88	128.88	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.66718+02	\N	2011-03-28 21:06:01.40554+02	2011-03-28 21:06:32.671353+02	
956	4	33	33	92	21710JP10A	\N			1	\N	\N	19	3	1	бачёк расширительный	Cooling  Reservoir	76.319999999999993	76.319999999999993	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:06:32.673441+02	\N	2011-03-28 21:06:01.410857+02	2011-03-28 21:06:32.677558+02	
957	6	58	13	93	51490-MCH-C11	\N	honda		1	\N	\N	36	3	1	пыльники вилки	seal	23.199999999999999	23.199999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.104933+02	\N	2011-03-28 21:15:13.098278+02	2011-03-28 21:58:29.11278+02	
958	6	58	34	93	43585-33E00	\N	suzuki		1	\N	\N	36	3	1	заглушка	cover	2.6800000000000002	2.6800000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.116832+02	\N	2011-03-28 21:15:13.105602+02	2011-03-28 21:58:29.123832+02	
959	6	58	34	93	56246-24F00	\N	suzuki		1	\N	\N	36	3	1	заглушка	cover	5.5099999999999998	5.5099999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.127213+02	\N	2011-03-28 21:15:13.110161+02	2011-03-28 21:58:29.134455+02	
960	6	58	13	93	06435-MCA-006	\N	honda		1	\N	\N	36	3	1	колодки тормозные	brake pads	52.350000000000001	52.350000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.138856+02	\N	2011-03-28 21:15:13.115237+02	2011-03-28 21:58:29.145666+02	
961	6	58	13	93	53104-MV4-000	\N	honda		1	\N	\N	36	3	1	грузик	bar end	19.149999999999999	19.149999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.148983+02	\N	2011-03-28 21:15:13.122856+02	2011-03-28 21:58:29.156067+02	
962	6	58	34	93	94462-24F00	\N	suzuki		1	\N	\N	36	3	1	накладка	cover	19.09	19.09	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.159998+02	\N	2011-03-28 21:15:13.128488+02	2011-03-28 21:58:29.167002+02	
963	6	58	34	93	51173-02FA0	\N	suzuki		2	\N	\N	36	3	1	пыльники вилки	seal	81.439999999999998	20.359999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.170125+02	\N	2011-03-28 21:15:13.134558+02	2011-03-28 21:58:29.17696+02	
964	6	58	34	93	51153-02FA0	\N	suzuki		2	\N	\N	36	3	1	сальник	seal	76.560000000000002	19.140000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.180363+02	\N	2011-03-28 21:15:13.14145+02	2011-03-28 21:58:29.187152+02	
965	6	58	34	93	09161-06021	\N	suzuki		2	\N	\N	36	3	1	втулка	bushing	7.9199999999999999	1.98	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.190712+02	\N	2011-03-28 21:15:13.14998+02	2011-03-28 21:58:29.200426+02	
966	6	58	34	93	09139-06030	\N	suzuki		1	\N	\N	36	3	1	болт	bolt	2.6800000000000002	2.6800000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.203751+02	\N	2011-03-28 21:15:13.156597+02	2011-03-28 21:58:29.211149+02	
967	6	58	34	93	03541-05083	\N	suzuki		3	\N	\N	36	3	1	болт	bolt	26.73	2.9700000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.214484+02	\N	2011-03-28 21:15:13.163318+02	2011-03-28 21:58:29.221834+02	
968	5	52	89	93	41540A.75MM	\N		sealed power	1	\N	\N	25	1	1	вкладыши коренные 0.75	engine bearing	51.5	59.219999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.225073+02	\N	2011-03-28 21:58:05.936167+02	2011-03-28 21:58:29.232193+02	
969	5	52	89	93	H852CP	\N		SEALED POWER\r\n	1	\N	\N	7	15	1	поршень(комплект)	Cast Piston	37.789999999999999	245	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.235755+02	\N	2011-03-28 21:58:05.948461+02	2011-03-28 21:58:29.242973+02	
970	5	45	71	93	9515PT	\N		fel-pro	3	\N	\N	52	2	1	прокладка ГБЦ	gasket	22.18	32	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.246328+02	\N	2011-03-28 21:58:05.95863+02	2011-03-28 21:58:29.25334+02	
971	5	62	72	93	13326	\N		bendix	1	\N	\N	52	2	1	цилиндр выжимной	clave cylinder	114.39	130	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.256771+02	\N	2011-03-28 21:58:05.967601+02	2011-03-28 21:58:29.263409+02	
972	5	62	58	93	P7698P	\N		DORMAN	1	\N	\N	7	15	1	поршень в суппорт	Caliper Piston	9.6600000000000001	21.43	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.265626+02	\N	2011-03-28 21:58:05.975177+02	2011-03-28 21:58:29.27029+02	
973	5	62	64	93	3009	\N		ANCHOR	1	\N	\N	7	15	1	подушка двигателя 	Motor Mount \r\n	45.789999999999999	81.170000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-28 21:58:29.27251+02	\N	2011-03-28 21:58:05.998085+02	2011-03-28 21:58:29.276471+02	
974	7	48	59	94	350410736846	\N			4	\N	\N	52	3	1	ручка наружная левая	handle	11.1	16	\N	\N	\N	\N	\N	in_processing	2011-03-28 22:02:08.042998+02	\N	2011-03-28 22:01:52.273005+02	2011-03-28 22:02:08.048222+02	
975	4	23	23	95	BC1M67362	\N			1	\N	\N	3	18	1	Рычаг трапеции стеклоочистителя	wiper arm	37.840000000000003	31.039999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:34:36.613006+02	\N	2011-03-28 22:06:05.962715+02	2011-03-28 23:34:36.617846+02	
976	4	23	23	95	AJY215SC0	\N			1	\N	\N	3	18	1	Блок управления вентиляторами	ecm	96.010000000000005	78.730000000000004	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:34:36.621203+02	\N	2011-03-28 22:06:05.976637+02	2011-03-28 23:34:36.625407+02	
977	4	47	8	95	4448896AB	\N			1	\N	\N	3	18	1	Прокладка поддона 	oil pan gasket	17	13.94	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:34:36.627654+02	\N	2011-03-28 22:06:05.982615+02	2011-03-28 23:34:36.632139+02	
978	4	47	8	95	4621987AC	\N			1	\N	\N	3	18	1	Прокладка крышки ремня ГРМ	gasket	9.25	7.6100000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:34:36.634358+02	\N	2011-03-28 22:06:05.989658+02	2011-03-28 23:34:36.638386+02	
979	4	23	23	95	AJ0311225	\N			4	\N	\N	52	4	2	вкладыш шатуна	bearing rod	16.350000000000001	16.350000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:34:36.644778+02	\N	2011-03-28 22:12:43.281555+02	2011-03-28 23:34:36.648941+02	
980	4	47	8	95	4389584AF	\N			1	\N	\N	73	2	2	панель задняя	panel below lid	192	204	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:34:36.651972+02	\N	2011-03-28 22:12:43.289567+02	2011-03-28 23:34:36.658639+02	
981	4	47	8	95	5076510AA	\N			1	\N	\N	73	2	2	наружная часть по лонжерону	outer rail right	91.75	97	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:34:36.661811+02	\N	2011-03-28 22:12:43.296213+02	2011-03-28 23:34:36.665969+02	
982	4	47	8	95	4389492AF	\N			1	\N	\N	73	2	2	фонарь внутренний задний	amp assy right	98.950000000000003	105	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:34:36.668463+02	\N	2011-03-28 22:12:43.300703+02	2011-03-28 23:34:36.672778+02	
983	4	12	29	95	19184593	\N			1	\N	\N	73	2	2	бачек омывателя	washer reservoir	36.979999999999997	39	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:34:36.675555+02	\N	2011-03-28 22:12:43.308286+02	2011-03-28 23:34:36.680058+02	
984	4	12	29	95	88975686	\N			1	\N	\N	73	2	2	направляющая правая бампера переднего	side support sight	16.809999999999999	18	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:34:36.682657+02	\N	2011-03-28 22:12:43.312823+02	2011-03-28 23:34:36.687066+02	
985	4	17	17	96	C2S10796	\N			1	\N	\N	3	19	1	рамка хром решетки радиатора	GRILLE-RADIATOR	510	510	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:45:21.923344+02	\N	2011-03-28 23:45:13.155785+02	2011-03-28 23:45:21.928408+02	
986	4	17	17	96	C2S20488	\N			1	\N	\N	3	19	1	молдинг	VANE-SPLITTER	67.459999999999994	67.459999999999994	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:45:21.935248+02	\N	2011-03-28 23:45:13.180233+02	2011-03-28 23:45:21.940247+02	
987	4	17	17	96	C2S17101	\N			1	\N	\N	3	19	1	фара правая	HEADLAMP	415.80000000000001	415.80000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:45:21.94373+02	\N	2011-03-28 23:45:13.18813+02	2011-03-28 23:45:21.949567+02	
988	4	17	17	96	C2S8244XXX	\N			1	\N	\N	3	19	1	облицовка бампера переднего	COVER-BUMPER	720	720	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:45:21.953231+02	\N	2011-03-28 23:45:13.192677+02	2011-03-28 23:45:21.957759+02	
989	4	17	17	96	C2S11801	\N			1	\N	\N	3	19	1	накладка бампера переднего прав хром	MOULDING	109	109	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:45:21.960546+02	\N	2011-03-28 23:45:13.19687+02	2011-03-28 23:45:21.965167+02	
990	4	17	17	96	C2S10230	\N			1	\N	\N	3	19	1	крыло переднее правое	PANEL-WING	386.39999999999998	386.39999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:45:21.9684+02	\N	2011-03-28 23:45:13.201041+02	2011-03-28 23:45:21.973216+02	
991	4	17	17	96	C2S6510	\N			1	\N	\N	3	19	1	капот	PANEL-BONNET	715	715	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:45:21.975893+02	\N	2011-03-28 23:45:13.205363+02	2011-03-28 23:45:21.980758+02	
992	4	17	17	96	C2S3065	\N			1	\N	\N	3	19	1	форсунка омывателя фары прав	JET-POWERWASH	86.359999999999999	86.359999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:45:21.983991+02	\N	2011-03-28 23:45:13.209766+02	2011-03-28 23:45:21.988788+02	
993	4	17	17	96	C2S8804	\N			1	\N	\N	3	19	1	направляющая бампера переднего прав	BRACKET-BUMPER	27.5	27.5	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:45:21.992043+02	\N	2011-03-28 23:45:13.214014+02	2011-03-28 23:45:21.998073+02	
994	4	17	17	96	C2S3994	\N			1	\N	\N	3	19	1	подкрылок колеса переднего прав	LINER-WHEELARCH	226.5	226.5	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:45:22.000728+02	\N	2011-03-28 23:45:13.218534+02	2011-03-28 23:45:22.005584+02	
1005	4	11	11	97	8L8Z13405A	\N			1	\N	\N	77	1	2	фонарь левый	taillamp left	72.219999999999999	77	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:56:45.577034+02	\N	2011-03-28 23:56:22.87355+02	2011-03-28 23:56:45.582204+02	
1006	4	2	2	97	12342RYE004	\N			6	\N	\N	59	3	2	кольца свечных колодцев	tube gasket	2.6299999999999999	2.6299999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:56:45.586242+02	\N	2011-03-28 23:56:22.89307+02	2011-03-28 23:56:45.590721+02	
1007	4	2	2	97	17220RYEA00	\N			1	\N	\N	59	3	2	фильтр возд	air filter	24.780000000000001	24.780000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:56:45.593238+02	\N	2011-03-28 23:56:22.900227+02	2011-03-28 23:56:45.600753+02	
1008	4	2	2	97	80292SHJA41	\N			1	\N	\N	59	3	2	фильтр салона	air filter	36.009999999999998	36.009999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:56:45.603298+02	\N	2011-03-28 23:56:22.907481+02	2011-03-28 23:56:45.607457+02	
1009	4	13	13	97	84251TA0A01ZC	\N			1	\N	\N	15	9	2	накладка порога	sill plate left	10.02	11	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:56:45.610359+02	\N	2011-03-28 23:56:22.916534+02	2011-03-28 23:56:45.614604+02	
1010	4	11	11	97	3C2Z8005A	\N			1	\N	\N	78	1	2	радиатор	radiator	301.31999999999999	454	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:56:45.617193+02	\N	2011-03-28 23:56:22.925086+02	2011-03-28 23:56:45.621259+02	
1011	4	2	2	97	13210RYEA00	\N			2	\N	\N	59	3	2	шатун 	connecting rod	46.920000000000002	46.920000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:56:45.62353+02	\N	2011-03-28 23:56:22.931192+02	2011-03-28 23:56:45.627559+02	
1012	4	2	2	97	13010RYEA00	\N			1	\N	\N	59	3	2	поршень	piston	79.200000000000003	79.200000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:56:45.630125+02	\N	2011-03-28 23:56:22.93556+02	2011-03-28 23:56:45.634314+02	
1013	4	2	2	97	12251RYEA01	\N			2	\N	\N	59	3	2	прокладка	gasket	42.350000000000001	42.350000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:56:45.637237+02	\N	2011-03-28 23:56:22.939991+02	2011-03-28 23:56:45.641548+02	
1014	4	2	2	97	15825P8AA01	\N			1	\N	\N	59	3	2	прокладка масл насоса	filter	10.58	10.58	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:56:45.64408+02	\N	2011-03-28 23:56:22.944284+02	2011-03-28 23:56:45.648311+02	
1015	4	2	2	97	15400PLMA01	\N			1	\N	\N	59	3	2	масл фильтр	oil filter	7.04	7.04	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:56:45.650618+02	\N	2011-03-28 23:56:22.94842+02	2011-03-28 23:56:45.655284+02	
1016	4	2	2	97	19411P8AA03	\N			1	\N	\N	59	3	2	прокладка EGR	gasket 	3.8199999999999998	3.8199999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:56:45.657802+02	\N	2011-03-28 23:56:22.95257+02	2011-03-28 23:56:45.661864+02	
1017	4	2	2	97	14400RCAA01	\N			1	\N	\N	59	3	2	ремень ГРМ	timing belt	55.869999999999997	55.869999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:56:45.664236+02	\N	2011-03-28 23:56:22.956913+02	2011-03-28 23:56:45.668388+02	
1018	7	48	59	98	380317813722	\N			1	\N	\N	58	3	2	датчики давления	tire pressure sensors	52	72.799999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-28 23:58:18.052455+02	\N	2011-03-28 23:58:09.832886+02	2011-03-28 23:58:18.057375+02	
1019	5	62	92	99	6712NA	\N		national	1	\N	\N	18	2	2	сальник АКПП	seal	2.96	14	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:03:02.865936+02	\N	2011-03-29 00:02:52.703449+02	2011-03-29 00:03:02.870703+02	
1020	5	62	71	99	9170PT1	\N		fel-pro	1	\N	\N	79	1	2	прокладка ГБЦ	gasket	20.75	34	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:03:02.873537+02	\N	2011-03-29 00:02:52.713868+02	2011-03-29 00:03:02.878768+02	
1021	5	46	62	99	FP51	\N		ЗАКАЗАНО	1	\N	\N	77	2	2	фильтр	filter	10.029999999999999	17	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:03:02.881019+02	\N	2011-03-29 00:02:52.724452+02	2011-03-29 00:03:02.885203+02	
1022	5	46	62	99	FP66	\N		ЗАКАЗАНО	1	\N	\N	77	2	2	фильтр салона	filter	10.029999999999999	17	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:03:02.887625+02	\N	2011-03-29 00:02:52.731791+02	2011-03-29 00:03:02.891719+02	
1023	5	46	62	99	MCS104132	\N		ЗАКАЗАНО	2	\N	\N	78	2	2	шаровая передняя верхняя	ball joint upper	27.34	45	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:03:02.896037+02	\N	2011-03-29 00:02:52.742411+02	2011-03-29 00:03:02.900397+02	
1024	5	46	62	99	MCS104173	\N		ЗАКАЗАНО	2	\N	\N	78	2	2	шаровая передняя нижняя	ball joint lower	33.460000000000001	55	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:03:02.903713+02	\N	2011-03-29 00:02:52.749561+02	2011-03-29 00:03:02.907767+02	
1025	5	46	62	99	BRC7RM	\N		ЗАКАЗАНО	1	\N	\N	78	2	2	суппорт передний левый	caliper left	107.05	203	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:03:02.911574+02	\N	2011-03-29 00:02:52.75618+02	2011-03-29 00:03:02.915653+02	
1026	6	58	13	100	17210-MCA-A60	\N		honda	1	\N	\N	36	4	1	фильтр воздушный	air filter	22.510000000000002	22.510000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:18:36.104543+02	\N	2011-03-29 00:18:26.543981+02	2011-03-29 00:18:36.111133+02	
1027	6	58	13	100	18330-MEL-D00	\N		honda	1	\N	\N	36	4	1	накладка	cover	12.69	12.69	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:18:36.122502+02	\N	2011-03-29 00:18:26.554532+02	2011-03-29 00:18:36.126542+02	
1028	6	58	13	100	53166-MY9-890	\N		honda	1	\N	\N	36	4	1	рукоятка	grip	14.529999999999999	14.529999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:18:36.128985+02	\N	2011-03-29 00:18:26.559212+02	2011-03-29 00:18:36.132968+02	
1029	6	58	13	100	33181-MEL-000	\N		honda	1	\N	\N	36	4	1	стекло габарита	lens	16.07	16.07	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:18:36.135342+02	\N	2011-03-29 00:18:26.56458+02	2011-03-29 00:18:36.139733+02	
1030	6	58	13	100	91254-MEJ-003	\N		honda	2	\N	\N	36	4	1	пыльники	seal	9.0399999999999991	9.0399999999999991	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:18:36.154768+02	\N	2011-03-29 00:18:26.572629+02	2011-03-29 00:18:36.158889+02	
1031	6	58	13	100	24705-MR7-000	\N		honda	2	\N	\N	36	4	1	переключатель	pin	3.04	3.04	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:18:36.161391+02	\N	2011-03-29 00:18:26.579039+02	2011-03-29 00:18:36.166285+02	
1032	6	58	13	100	17260-MEL-D20	\N		honda	1	\N	\N	36	4	1	решётка	grille	3.5600000000000001	3.5600000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:18:36.168641+02	\N	2011-03-29 00:18:26.586615+02	2011-03-29 00:18:36.17268+02	
1033	6	58	13	100	17257-MEL-D20	\N		honda	1	\N	\N	36	4	1	крышка	cover	9.3599999999999994	9.3599999999999994	\N	\N	\N	\N	\N	in_processing	2011-03-29 00:18:36.175002+02	\N	2011-03-29 00:18:26.593001+02	2011-03-29 00:18:36.179058+02	
1034	2	78	93	15	32212	\N			2	\N	\N	80	1	2	Амортизатор задний	-	36.93	48	\N	\N	\N	\N	\N	issued	2011-04-05 12:40:21.327246+02	in_processing	2011-03-29 11:03:27.664882+02	2011-04-05 12:40:21.332431+02	150
1035	2	66	93	15	32066	\N			2	\N	\N	80	1	2	Амортизатор передний	-	31	41	\N	\N	\N	\N	\N	issued	2011-04-05 12:40:05.680806+02	in_processing	2011-03-29 11:03:27.693131+02	2011-04-05 12:40:05.686014+02	149
1036	2	74	26	15	54613AL524	\N			2	\N	\N	31	8	1	Втулка стабилизатора	-	3.8700000000000001	5	\N	\N	\N	\N	\N	issued	2011-04-05 11:40:46.374893+02	in_processing	2011-03-29 11:06:22.316955+02	2011-04-05 12:39:34.830688+02	147
1037	2	74	26	15	54618AL502	\N			1	\N	\N	31	8	1	Стойка стабилизатора	-	15.76	17	\N	\N	\N	\N	\N	issued	2011-04-05 11:40:52.815552+02	in_processing	2011-03-29 11:06:22.333628+02	2011-04-05 12:39:32.418337+02	147
1038	2	74	26	15	54668AL502	\N			1	\N	\N	31	8	1	Стойка стабилизатора	-	16.050000000000001	17	\N	\N	\N	\N	\N	issued	2011-04-05 11:41:02.349074+02	in_processing	2011-03-29 11:06:22.337863+02	2011-04-05 12:38:40.563167+02	147
1039	1	79	8	16	53013 775AA	\N	14 8,23		1	\N	\N	31	9	1	Крышка маслозаливной горловины	-	8.2300000000000004	10	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:14:10.917526+02	\N	2011-03-29 11:14:02.833748+02	2011-03-29 11:14:10.922568+02	
1040	4	11	11	101	1C2Z4676AA	\N			1	\N	\N	78	3	2	сальник  	pinion seal	19.98	21	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.253946+02	\N	2011-03-29 11:18:13.838816+02	2011-03-29 11:25:21.259076+02	
1041	4	11	11	101	E8UZ4670A	\N			1	\N	\N	78	3	2	кольцо	washer	2.6699999999999999	3	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.27011+02	\N	2011-03-29 11:18:13.855924+02	2011-03-29 11:25:21.274363+02	
1042	4	11	11	101	B5A4621B	\N			1	\N	\N	78	3	2	подшипник	front pinion bearing	40.32	43	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.276677+02	\N	2011-03-29 11:18:13.86061+02	2011-03-29 11:25:21.280931+02	
1043	4	11	11	101	B5A4616B	\N			1	\N	\N	78	3	2	обойма подшипника	front pinion bearing cup	64.120000000000005	68	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.283264+02	\N	2011-03-29 11:18:13.867962+02	2011-03-29 11:25:21.287702+02	
1044	4	11	11	101	F7UZ4067AE	\N			1	\N	\N	78	3	2	набор колец	kit shim	148.31999999999999	157	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.292415+02	\N	2011-03-29 11:18:13.873321+02	2011-03-29 11:25:21.296571+02	
1045	4	11	11	101	B6D4616A	\N			1	\N	\N	78	3	2	обойма подшипника	cup	44.600000000000001	47	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.298866+02	\N	2011-03-29 11:18:13.877831+02	2011-03-29 11:25:21.303784+02	
1046	4	11	11	101	B5D4630A	\N			1	\N	\N	78	3	2	подшипник	bearing	62.130000000000003	66	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.306265+02	\N	2011-03-29 11:18:13.882595+02	2011-03-29 11:25:21.311656+02	
1047	4	11	11	101	TCAA1244A	\N			2	\N	\N	78	3	2	подшипник 	side bearings	41.630000000000003	22	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.314284+02	\N	2011-03-29 11:18:13.886819+02	2011-03-29 11:25:21.319115+02	
1048	4	11	11	101	F8UZ4222AA	\N			2	\N	\N	78	3	2	подшипник	side bearings	31.629999999999999	17	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.321691+02	\N	2011-03-29 11:18:13.891223+02	2011-03-29 11:25:21.326686+02	
1049	4	11	11	101	1C2Z4676AA	\N			1	\N	\N	78	4	2	сальник  	pinion seal	19.98	21	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.329328+02	\N	2011-03-29 11:18:58.816028+02	2011-03-29 11:25:21.334184+02	
1050	4	11	11	101	E8UZ4670A	\N			1	\N	\N	78	4	2	кольцо	washer	2.6699999999999999	3	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.336801+02	\N	2011-03-29 11:18:58.821868+02	2011-03-29 11:25:21.341446+02	
1051	4	11	11	101	B5A4621B	\N			1	\N	\N	78	4	2	подшипник	front pinion bearing	40.32	43	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.344626+02	\N	2011-03-29 11:18:58.826373+02	2011-03-29 11:25:21.348909+02	
1052	4	11	11	101	B5A4616B	\N			1	\N	\N	78	4	2	обойма подшипника	front pinion bearing cup	64.120000000000005	68	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.351878+02	\N	2011-03-29 11:18:58.832165+02	2011-03-29 11:25:21.356054+02	
1053	4	11	11	101	F7UZ4067AE	\N			1	\N	\N	78	4	2	набор колец	kit shim	148.31999999999999	157	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.358349+02	\N	2011-03-29 11:18:58.837103+02	2011-03-29 11:25:21.362728+02	
1054	4	11	11	101	B6D4616A	\N			1	\N	\N	78	4	2	обойма подшипника	cup	44.600000000000001	47	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.36523+02	\N	2011-03-29 11:18:58.841738+02	2011-03-29 11:25:21.369573+02	
1055	4	11	11	101	B5D4630A	\N			1	\N	\N	78	4	2	подшипник	bearing	62.130000000000003	66	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.372009+02	\N	2011-03-29 11:18:58.847503+02	2011-03-29 11:25:21.376251+02	
1056	4	11	11	101	TCAA1244A	\N			2	\N	\N	78	4	2	подшипник 	side bearings	41.630000000000003	22	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.378529+02	\N	2011-03-29 11:18:58.852485+02	2011-03-29 11:25:21.383001+02	
1057	4	11	11	101	F8UZ4222AA	\N			2	\N	\N	78	4	2	подшипник	side bearings	31.629999999999999	17	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.386263+02	\N	2011-03-29 11:18:58.857784+02	2011-03-29 11:25:21.390797+02	
1058	6	50	79	101	2040-0344	\N			1	\N	\N	36	5	1	молдинги	molding	159.94999999999999	159.94999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.393473+02	\N	2011-03-29 11:24:38.382028+02	2011-03-29 11:25:21.397851+02	
1059	6	50	79	101	1405-0016	\N			1	\N	\N	36	5	1	накладка	cover	29.949999999999999	29.949999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.400068+02	\N	2011-03-29 11:24:38.38804+02	2011-03-29 11:25:21.404359+02	
1060	6	50	79	101	0521-0319	\N			1	\N	\N	36	5	1	накладка	cover	49.950000000000003	49.950000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.407613+02	\N	2011-03-29 11:24:38.392328+02	2011-03-29 11:25:21.412545+02	
1061	6	50	79	101	32-110	\N			2	\N	\N	36	5	1	крепежный набор	mounting kit	14.949999999999999	14.949999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:25:21.415073+02	\N	2011-03-29 11:24:38.398043+02	2011-03-29 11:25:21.419511+02	
1062	4	11	11	102	F7UZ4067AE	\N			1	\N	\N	78	5	2	набор колец	kit shim	148.31999999999999	157	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:35:45.801987+02	\N	2011-03-29 11:29:06.708475+02	2011-03-29 11:35:45.806846+02	
1063	4	26	26	102	165541AA0A	\N			1	\N	\N	19	4	1	воздухозаборник	Air inlet duct	70.769999999999996	70.769999999999996	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:35:45.809769+02	\N	2011-03-29 11:30:16.976589+02	2011-03-29 11:35:45.814014+02	
1064	4	26	26	102	140411AA1A	\N			1	\N	\N	19	4	1	накладка	Cover	128.88	128.88	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:35:45.816393+02	\N	2011-03-29 11:30:16.987892+02	2011-03-29 11:35:45.820715+02	
1065	4	26	26	102	21710JP10A	\N			1	\N	\N	19	4	1	бачёк расширительный	Cooling  Reservoir	76.319999999999993	76.319999999999993	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:35:45.82322+02	\N	2011-03-29 11:30:16.992856+02	2011-03-29 11:35:45.827503+02	
1066	4	47	8	102	5189837AA	\N			1	\N	\N	6	7	1	крышка акпп	oil pan	48	40.799999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-29 11:35:45.829793+02	\N	2011-03-29 11:35:28.504816+02	2011-03-29 11:35:45.834052+02	
1067	5	62	87	103	CH1146102	\N	VARIOUS		1	\N	\N	51	1	2	молдинг левый хром	molding	31.98	52	\N	\N	\N	\N	\N	in_processing	2011-03-29 12:04:11.757143+02	\N	2011-03-29 12:03:43.994811+02	2011-03-29 12:04:11.762185+02	
1068	5	62	73	103	 Z135	\N	ATP		1	\N	\N	18	3	2	маховик 	flywheel	46.590000000000003	94	\N	\N	\N	\N	\N	in_processing	2011-03-29 12:04:11.774263+02	\N	2011-03-29 12:03:44.01411+02	2011-03-29 12:04:11.77893+02	
1069	5	62	72	103	34120	\N	BENDIX		2	\N	\N	81	1	2	торм цилиндр	 wheel cylinder	13.06	15	\N	\N	\N	\N	\N	in_processing	2011-03-29 12:04:11.781417+02	\N	2011-03-29 12:03:44.024253+02	2011-03-29 12:04:11.785763+02	
1070	7	48	59	104	170603485676	\N			1	\N	\N	10	6	2	датчик	сенсор	47.939999999999998	62.32	\N	\N	\N	\N	\N	in_processing	2011-03-29 12:05:17.311146+02	\N	2011-03-29 12:04:58.535418+02	2011-03-29 12:05:17.316188+02	
1071	4	31	31	105	32007582	\N			1	\N	\N	82	1	2	заглушка противотуманки правой	cover fog 	40.170000000000002	43	\N	\N	\N	\N	\N	in_processing	2011-03-29 12:15:13.746414+02	\N	2011-03-29 12:08:06.544068+02	2011-03-29 12:15:13.75153+02	
1073	4	2	2	105	08P21STX2M004	\N			1	\N	\N	4	19	1	накладка	FENDER GARNISH, L	65.329999999999998	57.490000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-29 12:15:13.761569+02	\N	2011-03-29 12:11:41.448027+02	2011-03-29 12:15:13.765918+02	
1074	4	13	13	105	74222TK6A00	\N			1	\N	\N	4	19	1	крышка	 COVER	9.3699999999999992	8.2400000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-29 12:15:13.768271+02	\N	2011-03-29 12:11:41.453104+02	2011-03-29 12:15:13.773106+02	
1075	6	49	94	106	60-0222	\N			1	\N	\N	36	6	1	зеркало	mirror	23.949999999999999	23.949999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:22:35.142145+02	\N	2011-03-29 12:26:08.870416+02	2011-03-29 13:22:35.148055+02	
1076	6	49	94	106	20-3171	\N			1	\N	\N	36	6	1	стекло лоб	windshield	92.950000000000003	92.950000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:22:35.152783+02	\N	2011-03-29 12:26:08.877938+02	2011-03-29 13:22:35.157862+02	
1077	6	49	94	106	21-3782	\N			1	\N	\N	36	6	1	рукаятки	grips	24.449999999999999	24.449999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:22:35.161567+02	\N	2011-03-29 12:26:08.883877+02	2011-03-29 13:22:35.166412+02	
1078	6	49	94	106	41-3194	\N			1	\N	\N	42	2	1	ремень	belt	84.950000000000003	84.950000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:22:35.169157+02	\N	2011-03-29 12:26:08.895052+02	2011-03-29 13:22:35.173976+02	
1079	2	77	63	17	PGD655M	\N			2	\N	\N	78	6	2	Колодки тормозные передние	-	51.979999999999997	66	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:26:03.012689+02	\N	2011-03-29 13:25:56.572549+02	2011-03-29 13:26:03.017442+02	
1080	4	13	13	107	39055SEPA01	\N			1	\N	\N	34	4	2	лампочка	light	4.4500000000000002	5	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.142163+02	\N	2011-03-29 13:26:38.658086+02	2011-03-29 13:37:05.146944+02	
1081	4	13	13	107	39055SEPA11	\N			1	\N	\N	34	4	2	лампочка	light	4.4500000000000002	5	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.151554+02	\N	2011-03-29 13:26:38.663849+02	2011-03-29 13:37:05.155623+02	
1082	4	2	2	107	50377STKA00	\N			1	\N	\N	5	17	1	кронштейн подрамника левый	bracket	21.829999999999998	21.100000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.157815+02	\N	2011-03-29 13:29:36.725904+02	2011-03-29 13:37:05.161806+02	
1083	4	2	2	107	33555STKA01	\N			1	\N	\N	5	17	1	световозвращатель задн левый	Reflector	27.199999999999999	26.289999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.164094+02	\N	2011-03-29 13:29:36.743033+02	2011-03-29 13:37:05.169502+02	
1084	4	2	2	107	71598STKA00	\N			1	\N	\N	5	17	1	крепление заднего бампера левое	bracket	5.5	5.3200000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.175854+02	\N	2011-03-29 13:29:36.747467+02	2011-03-29 13:37:05.181882+02	
1085	4	2	2	107	76630STKA01	\N			2	\N	\N	5	17	1	щётка лобового стекла правая	wiper blade	20.27	19.59	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.185414+02	\N	2011-03-29 13:29:36.754835+02	2011-03-29 13:37:05.1922+02	
1086	4	2	2	107	76620STKA01	\N			4	\N	\N	5	17	1	щётка лобового стекла левая	wiper blade	26.649999999999999	25.760000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.195009+02	\N	2011-03-29 13:29:36.76157+02	2011-03-29 13:37:05.199348+02	
1087	4	2	2	107	42017STKA01	\N			1	\N	\N	5	17	1	пыльник ШРУС	boot kit	30.170000000000002	29.16	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.201773+02	\N	2011-03-29 13:29:36.76861+02	2011-03-29 13:37:05.206056+02	
1088	4	2	2	107	52372STKA00	\N			1	\N	\N	5	17	1	продольный рычаг задн лев	arm	118.97	21.100000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.209619+02	\N	2011-03-29 13:29:36.775883+02	2011-03-29 13:37:05.213918+02	
1089	4	2	2	107	18215SMGE11	\N			4	\N	\N	5	17	1	крепление глушителя	mount	6.1500000000000004	5.9400000000000004	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.216275+02	\N	2011-03-29 13:29:36.78284+02	2011-03-29 13:37:05.220485+02	
1090	4	2	2	107	52315STKA01	\N			1	\N	\N	5	17	1	втулка стабилизатора заднего	bushing	1.05	1.01	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.222885+02	\N	2011-03-29 13:29:36.790329+02	2011-03-29 13:37:05.227398+02	
1091	4	2	2	107	75313STKA01ZA	\N			2	\N	\N	5	17	1	накладка двери задней правой	door cover	67.620000000000005	65.359999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.230238+02	\N	2011-03-29 13:29:36.797542+02	2011-03-29 13:37:05.234699+02	
1092	4	2	2	107	71503S0X000ZW	\N			4	\N	\N	5	17	1	заглушка бампера заднего	cover	3.1000000000000001	3	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.237241+02	\N	2011-03-29 13:29:36.8056+02	2011-03-29 13:37:05.241658+02	
1093	4	2	2	107	33506STKA01	\N			2	\N	\N	5	17	1	заглушка фонаря заднего	cover	3.1699999999999999	3.0600000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.244174+02	\N	2011-03-29 13:29:36.810186+02	2011-03-29 13:37:05.248484+02	
1094	4	2	2	107	33505STKA01	\N			1	\N	\N	5	17	1	световозвращатель задн правый	Reflector	27.199999999999999	26.289999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.251935+02	\N	2011-03-29 13:29:36.816193+02	2011-03-29 13:37:05.256404+02	
1095	4	11	11	107	7L2Z8A616A	\N			1	\N	\N	5	18	2	вискомуфта	clutch	330.72000000000003	319.6640304	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.259565+02	\N	2011-03-29 13:34:47.444859+02	2011-03-29 13:37:05.263999+02	
1096	4	11	11	107	6L2Z8600BA	\N			1	\N	\N	5	18	2	вентилятор	blade	62.200000000000003	60.119999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.266523+02	\N	2011-03-29 13:34:47.452772+02	2011-03-29 13:37:05.270895+02	
1097	4	11	11	107	6L2Z1000154AA	\N			1	\N	\N	5	19	1	подушка подрамника верх	mount	25.530000000000001	24.676532099999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.274272+02	\N	2011-03-29 13:36:37.463226+02	2011-03-29 13:37:05.278687+02	
1098	4	11	11	107	6L2Z1000155AA	\N			1	\N	\N	5	19	1	подушка подрамника низ	mount	17.170000000000002	16.600000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.281193+02	\N	2011-03-29 13:36:37.485816+02	2011-03-29 13:37:05.28579+02	
1099	4	11	11	107	W710231S439	\N			1	\N	\N	5	19	1	болт	bolt	7	6.7699999999999996	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.289226+02	\N	2011-03-29 13:36:37.492633+02	2011-03-29 13:37:05.293783+02	
1100	4	11	11	107	1L2Z17K707CB	\N			1	\N	\N	4	20	1	стекло зеркала	стекло зеркала	36.380000000000003	32.009999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.296281+02	\N	2011-03-29 13:36:37.503076+02	2011-03-29 13:37:05.300853+02	
1101	4	11	11	107	8S4Z17683CA	\N			1	\N	\N	4	20	1	зеркало	зеркало	82.109999999999999	72.25	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.303329+02	\N	2011-03-29 13:36:37.51009+02	2011-03-29 13:37:05.307779+02	
1102	4	33	33	107	57497AG10A	\N			1	\N	\N	6	8	1	ключ	key	14.93	10.779999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.311192+02	\N	2011-03-29 13:36:37.520108+02	2011-03-29 13:37:05.31573+02	
1103	4	35	35	107	657700C060	\N			1	\N	\N	4	20	1	поводок	Stay Stay Right	37.409999999999997	32.920000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.318289+02	\N	2011-03-29 13:36:37.524932+02	2011-03-29 13:37:05.322961+02	
1104	4	35	35	107	657700C070	\N			1	\N	\N	4	20	1	поводок	Stay Stay Left	37.409999999999997	32.920000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:37:05.326261+02	\N	2011-03-29 13:36:37.529774+02	2011-03-29 13:37:05.330817+02	
1105	7	48	59	108	180634442986	\N			1	\N	\N	41	2	1	решётка радиатора	grille	73.75	92.180000000000007	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:55:12.351743+02	\N	2011-03-29 13:55:04.824047+02	2011-03-29 13:55:12.356474+02	
1108	7	48	59	108	260731687828	\N			1	\N	\N	5	20	1	бампер	bumper	190	247.94999999999999	\N	3.4300000000000002	44.590000000000003	292.53999999999996	292.53999999999996	received_office	2011-04-03 16:34:24.500322+02	in_processing	2011-03-29 13:55:04.863803+02	2011-04-03 16:34:24.505552+02	#103
1107	7	48	59	108	400197789299	\N			1	\N	\N	5	20	1	бампер	bumper	113	147.46000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 13:55:12.366042+02	\N	2011-03-29 13:55:04.858204+02	2011-03-29 13:55:12.370145+02	
1115	4	35	35	109	5320108032	\N			2	\N	\N	5	21	2	рамка крепления радиаторов	radiator support	366.26999999999998	354.02999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:03:44.762265+02	\N	2011-03-29 14:03:38.277543+02	2011-03-29 14:03:44.76722+02	
1116	4	35	35	109	53114AE010J0	\N			1	\N	\N	5	21	2	решетка радиатора голубая	grille	101.72	98.319999999999993	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:03:44.770763+02	\N	2011-03-29 14:03:38.294702+02	2011-03-29 14:03:44.774905+02	
1117	4	35	35	109	53114AE010A1	\N			1	\N	\N	5	21	2	решетка радиатора белая	grille	101.72	98.319999999999993	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:03:44.778916+02	\N	2011-03-29 14:03:38.29922+02	2011-03-29 14:03:44.783246+02	
1118	4	35	35	109	52115AE010	\N			1	\N	\N	5	21	2	кронштейн бампера боковой прав	bracket	18.149999999999999	17.539999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:03:44.785468+02	\N	2011-03-29 14:03:38.303929+02	2011-03-29 14:03:44.790368+02	
1119	4	35	35	109	52116AE010	\N			1	\N	\N	5	21	2	кронштейн бампера боковой лев	bracket	18.149999999999999	17.539999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:03:44.792718+02	\N	2011-03-29 14:03:38.308699+02	2011-03-29 14:03:44.797079+02	
1120	4	35	35	109	177520P050	\N			1	\N	\N	5	21	2	воздухозаборник	air intake	68.930000000000007	66.629999999999995	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:03:44.799606+02	\N	2011-03-29 14:03:38.31304+02	2011-03-29 14:03:44.803889+02	
1122	5	61	60	110	T043C	\N		ЗАКАЗАНО	1	\N	\N	5	22	2	петля капота прав	hingle	15	22.190000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:07:42.076498+02	\N	2011-03-29 14:07:33.991892+02	2011-03-29 14:07:42.088297+02	
1121	5	61	60	110	T0430	\N		ЗАКАЗАНО	2	\N	\N	5	22	2	капот	hood	120	177.47999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:07:42.052797+02	\N	2011-03-29 14:07:33.979247+02	2011-03-29 14:07:42.061617+02	
1123	5	61	60	110	T043D	\N		ЗАКАЗАНО	1	\N	\N	5	22	2	петля капота лев	hingle	15	22.190000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:07:42.092048+02	\N	2011-03-29 14:07:34.003927+02	2011-03-29 14:07:42.102094+02	
1124	5	61	60	110	TS520	\N		ЗАКАЗАНО	1	\N	\N	5	22	2	усилитель бампера	reinforsment	52	94.659999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:07:42.105797+02	\N	2011-03-29 14:07:34.009199+02	2011-03-29 14:07:42.113148+02	
1125	5	61	60	110	T0387	\N		ЗАКАЗАНО	1	\N	\N	5	22	2	пена бампера	foam	45	66.560000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:07:42.11689+02	\N	2011-03-29 14:07:34.018568+02	2011-03-29 14:07:42.123758+02	
1126	5	61	60	110	T0100	\N		ЗАКАЗАНО	1	\N	\N	5	22	2	бампер передний	bumper	79	124.23999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:07:42.12738+02	\N	2011-03-29 14:07:34.025532+02	2011-03-29 14:07:42.134832+02	
1127	5	61	60	110	T053F	\N		ЗАКАЗАНО	1	\N	\N	5	22	2	фонарь задний левый	taillight	79	116.84	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:07:42.139684+02	\N	2011-03-29 14:07:34.032288+02	2011-03-29 14:07:42.146991+02	
1128	5	61	60	110	T0565	\N		ЗАКАЗАНО	1	\N	\N	5	22	2	подложка решётки радиатора	grille inner	43	63.600000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:07:42.150692+02	\N	2011-03-29 14:07:34.042536+02	2011-03-29 14:07:42.157914+02	
1129	4	26	26	111	244201AA0A	\N			1	\N	\N	19	5	1	Кронштейн крепления аккамулятора	bracket	11.17	11.17	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:22:15.186326+02	\N	2011-03-29 14:11:10.47813+02	2011-03-29 14:22:15.191339+02	
1130	4	26	26	111	244258991A	\N			1	\N	\N	19	5	1	болт	bolt	3.3799999999999999	3.3300000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:22:15.194792+02	\N	2011-03-29 14:11:10.497534+02	2011-03-29 14:22:15.198812+02	
1131	4	23	23	111	L32114302A9U 	\N			10	\N	\N	3	21	1	Фильтр масляный	OIL FILTER	8.2899999999999991	6.7999999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:22:15.201127+02	\N	2011-03-29 14:11:10.506305+02	2011-03-29 14:22:15.205472+02	
1132	4	23	23	111	AJ9510235 	\N			1	\N	\N	3	21	1	Прокладка клапанной крышки	GASKET,HEAD COVER	10.220000000000001	8.3900000000000006	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:22:15.207912+02	\N	2011-03-29 14:11:10.513791+02	2011-03-29 14:22:15.212348+02	
1133	4	23	23	111	AJ95102D5	\N			1	\N	\N	3	21	1	Прокладка клапанной крышки	GASKET L ,HEAD COVER	14.470000000000001	11.869999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:22:15.214866+02	\N	2011-03-29 14:11:10.520446+02	2011-03-29 14:22:15.219155+02	
1134	4	23	23	111	EC0143980D	\N			4	\N	\N	3	21	1	Шланг тормозной	HOSE- FLEX	14.65	12.02	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:22:15.223723+02	\N	2011-03-29 14:11:10.52788+02	2011-03-29 14:22:15.228003+02	
1135	4	23	23	111	EC0344410A	\N			1	\N	\N	3	21	1	Трос ручника	CABLE R ,R.-PARK.	69.25	56.789999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:22:15.230484+02	\N	2011-03-29 14:11:10.535675+02	2011-03-29 14:22:15.235193+02	
1136	4	23	23	111	GY0918140	\N			1	\N	\N	3	21	1	Провода высоковольтные	CORD SET, HI. TENSIO	86.819999999999993	71.200000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:22:15.237917+02	\N	2011-03-29 14:11:10.542378+02	2011-03-29 14:22:15.242624+02	
1137	4	23	23	111	EC0134156H	\N			2	\N	\N	3	21	1	Втулка стабилизатора переднего	RUBBER,FRT STABILIZE	7.7199999999999998	6.3399999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:22:15.245383+02	\N	2011-03-29 14:11:10.549339+02	2011-03-29 14:22:15.250109+02	
1138	4	12	29	112	88973370	\N			1	\N	\N	73	3	2	решетка рад правая	grille right	71.620000000000005	76	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:29:34.065196+02	\N	2011-03-29 14:28:36.612679+02	2011-03-29 14:29:34.069976+02	
1139	4	12	29	112	88973371	\N			1	\N	\N	73	3	2	решетка рад левая	grille left	69.239999999999995	73	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:29:34.073362+02	\N	2011-03-29 14:28:36.649122+02	2011-03-29 14:29:34.07741+02	
1140	4	47	8	112	4389744AA	\N			1	\N	\N	73	3	2	панель фонаря правая	taillamp mount right	57.450000000000003	61	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:29:34.079704+02	\N	2011-03-29 14:28:36.65524+02	2011-03-29 14:29:34.084056+02	
1141	4	15	15	112	622561BA2A	\N			1	\N	\N	84	1	2	решетка в бампер правая	grille right	60.68	64	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:29:34.087056+02	\N	2011-03-29 14:28:36.663959+02	2011-03-29 14:29:34.091456+02	
1142	4	15	15	112	622571BA2A	\N			1	\N	\N	84	1	2	решетка в бампер левая	grille left	63.630000000000003	67	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:29:34.094205+02	\N	2011-03-29 14:28:36.671084+02	2011-03-29 14:29:34.098478+02	
1143	4	47	8	112	82209621	\N			1	\N	\N	83	1	2	задние брызговики	splash	44.850000000000001	48	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:29:34.102615+02	\N	2011-03-29 14:28:36.679392+02	2011-03-29 14:29:34.106937+02	
1144	4	15	15	112	260601BA0A	\N			1	\N	\N	84	1	2	фара левая	headlamp left	366.16000000000003	388	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:29:34.10942+02	\N	2011-03-29 14:28:36.686855+02	2011-03-29 14:29:34.113998+02	
1145	5	61	60	113	P0100	\N		ЗАКАЗАНО	1	\N	\N	73	4	2	решетка бампера центр	grille center	18	29	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:31:38.192353+02	\N	2011-03-29 14:31:31.380083+02	2011-03-29 14:31:38.197172+02	
1146	4	11	11	114	W710528S300	\N			14	\N	\N	74	4	1	пистон	clip	1.95	1.7549999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.412087+02	\N	2011-03-29 14:36:26.864259+02	2011-03-29 14:40:23.416924+02	
1147	4	23	23	114	LFH115940A	\N			2	\N	\N	3	22	1	Ролик	PULLEY-IDLE	53.490000000000002	43.865000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.4289+02	\N	2011-03-29 14:36:26.889898+02	2011-03-29 14:40:23.444345+02	
1148	4	23	23	114	GD7A3438X	\N			10	\N	\N	3	22	1	Подшипник поворотный амортизатора	BUSHING,MTG. RUBBER	3.4700000000000002	2.8460000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.449656+02	\N	2011-03-29 14:36:26.896487+02	2011-03-29 14:40:23.454924+02	
1149	4	23	23	114	GY0115171	\N			2	\N	\N	3	22	1	термостат	THERMOSTAT NO GASKET	20.620000000000001	16.91	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.45744+02	\N	2011-03-29 14:36:26.90339+02	2011-03-29 14:40:23.469401+02	
1150	4	23	23	114	AJF81389Y	\N			1	\N	\N	3	22	1	Трубка вентиляции картера	HOSE,P.C.V.	30.960000000000001	25.390000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.475499+02	\N	2011-03-29 14:36:26.910364+02	2011-03-29 14:40:23.482608+02	
1151	4	47	8	114	5080529AD	\N			1	\N	\N	3	22	1	Кнопка открывания багажника	SWITCH LIFTGATE LATC	36.200000000000003	29.690000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.48574+02	\N	2011-03-29 14:36:26.917367+02	2011-03-29 14:40:23.492133+02	
1152	4	47	8	114	5066756AA	\N			1	\N	\N	3	22	1	Сальник коленвала	SEAL CRANKSHAFT OIL	65.950000000000003	54.079999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.494516+02	\N	2011-03-29 14:36:26.924677+02	2011-03-29 14:40:23.498617+02	
1153	4	11	11	114	W709883S300	\N			14	\N	\N	74	4	1	пистон	clip	2	1.8	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.501656+02	\N	2011-03-29 14:36:26.931465+02	2011-03-29 14:40:23.505985+02	
1154	4	11	11	114	W710532S300	\N			16	\N	\N	74	4	1	пистон	clip	1.6299999999999999	1.4675	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.508283+02	\N	2011-03-29 14:36:26.938309+02	2011-03-29 14:40:23.512398+02	
1155	4	11	11	114	W709176S300	\N			4	\N	\N	74	4	1	пистон	clip	1.75	1.575	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.514937+02	\N	2011-03-29 14:36:26.945308+02	2011-03-29 14:40:23.518969+02	
1156	4	23	23	114	BR5V32600G	\N			1	\N	\N	27	8	1	насос гидроусилителя	ps pump	710.17999999999995	603.65999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.521368+02	\N	2011-03-29 14:36:26.954146+02	2011-03-29 14:40:23.525398+02	
1157	4	33	33	114	J101SXA001	\N			1	\N	\N	27	8	1	брызговики	splash guard	54.5	46.329999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.527736+02	\N	2011-03-29 14:36:26.960012+02	2011-03-29 14:40:23.532162+02	
1158	4	33	33	114	E771SXA100	\N			1	\N	\N	27	8	1	защита бампера	bumper guard	49.950000000000003	42.460000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.53505+02	\N	2011-03-29 14:36:26.964871+02	2011-03-29 14:40:23.539152+02	
1159	4	23	23	114	AJTM14302	\N			2	\N	\N	3	22	1	Фильтр масляный	Oil filter	4.21	3.4550000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.541564+02	\N	2011-03-29 14:36:26.969249+02	2011-03-29 14:40:23.545623+02	
1160	4	23	23	114	GY0120660B	\N			1	\N	\N	3	22	1	Клапан холостого хода	BYPASS VLV	99.849999999999994	81.879999999999995	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.548085+02	\N	2011-03-29 14:36:26.9738+02	2011-03-29 14:40:23.552216+02	
1161	4	15	15	114	622781BA2A	\N			1	\N	\N	15	10	2	заглушка 	 finisher	12.83	14	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.55456+02	\N	2011-03-29 14:40:06.537365+02	2011-03-29 14:40:23.558644+02	
1162	4	13	13	114	88217TA0A02ZB	\N			1	\N	\N	15	10	2	держатель козырька	holder	2.4700000000000002	3	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.56105+02	\N	2011-03-29 14:40:06.543125+02	2011-03-29 14:40:23.565251+02	
1163	4	2	2	114	12210PZ1003	\N			1	\N	\N	59	4	2	маслосъемное кольцо	seal	1.55	1.55	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.568295+02	\N	2011-03-29 14:40:06.548404+02	2011-03-29 14:40:23.572728+02	
1164	4	2	2	114	12211PZ1004	\N			1	\N	\N	59	4	2	маслосъемное кольцо	seal	1.55	1.55	\N	\N	\N	\N	\N	in_processing	2011-03-29 14:40:23.575041+02	\N	2011-03-29 14:40:06.553272+02	2011-03-29 14:40:23.579251+02	
1189	4	2	2	121	51391S6M005	\N			2	\N	\N	4	23	1	сайлентблок	Bushings	14.98	13.18	\N	0.42999999999999999	5.5899999999999999	18.77	37.539999999999999	received_office	2011-04-09 18:32:21.478257+02	sent_representative	2011-03-30 14:12:47.357005+02	2011-04-09 18:32:21.483203+02	#104
1166	4	35	35	116	04152YZZA1	\N			4	\N	\N	6	9	1	фильтр маслянный	oil filter	5.4100000000000001	4.5999999999999996	\N	\N	\N	\N	\N	in_processing	2011-03-29 15:09:11.697402+02	\N	2011-03-29 15:07:44.479588+02	2011-03-29 15:09:11.702149+02	
1167	4	2	2	116	06531SDAA02	\N			1	\N	\N	4	21	1	комплект сальников	SEAL KIT A P.S.	37.119999999999997	32.659999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-29 15:09:11.705531+02	\N	2011-03-29 15:07:44.496635+02	2011-03-29 15:09:11.709627+02	
1165	5	62	84	115	CC850	\N		moog	1	\N	\N	85	1	2	пружины передние	coil spring	66.129999999999995	115	\N	12.93	168.09	283.09000000000003	283.09000000000003	received_office	2011-04-03 16:34:22.818736+02	in_processing	2011-03-29 14:44:01.451336+02	2011-04-03 16:34:22.824097+02	#103
1168	4	15	15	116	999J25U003	\N			1	\N	\N	15	11	2	правый передний брызговик	mud guard	59	63	\N	0.71499999999999997	9.2949999999999999	72.295000000000002	72.295000000000002	received_office	2011-04-03 16:34:21.0584+02	in_processing	2011-03-29 15:09:02.856928+02	2011-04-03 16:34:21.063902+02	#103
1169	4	13	13	116	88217TA0A02ZB	\N			1	\N	\N	15	11	2	крепление козырька ivory	bracket	2.4700000000000002	3	\N	0.014999999999999999	0.19500000000000001	3.1949999999999998	3.1949999999999998	received_office	2011-04-03 16:34:19.241603+02	in_processing	2011-03-29 15:09:02.863101+02	2011-04-03 16:34:19.24673+02	#103
1176	4	11	11	119	7L2Z19835LA	\N			1	\N	\N	5	23	2	трубка кондиционера масла	tube	110.31999999999999	106.6320024	\N	0.42499999999999999	5.5249999999999995	112.15700240000001	112.15700240000001	received_office	2011-04-09 18:32:12.092626+02	sent_representative	2011-03-30 14:04:10.329536+02	2011-04-09 18:32:12.098018+02	#104
1201	4	26	26	122	921841AA0A	\N			1	\N	\N	19	6	1	уплотнитель	seal 	20.73	20.73	\N	0.185	2.4049999999999998	23.135000000000002	23.135000000000002	received_office	2011-04-03 16:33:08.649244+02	in_processing	2011-03-30 14:21:41.176367+02	2011-04-03 16:33:08.654472+02	#103
1174	4	23	23	119	N3Z110S60A	\N			1	\N	\N	3	23	1	комплект колец	ring set	336.22000000000003	275.69999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-30 14:06:14.273802+02	\N	2011-03-30 13:58:47.410102+02	2011-03-30 14:06:14.278103+02	
1170	7	48	59	117	190511005904	\N			1	\N	\N	58	4	2	защитная плёнка	decal	25.989999999999998	36.5	\N	0.125	1.625	38.125	38.125	received_office	2011-04-03 16:34:17.270692+02	in_processing	2011-03-29 15:10:26.667566+02	2011-04-03 16:34:17.27595+02	#103
1172	5	62	69	118	11625500	\N			1	\N	\N	7	16	1	фонарь правый 	Tail Lamp 	42.789999999999999	73.890000000000001	\N	2.1099999999999999	27.43	101.31999999999999	101.31999999999999	received_office	2011-04-09 18:32:09.890604+02	sent_representative	2011-03-30 13:55:47.767209+02	2011-04-09 18:32:09.895712+02	#104
1175	4	11	11	119	7L2Z7890A	\N			1	\N	\N	5	23	2	трубка радиатора	cooler line	58.32	56.370362399999998	\N	0.28000000000000003	3.6400000000000006	60.010362399999998	60.010362399999998	received_office	2011-04-03 16:34:13.808966+02	in_processing	2011-03-30 14:04:10.321404+02	2011-04-03 16:34:13.814374+02	#103
1177	4	11	11	119	6L2Z16E205AA	\N			1	\N	\N	5	23	2	подкрылок железо правый	apron panel right	86.920000000000002	84.010000000000005	\N	3.2349999999999999	42.055	126.065	126.065	received_office	2011-04-03 16:34:11.990273+02	in_processing	2011-03-30 14:04:10.336512+02	2011-04-03 16:34:11.995358+02	#103
1197	4	23	23	122	GE4T33048	\N			1	\N	\N	87	1	2	стопорное кольцо	c-clip	8.5399999999999991	9	\N	0.025000000000000001	0.32500000000000001	9.3249999999999993	9.3249999999999993	received_office	2011-04-09 18:32:26.488332+02	sent_representative	2011-03-30 14:19:17.471975+02	2011-04-09 18:32:26.49326+02	#104
1187	4	33	33	121	22401AA65A	\N			12	\N	\N	6	10	1	свеча зажигания	spark plug	11.949999999999999	10.157500000000001	\N	0.047	0.61099999999999999	10.768500000000001	129.22200000000001	received_office	2011-04-03 16:33:40.249797+02	in_processing	2011-03-30 14:12:47.338815+02	2011-04-03 16:33:40.254736+02	#103
1181	4	2	2	119	15100PRBA01	\N			1	\N	\N	4	22	1	маслонасос	Oil pump	174.55000000000001	153.59999999999999	\N	1.4650000000000001	19.045000000000002	172.64499999999998	172.64499999999998	received_office	2011-04-09 18:32:14.671585+02	sent_representative	2011-03-30 14:06:00.199956+02	2011-04-09 18:32:14.676479+02	#104
1202	4	23	23	122	AJTT18110	\N		AGSF22F1M	24	\N	\N	3	24	1	Свеча зажигания	SPARK PLUG	4.4800000000000004	3.6699999999999999	\N	0.048000000000000001	0.624	4.2939999999999996	103.05599999999998	received_office	2011-04-09 18:32:31.207924+02	sent_representative	2011-03-30 14:21:41.196338+02	2011-04-09 18:32:31.21292+02	#104
1179	4	11	11	119	1W1Z19E889BB	\N			1	\N	\N	5	23	2	кольцо уплотнительное	seal	2.2999999999999998	2.2200000000000002	\N	0.0050000000000000001	0.065000000000000002	2.2850000000000001	2.2850000000000001	received_office	2011-04-03 16:34:07.14068+02	in_processing	2011-03-30 14:04:10.350752+02	2011-04-03 16:34:07.145567+02	#103
1183	4	13	13	121	47510s82a63	\N			1	\N	\N	59	5	2	трос ручного тормоза правый	сable brake right	33.829999999999998	4.5999999999999996	\N	0.63500000000000001	8.2550000000000008	12.855	12.855	received_office	2011-04-03 16:33:58.438444+02	in_processing	2011-03-30 14:11:19.844386+02	2011-04-03 16:33:58.443571+02	#103
1194	4	2	2	122	52610STKA03	\N			1	\N	\N	6	10	1	амортизатор задний	shock absorber	53.68	45.630000000000003	\N	2.6800000000000002	34.840000000000003	80.469999999999999	80.469999999999999	received_office	2011-04-03 16:33:30.519807+02	in_processing	2011-03-30 14:12:47.389663+02	2011-04-03 16:33:30.525123+02	#103
1203	4	23	23	122	GJ4K39050A	\N			1	\N	\N	3	24	1	Подушка двигателя	RUBBER LT, ENG MTG	64.180000000000007	52.630000000000003	\N	1.48	19.239999999999998	71.870000000000005	71.870000000000005	received_office	2011-04-09 18:32:33.50493+02	sent_representative	2011-03-30 14:21:41.202519+02	2011-04-09 18:32:33.509966+02	#104
1184	4	35	35	121	5212806140	\N			1	\N	\N	73	5	2	накладка  левая	hole cover left	32.700000000000003	32.659999999999997	\N	0.14000000000000001	1.8200000000000003	34.479999999999997	34.479999999999997	received_office	2011-04-03 16:33:56.789738+02	in_processing	2011-03-30 14:11:19.856176+02	2011-04-03 16:33:56.794777+02	#103
1191	4	2	2	121	74220S6MA00	\N			1	\N	\N	4	23	1	накладка	Cowl grille	48.75	42.899999999999999	\N	0.40999999999999998	5.3300000000000001	48.229999999999997	48.229999999999997	received_office	2011-04-03 16:33:35.759851+02	in_processing	2011-03-30 14:12:47.374471+02	2011-04-03 16:33:35.764982+02	#103
1182	7	48	59	120	130487588671	310305072401		outback 8	1	\N	\N	84	2	2	фара правая	headlamp right	145.96000000000001	189	\N	3.4500000000000002	44.850000000000001	233.84999999999999	233.84999999999999	received_office	2011-04-09 18:32:16.999002+02	sent_representative	2011-03-30 14:09:17.450745+02	2011-04-09 18:32:17.003865+02	#104
1188	4	33	33	121	57705SC000	\N			1	\N	\N	6	10	1	абсорбер	absorber	64.950000000000003	55.210000000000001	\N	1.105	14.365	69.575000000000003	69.575000000000003	received_office	2011-04-03 16:33:38.631082+02	in_processing	2011-03-30 14:12:47.346412+02	2011-04-03 16:33:38.636209+02	#103
1190	4	2	2	121	77930S6MA81	\N			1	\N	\N	4	23	1	датчик	Front sensor	82.969999999999999	73.010000000000005	\N	0.16500000000000001	2.145	75.155000000000001	75.155000000000001	received_office	2011-04-03 16:33:37.141144+02	in_processing	2011-03-30 14:12:47.367695+02	2011-04-03 16:33:37.146224+02	#103
1200	4	11	11	122	7T4Z7822811A	\N			1	\N	\N	87	1	2	петля нижняя левая	lower hinge Left	44.920000000000002	48	\N	0.46999999999999997	6.1099999999999994	54.109999999999999	54.109999999999999	received_office	2011-04-03 16:33:24.907222+02	in_processing	2011-03-30 14:19:17.485342+02	2011-04-03 16:33:24.912609+02	#103
1198	4	23	23	122	BBM233047	\N			1	\N	\N	87	1	2	подшипник ступицы	wheel bearings	55.030000000000001	58	\N	0.93999999999999995	12.219999999999999	70.219999999999999	70.219999999999999	received_office	2011-04-09 18:32:28.690829+02	sent_representative	2011-03-30 14:19:17.476392+02	2011-04-09 18:32:28.695609+02	#104
1211	4	23	23	122	KLG418140A	000018150A			1	\N	\N	3	24	1	Провод зажигания	PLUG WIRE 6 CYL	146.38	120.03	\N	0.96999999999999997	12.609999999999999	132.63999999999999	132.63999999999999	received_office	2011-04-09 18:34:27.770245+02	sent_representative	2011-03-30 14:21:41.246217+02	2011-04-09 18:34:27.775118+02	#104
1204	4	23	23	122	C24328156D	\N			4	\N	\N	3	24	1	Втулка стабилизатора	BUSH,STABILIZER-RR	6.8399999999999999	5.6100000000000003	\N	0.035000000000000003	0.45500000000000007	6.0650000000000004	24.260000000000002	received_office	2011-04-09 18:32:36.34774+02	sent_representative	2011-03-30 14:21:41.207283+02	2011-04-09 18:32:36.352728+02	#104
1216	4	26	26	122	921821AA0C	\N			1	\N	\N	19	6	1	уплотнитель	seal 	9.8000000000000007	9.8000000000000007	\N	0.040000000000000001	0.52000000000000002	10.32	10.32	received_office	2011-04-09 18:34:25.51783+02	sent_representative	2011-03-30 14:21:41.281769+02	2011-04-09 18:34:25.522728+02	#104
1199	4	11	11	122	7T4Z7822801A	\N			1	\N	\N	87	1	2	петля верхняя левая	upper hinge Left	45.119999999999997	48	\N	0.46500000000000002	6.0449999999999999	54.045000000000002	54.045000000000002	received_office	2011-04-03 16:33:27.079657+02	in_processing	2011-03-30 14:19:17.480997+02	2011-04-03 16:33:27.085333+02	#103
1206	4	23	23	122	T03239020B	\N			1	\N	\N	3	24	1	Кронштейн	BRACKET NO.2,ENGINE	20.600000000000001	16.890000000000001	\N	0.94999999999999996	12.35	29.240000000000002	29.240000000000002	received_office	2011-04-09 18:32:40.992967+02	sent_representative	2011-03-30 14:21:41.216629+02	2011-04-09 18:32:40.998101+02	#104
1207	4	47	8	122	4781639AB	\N			1	\N	\N	3	24	1	Прокладка клапанной крышки	GASKET VALVE COVER	16.449999999999999	13.49	\N	0.059999999999999998	0.78000000000000003	14.27	14.27	issued	2011-04-04 20:01:14.037871+02	received_office	2011-03-30 14:21:41.223136+02	2011-04-04 20:01:14.04643+02	#103
1208	4	47	8	122	4621851	\N			4	\N	\N	3	24	1	Прокладка колодца свечного	SEAL SPARK PLUG TUBE	3.75	3.0750000000000002	\N	0.0050000000000000001	0.065000000000000002	3.1400000000000001	12.56	issued	2011-04-04 20:01:11.303324+02	received_office	2011-03-30 14:21:41.228871+02	2011-04-04 20:01:11.30836+02	#103
1221	4	23	23	122	GD7A3438X	\N			10	\N	\N	3	24	1	Подшипник поворотный амортизатора	BUSHING,MTG. RUBBER	3.4700000000000002	2.8450000000000002	\N	0.014999999999999999	0.19500000000000001	3.04	30.399999999999999	received_office	2011-04-09 18:34:21.546073+02	sent_representative	2011-03-30 14:21:41.313567+02	2011-04-09 18:34:21.551012+02	#104
1209	4	47	8	122	5149098AA	\N			2	\N	\N	3	24	1	Датчик давления масла	SWITCH OIL PRESSURE	18.600000000000001	15.25	\N	0.059999999999999998	0.78000000000000003	16.030000000000001	32.060000000000002	issued	2011-04-04 20:01:09.27894+02	received_office	2011-03-30 14:21:41.234701+02	2011-04-04 20:01:09.286743+02	#103
1235	4	11	11	125	5328542929	\N			1	\N	\N	87	2	2	заглушка бампера  правая	grille right	11.630000000000001	12	\N	\N	\N	\N	\N	wrong_number	2011-04-03 15:25:34.692951+02	in_processing	2011-03-30 14:30:35.940305+02	2011-04-03 15:25:34.6982+02	
1214	4	47	8	122	4882361	\N			1	\N	\N	4	24	1	прокладка	 GSKT KIT VALVE BODY	29	25.52	\N	\N	\N	\N	\N	in_processing	2011-03-30 14:21:58.650685+02	\N	2011-03-30 14:21:41.267797+02	2011-03-30 14:21:58.655465+02	
1212	4	26	26	122	921851AA0A	\N			1	\N	\N	19	6	1	уплотнитель	seal 	20.73	20.73	\N	0.19500000000000001	2.5350000000000001	23.265000000000001	23.265000000000001	received_office	2011-04-03 16:32:56.685444+02	in_processing	2011-03-30 14:21:41.25428+02	2011-04-03 16:32:56.690862+02	#103
1213	4	2	2	122	04715SECA91ZZ	\N			1	\N	\N	4	24	1	бампер задний	Bumper cover	346	304.48000000000002	\N	5.5999999999999996	72.799999999999997	377.28000000000003	377.28000000000003	issued	2011-04-03 16:34:57.100487+02	received_office	2011-03-30 14:21:41.26199+02	2011-04-03 16:34:57.105556+02	#103
1217	4	26	26	122	921821AA2B	\N			1	\N	\N	19	6	1	уплотнитель	seal 	10.369999999999999	10.369999999999999	\N	0.14000000000000001	1.8200000000000003	12.19	12.19	received_office	2011-04-03 16:32:51.160139+02	in_processing	2011-03-30 14:21:41.287976+02	2011-04-03 16:32:51.165213+02	#103
1210	4	35	35	122	75301AE010	\N			1	\N	\N	3	24	1	Эмблема	EMBLEM SUB-ASSY, FR	30.719999999999999	25.190000000000001	\N	0.089999999999999997	1.1699999999999999	26.359999999999999	26.359999999999999	issued	2011-04-04 20:01:07.272364+02	received_office	2011-03-30 14:21:41.240519+02	2011-04-04 20:01:07.277873+02	#103
1205	4	23	23	122	BP0318110	000018BP03			40	\N	\N	3	24	1	Свеча зажигания	SPARK PLUG - FLASH 0	4.0300000000000002	3.2999999999999998	\N	0.048000000000000001	0.624	3.9239999999999999	156.96000000000001	received_office	2011-04-09 18:32:38.691519+02	sent_representative	2011-03-30 14:21:41.212044+02	2011-04-09 18:32:38.696408+02	#104
1232	4	14	14	125	663212M000	\N			1	\N	\N	73	7	2	крыло правое	fender right	255.69	271	\N	5.5	71.5	342.5	342.5	received_office	2011-04-09 18:34:15.448338+02	sent_representative	2011-03-30 14:30:35.926491+02	2011-04-09 18:34:15.453358+02	#104
1222	4	23	23	122	AC0127238	\N			2	\N	\N	3	24	1	Сальник	SEAL,OIL	9.7599999999999998	8.0099999999999998	\N	0.029999999999999999	0.39000000000000001	8.4000000000000004	16.800000000000001	received_office	2011-04-09 18:34:19.570034+02	sent_representative	2011-03-30 14:21:41.320797+02	2011-04-09 18:34:19.574941+02	#104
1219	4	26	26	122	924461AA0A	\N			1	\N	\N	19	6	1	патрубок	pipe	35.170000000000002	35.170000000000002	\N	0.10000000000000001	1.3	36.469999999999999	36.469999999999999	received_office	2011-04-03 16:32:44.406924+02	in_processing	2011-03-30 14:21:41.301064+02	2011-04-03 16:32:44.412046+02	#103
1238	4	35	35	125	5212642020	\N			1	\N	\N	87	2	2	кольцо противотуманки левой	bracket fog lamp	30.579999999999998	32	\N	0.080000000000000002	1.04	33.039999999999999	33.039999999999999	received_office	2011-04-03 16:32:19.85086+02	in_processing	2011-03-30 14:30:35.960736+02	2011-04-03 16:32:19.856045+02	#103
1223	4	21	21	123	PT39848112	\N			1	\N	\N	4	25	1	автозапуск	RES RX	240	211.19999999999999	\N	0.40000000000000002	5.2000000000000002	216.39999999999998	216.39999999999998	received_office	2011-04-03 16:32:42.487521+02	in_processing	2011-03-30 14:24:22.338125+02	2011-04-03 16:32:42.493143+02	#103
1225	4	13	13	123	57450TF0003	\N			1	\N	\N	4	25	1	датчик абс	Front speed sensor	112.97	99.409999999999997	\N	0.085000000000000006	1.105	100.515	100.515	received_office	2011-04-03 16:32:38.940554+02	in_processing	2011-03-30 14:24:22.362286+02	2011-04-03 16:32:38.945827+02	#103
1226	4	2	2	123	51605SEPA04	\N			2	\N	\N	4	25	1	амортизатор	Strut	119.08	104.79000000000001	\N	2.2000000000000002	28.600000000000001	133.39000000000001	266.78000000000003	received_office	2011-04-03 16:32:37.221109+02	in_processing	2011-03-30 14:24:22.371411+02	2011-04-03 16:32:37.226404+02	#103
1227	5	46	61	124	TCK283	\N		Заказано	1	\N	\N	7	18	1	комплект грм	Timing Belt Component Kit	41.909999999999997	60.25	\N	0.70999999999999996	9.2300000000000004	69.480000000000004	69.480000000000004	received_office	2011-04-03 16:32:35.339231+02	in_processing	2011-03-30 14:26:05.308845+02	2011-04-03 16:32:35.344305+02	#103
1228	5	61	60	124	T6421	\N	sienna 2005	Заказано	1	\N	\N	73	6	2	бампер задний	bumper rear	139	225	\N	6.1600000000000001	80.079999999999998	305.07999999999998	305.07999999999998	received_office	2011-04-03 16:32:33.480806+02	in_processing	2011-03-30 14:26:43.517323+02	2011-04-03 16:32:33.485875+02	#103
1229	4	35	35	125	5310142220	531010R010			1	\N	\N	87	2	2	решетка	grille	132.02000000000001	140	\N	1.0449999999999999	13.584999999999999	153.58500000000001	153.58500000000001	received_office	2011-04-03 16:32:31.235656+02	superseded	2011-03-30 14:30:35.897394+02	2011-04-03 16:32:31.240749+02	#103
1193	4	35	35	122	PTR2635060	\N			1	\N	\N	4	23	1	ручка кпп	SHIFT KNB	47	41.359999999999999	\N	0.20000000000000001	2.6000000000000001	43.960000000000001	43.960000000000001	received_office	2011-04-03 16:33:32.109656+02	in_processing	2011-03-30 14:12:47.384874+02	2011-04-03 16:33:32.114899+02	#103
1236	4	11	11	125	5328642930	\N			1	\N	\N	87	2	2	заглушка бампера левая	grille left	11.630000000000001	12	\N	\N	\N	\N	\N	wrong_number	2011-04-03 15:26:10.119893+02	in_processing	2011-03-30 14:30:35.944719+02	2011-04-03 15:26:10.12483+02	
1234	4	33	33	125	86631SA051	\N			1	\N	\N	73	7	2	бачек омывателя	tank washer	62.619999999999997	66	\N	0.58999999999999997	7.6699999999999999	73.670000000000002	73.670000000000002	received_office	2011-04-03 16:32:25.363656+02	in_processing	2011-03-30 14:30:35.935452+02	2011-04-03 16:32:25.369141+02	#103
1230	4	47	8	125	6504521	\N			4	\N	\N	73	7	2	пистон	clip	4.4500000000000002	5	\N	0.0050000000000000001	0.065000000000000002	5.0650000000000004	20.260000000000002	received_office	2011-04-03 16:32:29.023027+02	in_processing	2011-03-30 14:30:35.916544+02	2011-04-03 16:32:29.028298+02	#103
1192	4	47	8	122	4864505AB	\N			3	\N	\N	4	23	1	фильтр	Filter	10.5	9.2400000000000002	\N	0.26500000000000001	3.4450000000000003	12.685	38.055	received_office	2011-04-03 16:33:33.758031+02	in_processing	2011-03-30 14:12:47.380074+02	2011-04-03 16:33:33.763618+02	#103
1215	4	35	35	122	521590C903	\N			1	\N	\N	4	24	1	бампер задний	Bumper cover W/o pk. sensor	180.63	158.94999999999999	\N	2.48	32.240000000000002	191.19	191.19	issued	2011-04-03 16:34:55.118646+02	received_office	2011-03-30 14:21:41.27443+02	2011-04-03 16:34:55.124233+02	#103
1250	4	23	23	128	AJ5710522	\N			2	\N	\N	3	25	1	Прокладка	GASKET L ,T.CHAIN CO	6.4299999999999997	5.2750000000000004	\N	0.014999999999999999	0.19500000000000001	5.4700000000000006	10.940000000000001	received_office	2011-04-09 18:33:48.55746+02	sent_representative	2011-03-30 14:48:04.001994+02	2011-04-09 18:33:48.562377+02	#104
1277	5	62	69	131	3772	\N			1	\N	\N	84	5	2	радиатор кондиционер	condenser	122.17	202	\N	5.6749999999999998	73.774999999999991	275.77499999999998	275.77499999999998	received_office	2011-04-09 18:34:59.016175+02	sent_representative	2011-03-30 14:59:00.679321+02	2011-04-09 18:34:59.020961+02	#104
1254	4	23	23	128	GM6A42250C	\N			1	\N	\N	3	25	1	Крышка	Filler cap	22.399999999999999	18.370000000000001	\N	0.089999999999999997	1.1699999999999999	19.539999999999999	19.539999999999999	received_office	2011-04-09 18:35:17.765623+02	sent_representative	2011-03-30 14:48:04.032017+02	2011-04-09 18:35:17.770908+02	#104
1241	4	35	35	125	5212842080	521280R020			1	\N	\N	87	2	2	заглушка	plug	33.119999999999997	35	\N	0.074999999999999997	0.97499999999999998	35.975000000000001	35.975000000000001	received_office	2011-04-03 16:32:17.857501+02	superseded	2011-03-30 14:30:36.048925+02	2011-04-03 16:32:17.862602+02	#103
1253	4	23	23	128	GK2A34012	\N			1	\N	\N	3	25	1	Пыльник	SHEET,RUBBER	8.0299999999999994	6.5800000000000001	\N	0.20499999999999999	2.665	9.245000000000001	9.245000000000001	received_office	2011-04-09 18:33:40.432281+02	sent_representative	2011-03-30 14:48:04.024351+02	2011-04-09 18:33:40.437174+02	#104
1245	5	62	69	126	19592200	\N	tyc		1	\N	\N	87	3	2	противотуманная фара	fog lamp	62.020000000000003	100	\N	0.35499999999999998	4.6150000000000002	104.61499999999999	104.61499999999999	received_office	2011-04-09 18:34:01.388436+02	sent_representative	2011-03-30 14:42:54.99619+02	2011-04-09 18:34:01.393358+02	#104
1263	4	23	23	128	L32114302A9U				20	\N	\N	3	25	1	Фильтр масляный	OIL FILTER	8.2899999999999991	6.798	\N	0.079000000000000001	1.0269999999999999	7.8250000000000002	156.5	received_office	2011-04-09 18:35:01.445743+02	sent_representative	2011-03-30 14:48:04.10173+02	2011-04-09 18:35:01.450782+02	#104
1246	5	52	95	126	MS1703P.75MM	\N	clevite		1	\N	\N	89	1	2	вкладыши  коренные 	main bearing set	68	90	\N	\N	\N	\N	\N	in_processing	2011-03-30 14:43:18.081205+02	\N	2011-03-30 14:42:55.004098+02	2011-03-30 14:43:18.086588+02	
1278	5	62	69	131	13078	\N			1	\N	\N	84	5	2	радиатор  	radiator	172.13999999999999	279	\N	7.0999999999999996	92.299999999999997	371.30000000000001	371.30000000000001	received_office	2011-04-09 18:34:57.218236+02	sent_representative	2011-03-30 14:59:00.68654+02	2011-04-09 18:34:57.223407+02	#104
1252	4	23	23	128	000018BP01	\N			20	\N	\N	3	25	1	Свеча зажигания	SPARK PLUG - FLASH 0	4.0300000000000002	3.3045	\N	0.048000000000000001	0.624	3.9285000000000001	78.570000000000007	received_office	2011-04-09 18:33:44.318712+02	sent_representative	2011-03-30 14:48:04.016669+02	2011-04-09 18:33:44.323711+02	#104
1261	4	23	23	128	H00126205	\N			4	\N	\N	3	25	1	Подшипник	BEARING	20.850000000000001	17.0975	\N	0.014999999999999999	0.19500000000000001	17.2925	69.170000000000002	received_office	2011-04-09 18:35:06.041261+02	sent_representative	2011-03-30 14:48:04.086572+02	2011-04-09 18:35:06.046086+02	#104
1247	7	48	59	127	130487590425	130498911459			1	\N	\N	84	3	2	фара левая	headlamp left	145.96000000000001	189	\N	3.5099999999999998	45.629999999999995	234.63	234.63	received_office	2011-04-09 18:33:54.87947+02	sent_representative	2011-03-30 14:44:44.204889+02	2011-04-09 18:33:54.884241+02	#104
1249	4	23	23	128	AJ5710513	\N			2	\N	\N	3	25	1	Прокладка	GASKET,CHAIN COVER-C	6.1200000000000001	5.0199999999999996	\N	0.02	0.26000000000000001	5.2799999999999994	10.559999999999999	received_office	2011-04-09 18:33:50.39806+02	sent_representative	2011-03-30 14:48:03.996488+02	2011-04-09 18:33:50.402858+02	#104
1262	4	23	23	128	L3Y211SE0	\N			1	\N	\N	3	25	1	Вкладыши шатунные	Bearing set, mazdaspeed6 - 2.3l	90.700000000000003	74.370000000000005	\N	0.14999999999999999	1.95	76.320000000000007	76.320000000000007	received_office	2011-04-09 18:35:03.756084+02	sent_representative	2011-03-30 14:48:04.094235+02	2011-04-09 18:35:03.761129+02	#104
1259	4	14	14	128	546124D000	\N			4	\N	\N	3	25	1	Подшипник опоры	BEARING-STRUT	17.43	14.815	\N	0.085000000000000006	1.105	15.92	63.68	received_office	2011-04-09 18:35:09.920605+02	sent_representative	2011-03-30 14:48:04.072029+02	2011-04-09 18:35:09.925441+02	#104
1243	5	62	81	126	HA590285	\N	timken		1	\N	\N	73	8	2	ступица передняя	hub	49.990000000000002	100	\N	\N	\N	\N	\N	in_delivery	2011-04-09 18:33:06.509987+02	sent_representative	2011-03-30 14:42:54.964541+02	2011-04-09 18:33:06.514777+02	#104
1240	4	14	14	125	878202M010	\N			1	\N	\N	73	7	2	стекло правое	qtr glass right	131.38	139	\N	2.5649999999999999	33.344999999999999	172.345	172.345	received_office	2011-04-09 18:34:05.501265+02	sent_representative	2011-03-30 14:30:36.005789+02	2011-04-09 18:34:05.506103+02	#104
1257	4	23	23	128	LFH115940A	\N			2	\N	\N	3	25	1	Ролик	PULLEY-IDLE	53.490000000000002	43.859999999999999	\N	0.34000000000000002	4.4199999999999999	48.280000000000001	96.560000000000002	received_office	2011-04-09 18:35:11.948122+02	sent_representative	2011-03-30 14:48:04.056203+02	2011-04-09 18:35:11.953346+02	#104
1251	4	23	23	128	AJ5710523	\N			2	\N	\N	3	25	1	Прокладка	GASKET,TIMING COVER	6.4000000000000004	5.25	\N	0.02	0.26000000000000001	5.5099999999999998	11.02	received_office	2011-04-09 18:33:46.451111+02	sent_representative	2011-03-30 14:48:04.009808+02	2011-04-09 18:33:46.456038+02	#104
1256	4	23	23	128	GY0115171	\N		RT1131	2	\N	\N	3	25	1	термостат	THERMOSTAT NO GASKET	20.620000000000001	16.91	\N	0.089999999999999997	1.1699999999999999	18.079999999999998	36.159999999999997	received_office	2011-04-09 18:35:13.91745+02	sent_representative	2011-03-30 14:48:04.048468+02	2011-04-09 18:35:13.922376+02	#104
1281	5	61	60	131	T1307	\N		ЗАКАЗАНО	1	\N	\N	87	4	2	фара левая	headlamp left	117	188	\N	3.3500000000000001	43.550000000000004	231.55000000000001	231.55000000000001	received_office	2011-04-03 16:31:46.016841+02	in_processing	2011-03-30 14:59:00.706428+02	2011-04-03 16:31:46.022604+02	#103
1242	4	47	8	125	5116124AC	5113607AB			1	\N	\N	73	7	2	эмблема	medallion	81.700000000000003	87	\N	0.38	4.9400000000000004	91.939999999999998	91.939999999999998	received_office	2011-04-03 16:32:14.802193+02	superseded	2011-03-30 14:30:36.090239+02	2011-04-03 16:32:14.807337+02	#103
1264	4	35	35	129	4853080432	\N			1	\N	\N	73	9	2	амортизатор	strut right	163.06999999999999	173	\N	7.0499999999999998	91.649999999999991	264.64999999999998	264.64999999999998	received_office	2011-04-03 16:32:10.868339+02	in_processing	2011-03-30 14:49:32.712982+02	2011-04-03 16:32:10.873136+02	#103
1265	4	13	13	129	90023PA9000	\N			8	\N	\N	57	2	2	болт маховика	bolt	4.3499999999999996	0.54374999999999996	\N	0.029999999999999999	0.39000000000000001	0.93374999999999997	7.4699999999999998	received_office	2011-04-03 16:32:08.689983+02	in_processing	2011-03-30 14:49:32.724108+02	2011-04-03 16:32:08.69494+02	#103
1267	7	48	59	130	220753981569	\N			1	\N	\N	84	4	2	зеркало правое	mirror right	194	271	\N	\N	\N	\N	\N	in_processing	2011-03-30 14:50:39.541817+02	\N	2011-03-30 14:50:33.283298+02	2011-03-30 14:50:39.547597+02	
1266	4	13	13	129	90429PC6900	\N			1	\N	\N	57	2	2	шайба маховика	washer	16.77	16.77	\N	0.055	0.71499999999999997	17.484999999999999	17.484999999999999	received_office	2011-04-03 16:32:06.803536+02	in_processing	2011-03-30 14:49:32.729605+02	2011-04-03 16:32:06.808972+02	#103
1270	5	61	60	131	P0100	\N		ЗАКАЗАНО	1	\N	\N	73	10	2	решетка бампера центр 	grille	18	29	\N	\N	\N	\N	\N	in_processing	2011-03-30 14:59:19.197902+02	\N	2011-03-30 14:59:00.629563+02	2011-03-30 14:59:19.202243+02	
1269	5	61	60	131	T027H	\N		ЗАКАЗАНО	1	\N	\N	87	4	2	решетка нижняя бампера 2-ая	grille lower	13	21	\N	0.13500000000000001	1.7550000000000001	22.754999999999999	22.754999999999999	received_office	2011-04-03 16:32:03.167144+02	in_processing	2011-03-30 14:59:00.623916+02	2011-04-03 16:32:03.172362+02	#103
1280	5	61	60	131	T0491	\N		ЗАКАЗАНО	1	\N	\N	87	4	2	бампер передний	bumper front	79	185	\N	5	65	250	250	received_office	2011-04-03 16:31:47.881976+02	in_processing	2011-03-30 14:59:00.700546+02	2011-04-03 16:31:47.88724+02	#103
1271	5	61	60	131	D2120	\N		ЗАКАЗАНО	1	\N	\N	73	10	2	телевизор 	radiator support	176	283	\N	6.5199999999999996	84.759999999999991	367.75999999999999	367.75999999999999	received_office	2011-04-03 16:32:01.507943+02	in_processing	2011-03-30 14:59:00.634475+02	2011-04-03 16:32:01.513245+02	#103
1276	5	62	87	131	TO1036115	\N			1	\N	\N	87	4	2	решетка нижняя 2-я	grille lower	11	18	\N	0.69999999999999996	9.0999999999999996	27.100000000000001	27.100000000000001	received_office	2011-04-03 16:31:49.791968+02	in_processing	2011-03-30 14:59:00.670769+02	2011-04-03 16:31:49.796876+02	#103
1273	5	61	60	131	H1109	\N		ЗАКАЗАНО	1	\N	\N	90	1	2	правый фонарь 	tail lamp right	59	97	\N	1.415	18.395	115.395	115.395	received_office	2011-04-03 16:31:57.700243+02	in_processing	2011-03-30 14:59:00.647828+02	2011-04-03 16:31:57.705463+02	#103
1275	5	62	87	131	TO1036114	\N			1	\N	\N	87	4	2	решетка нижняя	grille lower	16	26	\N	0.69999999999999996	9.0999999999999996	35.100000000000001	35.100000000000001	received_office	2011-04-03 16:31:51.959432+02	in_processing	2011-03-30 14:59:00.663655+02	2011-04-03 16:31:51.964451+02	#103
1283	4	35	35	132	5328542929	5328542930			1	\N	\N	87	5	2	заглушка бампера  правая	grille right	11.630000000000001	12	\N	0.02	0.26000000000000001	12.26	12.26	received_office	2011-04-03 16:31:34.25834+02	superseded	2011-03-30 15:00:31.781593+02	2011-04-03 16:31:34.263733+02	#103
1291	4	33	33	132	83001AG33AEU	\N			1	\N	\N	4	27	1	переключатель	Mirror switch	137.66999999999999	121.15000000000001	\N	0.27000000000000002	3.5100000000000002	124.66000000000001	124.66000000000001	received_office	2011-04-09 18:34:44.601488+02	sent_representative	2011-03-30 15:24:31.033633+02	2011-04-09 18:34:44.606282+02	#104
1288	4	2	2	132	71102S6M000	\N			1	\N	\N	4	27	1	решётка	Grille	52.100000000000001	45.850000000000001	\N	0.5	6.5	52.350000000000001	52.350000000000001	received_office	2011-04-09 18:34:48.95898+02	sent_representative	2011-03-30 15:24:31.012324+02	2011-04-09 18:34:48.963767+02	#104
1316	4	23	23	135	AJ1940061	\N			2	\N	\N	3	27	1	держатель глушителя	HANGER,SILENCER	6.5300000000000002	5.3550000000000004	\N	0.085000000000000006	1.105	6.4600000000000009	12.920000000000002	received_office	2011-04-09 18:36:24.649865+02	sent_representative	2011-03-30 15:36:17.762132+02	2011-04-09 18:36:24.654772+02	#104
1289	4	2	2	132	74100S6MJ00	\N			1	\N	\N	4	27	1	подкрылок	Fender liner	82.069999999999993	72.219999999999999	\N	0.86499999999999999	11.244999999999999	83.465000000000003	83.465000000000003	received_office	2011-04-09 18:34:47.490025+02	sent_representative	2011-03-30 15:24:31.018315+02	2011-04-09 18:34:47.49486+02	#104
1305	4	23	23	133	L33L188G1D9U	\N			1	\N	\N	3	26	1	Датчик кислородный	spark plug	132.74000000000001	108.84999999999999	\N	0.19	2.4700000000000002	111.31999999999999	111.31999999999999	received_office	2011-04-09 18:36:37.511656+02	sent_representative	2011-03-30 15:29:47.664721+02	2011-04-09 18:36:37.516577+02	#104
1301	4	23	23	133	EC013438XA	\N		AD959	2	\N	\N	3	26	1	Подшипник поворотный амортизатора	fender left	9.0199999999999996	7.3949999999999996	\N	0.029999999999999999	0.39000000000000001	7.7849999999999993	15.569999999999999	received_office	2011-04-09 18:36:45.077907+02	sent_representative	2011-03-30 15:29:47.63409+02	2011-04-09 18:36:45.082935+02	#104
1311	4	47	8	135	55396462AC	\N			1	\N	\N	3	27	1	Подкрылок	SHIELD FENDER SIDE	31.699999999999999	25.989999999999998	\N	1.48	19.239999999999998	45.229999999999997	45.229999999999997	received_office	2011-04-09 18:36:30.412659+02	sent_representative	2011-03-30 15:36:17.731518+02	2011-04-09 18:36:30.417563+02	#104
1284	4	35	35	132	5328642930	5328642931			1	\N	\N	87	5	2	заглушка бампера левая	grille left	11.630000000000001	12	\N	0.02	0.26000000000000001	12.26	12.26	received_office	2011-04-03 16:31:32.202078+02	superseded	2011-03-30 15:00:31.788204+02	2011-04-03 16:31:32.206972+02	#103
1292	4	13	13	133	71190TA0A00	\N			1	\N	\N	65	2	2	крепление	bracket	13.199999999999999	13.199999999999999	\N	0.315	4.0949999999999998	17.294999999999998	17.294999999999998	received_office	2011-04-03 16:31:29.821837+02	in_processing	2011-03-30 15:28:40.501731+02	2011-04-03 16:31:29.82721+02	#103
1299	4	23	23	133	L3K912500A	\N			1	\N	\N	10	7	2	натяжитель	tensioner	81.299999999999997	81.299999999999997	\N	0.20999999999999999	2.73	84.030000000000001	84.030000000000001	received_office	2011-04-09 18:36:50.242465+02	sent_representative	2011-03-30 15:28:40.566085+02	2011-04-09 18:36:50.247863+02	#104
1303	4	23	23	133	GK2A28011B	\N			2	\N	\N	3	26	1	Пружина	radiator	49.359999999999999	40.475000000000001	\N	2.1200000000000001	27.560000000000002	68.034999999999997	136.06999999999999	received_office	2011-04-09 18:36:41.376924+02	sent_representative	2011-03-30 15:29:47.649225+02	2011-04-09 18:36:41.382259+02	#104
1302	4	47	8	133	4648987AA	\N			2	\N	\N	3	26	1	Прокладка клапанной крышки	condenser	7.0999999999999996	5.8200000000000003	\N	0.070000000000000007	0.91000000000000014	6.7300000000000004	13.460000000000001	received_office	2011-04-09 18:36:43.321534+02	sent_representative	2011-03-30 15:29:47.642339+02	2011-04-09 18:36:43.326613+02	#104
1295	4	23	23	133	L3K912121C	\N			8	\N	\N	10	7	2	клапан выпуск	exhaust valve	50.060000000000002	50.060000000000002	\N	0.035000000000000003	0.45500000000000007	50.515000000000001	404.12	received_office	2011-04-09 18:34:41.197064+02	sent_representative	2011-03-30 15:28:40.536816+02	2011-04-09 18:34:41.202272+02	#104
1304	4	23	23	133	GJ6E664T0	\N			1	\N	\N	3	26	1	кнопка	tail lamp right	30.359999999999999	24.899999999999999	\N	0.029999999999999999	0.39000000000000001	25.289999999999999	25.289999999999999	received_office	2011-04-09 18:36:39.490646+02	sent_representative	2011-03-30 15:29:47.656095+02	2011-04-09 18:36:39.495826+02	#104
1297	4	23	23	133	L3K9124X0A	L3K9124X0C			1	\N	\N	10	7	2	гидронатяжитель 	actuator	127.38	127.38	\N	0.92000000000000004	11.960000000000001	139.34	139.34	received_office	2011-04-09 18:36:53.368255+02	sent_representative	2011-03-30 15:28:40.552245+02	2011-04-09 18:36:53.373205+02	#104
1298	4	23	23	133	L3K910271B	L3K910271C			1	\N	\N	10	7	2	прокладка гбц  	head gasket	81.299999999999997	81.299999999999997	\N	0.23000000000000001	2.9900000000000002	84.289999999999992	84.289999999999992	received_office	2011-04-09 18:36:51.897922+02	sent_representative	2011-03-30 15:28:40.55927+02	2011-04-09 18:36:51.903058+02	#104
1300	4	23	23	133	L3K9124X0C	\N			2	\N	\N	3	26	1	Звездочка распредвала	strut right	127.38	104.45	\N	0.92000000000000004	11.960000000000001	116.41	232.81999999999999	received_office	2011-04-09 18:36:47.360846+02	sent_representative	2011-03-30 15:29:47.619105+02	2011-04-09 18:36:47.365813+02	#104
1296	4	23	23	133	L3K912201	L3K912201A			1	\N	\N	10	7	2	цепь	timing chain	39.759999999999998	39.759999999999998	\N	0.42499999999999999	5.5249999999999995	45.284999999999997	45.284999999999997	received_office	2011-04-09 18:36:54.682497+02	sent_representative	2011-03-30 15:28:40.543678+02	2011-04-09 18:36:54.687426+02	#104
1314	4	47	8	135	5JP91TZZAD	5JP91TZZAF			1	\N	\N	3	27	1	молдинг	FLARE REAR DOOR	114	93.480000000000004	\N	0.79000000000000004	10.27	103.75	103.75	received_office	2011-04-09 18:36:26.29767+02	sent_representative	2011-03-30 15:36:17.749264+02	2011-04-09 18:36:26.30268+02	#104
1313	4	47	8	135	5JP87TZZAC	5JP87TZZAD			1	\N	\N	3	27	1	молдинг	FLARE REAR WHEEL OPE	50.75	41.619999999999997	\N	0.72999999999999998	9.4900000000000002	51.109999999999999	51.109999999999999	received_office	2011-04-09 18:36:28.347206+02	sent_representative	2011-03-30 15:36:17.743743+02	2011-04-09 18:36:28.352074+02	#104
1306	7	48	59	134	220756670658	\N		outback	1	\N	\N	84	6	2	бампер передний	bumper front	149	199	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:33:39.568848+02	\N	2011-03-30 15:32:25.990104+02	2011-03-30 15:33:39.573811+02	
1307	7	48	59	134	380273944595	\N		ex35	1	\N	\N	84	6	2	бампер передний	bumper front	220.99000000000001	287	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:33:39.594774+02	\N	2011-03-30 15:32:26.003897+02	2011-03-30 15:33:39.59923+02	
1287	4	2	2	132	74111S6MA50	\N			1	\N	\N	4	27	1	защита	Under cover	55.75	49.060000000000002	\N	0.78000000000000003	10.140000000000001	59.200000000000003	59.200000000000003	received_office	2011-04-09 18:34:50.952437+02	sent_representative	2011-03-30 15:24:31.00766+02	2011-04-09 18:34:50.957215+02	#104
1294	4	23	23	133	L3K912111	\N			8	\N	\N	10	7	2	клапан впуск	intake valve	16.190000000000001	16.190000000000001	\N	0.055	0.71499999999999997	16.905000000000001	135.24000000000001	received_office	2011-04-09 18:34:42.804786+02	sent_representative	2011-03-30 15:28:40.527748+02	2011-04-09 18:34:42.809686+02	#104
1286	4	2	2	132	71121S6MJ01	\N			1	\N	\N	4	27	1	решётка	Grille	83.629999999999995	73.590000000000003	\N	0.56000000000000005	7.2800000000000011	80.870000000000005	80.870000000000005	received_office	2011-04-09 18:34:52.620876+02	sent_representative	2011-03-30 15:24:31.00336+02	2011-04-09 18:34:52.625829+02	#104
1312	4	47	8	135	1DE16XDVAA	\N			1	\N	\N	3	27	1	бардачек	BEZEL INSTRUMENT PAN	40.75	33.420000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:36:32.593242+02	\N	2011-03-30 15:36:17.736613+02	2011-03-30 15:36:32.597399+02	
1315	4	23	23	135	CC2934156C	\N			4	\N	\N	3	27	1	Втулка стабилизатора	BUSH,STABILIZER-FRT	7.75	6.3550000000000004	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:36:32.615156+02	\N	2011-03-30 15:36:17.75644+02	2011-03-30 15:36:32.620748+02	
1293	4	13	13	133	71198TA0A00	\N			1	\N	\N	65	2	2	крепление	bracket	2.1699999999999999	2.1699999999999999	\N	0.059999999999999998	0.78000000000000003	2.9500000000000002	2.9500000000000002	received_office	2011-04-03 16:31:27.600765+02	in_processing	2011-03-30 15:28:40.518934+02	2011-04-03 16:31:27.606341+02	#103
1268	5	62	87	131	TO1006208	\N			1	\N	\N	87	4	2	усилитель бампера	reinforcement	72.890000000000001	118	\N	7.4000000000000004	96.200000000000003	214.19999999999999	214.19999999999999	received_office	2011-04-03 16:32:04.970078+02	in_processing	2011-03-30 14:59:00.617268+02	2011-04-03 16:32:04.975392+02	#103
1282	5	61	60	131	T0189	\N		ЗАКАЗАНО	1	\N	\N	87	4	2	бампер передний	bumper front	69	130	\N	5	65	195	195	received_office	2011-04-03 16:31:38.970923+02	issued	2011-03-30 14:59:00.711569+02	2011-04-03 16:31:38.975993+02	#103
1345	5	61	60	137	H0666	\N		odyssey 2008	1	\N	\N	84	8	2	фара левая	headlamp left	153	245	\N	4.915	63.895000000000003	308.89499999999998	308.89499999999998	received_office	2011-04-09 18:37:50.731806+02	sent_representative	2011-03-30 16:16:07.812208+02	2011-04-09 18:37:50.736958+02	#104
1329	4	47	8	135	52111342AC	52114332AD			1	\N	\N	3	27	1	крышка	COVER DIFFERENTIAL	107	87.739999999999995	\N	3	39	126.73999999999999	126.73999999999999	received_office	2011-04-09 18:37:46.281946+02	sent_representative	2011-03-30 15:36:17.845579+02	2011-04-09 18:37:46.287146+02	#104
1346	5	61	60	137	H0127	\N		odyssey 2008	1	\N	\N	84	8	2	крыло левое	fender left	53	95	\N	3.6099999999999999	46.93	141.93000000000001	141.93000000000001	received_office	2011-04-09 18:37:52.524272+02	sent_representative	2011-03-30 16:16:07.817398+02	2011-04-09 18:37:52.530308+02	#104
1320	4	35	35	135	7573006060	\N			1	\N	\N	4	28	1	молдинг	MOULDING ASSY	69.959999999999994	61.560000000000002	\N	0.59999999999999998	7.7999999999999998	69.359999999999999	69.359999999999999	received_office	2011-04-09 18:37:32.138721+02	sent_representative	2011-03-30 15:36:17.786525+02	2011-04-09 18:37:32.143789+02	#104
1327	4	47	8	135	52111343AC	\N			1	\N	\N	3	27	1	крышка	TUBE AXLE HOUSING	95.450000000000003	78.269999999999996	\N	2.3199999999999998	30.159999999999997	108.42999999999999	108.42999999999999	received_office	2011-04-09 18:37:41.955431+02	sent_representative	2011-03-30 15:36:17.836929+02	2011-04-09 18:37:41.960275+02	#104
1317	4	23	23	135	L30440061A	\N			3	\N	\N	3	27	1	держатель глушителя	HANGER,SILENCER	6	4.9199999999999999	\N	0.059999999999999998	0.78000000000000003	5.7000000000000002	17.100000000000001	received_office	2011-04-09 18:36:23.070808+02	sent_representative	2011-03-30 15:36:17.767849+02	2011-04-09 18:36:23.076353+02	#104
1324	4	2	2	135	60485S6M306ZZ	\N			1	\N	\N	4	28	1	кронштейн	Outer support	33.479999999999997	29.460000000000001	\N	0.45000000000000001	5.8500000000000005	35.310000000000002	35.310000000000002	received_office	2011-04-09 18:37:38.438337+02	sent_representative	2011-03-30 15:36:17.818765+02	2011-04-09 18:37:38.443564+02	#104
1321	4	35	35	135	5310106070B0	\N			1	\N	\N	4	28	1	решётка	GRILLE	203.43000000000001	179.02000000000001	\N	1.3300000000000001	17.289999999999999	196.31	196.31	received_office	2011-04-09 18:37:33.410939+02	sent_representative	2011-03-30 15:36:17.794369+02	2011-04-09 18:37:33.415912+02	#104
1325	4	11	11	135	YF1Z6148BA	\N			6	\N	\N	3	27	1	Кольца поршневые	KIT- PARTIAL RING SE	51.219999999999999	42	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:36:32.692321+02	\N	2011-03-30 15:36:17.825885+02	2011-03-30 15:36:32.697049+02	
1343	5	46	62	137	DY831	\N			1	\N	\N	85	3	2	кислородный датчик передний	oxy sensor front	32.100000000000001	53	\N	0.115	1.4950000000000001	54.494999999999997	54.494999999999997	received_office	2011-04-09 18:37:48.86822+02	sent_representative	2011-03-30 16:16:07.798442+02	2011-04-09 18:37:48.873141+02	#104
1348	5	61	60	137	F5035	\N		explorer 2002	1	\N	\N	95	1	2	зеркало правое 	mirror right	39	61	\N	1.27	16.510000000000002	77.510000000000005	77.510000000000005	received_office	2011-04-09 18:37:55.917791+02	sent_representative	2011-03-30 16:16:07.831441+02	2011-04-09 18:37:55.922613+02	#104
1347	5	61	60	137	H6219	\N		odyssey 2008	1	\N	\N	84	8	2	задний усилитель бампер	reinforcement	99	159	\N	12.414999999999999	161.39499999999998	320.39499999999998	320.39499999999998	received_office	2011-04-09 18:37:54.228147+02	sent_representative	2011-03-30 16:16:07.82523+02	2011-04-09 18:37:54.233043+02	#104
1319	4	2	2	135	04611S6M300ZZ	\N			1	\N	\N	4	28	1	кронштейн	Upper tie bar	26.629999999999999	23.43	\N	0.37	4.8099999999999996	28.239999999999998	28.239999999999998	received_office	2011-04-09 18:35:27.097371+02	sent_representative	2011-03-30 15:36:17.780589+02	2011-04-09 18:35:27.102403+02	#104
1330	5	62	96	136	152	\N		pci	1	\N	\N	94	1	2	трубка EGR	EGR line	31.09	53	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:54:37.200661+02	\N	2011-03-30 15:54:14.121894+02	2011-03-30 15:54:37.20537+02	
1331	7	48	59	136	400202909336	\N			1	\N	\N	93	1	2	набор накладок	set chrome	79.989999999999995	112	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:54:37.226506+02	\N	2011-03-30 15:54:14.131374+02	2011-03-30 15:54:37.232279+02	
1332	4	13	13	136	76602SNAA01	\N			1	\N	\N	15	12	2	заглушка щетки	cap	1.4199999999999999	2	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:54:37.241149+02	\N	2011-03-30 15:54:14.138071+02	2011-03-30 15:54:37.247609+02	
1333	4	13	13	136	37870RTA005	\N			1	\N	\N	15	12	2	датчик температуры	temp sensor	32.780000000000001	35	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:54:37.250653+02	\N	2011-03-30 15:54:14.143088+02	2011-03-30 15:54:37.254863+02	
1334	5	62	90	136	PC94	\N		standard	1	\N	\N	85	2	2	датчик к-вала	crank sensor	15.550000000000001	26	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:54:37.257208+02	\N	2011-03-30 15:54:14.149045+02	2011-03-30 15:54:37.261601+02	
1335	7	48	59	136	360348149735	\N			1	\N	\N	76	2	2	комплект фар	headlamp pkg	335	469	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:54:37.264771+02	\N	2011-03-30 15:54:14.155613+02	2011-03-30 15:54:37.268975+02	
1336	5	45	97	136	691210TS	\N		K&N	1	\N	\N	17	7	2	фильтр комплект	typhoon Kit	291.85000000000002	407	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:54:37.271344+02	\N	2011-03-30 15:54:14.162236+02	2011-03-30 15:54:37.27551+02	
1337	4	13	13	136	60100SHJA91ZZ 	\N			1	\N	\N	84	7	2	капот	hood	338.67000000000002	360	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:54:37.277877+02	\N	2011-03-30 15:54:14.169501+02	2011-03-30 15:54:37.282089+02	
1338	4	13	13	136	74151SHJA01	\N			1	\N	\N	84	7	2	подкрылок левый	liner left	43.020000000000003	46	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:54:37.284474+02	\N	2011-03-30 15:54:14.175054+02	2011-03-30 15:54:37.288627+02	
1339	4	13	13	136	75810SHJC01	\N			1	\N	\N	84	7	2	брызговик левый	mud guard left	53.299999999999997	56	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:54:37.291074+02	\N	2011-03-30 15:54:14.181027+02	2011-03-30 15:54:37.295236+02	
1340	4	35	35	136	5310133230B1	\N			1	\N	\N	92	1	2	решетка радиатора	grille	203.43000000000001	216	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:54:37.298101+02	\N	2011-03-30 15:54:14.188216+02	2011-03-30 15:54:37.302387+02	
1341	5	62	98	136	CA10359	\N		fram	1	\N	\N	82	2	2	фильтр воздушный	air filter	17.809999999999999	29	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:54:37.304744+02	\N	2011-03-30 15:54:14.195476+02	2011-03-30 15:54:37.308953+02	
1342	4	13	13	136	84251TE0A00ZB	\N			1	\N	\N	15	12	2	накладка	cover	15.49	19	\N	\N	\N	\N	\N	in_processing	2011-03-30 15:54:37.311958+02	\N	2011-03-30 15:54:14.201196+02	2011-03-30 15:54:37.316097+02	
1344	5	61	60	137	H0309	\N		odyssey 2008	1	\N	\N	84	8	2	бампер передний	bumper front	89	152	\N	\N	\N	\N	\N	in_processing	2011-03-30 16:51:00.095217+02	\N	2011-03-30 16:16:07.807441+02	2011-03-30 16:51:00.099647+02	
1328	4	47	8	135	5143592AB	\N			1	\N	\N	3	27	1	молдинг	CUPHOLDER FLOOR CONS	18.25	14.970000000000001	\N	0.20499999999999999	2.665	17.635000000000002	17.635000000000002	received_office	2011-04-09 18:37:44.230773+02	sent_representative	2011-03-30 15:36:17.841134+02	2011-04-09 18:37:44.235648+02	#104
1322	4	33	33	135	J1010SC100HB	\N			1	\N	\N	6	11	1	решетка радиатора	grille	277	235.44999999999999	\N	2.3999999999999999	31.199999999999999	266.64999999999998	266.64999999999998	received_office	2011-04-09 18:37:34.942301+02	sent_representative	2011-03-30 15:36:17.801997+02	2011-04-09 18:37:34.947272+02	#104
1323	4	2	2	135	60461S6MA00ZZ	\N			1	\N	\N	4	28	1	кронштейн	Side baffle	17.75	15.619999999999999	\N	0.30499999999999999	3.9649999999999999	19.585000000000001	19.585000000000001	received_office	2011-04-09 18:37:36.629118+02	sent_representative	2011-03-30 15:36:17.811931+02	2011-04-09 18:37:36.634112+02	#104
1326	4	47	8	135	52090402AA	\N			2	\N	\N	3	27	1	Колпак диска	CAP WHEEL CENTER	13.75	11.275	\N	0.025000000000000001	0.32500000000000001	11.6	23.199999999999999	received_office	2011-04-09 18:37:40.048718+02	sent_representative	2011-03-30 15:36:17.832565+02	2011-04-09 18:37:40.053641+02	#104
1360	5	62	69	138	600820	\N			1	\N	\N	76	4	2	диффузор кондиционера	shrood condencer	60.399999999999999	98	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:02:42.797423+02	\N	2011-03-30 18:29:21.115458+02	2011-03-30 21:02:42.809663+02	
1361	5	62	69	138	610820	\N			1	\N	\N	76	4	2	диффузор радиатора	shrood radiator	59.289999999999999	96	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:02:42.824439+02	\N	2011-03-30 18:29:21.123406+02	2011-03-30 21:02:42.828652+02	
1362	4	23	23	138	BBM328910D	\N		odyssey 2008	2	\N	\N	96	1	2	амортизатор задний	shock absorber	90.930000000000007	94	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:02:42.830945+02	\N	2011-03-30 18:29:21.129033+02	2011-03-30 21:02:42.835175+02	
1583	4	13	13	161	76833SHJA01	\N			1	\N	\N	84	17	2	переходник	joint	10.130000000000001	11	\N	\N	\N	\N	\N	in_processing	2011-04-07 21:08:31.002673+02	\N	2011-04-07 18:02:00.652778+02	2011-04-07 21:08:31.00653+02	
1584	4	13	13	161	42753SHJA82	\N			1	\N	\N	84	17	2	датчик давления	pressure sensor	68.019999999999996	72	\N	\N	\N	\N	\N	in_processing	2011-04-07 21:08:31.009787+02	\N	2011-04-07 18:02:00.659741+02	2011-04-07 21:08:31.012124+02	
1367	4	13	13	139	12210PZ1003	\N			11	\N	\N	59	6	2	маслосъемное кольцо	seal valve	1.55	1.55	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.200255+02	\N	2011-03-30 21:56:43.115501+02	2011-03-30 21:57:54.2095+02	
1363	4	2	2	138	83200TK4A01ZB			odyssey 2008	1	\N	\N	97	1	2	обшивка потолка	headliner	261.39999999999998	261.39999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:02:42.851321+02		2011-03-30 18:29:21.134954+02	2011-03-30 21:02:42.855764+02	#
1364	7	48	59	138	180503828062	\N			1	\N	\N	57	3	2	маховик	flywheel	44	85	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:02:42.860039+02	\N	2011-03-30 19:34:21.281134+02	2011-03-30 21:02:42.864593+02	
1365	4	11	11	138	F6DZ6C501A	\N			4	\N	\N	98	1	2	гидрокомпенсатор	push rod	13.48	14	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:02:42.867342+02	\N	2011-03-30 19:34:21.289608+02	2011-03-30 21:02:42.871577+02	
1366	4	11	11	138	F6AZ6564AA	\N			8	\N	\N	98	1	2	рокер	rocker	20.300000000000001	22	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:02:42.874791+02	\N	2011-03-30 19:34:21.294819+02	2011-03-30 21:02:42.878934+02	
1368	4	13	13	139	71570SHJA00	\N			1	\N	\N	84	9	2	Адсорбер заднего бампера	absorber	37.729999999999997	39.9938	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.212761+02	\N	2011-03-30 21:56:43.123491+02	2011-03-30 21:57:54.216396+02	
1369	4	13	13	139	71145SHJA00	\N			1	\N	\N	84	9	2	Кронштейн крепления фары(левый)	beam left	16.800000000000001	17.808	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.219153+02	\N	2011-03-30 21:56:43.128245+02	2011-03-30 21:57:54.222805+02	
1370	4	13	13	139	71198SHJA00	\N			1	\N	\N	84	9	2	Кронштейн крепления бампера переднего к крылу(левый)	spacer left	10.17	10.780200000000001	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.225254+02	\N	2011-03-30 21:56:43.133019+02	2011-03-30 21:57:54.228891+02	
1371	4	13	13	139	71598SHJA00	\N			1	\N	\N	84	9	2	Кронштейн крепления бампера заднего к крылу(левый)	spacer left	8.4499999999999993	8.9570000000000007	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.232796+02	\N	2011-03-30 21:56:43.138177+02	2011-03-30 21:57:54.236395+02	
1372	4	13	13	139	90101SHJA01	\N			2	\N	\N	84	9	2	Кронштейн	grommet	0.52000000000000002	0.55120000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.238942+02	\N	2011-03-30 21:56:43.142819+02	2011-03-30 21:57:54.243026+02	
1373	4	13	13	139	90102S3VA01	\N			2	\N	\N	84	9	2	Клип	grommet	0.33000000000000002	0.3498	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.246097+02	\N	2011-03-30 21:56:43.150895+02	2011-03-30 21:57:54.250412+02	
1374	4	13	13	139	90101SE0010	\N			4	\N	\N	84	9	2	Крепеж	retainer	4.3499999999999996	4.6109999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.253254+02	\N	2011-03-30 21:56:43.157151+02	2011-03-30 21:57:54.25721+02	
1375	4	13	13	139	90682SB0003	\N			2	\N	\N	84	9	2	Крепеж	grommet	0.22	0.23319999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.260206+02	\N	2011-03-30 21:56:43.164106+02	2011-03-30 21:57:54.264212+02	
1376	4	13	13	139	91503SHJA01	\N			2	\N	\N	84	9	2	Клип	clip	1.1200000000000001	1.1872	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.267121+02	\N	2011-03-30 21:56:43.17053+02	2011-03-30 21:57:54.271471+02	
1377	4	13	13	139	91505S9A003	\N			15	\N	\N	84	9	2	Клип	clip	2.1200000000000001	2.2471999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.275183+02	\N	2011-03-30 21:56:43.176704+02	2011-03-30 21:57:54.279514+02	
1378	4	13	13	139	12211PZ1004	\N			2	\N	\N	59	6	2	маслосъемное кольцо	seal valve	1.55	1.55	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.282574+02	\N	2011-03-30 21:56:43.18311+02	2011-03-30 21:57:54.286904+02	
1379	4	13	13	139	17230RGLA00	\N			1	\N	\N	84	9	2	Резонатор воздушного фильтра	resonator	39.020000000000003	41.361199999999997	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.29124+02	\N	2011-03-30 21:56:43.189235+02	2011-03-30 21:57:54.295539+02	
1380	4	13	13	139	74155SHJA00	\N			1	\N	\N	84	9	2	Адсорбер левого крыла	closure panel left	5.9800000000000004	6.3388	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.299384+02	\N	2011-03-30 21:56:43.195814+02	2011-03-30 21:57:54.30379+02	
1381	4	13	13	139	74111SHJA02	\N			1	\N	\N	84	9	2	Защита моторного отсека	splash shield	28.57	30.284199999999998	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.306653+02	\N	2011-03-30 21:56:43.202367+02	2011-03-30 21:57:54.310791+02	
1382	4	13	13	139	91503SZ5003	\N			6	\N	\N	84	9	2	Клип	clip	3.0299999999999998	3.2118000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.313839+02	\N	2011-03-30 21:56:43.208586+02	2011-03-30 21:57:54.318351+02	
1383	4	13	13	139	91512SX0003	\N			23	\N	\N	84	9	2	Клип	clip	1.3300000000000001	1.4097999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.321214+02	\N	2011-03-30 21:56:43.21487+02	2011-03-30 21:57:54.324696+02	
1384	4	13	13	139	74146SHJA01	\N			1	\N	\N	84	9	2	Уплотнение капота	seal  	22.859999999999999	24.2316	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.327004+02	\N	2011-03-30 21:56:43.220946+02	2011-03-30 21:57:54.330442+02	
1385	4	13	13	139	91518S10003	\N			21	\N	\N	84	9	2	Клип уплотнение капота	clip	2.5699999999999998	2.7242000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.333751+02	\N	2011-03-30 21:56:43.227674+02	2011-03-30 21:57:54.337356+02	
1386	4	13	13	139	44733SHJA00	\N			1	\N	\N	84	9	2	Колпак колеса        R16	wheel cover	31.52	33.411200000000001	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.340188+02	\N	2011-03-30 21:56:43.233949+02	2011-03-30 21:57:54.343669+02	
1387	4	13	13	139	9391315520	\N			8	\N	\N	84	9	2	Саморез	screw	0.59999999999999998	0.63600000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.346131+02	\N	2011-03-30 21:56:43.240223+02	2011-03-30 21:57:54.350043+02	
1388	4	13	13	139	91506S9A003	\N			8	\N	\N	84	9	2	Клип	clip	2.1200000000000001	2.2471999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.352519+02	\N	2011-03-30 21:56:43.247223+02	2011-03-30 21:57:54.356021+02	
1389	4	13	13	139	71510SHJA00	\N			1	\N	\N	84	9	2	Накладка на задний бампер	step pad	31.030000000000001	32.891800000000003	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.358723+02	\N	2011-03-30 21:56:43.253564+02	2011-03-30 21:57:54.362379+02	
1390	4	13	13	139	84251SHJA00ZF	\N			1	\N	\N	84	9	2	Передний левый порог двери	plate left front	11.93	12.645799999999999	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.365183+02	\N	2011-03-30 21:56:43.2599+02	2011-03-30 21:57:54.369097+02	
1391	4	13	13	139	71850SHJA02	\N			1	\N	\N	84	9	2	Передний левый порог 	rocker molding left	45.100000000000001	47.805999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.371715+02	\N	2011-03-30 21:56:43.266231+02	2011-03-30 21:57:54.375234+02	
1392	4	13	13	139	08P09SHJ100R2	\N			1	\N	\N	84	9	2	брызговики задние	mud guard rear	54.270000000000003	58	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.377497+02	\N	2011-03-30 21:56:43.272711+02	2011-03-30 21:57:54.381154+02	
1393	4	12	6	139	24507608	\N			1	\N	\N	99	1	2	прокладка под компрессор	gasket	12.199999999999999	15	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.383736+02	\N	2011-03-30 21:56:43.280652+02	2011-03-30 21:57:54.3874+02	
1394	4	2	2	139	57455STXA01      	\N			1	\N	\N	100	1	2	датчик абс перед лев	abs sensor left front	33.329999999999998	33.329999999999998	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.38978+02	\N	2011-03-30 21:56:43.288651+02	2011-03-30 21:57:54.392911+02	
1395	4	2	2	139	75810STXA10ZA    	\N			1	\N	\N	100	1	2	брызговик лев передний	mud guard left front	36.020000000000003	36.020000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.395168+02	\N	2011-03-30 21:56:43.295245+02	2011-03-30 21:57:54.398999+02	
1396	4	47	47	139	5171101AB     	\N			1	\N	\N	100	1	2	лев кулак 	knukle left	122	122	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.401261+02	\N	2011-03-30 21:56:43.301647+02	2011-03-30 21:57:54.404804+02	
1397	4	47	47	139	5293138AA	\N			1	\N	\N	100	1	2	датчик температуры	sensor air temp	8.3000000000000007	8.3000000000000007	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.407071+02	\N	2011-03-30 21:56:43.308329+02	2011-03-30 21:57:54.410723+02	
1398	4	13	13	139	71145SHJA00	\N			1	\N	\N	84	9	2	Кронштейн	beam left	16.800000000000001	17.808	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.412991+02	\N	2011-03-30 21:56:43.314754+02	2011-03-30 21:57:54.41644+02	
1399	4	13	13	139	71140SHJA00	\N			1	\N	\N	84	9	2	Кронштейн	beam right	16.800000000000001	17.808	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.418922+02	\N	2011-03-30 21:56:43.321013+02	2011-03-30 21:57:54.42234+02	
1401	4	13	13	139	71108SHJA00	\N			1	\N	\N	84	9	2	Нижняя решетка бампера(левая)	grille left	15.73	16.6738	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.431662+02	\N	2011-03-30 21:56:43.333676+02	2011-03-30 21:57:54.435174+02	
1402	4	13	13	139	71103SHJA00	\N			1	\N	\N	84	9	2	Нижняя решетка бампера(правая)	grille right	15.73	16.6738	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.437696+02	\N	2011-03-30 21:56:43.340159+02	2011-03-30 21:57:54.441308+02	
1403	4	13	13	139	71110SHJA00	\N			1	\N	\N	84	9	2	Нижний спойлер переднего бампера	spoiler	15.93	16.8858	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.443817+02	\N	2011-03-30 21:56:43.347354+02	2011-03-30 21:57:54.447434+02	
1511	5	62	73	153	 B144	\N			1	\N	\N	98	2	2	фильтр акпп	filter trans	25.370000000000001	40	\N	\N	\N	\N	\N	in_processing	2011-04-05 18:43:29.339874+02	\N	2011-04-05 17:41:55.468697+02	2011-04-05 18:43:29.346535+02	
1400	4	13	13	139	71102SHJA00	\N			1	\N	\N	84	9	2	Нижняя решетка бампера(центральная)	grille centr	32.920000000000002	34.895200000000003	\N	\N	\N	\N	\N	in_processing	2011-03-30 21:57:54.425381+02	\N	2011-03-30 21:56:43.3272+02	2011-03-30 21:57:54.428981+02	
1408	5	46	61	141	6K605	\N		ЗАКАЗАНО	1	\N	\N	99	2	2	ремень генератора	belt	13.58	24	\N	0.14499999999999999	1.8849999999999998	25.884999999999998	25.884999999999998	received_office	2011-04-09 18:37:59.580822+02	sent_representative	2011-03-31 17:12:40.715706+02	2011-04-09 18:37:59.585734+02	#104
1409	5	46	61	141	6K860	\N		ЗАКАЗАНО	1	\N	\N	99	2	2	ремень г/у	belt	21.399999999999999	35	\N	0.20000000000000001	2.6000000000000001	37.600000000000001	37.600000000000001	received_office	2011-04-09 18:38:02.968279+02	sent_representative	2011-03-31 17:12:40.723068+02	2011-04-09 18:38:02.973875+02	#104
1410	5	62	58	141	917022	\N	dorman		1	\N	\N	99	2	2	демпфер	coupling	14.82	24	\N	\N	\N	\N	\N	in_processing	2011-03-31 17:12:58.679482+02	\N	2011-03-31 17:12:40.72749+02	2011-03-31 17:12:58.682951+02	
1411	7	48	59	142	270714917008	\N			1	\N	\N	84	11	2	решетка радиатора	grille	125	162.5	\N	\N	\N	\N	\N	in_processing	2011-03-31 17:25:55.436124+02	\N	2011-03-31 17:25:39.686194+02	2011-03-31 17:25:55.445213+02	
1413	4	33	33	143	20204AG01B	\N			4	\N	\N	6	12	1	сайлентблок	bushing	10.58	9	\N	\N	\N	\N	\N	in_processing	2011-03-31 21:26:57.263656+02	\N	2011-03-31 21:26:36.308848+02	2011-03-31 21:26:57.267371+02	
1414	4	2	2	143	39120TK4A21	\N			1	\N	\N	6	12	1	динамик	speaker 	27.52	24.219999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-31 21:26:57.271699+02	\N	2011-03-31 21:26:36.328129+02	2011-03-31 21:26:57.274089+02	
1415	4	2	2	143	51210S6MA00	\N			1	\N	\N	4	29	1	поворотный кулак	Knuckle	185.78	163.49000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-31 21:26:57.276364+02	\N	2011-03-31 21:26:36.337968+02	2011-03-31 21:26:57.278686+02	
1416	4	2	2	143	51605S6MC51	\N			1	\N	\N	4	29	1	амортизатор	Strut	187.28	164.81	\N	\N	\N	\N	\N	in_processing	2011-03-31 21:26:57.281248+02	\N	2011-03-31 21:26:36.345781+02	2011-03-31 21:26:57.283575+02	
1417	4	33	33	143	60315FC220	\N			1	\N	\N	4	29	1	амортизатор крышки багажника	lift support	66.700000000000003	58.700000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-31 21:26:57.285794+02	\N	2011-03-31 21:26:36.350493+02	2011-03-31 21:26:57.288058+02	
1418	4	33	33	143	60315FC230	\N			1	\N	\N	4	29	1	амортизатор крышки багажника	lift support	66.700000000000003	58.700000000000003	\N	\N	\N	\N	\N	in_processing	2011-03-31 21:26:57.291175+02	\N	2011-03-31 21:26:36.355269+02	2011-03-31 21:26:57.293578+02	
1419	4	13	13	143	76400SDAA03	\N			1	\N	\N	4	29	1	зеркало	mirror	16.48	14.5	\N	\N	\N	\N	\N	in_processing	2011-03-31 21:26:57.296383+02	\N	2011-03-31 21:26:36.361703+02	2011-03-31 21:26:57.298726+02	
1420	5	61	60	144	S0207	\N		ЗАКАЗАНО	1	\N	\N	27	9	1	бампер	bumper	130	187	\N	4.2800000000000002	55.640000000000001	242.63999999999999	242.63999999999999	received_office	2011-04-09 18:38:04.674009+02	sent_representative	2011-03-31 21:38:15.387364+02	2011-04-09 18:38:04.678946+02	#104
1421	4	33	33	145	91121AG07C	\N			1	\N	\N	6	13	1	решётка радиатора	grille	169.94999999999999	144.46000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-31 22:25:09.815494+02	\N	2011-03-31 22:24:59.01023+02	2011-03-31 22:25:09.821754+02	
1422	4	35	35	145	661200C020	\N			1	\N	\N	4	30	1	петля	hingle	39.840000000000003	35.060000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-31 22:25:09.828168+02	\N	2011-03-31 22:24:59.036073+02	2011-03-31 22:25:09.83213+02	
1423	4	35	35	145	661100C020	\N			1	\N	\N	4	30	1	петля	hingle	34.979999999999997	30.780000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-31 22:25:09.841592+02	\N	2011-03-31 22:24:59.040884+02	2011-03-31 22:25:09.845589+02	
1425	4	23	23	146	AJ5710513	\N			2	\N	\N	3	28	1	Прокладка	GASKET,CHAIN COVER-C	6.1200000000000001	5.0199999999999996	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.269381+02	\N	2011-03-31 23:01:33.287901+02	2011-03-31 23:02:18.27438+02	
1426	4	23	23	146	AJY215SC0	\N			1	\N	\N	3	28	1	Блок управления вентилятором	C/UNIT,ELEC-FAN	96.010000000000005	78.730000000000004	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.287013+02	\N	2011-03-31 23:01:33.31818+02	2011-03-31 23:02:18.291668+02	
1428	4	2	2	146	60400STXA02ZZ	\N			1	\N	\N	5	25	1	телевизор	support	400.56999999999999	387.18000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.300713+02	\N	2011-03-31 23:01:33.330011+02	2011-03-31 23:02:18.304941+02	
1429	4	2	2	146	77220STKA01ZA	\N			1	\N	\N	5	25	1	накладка панели боковая	panel	7.0300000000000002	6.79	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.30725+02	\N	2011-03-31 23:01:33.335225+02	2011-03-31 23:02:18.31257+02	
1424	4	2	2	146	52320STKA01	\N			1	\N	\N	5	24	1	стойка стабилизатора	link	17.329999999999998	16.75	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.314956+02	\N	2011-03-31 22:34:27.453424+02	2011-03-31 23:02:18.319178+02	
1430	4	2	2	146	72121STKA01ZB	\N			1	\N	\N	5	25	1	заглушка	cover	1.8700000000000001	1.8100000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.321798+02	\N	2011-03-31 23:01:33.3401+02	2011-03-31 23:02:18.325989+02	
1431	4	2	2	146	72910STKA01	\N			1	\N	\N	5	25	1	молдинг стекла задней двери	molding	22.420000000000002	21.670000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.328168+02	\N	2011-03-31 23:01:33.345124+02	2011-03-31 23:02:18.332458+02	
1432	4	2	2	146	72721STKA01	\N			1	\N	\N	5	25	1	накладка стекла задней двери	cover	5.4199999999999999	5.2400000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.334741+02	\N	2011-03-31 23:01:33.351781+02	2011-03-31 23:02:18.338966+02	
1433	4	2	2	146	75450SAA013	\N			1	\N	\N	5	25	1	клапан вентиляции	valve	8.6799999999999997	8.3900000000000006	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.341249+02	\N	2011-03-31 23:01:33.358978+02	2011-03-31 23:02:18.345561+02	
1434	4	11	11	146	6L2Z1000154AA	\N			1	\N	\N	5	25	1	подушка подрамника верх	mount	25.530000000000001	24.68	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.348174+02	\N	2011-03-31 23:01:33.366231+02	2011-03-31 23:02:18.352561+02	
1435	4	11	11	146	6L2Z1000155AA	\N			1	\N	\N	5	25	1	подушка подрамника низ	mount	17.170000000000002	16.600000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.354859+02	\N	2011-03-31 23:01:33.373512+02	2011-03-31 23:02:18.35901+02	
1436	4	23	23	146	AJ5710522	\N			2	\N	\N	3	28	1	Прокладка	GASKET L ,T.CHAIN CO	6.4299999999999997	5.2800000000000002	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.361298+02	\N	2011-03-31 23:01:33.38093+02	2011-03-31 23:02:18.365438+02	
1437	4	11	11	146	W710231S439	\N			1	\N	\N	5	25	1	болт	bolt	7	6.7699999999999996	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.368322+02	\N	2011-03-31 23:01:33.389098+02	2011-03-31 23:02:18.372925+02	
1438	4	23	23	146	AJ5710523	\N			2	\N	\N	3	28	1	Прокладка	GASKET,TIMING COVER	6.4000000000000004	5.25	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.375469+02	\N	2011-03-31 23:01:33.397572+02	2011-03-31 23:02:18.37988+02	
1439	4	23	23	146	AJ0315980B	\N			1	\N	\N	3	28	1	Ролик натяжной	TENSIONER,BELT V	30.539999999999999	25.039999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.384587+02	\N	2011-03-31 23:01:33.406134+02	2011-03-31 23:02:18.389233+02	
1440	4	23	23	146	A60227238	\N			1	\N	\N	3	28	1	Сальник привода правый	SEAL,OIL	10.59	8.6799999999999997	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.392257+02	\N	2011-03-31 23:01:33.413883+02	2011-03-31 23:02:18.396496+02	
1441	4	23	23	146	GK2A44410C	\N			1	\N	\N	3	28	1	Трос ручника	Brakes Parking brake Rear cable Mazda6	40.159999999999997	32.93	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.398752+02	\N	2011-03-31 23:01:33.420837+02	2011-03-31 23:02:18.403375+02	
1442	4	23	23	146	A60127238	\N			1	\N	\N	3	28	1	Сальник привода	SEAL,OIL	15.92	13.050000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.406379+02	\N	2011-03-31 23:01:33.428081+02	2011-03-31 23:02:18.410782+02	
1443	4	23	23	146	H00126205	\N			4	\N	\N	3	28	1	Подшипник	BEARING	20.850000000000001	17.100000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.413157+02	\N	2011-03-31 23:01:33.435643+02	2011-03-31 23:02:18.417341+02	
1444	4	23	23	146	L3K912201A	\N			1	\N	\N	3	28	1	Цепь грм	CHAIN,TIMING	39.759999999999998	32.600000000000001	\N	\N	\N	\N	\N	in_processing	2011-03-31 23:02:18.419766+02	\N	2011-03-31 23:01:33.443115+02	2011-03-31 23:02:18.424238+02	
1427	4	47	47	146	52058539	\N			1	\N	\N	3	28	1	опора двс	PLATE TRANSMISSION M	92.450000000000003	75.810000000000002	\N	\N	\N	\N	\N	failure	2011-04-05 14:45:53.713206+02	in_processing	2011-03-31 23:01:33.323252+02	2011-04-05 14:45:53.718616+02	
1447	4	12	29	148	24572393				2	\N	\N	52	5	1	цепь грм	chain	96.459999999999994	83.340000000000003	\N	\N	\N	\N	\N	in_processing	2011-04-01 14:50:26.367665+02		2011-04-01 14:19:23.898362+02	2011-04-01 15:00:50.083065+02	#
1445	5	45	71	148	9515PT				2	\N	\N	52	5	1	прокладка ГБЦ	head gasket	22.059999999999999	31.710000000000001	\N	\N	\N	\N	\N	in_processing	2011-04-01 14:50:26.348391+02		2011-04-01 14:19:23.859279+02	2011-04-01 14:59:10.907534+02	#
1512	4	47	18	153	5116129AA	\N			1	\N	\N	105	1	2	накладка	moulding	51.450000000000003	55	\N	\N	\N	\N	\N	in_processing	2011-04-05 18:43:29.354253+02	\N	2011-04-05 17:41:55.477848+02	2011-04-05 18:43:29.358222+02	
1237	4	35	35	125	5212542020	\N			1	\N	\N	87	2	2	кольцо противотуманки правой	bracket fog lamp	31.84	34	\N	0.080000000000000002	1.04	35.039999999999999	35.039999999999999	received_office	2011-04-03 16:32:22.280747+02	in_processing	2011-03-30 14:30:35.950412+02	2011-04-03 16:32:22.285534+02	#103
1224	4	35	35	123	5311206170	\N			1	\N	\N	4	25	1	решётка	GRILLE RADIATOR LW	43.380000000000003	38.170000000000002	\N	0.39000000000000001	5.0700000000000003	43.240000000000002	43.240000000000002	received_office	2011-04-03 16:32:40.676645+02	in_processing	2011-03-30 14:24:22.355332+02	2011-04-03 16:32:40.68165+02	#103
1218	4	26	26	122	921141AA0B	\N			1	\N	\N	19	6	1	кронштейн	bracket	3.2799999999999998	3.2799999999999998	\N	0.035000000000000003	0.45500000000000007	3.7349999999999999	3.7349999999999999	received_office	2011-04-03 16:32:49.315182+02	in_processing	2011-03-30 14:21:41.294299+02	2011-04-03 16:32:49.320902+02	#103
1195	4	13	13	122	71510SHJA00	\N			1	\N	\N	86	1	2	накладка на задний бампер	tube	31.030000000000001	33	\N	0.27000000000000002	3.5100000000000002	36.509999999999998	36.509999999999998	received_office	2011-04-03 16:33:28.899992+02	in_processing	2011-03-30 14:19:17.460475+02	2011-04-03 16:33:28.905132+02	#103
1185	4	35	35	121	5212706140	\N			1	\N	\N	73	5	2	накладка правая	hole cover right	32.700000000000003	63	\N	0.14499999999999999	1.8849999999999998	64.885000000000005	64.885000000000005	received_office	2011-04-03 16:33:54.16066+02	in_processing	2011-03-30 14:11:19.864016+02	2011-04-03 16:33:54.165759+02	#103
1446	5	46	61	148	D1808A				1	\N	\N	52	5	1	датчик давления масла	pressure sensor	19.02	27.350000000000001	\N	\N	\N	\N	\N	in_processing	2011-04-01 14:51:03.47152+02		2011-04-01 14:19:23.88971+02	2011-04-01 15:00:36.861005+02	#
1448	7	48	59	148	350410736846				5	\N	\N	52	6	1	ручка наружная левая	handle outside	11.1	20	\N	\N	\N	\N	\N	in_processing	2011-04-01 14:55:23.314886+02		2011-04-01 14:55:12.661232+02	2011-04-01 15:01:00.00992+02	#
1449	7	48	59	148	370450765767				5	\N	\N	52	6	1	ручка наружная правая	handle outside	11.1	20	\N	\N	\N	\N	\N	in_processing	2011-04-01 14:55:23.324994+02		2011-04-01 14:55:12.679414+02	2011-04-01 15:01:13.219513+02	#
1180	4	2	2	119	75450SAA013	\N			1	\N	\N	5	23	2	клапан вентиляции	Air outlet	8.6799999999999997	7.5499999999999998	\N	0.050000000000000003	0.65000000000000002	8.1999999999999993	8.1999999999999993	received_office	2011-04-03 16:33:59.997699+02	in_processing	2011-03-30 14:04:10.360199+02	2011-04-03 16:34:00.002922+02	#103
1178	4	11	11	119	7L2Z7R081E	\N			1	\N	\N	5	23	2	трубка охлаждения масла АКПП	tube trans	77.019999999999996	74.450000000000003	\N	0.75	9.75	84.200000000000003	84.200000000000003	received_office	2011-04-03 16:34:09.119244+02	in_processing	2011-03-30 14:04:10.342344+02	2011-04-03 16:34:09.12443+02	#103
1173	4	23	23	119	GK2C39040C	\N			1	\N	\N	7	17	1	подушка двигателя 	Engine - Mounts 	150.06	135.05000000000001	\N	0.755	9.8149999999999995	144.86500000000001	144.86500000000001	received_office	2011-04-03 16:34:15.220477+02	in_processing	2011-03-30 13:58:47.395287+02	2011-04-03 16:34:15.225991+02	#103
1106	7	48	59	108	270707726126	\N			1	\N	\N	5	20	1	фара головного света правая	headlight	328	428.04000000000002	\N	4.1950000000000003	54.535000000000004	482.57500000000005	482.57500000000005	received_office	2011-04-03 16:34:26.238878+02	in_processing	2011-03-29 13:55:04.853661+02	2011-04-03 16:34:26.24425+02	#103
1260	4	23	23	128	000018BP03				12	\N	\N	3	25	1	Свеча зажигания	SPARK PLUG - FLASH 0	4.0300000000000002	3.2999999999999998	3.2999999999999998	0.047	0.61099999999999999	3.9109999999999996	46.931999999999995	issued	2011-04-04 19:59:26.813408+02	received_office	2011-03-30 14:48:04.078915+02	2011-04-04 21:13:52.218403+02	#103
1274	5	46	62	131	sp486	\N		ЗАКАЗАНО 	8	\N	\N	53	2	2	свеча	spark plug	2.98	0.875	\N	0.047	0.61099999999999999	1.486	11.888	received_office	2011-04-03 16:31:53.968963+02	in_processing	2011-03-30 14:59:00.656989+02	2011-04-03 16:31:53.974076+02	#103
1272	5	61	60	131	F0774	\N		ЗАКАЗАНО	1	\N	\N	87	4	2	крыло левое	fender left	59	100	\N	3.6499999999999999	47.449999999999996	147.44999999999999	147.44999999999999	received_office	2011-04-03 16:31:59.911467+02	in_processing	2011-03-30 14:59:00.639437+02	2011-04-03 16:31:59.91638+02	#103
1072	4	23	23	105	ZZC411400	\N			1	\N	\N	3	20	1	Шкив коленвала	PULLEY,CRANKSHAFT	58.579999999999998	48.030000000000001	48.030000000000001	2.3799999999999999	30.939999999999998	78.969999999999999	78.969999999999999	issued	2011-04-04 19:59:34.855304+02	received_office	2011-03-29 12:11:41.42999+02	2011-04-04 19:59:34.858924+02	#103
1451	7	48	59	149	280639245942	\N			1	\N	\N	101	1	1	поршни и шатуны	rod piston set	1101.8699999999999	1381.0899999999999	\N	\N	\N	\N	\N	in_processing	2011-04-04 18:02:39.723815+02	\N	2011-04-04 18:01:57.368948+02	2011-04-04 18:02:39.728316+02	
1459	4	14	14	150	583052BA00	\N			1	\N	\N	3	29	1	Колодки ручного тормоза	Shoes, santa fe	60.579999999999998	51.5	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.456187+02	\N	2011-04-04 19:42:25.153478+02	2011-04-04 19:43:01.460857+02	
1460	4	19	19	150	86511-3F050	\N	nekrasof		1	\N	\N	3	29	1	Бампер передний	COVER-FR BUMPER	270	229.5	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.464232+02	\N	2011-04-04 19:42:25.158062+02	2011-04-04 19:43:01.467492+02	
1452	4	47	8	150	52028440	\N			1	\N	\N	4	31	1	лопасти вентилятора	FAN COOLING	65.75	57.859999999999999	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.470509+02	\N	2011-04-04 18:59:41.681187+02	2011-04-04 19:43:01.474027+02	
1453	4	23	23	150	GS3L34350B	\N			1	\N	\N	4	31	1	рычаг левый	lower arm left	203.86000000000001	179.40000000000001	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.477418+02	\N	2011-04-04 18:59:41.687771+02	2011-04-04 19:43:01.480877+02	
1454	4	13	13	150	28260RPC004	\N			1	\N	\N	4	31	1	соленоид	SOLENOID	233.62	205.59	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.484035+02	\N	2011-04-04 18:59:41.692358+02	2011-04-04 19:43:01.48738+02	
1455	4	13	13	150	28262RPC000	\N			1	\N	\N	4	31	1	прокладка	GASKET	3.2000000000000002	2.8199999999999998	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.490871+02	\N	2011-04-04 18:59:41.697603+02	2011-04-04 19:43:01.494398+02	
1456	4	2	2	150	51920S5A751	\N			1	\N	\N	4	31	1	опора	Mount	56.270000000000003	49.520000000000003	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.49757+02	\N	2011-04-04 18:59:41.701888+02	2011-04-04 19:43:01.501004+02	
1457	4	2	2	150	51350S6MA51	\N			1	\N	\N	4	31	1	рычаг	Lower control arm	167.02000000000001	146.97999999999999	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.504483+02	\N	2011-04-04 18:59:41.70635+02	2011-04-04 19:43:01.507742+02	
1462	4	23	23	150	CC2934156C	\N			4	\N	\N	3	29	1	Втулка стабилизатора	BUSH,STABILIZER-FRT	7.75	6.3899999999999997	6.3899999999999997	0	\N	\N	\N	in_processing	2011-04-04 19:43:01.51744+02	\N	2011-04-04 19:42:25.170757+02	2011-04-04 19:57:18.369559+02	
1463	4	47	8	150	5113147AA 	\N			1	\N	\N	3	29	1	заглушка	COVER LAMP OPENING	21.25	17.530000000000001	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.522918+02	\N	2011-04-04 19:42:25.175256+02	2011-04-04 19:43:01.5266+02	
1464	4	47	8	150	4668448AA	\N			1	\N	\N	3	29	1	шкив 	PULLEY POWER STEERIN	20.449999999999999	16.870000000000001	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.529769+02	\N	2011-04-04 19:42:25.179762+02	2011-04-04 19:43:01.533452+02	
1465	4	23	23	150	AJ0310155 				24	\N	\N	3	29	1	Колпачок маслосъёмный	SEAL,VALVE	2.4700000000000002	2.04	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.536712+02		2011-04-04 19:42:25.185416+02	2011-04-04 19:58:56.847097+02	
1450	4	23	23	128	000018BP03				8	\N	\N	3	25	1	свеча зажигания	spark plug	4.0300000000000002	3.2999999999999998	\N	0.048000000000000001	0.624	3.9239999999999999	31.391999999999999	received_office	2011-04-09 18:38:06.217203+02	sent_representative	2011-04-03 16:16:07.80075+02	2011-04-09 18:38:06.232231+02	#104
1466	4	23	23	150	CC2934156C 				6	\N	\N	3	29	1	Втулка стабилизатора переднего	BUSH,STABILIZER-FRT	7.75	6.3899999999999997	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.541758+02		2011-04-04 19:42:25.19046+02	2011-04-04 19:58:53.226412+02	
1468	4	23	23	150	FS0210602 				2	\N	\N	3	29	1	Сальник	OIL SEAL	9.5199999999999996	7.8499999999999996	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.552216+02		2011-04-04 19:42:25.200177+02	2011-04-04 19:58:46.79159+02	
1467	4	23	23	150	GY0113220B 				2	\N	\N	3	29	1	Патрубок воздухозаборника	HOSE,AIR	22.390000000000001	18.469999999999999	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.546642+02		2011-04-04 19:42:25.195295+02	2011-04-04 19:58:50.328922+02	
1469	4	23	23	150	GK2A-34-156 				20	\N	\N	3	29	1	Втулка стабилизатора	BUSH,STABILIZER-FRT	2.0699999999999998	1.71	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.557079+02		2011-04-04 19:42:25.204969+02	2011-04-04 19:58:43.596749+02	
1470	4	23	23	150	GK2A-28-156A 				10	\N	\N	3	29	1	Втулка стабилизатора	Bushing, mazda6, all - mazda6	1.45	1.1899999999999999	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.56193+02		2011-04-04 19:42:25.209957+02	2011-04-04 19:58:40.30681+02	
1582	4	13	13	161	76832SHJA01	\N			1	\N	\N	84	17	2	переходник	joint	10.130000000000001	11	\N	\N	\N	\N	\N	in_processing	2011-04-07 21:08:31.020004+02	\N	2011-04-07 18:02:00.645522+02	2011-04-07 21:08:31.022358+02	
1461	4	19	19	150	92303-3F050	\N	nekrasof		1	\N	\N	3	29	1	Габарит в бампер лев.сторона	LAMP ASSY-FR S/MARKE	17.800000000000001	15.130000000000001	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.510817+02	\N	2011-04-04 19:42:25.164794+02	2011-04-04 19:43:01.514174+02	
1483	1	79	26	20	FCA011BAMA	\N			1	\N	\N	84	12	1	Крыло переднее		208.75	285	\N	\N	\N	\N	\N	issued	2011-04-05 11:38:01.235432+02	in_processing	2011-04-05 11:32:52.037568+02	2011-04-05 11:38:01.241704+02	
1482	1	79	26	20	625011BA0B	\N			1	\N	\N	84	12	1	Диффузор радиатора		209.87	313	\N	\N	\N	\N	\N	issued	2011-04-05 11:38:04.829049+02	in_processing	2011-04-05 11:32:52.024891+02	2011-04-05 11:38:04.833984+02	
1473	4	23	23	150	L3K9124X0C				1	\N	\N	3	29	1	Звездочка распредвала	ACTR,VARIABLE V. TIM	127.38	105.09	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.443486+02		2011-04-04 19:42:25.225668+02	2011-04-04 19:50:05.347137+02	
1479	2	68	4	19	64319159606	\N			1	\N	\N	31	11	1	Комплект микрофильтров с углем	-	105.3	116	\N	\N	\N	\N	\N	issued	2011-04-05 11:38:34.807403+02	in_processing	2011-04-04 22:08:05.031066+02	2011-04-05 11:38:34.812457+02	
1477	2	73	13	19	52360STXA01	\N			1	\N	\N	31	11	1	Рычаг	-	252.05000000000001	278	\N	\N	\N	\N	\N	issued	2011-04-05 11:38:36.964836+02	in_processing	2011-04-04 22:08:05.013663+02	2011-04-05 11:38:36.970074+02	
1476	2	81	13	18	42312MAY000	\N			1	\N	\N	31	10	1	Втулка	-	21.620000000000001	24	\N	\N	\N	\N	\N	issued	2011-04-05 11:42:04.572339+02	in_processing	2011-04-04 21:56:10.981438+02	2011-04-05 11:42:04.581096+02	
1472	4	23	23	150	L3K912429 				2	\N	\N	3	29	1	Шайба	WASHER	8.5199999999999996	7.0199999999999996	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.571541+02		2011-04-04 19:42:25.22038+02	2011-04-04 19:58:32.226895+02	
1458	4	23	23	150	LF0114320A9U 				2	\N	\N	3	29	1	Корпус фильтра масляного	Engine / transaxle Engine parts Cover Cover	17.149999999999999	14.140000000000001	\N	\N	\N	\N	\N	in_processing	2011-04-04 19:43:01.451225+02		2011-04-04 19:42:25.146715+02	2011-04-04 19:58:59.78397+02	
1475	2	81	13	18	42312MW3600	\N			1	\N	\N	31	10	1	Втулка	-	20	22	\N	\N	\N	\N	\N	issued	2011-04-05 11:42:07.155186+02	in_processing	2011-04-04 21:56:10.976555+02	2011-04-05 11:42:07.161747+02	
1486	2	66	106	21	ZD784	\N			1	\N	\N	25	3	1	Колодки тормозные передние	1370.14	51.689999999999998	51.689999999999998	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.409392+02	\N	2011-04-05 13:48:42.466295+02	2011-04-05 13:49:23.41772+02	
1474	2	80	63	18	PGD787C				1	\N	\N	25	2	2	Колодки тормозные передние	-	45.140000000000001	49.649999999999999	\N	\N	\N	\N	\N	in_processing	2011-04-04 21:56:20.279235+02		2011-04-04 21:56:10.962196+02	2011-04-04 22:02:29.093169+02	#
1487	2	73	13	21	91257MAY003	\N			2	\N	\N	31	12	1	Уплотнение пыленепроницаемое	-	7.5300000000000002	8	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.421716+02	\N	2011-04-05 13:48:42.484891+02	2011-04-07 12:52:55.310241+02	
1489	2	68	4	21	11287799859	\N			1	\N	\N	102	1	1	Обводной ролик	1162.33	43.560000000000002	48	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.444811+02	\N	2011-04-05 13:48:42.499065+02	2011-04-05 13:49:23.451606+02	
1478	2	65	63	19	PGD1047C				1	\N	\N	48	3	2	Колодки тормозные передние	-	38.689999999999998	48	\N	\N	\N	\N	\N	in_processing	2011-04-04 22:08:13.813343+02		2011-04-04 22:08:05.02592+02	2011-04-04 22:14:38.883965+02	#
1480	7	53	102	151	708125-6	\N		dana spiser http://www.drivetrain.com/parts_catalog/ring_and_pinions/dana_60_differential_parts.html	1	\N	\N	78	7	1	главная пара	ring gear	367.45999999999998	1280	\N	\N	\N	\N	\N	in_processing	2011-04-04 23:15:44.352045+02	\N	2011-04-04 23:14:56.761366+02	2011-04-04 23:15:44.355806+02	
1481	4	35	35	152	4260706011	\N			1	\N	\N	4	32	1	Датчик давления воздуха	Pressure sensor	101.09	88.959999999999994	\N	\N	\N	\N	\N	in_processing	2011-04-05 11:27:49.919212+02	\N	2011-04-05 11:16:06.077111+02	2011-04-05 11:27:49.925654+02	
1490	2	70	76	21	986479436	\N			2	\N	\N	102	1	1	Диск тормозной передний	2765.62	103.62	118	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.45501+02	\N	2011-04-05 13:48:42.503738+02	2011-04-05 13:49:23.461751+02	
1491	2	95	105	21	20929612	\N			2	\N	\N	102	1	1	Тяга заднего стабилизатора	664.26	24.890000000000001	27	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.466244+02	\N	2011-04-05 13:48:42.508219+02	2011-04-05 13:49:23.473065+02	
399	2	66	61	3	213347	\N			1	\N	\N	22	1	2	Датчик скорости выходного вала раздатки	-	33.890000000000001	48	\N	\N	\N	\N	\N	issued	2011-04-05 12:02:05.04679+02	in_processing	2011-02-22 22:41:40.288524+01	2011-04-05 12:02:05.051887+02	143
1485	1	79	26	20	638451BA0A	\N			1	\N	\N	84	12	1	Подкрылок		25.079999999999998	33	\N	\N	\N	\N	\N	issued	2011-04-05 11:37:57.493593+02	in_processing	2011-04-05 11:32:52.050365+02	2011-04-05 11:37:57.501406+02	
1484	1	79	26	20	638431BA0A	\N			1	\N	\N	84	12	1	Подкрылок		32.780000000000001	45	\N	\N	\N	\N	\N	issued	2011-04-05 11:37:59.451046+02	in_processing	2011-04-05 11:32:52.043948+02	2011-04-05 11:37:59.456683+02	
1492	2	4	4	21	11287799851	\N			1	\N	\N	102	1	1	Механический натяжитель ремня	2523.05	94.530000000000001	109	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.476889+02	\N	2011-04-05 13:48:42.51287+02	2011-04-05 13:49:23.483818+02	
1493	2	90	103	21	1H1832	\N			1	\N	\N	61	4	1	Тяга стабилизатора передняя правая	185.28	6.9900000000000002	10	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.487314+02	\N	2011-04-05 13:48:42.518321+02	2011-04-05 13:49:23.494313+02	
1494	2	90	103	21	1H1833	\N			1	\N	\N	61	4	1	Тяга стабилизатора передняя левая	185.28	6.9900000000000002	10	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.497726+02	\N	2011-04-05 13:48:42.522602+02	2011-04-05 13:49:23.50442+02	
1495	2	65	63	21	PGD536C	\N			1	\N	\N	25	3	1	Колодки тормозные задние	750.42	28.219999999999999	51.689999999999998	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.507922+02	\N	2011-04-05 13:48:42.52689+02	2011-04-05 13:49:23.514913+02	
1488	2	73	13	21	91054MAM003	\N			2	\N	\N	31	12	1	Шарикоподшипник	-	24.620000000000001	25	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.433838+02	\N	2011-04-05 13:48:42.489682+02	2011-04-07 12:52:52.452287+02	
1496	2	91	26	21	2069265J00	\N			1	\N	\N	31	12	1	Прокладка глушителя	-	6.8399999999999999	7	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.519164+02	\N	2011-04-05 13:48:42.531529+02	2011-04-07 12:52:49.491298+02	
1498	2	92	4	21	31206779735	\N			1	\N	\N	102	1	1	Ступица колеса пд с подшипником	9200.81	346.00999999999999	363	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.542908+02	\N	2011-04-05 13:48:42.544703+02	2011-04-05 13:49:23.550051+02	
1499	2	93	104	21	2417001	\N			1	\N	\N	102	1	1	Тормозные колодки	2279.63	85.730000000000004	90	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.55366+02	\N	2011-04-05 13:48:42.551538+02	2011-04-05 13:49:23.56081+02	
1497	2	91	26	21	206921E810	\N			2	\N	\N	31	12	1	Прокладка приемной трубы	-	4.7800000000000002	5	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.531712+02	\N	2011-04-05 13:48:42.537848+02	2011-04-07 12:52:45.540061+02	
1501	2	73	13	22	45251STXA00	\N			1	\N	\N	5	26	1	Диск тормозной передний	-	211	276.60000000000002	\N	\N	\N	\N	\N	in_processing	2011-04-05 15:00:49.718787+02	\N	2011-04-05 15:00:20.415511+02	2011-04-05 15:00:49.727002+02	
1503	2	68	13	23	30500MAN003	\N			1	\N	\N	31	13	1	Катушка зажигания		91.959999999999994	92	94	\N	\N	\N	\N	issued	2011-04-07 14:13:12.036949+02	in_processing	2011-04-05 15:04:30.118771+02	2011-04-07 14:13:12.040867+02	
1504	5	61	60	153	G0120	\N			1	\N	\N	73	11	2	капот	hood	130	202	\N	\N	\N	\N	\N	in_processing	2011-04-05 18:43:29.369217+02	\N	2011-04-05 17:41:55.399908+02	2011-04-05 18:43:29.371462+02	
1505	5	62	87	153	GM1200527	\N			1	\N	\N	73	11	2	решетка радиатора	grille	38.409999999999997	60	\N	\N	\N	\N	\N	in_processing	2011-04-05 18:43:29.374955+02	\N	2011-04-05 17:41:55.416324+02	2011-04-05 18:43:29.377253+02	
1506	4	15	15	153	648951BA0A	\N			1	\N	\N	84	13	2	корпус  	cover	67.620000000000005	72	\N	\N	\N	\N	\N	in_processing	2011-04-05 18:43:29.379997+02	\N	2011-04-05 17:41:55.422824+02	2011-04-05 18:43:29.38236+02	
1508	4	13	13	153	11410PWC010	\N			1	\N	\N	73	11	2	крышка грм	timing cove	118.02	125	\N	\N	\N	\N	\N	in_processing	2011-04-05 18:43:29.389375+02	\N	2011-04-05 17:41:55.440298+02	2011-04-05 18:43:29.391838+02	
1509	4	35	35	153	692174202004	\N			1	\N	\N	87	6	2	накладка левая	cover	8.5999999999999996	9	\N	\N	\N	\N	\N	in_processing	2011-04-05 18:43:29.394518+02	\N	2011-04-05 17:41:55.452118+02	2011-04-05 18:43:29.396996+02	
1510	5	62	87	153	TO1228144	\N			1	\N	\N	84	13	2	защита	engine cover	69	111	\N	\N	\N	\N	\N	in_processing	2011-04-05 18:43:29.399554+02	\N	2011-04-05 17:41:55.459942+02	2011-04-05 18:43:29.402086+02	
1500	2	94	4	21	13711341528	\N			1	\N	\N	31	12	1	Воздушный фильтр	-	21.93	22	\N	\N	\N	\N	\N	in_processing	2011-04-05 13:49:23.5662+02	\N	2011-04-05 13:48:42.558002+02	2011-04-07 12:52:41.550244+02	
1502	4	23	23	153	GK2A515L0	\N			1	\N	\N	4	33	1	светоотражатель	REFLECTOR R ,REFLEX	21.140000000000001	18.600000000000001	\N	\N	\N	\N	\N	in_processing	2011-04-05 18:43:29.361676+02	\N	2011-04-05 15:02:27.75333+02	2011-04-05 18:43:29.365577+02	
1507	4	15	15	153	E61111BD0B	\N			1	\N	\N	84	13	2	амортизатор	absorber	186.97999999999999	198	\N	\N	\N	\N	\N	in_processing	2011-04-05 18:43:29.384735+02	\N	2011-04-05 17:41:55.431107+02	2011-04-05 18:43:29.386967+02	
482	5	43	69	40	3592	\N	ЗАКАЗАНО:TYC	ЗАКАЗАНО:TYC	1	\N	\N	39	2	1	радиатор кондиционера	condencer	96.260000000000005	236.63999999999999	\N	\N	\N	\N	\N	in_processing	2011-03-08 13:59:44.630831+01	\N	2011-03-08 13:58:31.541053+01	2011-04-06 12:46:18.68588+02	#95
548	4	23	23	48	AJH318110	AJTT18110	0	0	12	\N	\N	3	5	1	свеча зажигания	spark plug	4.4800000000000004	3.6699999999999999	3.6699999999999999	\N	\N	\N	\N	issued	2011-04-04 19:59:56.80128+02	superseded	2011-03-08 15:46:36.562031+01	2011-04-06 12:50:58.865998+02	#95
1513	4	21	21	154	PT39860100	\N	Игорёк		1	\N	\N	4	34	1	автозапуск	RES LX570	425	374	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:19.982692+02	\N	2011-04-06 17:53:36.441224+02	2011-04-06 19:23:19.989017+02	
1514	5	62	107	154	4288N				1	\N	\N	47	1	2	полуось правая	shaft\r\nassembly right	102.90000000000001	150	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:19.993319+02		2011-04-06 18:40:01.466122+02	2011-04-06 19:23:19.995898+02	#
1515	4	2	2	154	31180-RCA-A02	\N			1	\N	\N	59	7	2	ролик натяжителя	tensioner pulley	13.93	13.93	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:19.999014+02	\N	2011-04-06 19:22:22.311649+02	2011-04-06 19:23:20.001351+02	
1516	4	2	2	154	51321-SDA-A05 	\N			1	\N	\N	34	5	2	стойка стаб-ра левая	link left	17.77	19	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:20.004128+02	\N	2011-04-06 19:22:22.318985+02	2011-04-06 19:23:20.006881+02	
1517	4	2	2	154	51320-SDA-A05	\N			1	\N	\N	34	5	2	стойка стаб-ра правая	link right	17.77	19	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:20.009819+02	\N	2011-04-06 19:22:22.323803+02	2011-04-06 19:23:20.012342+02	
1518	4	2	2	154	52308-S3M-A00 	\N			2	\N	\N	34	5	2	втулка стаб-ра	bushing	1.1699999999999999	3	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:20.015647+02	\N	2011-04-06 19:22:22.328371+02	2011-04-06 19:23:20.018534+02	
1519	4	13	13	154	47510SHJA02	\N			1	\N	\N	84	14	2	трос ручного тормоза правый	brake cable right	42.799999999999997	45	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:20.021439+02	\N	2011-04-06 19:22:22.334052+02	2011-04-06 19:23:20.024254+02	
1520	4	47	8	154	5159075AA	\N			1	\N	\N	107	1	2	моторчк омывателя	washer pump	60.75	63	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:20.027918+02	\N	2011-04-06 19:22:22.340858+02	2011-04-06 19:23:20.030779+02	
1521	4	2	2	154	31190-RCA-A02	\N			1	\N	\N	59	7	2	ролик холостой	idler pulley	18.620000000000001	18.620000000000001	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:20.033907+02	\N	2011-04-06 19:22:22.345911+02	2011-04-06 19:23:20.036833+02	
1522	4	2	2	154	74111-STX-A01	\N			1	\N	\N	59	7	2	защита	splash shield	26.5	26.5	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:20.039652+02	\N	2011-04-06 19:22:22.351705+02	2011-04-06 19:23:20.042702+02	
1523	4	2	2	154	77211-STX-A01ZA	\N			1	\N	\N	59	7	2	крышка	cover	5.4199999999999999	5.4199999999999999	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:20.046419+02	\N	2011-04-06 19:22:22.356781+02	2011-04-06 19:23:20.049732+02	
1524	4	2	2	154	77216-STX-A01ZA	\N			1	\N	\N	59	7	2	крышка	cover	5.4199999999999999	5.4199999999999999	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:20.052913+02	\N	2011-04-06 19:22:22.362397+02	2011-04-06 19:23:20.056277+02	
1525	7	48	59	154	180609488594	\N			1	\N	\N	58	5	2	противотуманные фары	fog lamp	57.979999999999997	75.400000000000006	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:20.059273+02	\N	2011-04-06 19:22:22.368685+02	2011-04-06 19:23:20.062676+02	
1526	7	48	59	154	390284569876	\N			1	\N	\N	51	2	2	накладки хром	cover chrome	80	112	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:20.067098+02	\N	2011-04-06 19:22:22.376489+02	2011-04-06 19:23:20.070568+02	
1527	7	48	59	154	390284569876	\N			1	\N	\N	93	2	2	накладки хром	cover chrome	80	112	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:20.074014+02	\N	2011-04-06 19:22:22.383373+02	2011-04-06 19:23:20.078088+02	
1528	5	62	110	154	2344516	\N			1	\N	\N	5	27	2	кислородный датчик	oxygen sensor	62.399999999999999	102	\N	\N	\N	\N	\N	in_processing	2011-04-06 19:23:20.082814+02	\N	2011-04-06 19:22:22.390773+02	2011-04-06 19:23:20.086291+02	
1529	2	89	26	24	132708J102	\N			1	\N	\N	31	14	1	Прокладка клапанной крышки		6.6600000000000001	8	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.567332+02	\N	2011-04-07 14:28:59.950471+02	2011-04-07 14:30:22.572293+02	
1530	2	74	26	24	40202EJ70B	\N			1	\N	\N	31	14	1	Ступица передняя		224.71000000000001	248	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.582864+02	\N	2011-04-07 14:28:59.960307+02	2011-04-07 14:30:22.586963+02	
1531	2	85	100	24	284678F	\N			1	\N	\N	87	7	1	Радиатор охлаждения		64.129999999999995	150	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.589388+02	\N	2011-04-07 14:28:59.967181+02	2011-04-07 14:30:22.595481+02	
1532	2	84	99	24	3121157RAS	\N			1	\N	\N	38	2	1	Фара		85.200000000000003	113	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.600736+02	\N	2011-04-07 14:28:59.975862+02	2011-04-07 14:30:22.60726+02	
1533	2	84	99	24	3121157LAS	\N			1	\N	\N	38	2	1	Фара левая		85.200000000000003	113	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.610483+02	\N	2011-04-07 14:28:59.980264+02	2011-04-07 14:30:22.617003+02	
1534	2	73	13	24	43022TA0A40	\N			1	\N	\N	31	14	1	Колодки тормозные		71.670000000000002	80	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.620315+02	\N	2011-04-07 14:28:59.984654+02	2011-04-07 14:30:22.627215+02	
1535	2	83	35	24	521460E010	\N			1	\N	\N	104	1	1	Крепеж		24.530000000000001	33	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.63058+02	\N	2011-04-07 14:28:59.990457+02	2011-04-07 14:30:22.637074+02	
1536	2	78	84	24	EV80191	\N			2	\N	\N	103	1	1	Тяга рулевая		55.170000000000002	55.170000000000002	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.640588+02	\N	2011-04-07 14:28:59.995875+02	2011-04-07 14:30:22.647179+02	
1537	2	82	26	24	27722AL500	\N			1	\N	\N	19	7	1	Датчик		18.879999999999999	25	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.650623+02	\N	2011-04-07 14:29:00.001377+02	2011-04-07 14:30:22.655977+02	
1538	2	63	35	24	634930E010	\N			1	\N	\N	104	1	1	Накладка рейлинга крыши задняя правая		29.309999999999999	38	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.658912+02	\N	2011-04-07 14:29:00.005996+02	2011-04-07 14:30:22.663386+02	
1539	2	86	26	24	132708J112	\N			1	\N	\N	31	14	1	Прокладка клапанной крышки		7.6299999999999999	9	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.666356+02	\N	2011-04-07 14:29:00.012191+02	2011-04-07 14:30:22.670486+02	
1540	2	88	8	24	52089516AB	\N			1	\N	\N	10	8	1	Сайлентблок переднего моста		42.100000000000001	51	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.673989+02	\N	2011-04-07 14:29:00.018298+02	2011-04-07 14:30:22.678028+02	
1541	2	67	101	24	PCR11016AL	\N			1	\N	\N	10	8	1	Подкрылок левый		29.859999999999999	36	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.680298+02	\N	2011-04-07 14:29:00.023561+02	2011-04-07 14:30:22.684844+02	
1542	2	73	13	24	45022S6MA00	\N			1	\N	\N	31	14	1	Комплект тормозных колодок		73.439999999999998	82	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.687159+02	\N	2011-04-07 14:29:00.027871+02	2011-04-07 14:30:22.691575+02	
1543	2	87	13	24	42700SHJA01	\N			1	\N	\N	84	15	1	Диск		69.060000000000002	100	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.694649+02	\N	2011-04-07 14:29:00.033415+02	2011-04-07 14:30:22.698721+02	
1544	2	86	35	24	1671128320	\N			1	\N	\N	87	7	1	Диффузор вентилятора		79.329999999999998	104	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.701005+02	\N	2011-04-07 14:29:00.038002+02	2011-04-07 14:30:22.705052+02	
1545	2	83	11	24	YL8Z1215AA	\N			1	\N	\N	48	4	1	Подшипник передней ступицы		73.489999999999995	98	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.707372+02	\N	2011-04-07 14:29:00.043541+02	2011-04-07 14:30:22.711532+02	
1546	2	96	26	24	758921AA0A	\N			1	\N	\N	19	7	1	Пыльник		104.87	133	\N	\N	\N	\N	\N	in_processing	2011-04-07 14:30:22.713707+02	\N	2011-04-07 14:29:00.048489+02	2011-04-07 14:30:22.717729+02	
1547	5	43	58	155	594176	\N		ЗАКАЗАНО	1	\N	\N	108	1	1	шкив коленвала	Harmonic Balancer	68.769999999999996	116.91	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:01:17.235685+02	\N	2011-04-07 15:11:59.72861+02	2011-04-07 16:01:17.239619+02	
1548	4	33	33	156	20204AG00A	\N			10	\N	\N	6	14	1	сайлентблок	bushing	12.35	10.5	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:27:56.838519+02	\N	2011-04-07 16:17:13.972873+02	2011-04-07 16:27:56.842405+02	
1549	4	33	33	156	22401AA65A	\N			6	\N	\N	6	14	1	свеча зажигания	spark plug	11.949999999999999	10.16	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:27:56.847254+02	\N	2011-04-07 16:17:13.981085+02	2011-04-07 16:27:56.849942+02	
1551	4	13	13	156	71140SDAA10      	\N			1	\N	\N	62	3	2	крепления правое	support right	17.420000000000002	18	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:27:56.852437+02	\N	2011-04-07 16:25:32.622708+02	2011-04-07 16:27:56.854918+02	
1556	4	11	11	156	7T4Z16138B	\N			1	\N	\N	110	1	2	телевизор	Radiator support	197.66999999999999	210	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:27:56.85813+02	\N	2011-04-07 16:25:32.649531+02	2011-04-07 16:27:56.860589+02	
1558	4	13	13	156	04711SDAA90ZZ    	\N			1	\N	\N	62	3	2	бампер передний	bumper front	286.62	304	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:27:56.863156+02	\N	2011-04-07 16:25:32.660488+02	2011-04-07 16:27:56.865566+02	
1559	4	13	13	156	74101SDA-A00      	\N			1	\N	\N	62	3	2	подкрылок правый	liner right	45.899999999999999	49	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:27:56.868068+02	\N	2011-04-07 16:25:32.665392+02	2011-04-07 16:27:56.870585+02	
1550	7	48	59	157	230592835843	\N			1	\N	\N	109	1	2	крыло правое	fender right	109.90000000000001	148.5	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:28:46.35009+02	\N	2011-04-07 16:25:32.613591+02	2011-04-07 16:28:46.356598+02	
1552	7	48	59	157	230599073875	\N			1	\N	\N	109	1	2	противотуманка передняя правая	fog lamp	36.850000000000001	50	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:28:46.367+02	\N	2011-04-07 16:25:32.62755+02	2011-04-07 16:28:46.369386+02	
1554	7	48	59	157	330550682423	\N			1	\N	\N	84	16	2	решетка радиатора	grille	99	128.69999999999999	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:28:46.373433+02	\N	2011-04-07 16:25:32.638265+02	2011-04-07 16:28:46.378547+02	
1555	7	48	59	157	320679949078	\N			1	\N	\N	84	16	2	фары	headlamp set	274	356.19999999999999	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:28:46.382355+02	\N	2011-04-07 16:25:32.64315+02	2011-04-07 16:28:46.386371+02	
1560	4	23	23	158	AJ5710513	\N			1	\N	\N	3	30	1	Прокладка	GASKET,CHAIN COVER-C	6.1200000000000001	5.04	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:29:48.968523+02	\N	2011-04-07 16:29:33.662829+02	2011-04-07 16:29:48.974348+02	
1561	4	23	23	158	CC2934156C	\N			2	\N	\N	3	30	1	Втулка стабилизатора	BUSH,STABILIZER-FRT	8.5399999999999991	7.04	\N	0.029999999999999999	0.39000000000000001	7.4299999999999997	14.859999999999999	received_office	2011-04-09 18:38:08.25223+02	sent_representative	2011-04-07 16:29:33.691274+02	2011-04-09 18:38:08.257068+02	#104
1562	4	23	23	158	L32114302A9U	\N			10	\N	\N	3	30	1	Фильтр масляный	OIL FILTER	8.2899999999999991	6.8399999999999999	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:29:48.989329+02	\N	2011-04-07 16:29:33.701681+02	2011-04-07 16:29:48.993277+02	
1563	4	35	35	158	690900C040	\N	dima		1	\N	\N	4	35	1	ручка	Handle	100.11	88.099999999999994	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:29:48.996667+02	\N	2011-04-07 16:29:33.707357+02	2011-04-07 16:29:49.000323+02	
1564	4	23	23	158	AJ5710522	\N			1	\N	\N	3	30	1	Прокладка	GASKET L ,T.CHAIN CO	6.4299999999999997	5.2999999999999998	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:29:49.003812+02	\N	2011-04-07 16:29:33.722333+02	2011-04-07 16:29:49.006781+02	
1565	4	23	23	158	AJ5710523	\N			1	\N	\N	3	30	1	Прокладка	GASKET,TIMING COVER	4.5999999999999996	5.2800000000000002	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:29:49.010208+02	\N	2011-04-07 16:29:33.72676+02	2011-04-07 16:29:49.012606+02	
1566	4	11	11	158	YF1Z6L266BA	\N			2	\N	\N	3	30	1	Натяжитель	TENSIONER - TIMING C	56.649999999999999	46.740000000000002	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:29:49.015148+02	\N	2011-04-07 16:29:33.731767+02	2011-04-07 16:29:49.017725+02	
1567	4	23	23	158	KL6813460	\N			2	\N	\N	3	30	1	Прокладка коллектора	GASKET,EX.MANIFOLD	7.6299999999999999	6.29	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:29:49.021049+02	\N	2011-04-07 16:29:33.741877+02	2011-04-07 16:29:49.02333+02	
1568	4	23	23	158	LF0118140	\N			1	\N	\N	3	30	1	Провода высоковольтные	CORD SET,HI.TENSION	37.109999999999999	30.609999999999999	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:29:49.025925+02	\N	2011-04-07 16:29:33.752076+02	2011-04-07 16:29:49.028522+02	
1569	4	23	23	158	GY0918140	\N			2	\N	\N	3	30	1	Провода высоковольтные	CORD SET, HI. TENSIO	86.819999999999993	71.620000000000005	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:29:49.031342+02	\N	2011-04-07 16:29:33.761688+02	2011-04-07 16:29:49.033893+02	
1570	4	23	23	158	AC0127238	\N			4	\N	\N	3	30	1	Сальник	SEAL,OIL	9.7599999999999998	8.0500000000000007	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:29:49.036385+02	\N	2011-04-07 16:29:33.766677+02	2011-04-07 16:29:49.039056+02	
1571	4	23	23	158	C24328156D	\N			4	\N	\N	3	30	1	Втулка стабилизатора	BUSH,STABILIZER-RR	6.8399999999999999	5.6399999999999997	\N	\N	\N	\N	\N	in_processing	2011-04-07 16:29:49.04182+02	\N	2011-04-07 16:29:33.783207+02	2011-04-07 16:29:49.044768+02	
1557	5	61	60	160	F0773		ford edge 2007		1	\N	\N	110	1	2	прав крыло 	fender right	59	100	\N	\N	\N	\N	\N	in_processing	2011-04-07 17:28:27.633688+02		2011-04-07 16:25:32.655575+02	2011-04-07 17:31:30.484327+02	#
1572	4	13	13	159	84440STK003ZB	\N			1	\N	\N	19	8	1	ручка	handle	22.18	22	\N	\N	\N	\N	\N	in_processing	2011-04-07 17:28:27.638998+02	\N	2011-04-07 17:19:52.480853+02	2011-04-07 17:28:27.641479+02	
1573	4	13	13	159	84442STK003ZB	\N			2	\N	\N	19	8	1	заглушка	cover	3.1499999999999999	3	\N	\N	\N	\N	\N	in_processing	2011-04-07 17:28:27.644013+02	\N	2011-04-07 17:19:52.526173+02	2011-04-07 17:28:27.646435+02	
1574	4	2	2	159	71503S0X000ZW	\N			3	\N	\N	5	28	1	заглушка	cover	3.1800000000000002	3	\N	\N	\N	\N	\N	in_processing	2011-04-07 17:28:27.649054+02	\N	2011-04-07 17:24:44.861131+02	2011-04-07 17:28:27.651547+02	
1575	4	2	2	159	33506STKA01	\N			1	\N	\N	5	28	1	заглушка	cover	3.25	3.0600000000000001	\N	\N	\N	\N	\N	in_processing	2011-04-07 17:28:27.654172+02	\N	2011-04-07 17:24:44.881136+02	2011-04-07 17:28:27.656577+02	
1553	5	61	60	160	D22E3		dodge durango 2002	durango 2002	1	\N	\N	109	1	2	зеркало правое	mirro right	30	50	\N	\N	\N	\N	\N	in_processing	2011-04-07 17:28:27.602268+02		2011-04-07 16:25:32.632245+02	2011-04-07 17:31:45.749457+02	#
1577	2	95	108	25	GM1200527	\N	1 1115,32		1	\N	\N	100	2	2	колодки передние		38.460000000000001	52	\N	\N	\N	\N	\N	in_processing	2011-04-07 21:07:51.583726+02	\N	2011-04-07 17:41:21.955748+02	2011-04-07 21:07:51.588889+02	
1578	5	62	88	161	HDL933135BR	\N			1	\N	\N	111	1	2	ручка правая	handle right	14.44	28	\N	\N	\N	\N	\N	in_processing	2011-04-07 21:08:31.02466+02	\N	2011-04-07 18:02:00.608284+02	2011-04-07 21:08:31.02786+02	
1579	5	62	88	161	HDL933135BL	\N			1	\N	\N	111	1	2	ручка левая	handle left	14.44	28	\N	\N	\N	\N	\N	in_processing	2011-04-07 21:08:31.031735+02	\N	2011-04-07 18:02:00.623056+02	2011-04-07 21:08:31.034014+02	
1576	2	92	109	25	7PK2092	\N	1 479,71		1	\N	\N	100	2	2	ремень приводной		16.539999999999999	26	\N	\N	\N	\N	\N	in_processing	2011-04-07 21:07:51.568112+02	\N	2011-04-07 17:41:21.949332+02	2011-04-07 21:07:51.572846+02	
1581	4	13	13	161	76830SR0004	\N			1	\N	\N	84	17	2	переходник	joint	5.9800000000000004	6	\N	\N	\N	\N	\N	in_processing	2011-04-07 21:08:31.014466+02	\N	2011-04-07 18:02:00.63683+02	2011-04-07 21:08:31.016745+02	
1580	7	48	59	161	390303720321	\N			1	\N	\N	111	1	2	ручка задней двери	handle rear	16.760000000000002	28	\N	\N	\N	\N	\N	in_processing	2011-04-07 21:08:31.03635+02	\N	2011-04-07 18:02:00.627877+02	2011-04-07 21:08:31.038924+02	
1585	4	2	2	162	50820STKA02	\N			1	\N	\N	69	2	1	подушка двигателя	engine mount	257.63999999999999	237.03	\N	\N	\N	\N	\N	in_processing	2011-04-08 13:44:08.770123+02	\N	2011-04-08 09:14:19.128572+02	2011-04-08 13:44:08.776584+02	
1586	6	51	112	162	709400398	\N			1	\N	\N	4	36	1	накладка	cover	65.989999999999995	66	\N	\N	\N	\N	\N	in_processing	2011-04-08 13:44:08.781061+02	\N	2011-04-08 09:28:02.123039+02	2011-04-08 13:44:08.784901+02	
1588	2	97	113	26	1023V250FL	\N	1 349,27		1	\N	\N	113	1	2	стойка стаб-ра левая		12.470000000000001	16	\N	\N	\N	\N	\N	in_processing	2011-04-08 18:26:40.932127+02	\N	2011-04-08 17:49:02.070462+02	2011-04-08 18:26:40.937189+02	
1589	1	79	7	27	96639895	\N	1 $159.24		1	\N	\N	113	1	2	рычаг левый 		159.28999999999999	220	\N	\N	\N	\N	\N	in_processing	2011-04-08 18:26:55.575392+02	\N	2011-04-08 17:49:02.080575+02	2011-04-08 18:26:55.580979+02	
1590	1	79	35	27	8531542240	\N	7  $45.53		1	\N	\N	87	8	2	бачек омывателя		45.530000000000001	63	\N	\N	\N	\N	\N	in_processing	2011-04-08 18:26:55.630285+02	\N	2011-04-08 17:49:02.088288+02	2011-04-08 18:26:55.634856+02	
1597	7	48	59	\N	120707793439	\N			1	\N	\N	73	13	2	фара правая	headlamp right	75	160	\N	0	13	173	173	order	\N	\N	2011-04-08 18:44:58.994266+02	2011-04-09 16:12:01.249103+02	
1255	4	14	14	128	791104J000	\N			1	\N	\N	4	26	1	петля капота	HINGE ASSY-HOOD LH	45.350000000000001	39.909999999999997	\N	0.46999999999999997	6.1099999999999994	46.019999999999996	46.019999999999996	received_office	2011-04-09 18:35:15.64954+02	sent_representative	2011-03-30 14:48:04.041043+02	2011-04-09 18:35:15.655148+02	#104
1591	5	62	87	162	GM1210106				1	\N	\N	73	12	2	хром полоса решетки 	grille	40.590000000000003	69	\N	\N	\N	\N	\N	in_processing	2011-04-08 18:33:32.397077+02		2011-04-08 18:17:34.492221+02	2011-04-08 18:38:22.41904+02	#
1593	4	12	7	162	19121064				1	\N	\N	73	12	2	телевизор	radiator support	203.38999999999999	216	\N	\N	\N	\N	\N	in_processing	2011-04-08 18:33:32.407923+02		2011-04-08 18:17:34.575315+02	2011-04-08 18:38:49.701312+02	#
1594	5	62	114	162	10508				1	\N	\N	51	3	2	пробка 	cap	12.67	22	\N	\N	\N	\N	\N	in_processing	2011-04-08 18:33:32.41589+02		2011-04-08 18:17:34.584105+02	2011-04-08 18:39:11.17014+02	#
1231	4	14	14	125	866112M100	\N			1	\N	\N	73	7	2	бампер задний	bumper rear	335.38	367	\N	4.8499999999999996	63.049999999999997	430.05000000000001	430.05000000000001	received_office	2011-04-09 18:34:17.438497+02	sent_representative	2011-03-30 14:30:35.922087+02	2011-04-09 18:34:17.443409+02	#104
1587	5	46	62	162	DG532	\N		ЗАКАЗАНО	1	\N	\N	112	1	1	катушка зажигания	ignition coil	63.350000000000001	101.98999999999999	\N	\N	\N	\N	\N	in_processing	2011-04-08 13:44:08.789935+02	\N	2011-04-08 13:43:52.003965+02	2011-04-08 18:40:05.615352+02	
1595	5	46	62	163	FA1785	\N		ЗАКАЗАНО	2	\N	\N	114	1	2	фильтр воздушный	air filter	10.029999999999999	16	\N	\N	\N	\N	\N	in_processing	2011-04-08 18:40:21.932827+02	\N	2011-04-08 18:17:34.594814+02	2011-04-08 18:40:21.936741+02	
1592	5	61	60	164	G0120	\N	equinox 2006	ЗАКАЗАНО	1	\N	\N	73	12	2	капот	hood	130	209	\N	\N	\N	\N	\N	in_processing	2011-04-08 18:42:53.76652+02	\N	2011-04-08 18:17:34.568531+02	2011-04-08 18:42:53.772003+02	
1596	5	61	60	164	T0581	\N	rav 4 2007	ЗАКАЗАНО	1	\N	\N	87	9	2	решетка верхняя бампера	bumper grille	12	19	\N	\N	\N	\N	\N	in_processing	2011-04-08 18:42:53.775578+02	\N	2011-04-08 18:17:34.603002+02	2011-04-08 18:42:53.780136+02	
1471	4	23	23	150	L3K912201A 				1	\N	\N	3	29	1	Цепь грм	CHAIN,TIMING	39.759999999999998	32.799999999999997	\N	\N	\N	\N	\N	superseded	2011-04-09 11:37:28.984383+02	in_processing	2011-04-04 19:42:25.215204+02	2011-04-09 11:37:41.380541+02	
1239	4	23	23	125	GN3A37140B	BBM237140B			2	\N	\N	88	1	2	датчик давления колеса	sensor	84.530000000000001	90	\N	0.040000000000000001	0.52000000000000002	90.519999999999996	181.03999999999999	received_office	2011-04-09 18:34:07.159521+02	sent_representative	2011-03-30 14:30:35.98517+02	2011-04-09 18:34:07.164406+02	#104
1318	4	35	35	135	6740706030	\N			1	\N	\N	4	28	1	направляющая	BAR SUB-ASSY	64.420000000000002	56.689999999999998	\N	0.315	4.0949999999999998	60.784999999999997	60.784999999999997	received_office	2011-04-09 18:36:20.690553+02	sent_representative	2011-03-30 15:36:17.775001+02	2011-04-09 18:36:20.695416+02	#104
1186	4	34	34	121	1770085Z01	\N			1	\N	\N	6	10	1	радиатор	radiator	342.05000000000001	290.74000000000001	\N	3.77	49.009999999999998	339.75	339.75	received_office	2011-04-09 18:32:19.172663+02	sent_representative	2011-03-30 14:12:47.305342+02	2011-04-09 18:32:19.177639+02	#104
1196	4	23	23	122	BBM234350	\N			1	\N	\N	87	1	2	рычаг лев передний	arm left	151.08000000000001	160	\N	4.7149999999999999	61.295000000000002	221.29500000000002	221.29500000000002	received_office	2011-04-09 18:32:24.053223+02	sent_representative	2011-03-30 14:19:17.467615+02	2011-04-09 18:32:24.058238+02	#104
1279	5	62	69	131	3575	\N			1	\N	\N	87	4	2	радиатор кондиционера	condenser	104.17	209	\N	4.3499999999999996	56.549999999999997	265.55000000000001	265.55000000000001	received_office	2011-04-09 18:34:55.757638+02	sent_representative	2011-03-30 14:59:00.694005+02	2011-04-09 18:34:55.762485+02	#104
1171	5	62	69	118	3800032	\N			1	\N	\N	7	16	1	зеркало левое	Outside Mirror	32.789999999999999	59.18	\N	1.76	22.879999999999999	82.060000000000002	82.060000000000002	received_office	2011-04-09 18:32:06.819276+02	sent_representative	2011-03-30 13:55:47.760628+02	2011-04-09 18:32:06.824047+02	#104
1248	4	23	23	128	FP8518100C9U	\N			2	\N	\N	3	25	1	Катушка зажигания	IGNITION COIL	107.3	87.984999999999999	\N	0.32500000000000001	4.2250000000000005	92.209999999999994	184.41999999999999	received_office	2011-04-09 18:33:52.380148+02	sent_representative	2011-03-30 14:48:03.958966+02	2011-04-09 18:33:52.384948+02	#104
1244	5	62	69	126	19592100	\N	tyc		1	\N	\N	87	3	2	противотуманная фара	fog lamp	62.020000000000003	100	\N	0.35499999999999998	4.6150000000000002	104.61499999999999	104.61499999999999	received_office	2011-04-09 18:34:03.499813+02	sent_representative	2011-03-30 14:42:54.988086+02	2011-04-09 18:34:03.504793+02	#104
1233	4	14	14	125	876202M110	\N			1	\N	\N	73	7	2	зеркало правое	mirror right	211	224	\N	1.7649999999999999	22.945	246.94499999999999	246.94499999999999	received_office	2011-04-09 18:34:12.149392+02	sent_representative	2011-03-30 14:30:35.931141+02	2011-04-09 18:34:12.154239+02	#104
1220	4	23	23	122	EF91507E0A	\N			1	\N	\N	3	24	1	НАКЛАДКА ДЕКОРАТИВНАЯ	GRILLE,RADIATOR-UPP	73.579999999999998	60.340000000000003	\N	0.23000000000000001	2.9900000000000002	63.330000000000005	63.330000000000005	received_office	2011-04-09 18:34:23.554957+02	sent_representative	2011-03-30 14:21:41.30741+02	2011-04-09 18:34:23.559825+02	#104
1290	4	2	2	132	74150S6MJ00	\N			1	\N	\N	4	27	1	подкрылок	Fender liner	82.069999999999993	72.219999999999999	\N	0.87	11.31	83.530000000000001	83.530000000000001	received_office	2011-04-09 18:34:45.968025+02	sent_representative	2011-03-30 15:24:31.026824+02	2011-04-09 18:34:45.972994+02	#104
1285	4	2	2	132	04711S6MA91ZZ	\N			1	\N	\N	4	27	1	бампер	Bumper cover	344.63	303.26999999999998	\N	4.6200000000000001	60.060000000000002	363.32999999999998	363.32999999999998	received_office	2011-04-09 18:34:54.062746+02	sent_representative	2011-03-30 15:24:30.996036+02	2011-04-09 18:34:54.067727+02	#104
1310	4	47	8	135	5JU49RXFAC	5JU49RXFAD			1	\N	\N	3	27	1	Подкрылок	APPLIQUE D PILLAR	37.450000000000003	30.710000000000001	\N	0.47999999999999998	6.2400000000000002	36.950000000000003	36.950000000000003	received_office	2011-04-09 18:36:32.33757+02	sent_representative	2011-03-30 15:36:17.724861+02	2011-04-09 18:36:32.342534+02	#104
1309	4	47	8	135	5066756AA	\N			2	\N	\N	3	27	1	Сальник коленвала	SEAL CRANKSHAFT OIL	65.950000000000003	54.079999999999998	\N	0.245	3.1850000000000001	57.265000000000001	114.53	received_office	2011-04-09 18:36:34.432966+02	sent_representative	2011-03-30 15:36:17.719003+02	2011-04-09 18:36:34.437953+02	#104
1308	4	21	21	135	044650E010	\N			1	\N	\N	4	28	1	колодки	Brake pads	62.990000000000002	55.43	\N	1.9099999999999999	24.829999999999998	80.259999999999991	80.259999999999991	received_office	2011-04-09 18:36:35.970708+02	sent_representative	2011-03-30 15:36:17.705622+02	2011-04-09 18:36:35.975835+02	#104
1404	5	61	60	140	H8010		odyssey 08	ЗАКАЗАНО	1	\N	\N	84	10	2	бампер задний	bumper rear	150	242	\N	6.1299999999999999	79.689999999999998	321.69	321.69	received_office	2011-04-09 18:37:57.787107+02	sent_representative	2011-03-30 22:08:51.301108+02	2011-04-09 18:37:57.792141+02	#104
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_admin_log (id, action_time, user_id, content_type_id, object_id, object_repr, action_flag, change_message) FROM stdin;
50	2011-01-27 21:09:48.52284+01	1	10	5	US::AFTMARK	2	Изменён area.
51	2011-01-27 21:10:20.380424+01	1	11	52	Magnum	2	Изменён brands.
52	2011-01-27 21:15:50.24153+01	1	11	34	Suzuki	2	Изменён brands.
53	2011-01-27 21:16:41.276627+01	1	11	26	Nissan	2	Изменён brands.
54	2011-01-28 00:02:14.559805+01	1	10	5	US::AFTMARK	2	Изменён delivery, add_brand_to_comment и area.
55	2011-01-28 00:02:44.345792+01	1	10	5	US::AFTMARK	2	Ни одно поле не изменено.
56	2011-01-28 00:04:05.253673+01	1	12	59	AutoMarket	3	
57	2011-01-28 00:04:33.796605+01	1	12	58	Ronayers	3	
58	2011-01-28 00:04:33.801162+01	1	12	57	Summit	3	
59	2011-01-28 00:05:17.281754+01	1	12	52	Magnum	3	
60	2011-01-28 00:05:17.286367+01	1	12	51	Wop	3	
61	2011-01-28 00:05:17.289486+01	1	12	50	Pu	3	
62	2011-01-28 00:05:17.292476+01	1	12	49	Tr	3	
63	2011-01-28 00:05:17.295176+01	1	12	48	Ebay	3	
64	2011-01-28 00:05:17.297933+01	1	12	46	Nexpart	3	
65	2011-01-28 00:05:17.300713+01	1	12	45	Ekeystone	3	
66	2011-01-28 00:05:17.303324+01	1	12	44	Rockauto	3	
67	2011-01-28 00:05:17.306156+01	1	12	43	Turboii	3	
68	2011-01-28 00:05:44.258539+01	1	11	59	AutoMarket	3	
69	2011-01-28 00:07:19.533995+01	1	11	54	Jaguar	2	Изменён brands.
70	2011-01-28 00:07:37.474089+01	1	11	56	Bentley	3	
71	2011-01-28 00:13:22.368959+01	1	10	8	US::KOYO	1	
72	2011-01-28 00:13:33.622374+01	1	10	8	US::KOYO	3	
73	2011-01-28 00:15:25.191843+01	1	9	3	аа	1	
74	2011-01-28 00:15:32.053612+01	1	9	3	аа	3	
75	2011-01-28 00:18:43.417871+01	1	11	12	Gm	2	Изменён brands.
76	2011-01-28 00:22:56.711248+01	1	10	4	US::OEM	2	Изменён area.
77	2011-01-28 00:23:49.887992+01	1	10	4	US::OEM	2	Изменён area.
78	2011-01-28 00:27:27.292114+01	1	11	23	Mazda	2	Изменён brands.
79	2011-01-28 00:28:31.685103+01	1	3	3	Aps	1	
80	2011-01-28 00:29:20.009612+01	1	3	3	Aps	2	Изменён first_name и groups.
81	2011-01-28 00:29:43.043871+01	1	3	3	aps	2	Изменён username.
82	2011-01-28 00:40:16.235974+01	1	10	3	MSK::DOCVP	2	Изменён area.
83	2011-01-31 20:45:22.746913+01	1	12	56	Bentley	2	Ни одно поле не изменено.
84	2011-01-31 21:17:58.06497+01	1	11	59	test	1	
85	2011-01-31 21:18:07.014318+01	1	11	59	test	3	
86	2011-01-31 21:18:41.710932+01	1	12	57	test	1	
87	2011-01-31 21:18:48.908239+01	1	12	57	test	3	
88	2011-01-31 21:19:24.76744+01	1	9	4	test	1	
89	2011-01-31 21:19:34.155216+01	1	9	4	test	3	
90	2011-01-31 21:20:13.122207+01	1	10	9	US::test	1	
91	2011-01-31 21:20:20.837691+01	1	10	9	US::test	3	
92	2011-02-01 00:50:29.213061+01	1	13	23	2011-02-01 01:49:22.580473-23	3	
93	2011-02-01 00:50:29.217869+01	1	13	22	2011-02-01 01:49:22.549820-22	3	
94	2011-02-02 19:01:54.241591+01	1	13	21	2011-01-31 21:51:26.152172-21	3	
95	2011-02-02 19:01:54.646281+01	1	13	20	2011-01-31 21:51:26.145748-20	3	
96	2011-02-02 19:01:54.658165+01	1	13	19	2011-01-31 21:51:26.138258-19	3	
97	2011-02-02 19:01:54.666893+01	1	13	18	2011-01-31 21:51:24.483374-18	3	
98	2011-02-02 19:01:54.674862+01	1	13	17	2011-01-28 01:42:52.203775-17	3	
99	2011-02-02 19:01:54.686734+01	1	13	16	2011-01-28 01:42:52.197051-16	3	
100	2011-02-02 19:01:54.69248+01	1	13	15	2011-01-28 01:42:52.190502-15	3	
101	2011-02-02 19:01:54.698697+01	1	13	14	2011-01-28 01:42:52.179801-14	3	
102	2011-02-02 19:01:54.70451+01	1	13	13	2011-01-28 01:30:07.214999-13	3	
103	2011-02-02 19:01:54.713563+01	1	13	12	2011-01-28 01:30:07.208405-12	3	
104	2011-02-02 19:01:54.718006+01	1	13	11	2011-01-28 01:30:07.201682-11	3	
105	2011-02-02 19:01:54.735003+01	1	13	10	2011-01-28 01:30:07.192487-10	3	
106	2011-02-02 19:01:54.766026+01	1	13	9	2011-01-28 01:24:44.702004-9	3	
107	2011-02-02 19:01:54.77263+01	1	13	7	2011-01-27 22:28:33.706148-7	3	
108	2011-02-02 19:01:54.782317+01	1	13	6	2011-01-27 22:28:33.699952-6	3	
109	2011-02-02 19:31:42.112052+01	1	13	31	2011-02-02 20:06:20.620542-31	3	
110	2011-02-02 19:31:42.119067+01	1	13	30	2011-02-02 20:06:20.594018-30	3	
111	2011-02-02 19:31:42.131734+01	1	13	29	2011-02-02 20:06:20.570856-29	3	
112	2011-02-02 19:31:42.135253+01	1	13	28	2011-02-02 20:06:20.382997-28	3	
113	2011-02-02 19:31:42.138349+01	1	13	27	2011-02-02 20:02:51.230776-27	3	
114	2011-02-02 19:31:42.141382+01	1	13	26	2011-02-02 20:02:51.224868-26	3	
115	2011-02-02 19:31:42.14751+01	1	13	25	2011-02-02 20:02:51.219049-25	3	
116	2011-02-02 19:31:42.154973+01	1	13	24	2011-02-02 20:02:50.856094-24	3	
117	2011-02-02 19:32:24.238769+01	1	3	4	dp	1	
118	2011-02-02 19:32:58.328524+01	1	3	4	dp	2	Изменён first_name и groups.
119	2011-02-02 19:34:27.584453+01	1	3	5	vk	1	
120	2011-02-02 19:34:53.878745+01	1	3	5	vk	2	Изменён first_name и groups.
121	2011-02-02 19:36:05.38498+01	1	3	6	kp	1	
122	2011-02-02 19:36:42.106637+01	1	3	6	kp	2	Изменён first_name и groups.
123	2011-02-02 19:37:05.209606+01	1	3	7	sx	1	
124	2011-02-02 19:37:32.636001+01	1	3	7	sx	2	Изменён first_name и groups.
125	2011-02-02 19:39:02.065875+01	1	2	2	Розница	1	
126	2011-02-02 19:40:08.068531+01	1	3	8	V6684658	1	
127	2011-02-02 19:40:25.207561+01	1	3	8	V6684658	2	Изменён groups.
128	2011-02-02 19:41:01.014833+01	1	3	9	V6633927	1	
129	2011-02-02 19:41:08.540506+01	1	3	9	V6633927	2	Изменён groups.
130	2011-02-02 19:42:09.014673+01	1	3	10	iv	1	
131	2011-02-02 19:42:18.919887+01	1	3	10	iv	2	Изменён groups.
132	2011-02-02 19:42:56.090793+01	1	3	10	iv	2	Изменён first_name.
133	2011-02-02 19:43:30.436275+01	1	3	11	V6531911	1	
134	2011-02-02 19:43:42.092265+01	1	3	11	V6531911	2	Изменён groups.
135	2011-02-02 19:44:16.418001+01	1	3	12	V3181444	1	
136	2011-02-02 19:44:28.210755+01	1	3	12	V3181444	2	Изменён groups.
137	2011-02-02 19:51:29.664238+01	1	3	12	V44	2	Изменён username.
138	2011-02-02 19:52:36.219617+01	1	3	12	V	2	Изменён username.
139	2011-02-02 19:56:46.549421+01	1	3	12	v	2	Изменён username.
140	2011-02-02 19:58:55.398638+01	1	3	12	v3181444	2	Изменён username.
141	2011-02-02 20:04:14.752607+01	1	3	12	3181444v	2	Изменён username.
142	2011-02-02 20:06:17.493296+01	1	3	12	3181444v	3	
143	2011-02-02 20:06:17.501286+01	1	3	11	V6531911	3	
144	2011-02-02 20:06:17.507061+01	1	3	9	V6633927	3	
145	2011-02-02 20:06:17.514079+01	1	3	8	V6684658	3	
146	2011-02-02 20:11:40.825734+01	1	11	47	Mopar	2	Изменён brands.
147	2011-02-02 20:12:25.189628+01	1	11	60	Acura	1	
148	2011-02-02 20:13:12.111982+01	1	11	60	Acura	3	
149	2011-02-02 20:13:20.830873+01	1	11	2	Acura	2	Изменён brands.
150	2011-02-02 20:13:32.876389+01	1	11	13	Honda	2	Изменён brands.
151	2011-02-02 20:14:34.331195+01	1	11	34	Suzuki	2	Изменён brands.
152	2011-02-02 20:14:53.941236+01	1	11	21	Lexus	2	Изменён brands.
153	2011-02-02 20:15:07.870057+01	1	11	33	Subaru	2	Изменён brands.
535	2011-02-23 15:51:43.592201+01	1	12	76	Bosch	1	
154	2011-02-02 20:15:22.471823+01	1	11	15	Infiniti	2	Изменён brands.
155	2011-02-02 20:16:07.767837+01	1	11	26	Nissan	2	Изменён brands.
156	2011-02-02 20:16:28.891866+01	1	11	14	Hyundai	2	Изменён brands.
157	2011-02-02 20:17:04.37296+01	1	11	11	Ford	2	Изменён brands.
158	2011-02-02 20:17:20.420178+01	1	11	35	Toyota	2	Изменён brands.
159	2011-02-02 20:18:20.031062+01	1	12	58	Dorman	1	
160	2011-02-02 20:18:28.947922+01	1	11	43	Turboii	2	Изменён brands.
161	2011-02-02 20:18:48.880237+01	1	12	59	Ebay	1	
162	2011-02-02 20:18:52.114061+01	1	11	48	Ebay	2	Изменён brands.
163	2011-02-02 20:19:41.40086+01	1	12	60	Taiwan	1	
164	2011-02-02 20:19:44.069873+01	1	11	61	Empireauto	1	
165	2011-02-02 20:21:15.416874+01	1	10	5	US::AFTMARK	2	Изменён area.
166	2011-02-02 20:23:32.867074+01	1	10	7	US::ONLINE	2	Изменён area.
167	2011-02-02 20:24:22.673292+01	1	12	61	Acdelco	1	
168	2011-02-02 20:24:33.455156+01	1	12	62	Motorcraft	1	
169	2011-02-02 20:24:35.33356+01	1	11	46	Nexpart	2	Изменён brands.
170	2011-02-02 20:45:24.823727+01	1	10	5	US::AFTMARK	2	Изменён add_brand_to_comment.
171	2011-02-02 20:47:23.638149+01	1	13	101	2011-02-02 21:25:58.196283-101	3	
172	2011-02-02 20:47:23.720091+01	1	13	100	2011-02-02 21:25:58.186919-100	3	
173	2011-02-02 21:15:22.280973+01	1	10	5	US::AFTMARK	2	Изменён area.
174	2011-02-02 21:17:27.006889+01	1	12	63	Raybestos	1	
175	2011-02-02 21:18:15.02774+01	1	12	64	Anchor	1	
176	2011-02-02 21:18:37.802348+01	1	12	65	Dorman	1	
177	2011-02-02 21:18:52.178009+01	1	11	45	Ekeystone	2	Изменён brands.
178	2011-02-02 21:19:45.677129+01	1	11	44	Rockauto	3	
179	2011-02-02 21:20:28.188155+01	1	11	62	Rockauto	1	
180	2011-02-02 21:20:49.108194+01	1	12	65	Dorman	3	
181	2011-02-02 21:21:37.889003+01	1	11	45	Ekeystone	2	Изменён brands.
182	2011-02-02 21:34:48.869024+01	1	3	13	sg	1	
183	2011-02-02 21:35:18.011482+01	1	3	13	sg	2	Изменён first_name и groups.
184	2011-02-02 21:36:17.572607+01	1	3	2	user	2	Изменён is_staff.
185	2011-02-02 21:39:10.364088+01	1	10	5	US::AFTMARK	2	Ни одно поле не изменено.
186	2011-02-02 21:40:59.573007+01	1	10	5	US::AFTMARK	2	Изменён area.
187	2011-02-04 01:18:06.960896+01	1	12	66	test	1	
188	2011-02-04 01:18:16.263814+01	1	12	66	test	3	
189	2011-02-15 13:21:32.279231+01	1	13	106	2011-02-02 14:09:18.229460-106	3	
190	2011-02-15 13:21:32.417258+01	1	13	105	2011-02-02 14:00:48.099364-105	3	
191	2011-02-15 13:21:32.421576+01	1	13	104	2011-02-02 14:00:48.073599-104	3	
192	2011-02-15 13:21:32.424391+01	1	13	103	2011-02-02 13:25:58.214970-103	3	
193	2011-02-15 13:21:32.427905+01	1	13	102	2011-02-02 13:25:58.206295-102	3	
194	2011-02-15 13:21:32.431903+01	1	13	99	2011-02-02 13:25:58.171421-99	3	
195	2011-02-15 13:21:32.436403+01	1	13	98	2011-02-02 13:25:58.158455-98	3	
196	2011-02-15 13:21:32.439139+01	1	13	97	2011-02-02 13:25:58.148305-97	3	
197	2011-02-15 13:21:32.441994+01	1	13	96	2011-02-02 13:25:58.135108-96	3	
198	2011-02-15 13:21:32.445394+01	1	13	95	2011-02-02 13:25:58.126030-95	3	
199	2011-02-15 13:21:32.448+01	1	13	94	2011-02-02 13:25:58.117336-94	3	
200	2011-02-15 13:21:32.451779+01	1	13	93	2011-02-02 13:25:58.070913-93	3	
201	2011-02-15 13:21:32.454381+01	1	13	92	2011-02-02 13:25:58.017895-92	3	
202	2011-02-15 13:21:32.456957+01	1	13	91	2011-02-02 13:25:58.007338-91	3	
203	2011-02-15 13:21:32.462527+01	1	13	90	2011-02-02 13:25:57.937356-90	3	
204	2011-02-15 13:21:32.46438+01	1	13	89	2011-02-02 13:25:57.922086-89	3	
205	2011-02-15 13:21:32.466417+01	1	13	88	2011-02-02 13:25:57.907392-88	3	
206	2011-02-15 13:21:32.469318+01	1	13	87	2011-02-02 13:25:57.890892-87	3	
207	2011-02-15 13:21:32.471383+01	1	13	86	2011-02-02 13:25:57.878584-86	3	
208	2011-02-15 13:21:32.473735+01	1	13	85	2011-02-02 13:25:57.864685-85	3	
209	2011-02-15 13:21:32.475833+01	1	13	84	2011-02-02 13:25:57.850399-84	3	
210	2011-02-15 13:21:32.47867+01	1	13	83	2011-02-02 13:25:57.838220-83	3	
211	2011-02-15 13:21:32.480558+01	1	13	82	2011-02-02 13:25:57.826852-82	3	
212	2011-02-15 13:21:32.482554+01	1	13	81	2011-02-02 13:25:57.813712-81	3	
213	2011-02-15 13:21:32.484468+01	1	13	80	2011-02-02 13:25:57.800028-80	3	
214	2011-02-15 13:21:32.486908+01	1	13	79	2011-02-02 13:25:57.792369-79	3	
215	2011-02-15 13:21:32.488737+01	1	13	78	2011-02-02 13:25:57.780161-78	3	
216	2011-02-15 13:21:32.490763+01	1	13	77	2011-02-02 13:25:57.768349-77	3	
217	2011-02-15 13:21:32.492638+01	1	13	76	2011-02-02 13:25:57.755778-76	3	
218	2011-02-15 13:21:32.494526+01	1	13	75	2011-02-02 13:25:57.743939-75	3	
219	2011-02-15 13:21:32.496805+01	1	13	74	2011-02-02 13:25:57.733535-74	3	
220	2011-02-15 13:21:32.499408+01	1	13	73	2011-02-02 13:25:57.722907-73	3	
221	2011-02-15 13:21:32.501374+01	1	13	72	2011-02-02 13:25:57.710180-72	3	
222	2011-02-15 13:21:32.503355+01	1	13	71	2011-02-02 13:25:57.697872-71	3	
223	2011-02-15 13:21:32.508567+01	1	13	70	2011-02-02 13:25:57.688372-70	3	
224	2011-02-15 13:21:32.510503+01	1	13	69	2011-02-02 13:25:57.678872-69	3	
225	2011-02-15 13:21:32.513404+01	1	13	68	2011-02-02 13:25:57.669829-68	3	
226	2011-02-15 13:21:32.515775+01	1	13	67	2011-02-02 13:25:57.657992-67	3	
227	2011-02-15 13:21:32.517574+01	1	13	66	2011-02-02 13:25:57.649361-66	3	
228	2011-02-15 13:21:32.519463+01	1	13	65	2011-02-02 13:25:57.640093-65	3	
229	2011-02-15 13:21:32.521832+01	1	13	64	2011-02-02 13:25:57.631576-64	3	
230	2011-02-15 13:21:32.523997+01	1	13	63	2011-02-02 13:25:57.618730-63	3	
231	2011-02-15 13:21:32.525944+01	1	13	62	2011-02-02 13:25:57.608409-62	3	
232	2011-02-15 13:21:32.527722+01	1	13	61	2011-02-02 13:25:57.584279-61	3	
233	2011-02-15 13:21:32.530063+01	1	13	60	2011-02-02 13:25:57.561415-60	3	
234	2011-02-15 13:21:32.531958+01	1	13	59	2011-02-02 13:25:57.470795-59	3	
235	2011-02-15 13:21:32.533945+01	1	13	58	2011-02-02 13:25:57.449165-58	3	
236	2011-02-15 13:21:32.535718+01	1	13	57	2011-02-02 13:25:57.438587-57	3	
237	2011-02-15 13:21:32.538419+01	1	13	56	2011-02-02 13:25:57.425836-56	3	
238	2011-02-15 13:21:32.5402+01	1	13	55	2011-02-02 13:25:57.416092-55	3	
239	2011-02-15 13:21:32.542343+01	1	13	54	2011-02-02 13:25:57.404109-54	3	
240	2011-02-15 13:21:32.545044+01	1	13	53	2011-02-02 13:25:57.390708-53	3	
241	2011-02-15 13:21:32.546982+01	1	13	52	2011-02-02 13:25:57.380027-52	3	
242	2011-02-15 13:21:32.548787+01	1	13	51	2011-02-02 13:25:57.367302-51	3	
243	2011-02-15 13:21:32.550734+01	1	13	50	2011-02-02 13:25:57.356886-50	3	
244	2011-02-15 13:21:32.552598+01	1	13	49	2011-02-02 13:25:57.346325-49	3	
245	2011-02-15 13:21:32.555041+01	1	13	48	2011-02-02 13:25:57.330536-48	3	
246	2011-02-15 13:21:32.556738+01	1	13	47	2011-02-02 13:25:57.318358-47	3	
247	2011-02-15 13:21:32.558958+01	1	13	46	2011-02-02 13:25:57.307874-46	3	
248	2011-02-15 13:21:32.560874+01	1	13	45	2011-02-02 13:25:57.299112-45	3	
249	2011-02-15 13:21:32.563428+01	1	13	44	2011-02-02 13:25:57.291357-44	3	
250	2011-02-15 13:21:32.565191+01	1	13	43	2011-02-02 13:25:57.278911-43	3	
251	2011-02-15 13:21:32.567576+01	1	13	42	2011-02-02 13:25:57.268749-42	3	
252	2011-02-15 13:21:32.569915+01	1	13	41	2011-02-02 13:25:57.256908-41	3	
253	2011-02-15 13:21:32.572185+01	1	13	40	2011-02-02 13:25:57.246021-40	3	
254	2011-02-15 13:21:32.574498+01	1	13	39	2011-02-02 13:25:57.237642-39	3	
255	2011-02-15 13:21:32.577143+01	1	13	38	2011-02-02 13:25:57.229591-38	3	
256	2011-02-15 13:21:32.580177+01	1	13	37	2011-02-02 13:25:57.214936-37	3	
257	2011-02-15 13:21:32.583271+01	1	13	36	2011-02-02 13:25:57.205398-36	3	
258	2011-02-15 13:21:32.585835+01	1	13	35	2011-02-02 13:25:57.190463-35	3	
259	2011-02-15 13:21:32.588464+01	1	13	34	2011-02-02 13:25:57.182328-34	3	
260	2011-02-15 13:21:32.59106+01	1	13	33	2011-02-02 13:25:57.173168-33	3	
261	2011-02-15 13:21:32.593839+01	1	13	32	2011-02-02 13:25:57.160325-32	3	
262	2011-02-16 14:37:51.848781+01	1	13	178	2011-02-15 06:23:00.722461-178	3	
263	2011-02-16 14:37:51.882105+01	1	13	177	2011-02-15 06:23:00.717039-177	3	
264	2011-02-16 14:37:51.884661+01	1	13	176	2011-02-15 06:23:00.709663-176	3	
265	2011-02-16 14:37:51.887152+01	1	13	175	2011-02-15 06:23:00.703996-175	3	
266	2011-02-16 14:37:51.890724+01	1	13	174	2011-02-15 06:23:00.698449-174	3	
267	2011-02-16 14:37:51.893215+01	1	13	173	2011-02-15 06:23:00.692700-173	3	
268	2011-02-16 14:37:51.895743+01	1	13	172	2011-02-15 06:23:00.686782-172	3	
269	2011-02-16 14:37:51.899726+01	1	13	171	2011-02-15 06:23:00.681419-171	3	
270	2011-02-16 14:37:51.90238+01	1	13	170	2011-02-15 06:23:00.676792-170	3	
271	2011-02-16 14:37:51.906349+01	1	13	169	2011-02-15 06:23:00.672531-169	3	
272	2011-02-16 14:37:51.908812+01	1	13	168	2011-02-15 06:23:00.668140-168	3	
273	2011-02-16 14:37:51.911262+01	1	13	167	2011-02-15 06:23:00.662905-167	3	
274	2011-02-16 14:37:51.914554+01	1	13	166	2011-02-15 06:23:00.657600-166	3	
275	2011-02-16 14:37:51.917209+01	1	13	165	2011-02-15 06:23:00.652329-165	3	
276	2011-02-16 14:37:51.92287+01	1	13	164	2011-02-15 06:23:00.647433-164	3	
277	2011-02-16 14:37:51.925778+01	1	13	163	2011-02-15 06:23:00.642454-163	3	
278	2011-02-16 14:37:51.928448+01	1	13	162	2011-02-15 06:23:00.636003-162	3	
279	2011-02-16 14:37:51.930923+01	1	13	161	2011-02-15 06:23:00.631737-161	3	
280	2011-02-16 14:37:51.933756+01	1	13	160	2011-02-15 06:23:00.627206-160	3	
281	2011-02-16 14:37:51.93632+01	1	13	159	2011-02-15 06:23:00.622939-159	3	
282	2011-02-16 14:37:51.941733+01	1	13	158	2011-02-15 06:23:00.618529-158	3	
283	2011-02-16 14:37:51.94447+01	1	13	157	2011-02-15 06:23:00.613754-157	3	
284	2011-02-16 14:37:51.947687+01	1	13	156	2011-02-15 06:23:00.608715-156	3	
285	2011-02-16 14:37:51.950206+01	1	13	155	2011-02-15 06:23:00.602889-155	3	
286	2011-02-16 14:37:51.952659+01	1	13	154	2011-02-15 06:23:00.596809-154	3	
287	2011-02-16 14:37:51.955294+01	1	13	153	2011-02-15 06:23:00.589881-153	3	
288	2011-02-16 14:37:51.95949+01	1	13	152	2011-02-15 06:23:00.577471-152	3	
289	2011-02-16 14:37:51.962505+01	1	13	151	2011-02-15 06:23:00.571598-151	3	
290	2011-02-16 14:37:51.965323+01	1	13	150	2011-02-15 06:23:00.565834-150	3	
291	2011-02-16 14:37:51.967823+01	1	13	149	2011-02-15 06:23:00.559979-149	3	
292	2011-02-16 14:37:51.970573+01	1	13	148	2011-02-15 06:23:00.552445-148	3	
293	2011-02-16 14:37:51.97406+01	1	13	147	2011-02-15 06:23:00.546104-147	3	
294	2011-02-16 14:37:51.976542+01	1	13	146	2011-02-15 06:23:00.539836-146	3	
295	2011-02-16 14:37:51.981385+01	1	13	145	2011-02-15 06:23:00.532635-145	3	
296	2011-02-16 14:37:51.986302+01	1	13	144	2011-02-15 06:23:00.526456-144	3	
297	2011-02-16 14:37:51.988741+01	1	13	143	2011-02-15 06:23:00.518748-143	3	
298	2011-02-16 14:37:51.992137+01	1	13	142	2011-02-15 06:23:00.513070-142	3	
299	2011-02-16 14:37:51.994677+01	1	13	141	2011-02-15 06:23:00.506284-141	3	
300	2011-02-16 14:37:51.997171+01	1	13	140	2011-02-15 06:23:00.500683-140	3	
301	2011-02-16 14:37:52.0038+01	1	13	139	2011-02-15 06:23:00.494267-139	3	
302	2011-02-16 14:37:52.007107+01	1	13	138	2011-02-15 06:23:00.488976-138	3	
303	2011-02-16 14:37:52.013912+01	1	13	137	2011-02-15 06:23:00.484021-137	3	
304	2011-02-16 14:37:52.017045+01	1	13	136	2011-02-15 06:23:00.478753-136	3	
305	2011-02-16 14:37:52.021788+01	1	13	135	2011-02-15 06:23:00.474318-135	3	
306	2011-02-16 14:37:52.024184+01	1	13	134	2011-02-15 06:23:00.469258-134	3	
307	2011-02-16 14:37:52.026569+01	1	13	133	2011-02-15 06:23:00.463813-133	3	
308	2011-02-16 14:37:52.029487+01	1	13	132	2011-02-15 06:23:00.457614-132	3	
309	2011-02-16 14:37:52.031863+01	1	13	131	2011-02-15 06:23:00.450747-131	3	
310	2011-02-16 14:37:52.034302+01	1	13	130	2011-02-15 06:23:00.443522-130	3	
311	2011-02-16 14:37:52.037171+01	1	13	129	2011-02-15 06:23:00.436185-129	3	
312	2011-02-16 14:37:52.041413+01	1	13	128	2011-02-15 06:23:00.429006-128	3	
313	2011-02-16 14:37:52.043208+01	1	13	127	2011-02-15 06:23:00.416322-127	3	
314	2011-02-16 14:37:52.044978+01	1	13	126	2011-02-15 06:23:00.409264-126	3	
315	2011-02-16 14:37:52.046674+01	1	13	125	2011-02-15 06:23:00.401968-125	3	
316	2011-02-16 14:37:52.048467+01	1	13	124	2011-02-15 06:23:00.392829-124	3	
317	2011-02-16 14:37:52.050309+01	1	13	123	2011-02-15 06:23:00.385594-123	3	
318	2011-02-16 14:37:52.052073+01	1	13	122	2011-02-15 06:23:00.377791-122	3	
319	2011-02-16 14:37:52.053863+01	1	13	121	2011-02-15 06:23:00.370720-121	3	
320	2011-02-16 14:37:52.055573+01	1	13	120	2011-02-15 06:23:00.363298-120	3	
321	2011-02-16 14:37:52.060341+01	1	13	119	2011-02-15 06:23:00.356228-119	3	
322	2011-02-16 14:37:52.062476+01	1	13	118	2011-02-15 06:23:00.349079-118	3	
323	2011-02-16 14:37:52.064207+01	1	13	117	2011-02-15 06:23:00.341525-117	3	
324	2011-02-16 14:37:52.066406+01	1	13	116	2011-02-15 06:23:00.332206-116	3	
325	2011-02-16 14:37:52.068057+01	1	13	115	2011-02-15 06:23:00.323062-115	3	
326	2011-02-16 14:37:52.069652+01	1	13	114	2011-02-15 06:23:00.316153-114	3	
327	2011-02-16 14:37:52.071959+01	1	13	113	2011-02-15 06:23:00.308713-113	3	
328	2011-02-16 14:37:52.073597+01	1	13	112	2011-02-15 06:23:00.301245-112	3	
329	2011-02-16 14:37:52.075469+01	1	13	111	2011-02-15 06:23:00.292421-111	3	
330	2011-02-16 14:37:52.077651+01	1	13	110	2011-02-15 06:23:00.284964-110	3	
331	2011-02-16 14:37:52.080704+01	1	13	109	2011-02-15 06:23:00.278102-109	3	
332	2011-02-16 14:37:52.082718+01	1	13	108	2011-02-15 06:23:00.271329-108	3	
333	2011-02-16 14:37:52.084661+01	1	13	107	2011-02-15 06:23:00.236186-107	3	
334	2011-02-17 12:20:06.525882+01	1	3	14	V245	1	
335	2011-02-17 12:20:48.985802+01	1	3	14	V245	2	Изменен groups.
336	2011-02-17 12:23:00.753746+01	1	3	14	V245	3	
337	2011-02-17 12:23:34.838123+01	1	3	2	manager	2	Изменен username.
338	2011-02-17 12:32:07.864881+01	1	13	229	2011-02-17 04:38:58.161398-229	3	
339	2011-02-17 12:32:07.86951+01	1	13	228	2011-02-17 04:38:58.155941-228	3	
340	2011-02-17 12:32:07.871402+01	1	13	227	2011-02-17 04:38:58.150353-227	3	
341	2011-02-17 12:32:07.87318+01	1	13	226	2011-02-17 04:38:58.144772-226	3	
342	2011-02-17 12:32:07.875949+01	1	13	225	2011-02-17 04:38:58.138378-225	3	
343	2011-02-17 12:32:07.877963+01	1	13	224	2011-02-17 04:38:58.132959-224	3	
344	2011-02-17 12:32:07.880019+01	1	13	223	2011-02-17 04:38:58.126445-223	3	
345	2011-02-17 12:32:07.882003+01	1	13	222	2011-02-17 04:38:58.121809-222	3	
346	2011-02-17 12:32:07.883828+01	1	13	221	2011-02-17 04:38:58.115532-221	3	
347	2011-02-17 12:32:58.200464+01	1	3	15	Vffhdfeh	1	
348	2011-02-17 12:33:28.679864+01	1	3	15	Vffhdfeh	2	Изменен first_name и groups.
349	2011-02-17 12:34:00.345424+01	1	3	16	Vffccibg	1	
350	2011-02-17 12:34:24.969748+01	1	3	16	Vffccibg	2	Изменен first_name и groups.
351	2011-02-17 12:34:48.438523+01	1	3	17	Vfecaiaa	1	
352	2011-02-17 12:35:05.143209+01	1	3	17	Vfecaiaa	2	Изменен first_name и groups.
353	2011-02-17 12:38:15.048827+01	1	3	17	vfecaiaa	2	Изменен username.
354	2011-02-17 12:38:40.458262+01	1	3	16	vffccibg	2	Изменен username.
355	2011-02-17 12:38:57.368443+01	1	3	15	vffhdfeh	2	Изменен username.
356	2011-02-17 12:43:56.349216+01	1	3	17	vfecaia	2	Изменен username.
357	2011-02-17 12:44:51.147791+01	1	3	17	vfecaia	2	Изменен groups.
358	2011-02-17 12:57:22.722424+01	1	3	17	fecaia	2	Изменен username.
359	2011-02-17 12:57:42.080942+01	1	3	16	ffccibg	2	Изменен username.
360	2011-02-17 12:57:58.106683+01	1	3	15	ffhdfeh	2	Изменен username.
361	2011-02-17 13:02:08.644034+01	1	3	17	v6531911	2	Изменен username.
362	2011-02-17 13:05:03.294773+01	1	3	16	ffccibg	2	Изменен first_name и groups.
363	2011-02-17 13:05:18.854111+01	1	3	16	v6633927	2	Изменен username.
364	2011-02-17 13:05:33.924408+01	1	3	15	v6684658	2	Изменен username, first_name и groups.
365	2011-02-17 15:09:27.057801+01	1	3	18	v3181444	1	
366	2011-02-17 15:09:34.784801+01	1	3	18	v3181444	2	Изменен first_name и groups.
367	2011-02-17 15:10:04.823341+01	1	3	19	v6606055	1	
368	2011-02-17 15:10:24.083387+01	1	3	19	v6606055	2	Изменен first_name и groups.
369	2011-02-17 15:10:57.328548+01	1	3	20	v7787898	1	
370	2011-02-17 15:11:05.931042+01	1	3	20	v7787898	2	Изменен first_name и groups.
371	2011-02-17 15:11:40.841332+01	1	3	21	v6572563	1	
372	2011-02-17 15:11:49.356842+01	1	3	21	v6572563	2	Изменен first_name и groups.
373	2011-02-17 15:15:18.123538+01	1	12	12	Gm	2	Ни одно поле не изменено.
374	2011-02-17 15:18:14.75602+01	1	12	67	gmc	1	
375	2011-02-17 15:18:51.791666+01	1	12	67	Gmc	2	Изменен title.
376	2011-02-17 15:30:00.113013+01	1	13	270	2011-02-17 08:19:38.586049-270	3	
377	2011-02-17 15:30:00.116269+01	1	13	269	2011-02-17 08:19:38.578008-269	3	
378	2011-02-17 15:30:00.118148+01	1	13	268	2011-02-17 08:19:38.569963-268	3	
379	2011-02-17 15:30:00.119919+01	1	13	267	2011-02-17 08:19:38.561524-267	3	
380	2011-02-17 15:30:00.121863+01	1	13	266	2011-02-17 08:19:38.554495-266	3	
381	2011-02-17 15:30:00.123626+01	1	13	265	2011-02-17 08:19:38.544352-265	3	
382	2011-02-17 15:30:00.126042+01	1	13	264	2011-02-17 07:56:20.626761-264	3	
383	2011-02-17 15:30:00.128652+01	1	13	263	2011-02-17 07:56:20.622559-263	3	
384	2011-02-17 15:30:00.13075+01	1	13	262	2011-02-17 07:56:20.617257-262	3	
385	2011-02-17 15:30:00.132643+01	1	13	261	2011-02-17 07:56:20.611516-261	3	
386	2011-02-17 15:30:00.136307+01	1	13	260	2011-02-17 07:56:20.606267-260	3	
387	2011-02-17 15:30:00.138373+01	1	13	259	2011-02-17 07:56:20.602015-259	3	
388	2011-02-17 15:30:00.140729+01	1	13	258	2011-02-17 07:56:20.596833-258	3	
389	2011-02-17 15:30:00.145431+01	1	13	257	2011-02-17 07:56:20.592518-257	3	
390	2011-02-17 15:30:00.149478+01	1	13	256	2011-02-17 07:56:20.588209-256	3	
391	2011-02-17 15:30:00.15191+01	1	13	255	2011-02-17 07:56:20.582752-255	3	
392	2011-02-17 15:30:00.154453+01	1	13	254	2011-02-17 07:56:20.575954-254	3	
393	2011-02-17 15:30:00.157152+01	1	13	253	2011-02-17 07:56:20.571615-253	3	
394	2011-02-17 15:30:00.160174+01	1	13	252	2011-02-17 07:56:20.567358-252	3	
395	2011-02-17 15:30:00.162618+01	1	13	251	2011-02-17 07:56:20.562038-251	3	
396	2011-02-17 15:30:00.165656+01	1	13	250	2011-02-17 07:56:20.556386-250	3	
397	2011-02-17 15:30:00.168802+01	1	13	249	2011-02-17 07:56:20.551933-249	3	
398	2011-02-17 15:30:00.171352+01	1	13	248	2011-02-17 07:56:20.547451-248	3	
399	2011-02-17 15:30:00.173927+01	1	13	247	2011-02-17 07:56:20.543062-247	3	
400	2011-02-17 15:30:00.178204+01	1	13	246	2011-02-17 07:56:20.536813-246	3	
401	2011-02-17 15:30:00.18093+01	1	13	245	2011-02-17 07:56:20.532310-245	3	
402	2011-02-17 15:30:00.183495+01	1	13	244	2011-02-17 07:56:20.527914-244	3	
403	2011-02-17 15:30:00.186147+01	1	13	243	2011-02-17 07:56:20.523330-243	3	
404	2011-02-17 15:30:00.189715+01	1	13	242	2011-02-17 07:56:20.505703-242	3	
405	2011-02-17 15:30:00.192116+01	1	13	241	2011-02-17 07:32:47.834506-241	3	
406	2011-02-17 15:30:00.194681+01	1	13	240	2011-02-17 07:32:47.828545-240	3	
407	2011-02-17 15:30:00.197222+01	1	13	239	2011-02-17 07:32:47.812855-239	3	
408	2011-02-17 15:30:00.199899+01	1	13	238	2011-02-17 06:08:26.343201-238	3	
409	2011-02-17 15:30:00.202486+01	1	13	237	2011-02-17 06:08:26.337371-237	3	
410	2011-02-17 15:30:00.205621+01	1	13	236	2011-02-17 06:08:26.332046-236	3	
411	2011-02-17 15:30:00.210773+01	1	13	235	2011-02-17 06:08:26.325963-235	3	
412	2011-02-17 15:30:00.214317+01	1	13	234	2011-02-17 06:08:26.319471-234	3	
413	2011-02-17 15:30:00.217708+01	1	13	233	2011-02-17 06:08:26.314138-233	3	
414	2011-02-17 15:30:00.221047+01	1	13	232	2011-02-17 06:08:26.308542-232	3	
415	2011-02-17 15:30:00.22385+01	1	13	231	2011-02-17 06:08:26.304114-231	3	
416	2011-02-17 15:30:00.226285+01	1	13	230	2011-02-17 06:08:26.288030-230	3	
417	2011-02-17 15:30:00.229632+01	1	13	220	2011-02-17 04:27:16.685150-220	3	
418	2011-02-17 15:30:00.23222+01	1	13	219	2011-02-17 04:27:16.679980-219	3	
419	2011-02-17 15:30:00.234165+01	1	13	218	2011-02-17 04:27:16.675010-218	3	
420	2011-02-17 15:30:00.23625+01	1	13	217	2011-02-17 04:27:16.669855-217	3	
421	2011-02-17 15:30:00.238826+01	1	13	216	2011-02-17 04:27:16.664130-216	3	
422	2011-02-17 15:30:00.240924+01	1	13	215	2011-02-17 04:27:16.659119-215	3	
423	2011-02-17 15:30:00.243058+01	1	13	214	2011-02-17 04:27:16.654718-214	3	
424	2011-02-17 15:30:00.245346+01	1	13	213	2011-02-17 04:27:16.649370-213	3	
425	2011-02-17 15:30:00.247523+01	1	13	212	2011-02-17 04:27:16.641910-212	3	
426	2011-02-17 15:30:00.251025+01	1	13	211	2011-02-17 04:27:16.636207-211	3	
427	2011-02-17 15:30:00.253558+01	1	13	210	2011-02-17 04:27:16.627739-210	3	
428	2011-02-17 15:30:00.255952+01	1	13	209	2011-02-17 04:27:16.621026-209	3	
429	2011-02-17 15:30:00.258269+01	1	13	208	2011-02-17 04:27:16.614133-208	3	
430	2011-02-17 15:30:00.26078+01	1	13	207	2011-02-17 04:27:16.602635-207	3	
431	2011-02-17 15:30:00.26387+01	1	13	206	2011-02-16 07:55:17.834761-206	3	
432	2011-02-17 15:30:00.266447+01	1	13	205	2011-02-16 07:43:08.062050-205	3	
433	2011-02-17 15:30:00.270643+01	1	13	204	2011-02-16 07:43:08.056681-204	3	
434	2011-02-17 15:30:00.273144+01	1	13	203	2011-02-16 07:43:08.050973-203	3	
435	2011-02-17 15:30:00.275625+01	1	13	202	2011-02-16 07:43:08.045768-202	3	
436	2011-02-17 15:30:00.278139+01	1	13	201	2011-02-16 07:43:08.038844-201	3	
437	2011-02-17 15:30:00.280633+01	1	13	200	2011-02-16 07:43:08.030212-200	3	
438	2011-02-17 15:30:00.283231+01	1	13	199	2011-02-16 07:43:08.020715-199	3	
439	2011-02-17 15:30:00.285655+01	1	13	198	2011-02-16 07:43:08.013918-198	3	
440	2011-02-17 15:30:00.290091+01	1	13	197	2011-02-16 07:43:08.004720-197	3	
441	2011-02-17 15:30:00.292977+01	1	13	196	2011-02-16 07:43:07.996116-196	3	
442	2011-02-17 15:30:00.295843+01	1	13	195	2011-02-16 07:43:07.989492-195	3	
443	2011-02-17 15:30:00.29921+01	1	13	194	2011-02-16 07:43:07.982240-194	3	
444	2011-02-17 15:30:00.301701+01	1	13	193	2011-02-16 07:43:07.975420-193	3	
445	2011-02-17 15:30:00.304088+01	1	13	192	2011-02-16 07:43:07.968773-192	3	
446	2011-02-17 15:30:00.307288+01	1	13	191	2011-02-16 07:43:07.961497-191	3	
447	2011-02-17 15:30:00.310027+01	1	13	190	2011-02-16 07:43:07.954517-190	3	
448	2011-02-17 15:30:00.312545+01	1	13	189	2011-02-16 07:43:07.947344-189	3	
449	2011-02-17 15:30:00.31562+01	1	13	188	2011-02-16 07:43:07.940002-188	3	
450	2011-02-17 15:30:00.318244+01	1	13	187	2011-02-16 07:43:07.931301-187	3	
451	2011-02-17 15:30:00.320619+01	1	13	186	2011-02-16 07:43:07.922712-186	3	
452	2011-02-17 15:30:00.323974+01	1	13	185	2011-02-16 07:43:07.914691-185	3	
453	2011-02-17 15:30:00.32657+01	1	13	184	2011-02-16 07:43:07.907204-184	3	
454	2011-02-17 15:30:00.329164+01	1	13	183	2011-02-16 07:43:07.900425-183	3	
455	2011-02-17 15:30:00.332283+01	1	13	182	2011-02-16 07:43:07.893645-182	3	
456	2011-02-17 15:30:00.334941+01	1	13	181	2011-02-16 07:43:07.886290-181	3	
457	2011-02-17 15:30:00.337375+01	1	13	180	2011-02-16 07:43:07.879543-180	3	
458	2011-02-17 15:30:00.340722+01	1	13	179	2011-02-16 07:43:07.860180-179	3	
459	2011-02-17 16:04:47.927013+01	1	11	63	KTA	1	
460	2011-02-17 16:05:00.771807+01	1	10	2	MSK::DOCAP	2	Изменен area.
461	2011-02-17 16:06:16.452293+01	1	11	63	KTA	2	Изменен brands.
462	2011-02-17 16:06:48.064072+01	1	11	64	Эмираты 8	1	
463	2011-02-17 16:07:13.287711+01	1	11	64	Эмираты 8	2	Изменен brands.
464	2011-02-17 16:07:47.925185+01	1	11	65	AME1	1	
465	2011-02-17 16:08:06.498979+01	1	11	65	AME1	2	Изменен brands.
466	2011-02-17 16:08:39.586504+01	1	10	2	MSK::DOCAP	2	Изменен area.
467	2011-02-17 16:32:43.470174+01	1	11	65	Ame1	2	Изменен title.
468	2011-02-17 16:32:52.969246+01	1	11	63	Kta	2	Изменен title.
469	2011-02-17 16:41:38.406349+01	1	13	352	2011-02-17 09:33:20.296501-352	3	
470	2011-02-17 16:41:38.427499+01	1	13	351	2011-02-17 09:33:20.289567-351	3	
471	2011-02-17 16:41:38.429414+01	1	13	350	2011-02-17 09:33:20.271321-350	3	
472	2011-02-17 16:41:56.683865+01	1	9	1	MSK	2	Изменен po.
473	2011-02-17 16:45:53.204358+01	1	13	355	2011-02-17 09:42:49.000276-355	3	
474	2011-02-17 16:45:53.207585+01	1	13	354	2011-02-17 09:42:48.995872-354	3	
475	2011-02-17 16:45:53.209708+01	1	13	353	2011-02-17 09:42:48.988928-353	3	
476	2011-02-17 16:46:54.335715+01	1	9	1	MSK	2	Изменен po.
477	2011-02-17 16:55:58.099451+01	1	12	68	Sh auto parts	1	
478	2011-02-17 16:56:00.888252+01	1	11	65	Ame1	2	Изменен brands.
479	2011-02-17 17:15:21.543918+01	1	11	66	Pls	1	
480	2011-02-17 17:15:37.504579+01	1	11	67	Склад 34	1	
481	2011-02-17 17:15:54.750066+01	1	11	68	Berlin	1	
482	2011-02-17 17:16:36.64349+01	1	10	2	MSK::DOCAP	2	Изменен area.
483	2011-02-17 17:19:38.403037+01	1	3	22	v1344777	1	
484	2011-02-17 17:19:49.27049+01	1	3	22	v1344777	2	Изменен first_name и groups.
485	2011-02-17 19:47:22.8057+01	1	3	23	1344777	1	
486	2011-02-17 19:47:34.842763+01	1	3	23	1344777	2	Изменен groups.
487	2011-02-17 19:48:17.547967+01	1	3	23	1344777	3	
488	2011-02-17 20:19:00.909437+01	1	3	24	111111	1	
489	2011-02-17 20:19:15.871673+01	1	3	24	111111	2	Изменен groups.
490	2011-02-17 20:21:01.111642+01	1	3	24	111111	3	
491	2011-02-17 21:47:05.75115+01	1	3	25	1test	1	
492	2011-02-18 15:18:23.369695+01	1	13	360	2011-02-17 10:33:51.291602-360	2	Изменен part_number и invoice_code.
493	2011-02-18 15:19:53.194181+01	1	13	366	2011-02-17 10:33:51.355168-366	2	Изменен part_number и invoice_code.
494	2011-02-22 20:55:25.475849+01	1	12	7	Chevrolet	2	Изменен title.
495	2011-02-22 21:21:19.089945+01	1	3	26	7p	1	
496	2011-02-22 21:21:35.607032+01	1	3	26	7p	2	Изменен first_name и groups.
497	2011-02-22 21:22:50.890133+01	1	3	27	vp	1	
498	2011-02-22 21:23:05.275882+01	1	3	27	vp	2	Изменен first_name и groups.
499	2011-02-22 21:28:13.061414+01	1	11	25	Mitsubishi	2	Изменен brands.
500	2011-02-22 21:38:37.537624+01	1	12	69	Tyc	1	
501	2011-02-22 21:38:41.854537+01	1	11	62	Rockauto	2	Изменен brands.
502	2011-02-22 21:48:02.783316+01	1	3	28	v3363133	1	
503	2011-02-22 21:48:15.741649+01	1	3	28	v3363133	2	Изменен first_name и groups.
504	2011-02-22 21:48:56.310701+01	1	3	29	v3177961	1	
505	2011-02-22 21:49:36.580867+01	1	3	29	v3177961	2	Изменен first_name и groups.
506	2011-02-22 21:50:08.058899+01	1	3	30	m5754272	1	
507	2011-02-22 21:50:24.766818+01	1	3	30	m5754272	2	Изменен first_name и groups.
508	2011-02-22 21:54:36.237001+01	1	11	48	Ebay	2	Ни одно поле не изменено.
509	2011-02-22 21:57:28.933856+01	1	12	70	Rock products	1	
510	2011-02-22 21:58:10.152783+01	1	12	71	Fel-pro	1	
511	2011-02-22 21:58:43.752571+01	1	11	62	Rockauto	2	Изменен brands.
512	2011-02-22 22:10:17.058862+01	1	12	72	bendix	1	
513	2011-02-22 22:10:40.324792+01	1	12	73	Atp	1	
514	2011-02-22 22:11:05.860813+01	1	12	72	Bendix	2	Изменен title.
515	2011-02-22 22:11:40.217222+01	1	11	62	Rockauto	2	Изменен brands.
516	2011-02-22 22:29:12.204621+01	1	11	69	Pls	1	
517	2011-02-22 22:29:27.382635+01	1	10	2	MSK::DOCAP	2	Изменен area.
518	2011-02-22 22:30:14.599046+01	1	11	69	Pls	2	Изменен brands.
519	2011-02-22 22:32:49.778904+01	1	11	69	Pls	2	Ни одно поле не изменено.
520	2011-02-22 22:33:14.015135+01	1	11	69	Pls	2	Ни одно поле не изменено.
521	2011-02-22 22:34:16.37694+01	1	11	69	Pls	2	Ни одно поле не изменено.
522	2011-02-22 22:35:10.027113+01	1	11	69	Pls	3	
523	2011-02-22 22:35:23.35036+01	1	11	66	Pls	2	Изменен brands.
524	2011-02-23 15:25:15.62897+01	1	11	70	Ave	1	
525	2011-02-23 15:25:25.604789+01	1	10	2	MSK::DOCAP	2	Изменен area.
526	2011-02-23 15:26:12.520038+01	1	12	74	Signeda	1	
527	2011-02-23 15:26:20.092155+01	1	11	67	Склад 34	2	Изменен brands.
528	2011-02-23 15:27:47.056489+01	1	11	67	Склад 34	2	Ни одно поле не изменено.
529	2011-02-23 15:29:24.427428+01	1	3	31	nr	1	
530	2011-02-23 15:29:39.139572+01	1	3	31	nr	2	Изменен first_name и groups.
531	2011-02-23 15:43:39.852843+01	1	12	75	Bmw	1	
532	2011-02-23 15:43:42.702583+01	1	11	68	Berlin	2	Изменен brands.
533	2011-02-23 15:49:40.279032+01	1	12	75	Bmw	3	
534	2011-02-23 15:50:00.918657+01	1	11	68	Berlin	2	Изменен brands.
536	2011-02-23 15:51:44.925729+01	1	11	70	Ave	2	Изменен brands.
537	2011-02-23 15:56:10.251958+01	1	11	71	Эмираты F : NLL	1	
538	2011-02-23 15:56:23.431209+01	1	11	71	Эмираты F : NLL	2	Изменен brands.
539	2011-02-23 15:58:51.15106+01	1	10	3	MSK::DOCVP	3	
540	2011-02-23 15:59:16.477083+01	1	10	2	MSK::DOCAP	2	Изменен area.
541	2011-02-23 16:02:46.054391+01	1	3	32	v6192154	1	
542	2011-02-23 16:02:56.683661+01	1	3	32	v6192154	2	Изменен first_name и groups.
543	2011-02-23 16:27:21.986407+01	1	11	72	HOZ1	1	
544	2011-02-23 16:28:03.01914+01	1	10	2	MSK::DOCAP	2	Изменен area.
545	2011-02-23 16:28:19.083309+01	1	11	72	HOZ1	2	Изменен brands.
546	2011-02-23 16:28:28.415537+01	1	11	68	Berlin	2	Изменен brands.
547	2011-02-23 16:29:39.16358+01	1	11	72	Hoz1	2	Изменен title.
548	2011-02-23 16:30:50.651745+01	1	11	65	Ame1	2	Изменен brands.
549	2011-02-23 19:09:28.520146+01	1	11	73	Ahon	1	
550	2011-02-23 19:09:41.40062+01	1	10	2	MSK::DOCAP	2	Изменен area.
551	2011-02-23 19:16:47.190168+01	1	11	73	Ahon	2	Изменен brands.
552	2011-02-23 19:25:14.740068+01	1	3	33	v6712494	1	
553	2011-02-23 19:25:27.829928+01	1	3	33	v6712494	2	Изменен first_name и groups.
554	2011-02-23 19:33:34.750299+01	1	3	34	v6325623	1	
555	2011-02-23 19:33:43.078249+01	1	3	34	v6325623	2	Изменен first_name и groups.
556	2011-02-23 19:39:13.512974+01	1	12	77	Cardone	1	
557	2011-02-23 19:39:17.894828+01	1	11	62	Rockauto	2	Изменен brands.
558	2011-02-23 19:44:40.915844+01	1	3	35	v6628036	1	
559	2011-02-23 19:44:54.012544+01	1	3	35	v6628036	2	Изменен first_name и groups.
560	2011-02-23 19:52:01.121726+01	1	13	436	2011-02-23 12:45:18.232259-436	3	
561	2011-02-23 19:57:22.700057+01	1	3	36	mi	1	
562	2011-02-23 19:57:35.001917+01	1	3	36	mi	2	Изменен first_name и groups.
563	2011-02-23 19:58:48.968899+01	1	10	6	US::MOTO	2	Изменен area.
564	2011-02-23 19:59:10.243163+01	1	10	6	US::MOTO	2	Изменен delivery.
565	2011-02-23 19:59:57.45953+01	1	12	78	Kawasaki	1	
566	2011-02-23 20:00:01.802309+01	1	11	58	Ronayers	2	Изменен brands.
567	2011-02-23 20:05:41.215653+01	1	3	37	v6270092	1	
568	2011-02-23 20:05:51.59608+01	1	3	37	v6270092	2	Изменен first_name и groups.
569	2011-02-23 20:32:21.885655+01	1	3	38	m7153689	1	
570	2011-02-23 20:32:42.756256+01	1	3	38	m7153689	2	Изменен first_name и groups.
571	2011-02-23 22:42:39.412908+01	1	13	370	2011-02-22 14:10:37.497661-370	2	Изменен part_number и invoice_code.
572	2011-02-24 18:33:05.071982+01	1	11	74	ERV : Склад 1	1	
573	2011-02-24 18:33:13.011887+01	1	10	2	MSK::DOCAP	2	Изменен area.
574	2011-02-24 18:35:29.144454+01	1	11	74	ERV : Склад 1	2	Изменен brands.
575	2011-02-24 20:13:16.279696+01	1	13	381	2011-02-22 14:41:34.072258-381	2	Изменен part_number и invoice_code.
576	2011-02-24 20:13:42.137498+01	1	13	382	2011-02-22 14:41:34.077736-382	2	Изменен part_number и invoice_code.
577	2011-02-24 20:14:11.908698+01	1	13	383	2011-02-22 14:41:34.084600-383	2	Изменен invoice_code.
578	2011-02-24 20:14:35.500844+01	1	13	384	2011-02-22 14:58:59.481603-384	2	Изменен invoice_code.
579	2011-02-24 20:14:54.805542+01	1	13	385	2011-02-22 14:58:59.488935-385	2	Изменен invoice_code.
580	2011-02-24 20:15:19.492031+01	1	13	388	2011-02-22 14:58:59.507144-388	2	Изменен invoice_code.
581	2011-02-24 20:15:35.696046+01	1	13	389	2011-02-22 14:58:59.512078-389	2	Изменен invoice_code.
582	2011-02-24 20:16:16.429219+01	1	13	421	2011-02-23 12:29:54.174478-421	2	Изменен invoice_code.
583	2011-02-24 20:16:42.708196+01	1	13	422	2011-02-23 12:29:54.180323-422	2	Изменен invoice_code.
584	2011-02-24 20:17:53.984241+01	1	13	398	2011-02-22 15:14:22.731544-398	2	Изменен part_number и invoice_code.
585	2011-02-24 20:19:09.947+01	1	13	394	2011-02-22 15:14:22.709683-394	2	Изменен invoice_code.
586	2011-02-24 20:25:42.309781+01	1	13	440	2011-02-23 13:01:27.203631-440	2	Изменен invoice_code.
587	2011-02-24 20:26:25.612072+01	1	13	444	2011-02-23 13:03:18.362588-444	2	Изменен part_number и invoice_code.
588	2011-02-24 20:26:43.97844+01	1	13	445	2011-02-23 13:06:17.175351-445	2	Изменен invoice_code.
589	2011-02-24 20:27:01.030088+01	1	13	454	2011-02-23 13:34:11.828133-454	2	Изменен invoice_code.
590	2011-02-24 20:27:18.193258+01	1	13	455	2011-02-23 13:34:11.836328-455	2	Изменен invoice_code.
591	2011-02-24 20:28:59.993792+01	1	13	455	2011-02-23 13:34:11.836328-455	2	Ни одно поле не изменено.
592	2011-02-24 20:29:29.207551+01	1	13	457	2011-02-23 15:11:28.103058-457	2	Изменен invoice_code.
593	2011-02-24 20:29:50.71285+01	1	13	459	2011-02-23 15:11:28.128379-459	2	Изменен invoice_code.
594	2011-02-24 21:05:40.988066+01	1	13	366	2011-02-17 10:33:51.355168-366	3	
595	2011-02-24 22:31:19.375134+01	1	3	3	aps	2	Ни одно поле не изменено.
596	2011-02-24 22:38:20.338071+01	1	3	25	retail	2	Изменен username и groups.
597	2011-02-24 22:41:15.815162+01	1	2	2	Розница	2	Изменен discount.
598	2011-02-24 22:41:27.310612+01	1	2	2	Розница	2	Изменен discount.
599	2011-02-24 22:55:36.077167+01	1	3	39	v6232706	1	
600	2011-02-24 22:55:45.276311+01	1	3	39	v6232706	2	Изменен first_name и groups.
601	2011-02-24 22:57:34.005827+01	1	11	75	PU	1	
602	2011-02-24 22:57:44.079967+01	1	11	76	TR	1	
603	2011-02-24 22:59:12.503725+01	1	10	6	US::MOTO	2	Изменен area.
604	2011-02-25 16:35:50.752878+01	1	13	456	2011-02-23 15:11:28.090774-456	2	Изменен status и invoice_code.
605	2011-02-25 16:37:50.667826+01	1	13	454	2011-02-23 13:34:11.828133-454	2	Изменен quantity.
606	2011-03-03 21:22:47.171222+01	1	12	79	Parts-Unlimited	1	
607	2011-03-03 21:22:49.754335+01	1	11	75	PU	2	Изменен brands.
608	2011-03-03 21:23:36.198761+01	1	12	79	PU	2	Изменен title.
609	2011-03-03 21:24:20.616203+01	1	12	80	Centric	1	
610	2011-03-03 21:25:26.411563+01	1	12	81	Timken	1	
611	2011-03-03 21:25:28.742476+01	1	11	43	Turboii	2	Изменен brands.
612	2011-03-03 21:27:17.872099+01	1	3	40	rsxrename	1	
613	2011-03-03 21:27:29.990048+01	1	3	40	rsxrename	2	Изменен groups.
614	2011-03-03 21:29:06.190115+01	1	3	41	ed	1	
615	2011-03-03 21:29:20.272807+01	1	3	41	ed	2	Изменен first_name и groups.
616	2011-03-03 21:30:47.3447+01	1	12	79	Pu	2	Изменен title.
617	2011-03-03 21:31:07.517106+01	1	11	75	Pu	2	Изменен title.
618	2011-03-03 21:32:33.371436+01	1	11	75	pu	2	Изменен title.
619	2011-03-03 21:32:47.132515+01	1	11	75	Pu	2	Изменен title.
620	2011-03-03 21:50:53.180869+01	1	11	75	Pu	3	
621	2011-03-03 21:51:42.280968+01	1	10	6	US::MOTO	2	Изменен area.
622	2011-03-03 21:52:25.615502+01	1	12	82	Gates	1	
623	2011-03-03 21:52:27.411714+01	1	11	62	Rockauto	2	Изменен brands.
624	2011-03-03 21:53:48.930992+01	1	11	50	PU	2	Изменен title и brands.
625	2011-03-03 22:04:46.72994+01	1	3	42	tl	1	
626	2011-03-03 22:04:55.893331+01	1	3	42	tl	2	Изменен groups.
627	2011-03-08 13:46:31.160768+01	1	13	476	2011-03-03 15:05:10.044358-476	3	
628	2011-03-08 13:46:31.163913+01	1	13	475	2011-03-03 15:05:10.036129-475	3	
629	2011-03-08 13:57:56.634077+01	1	11	43	Turboii	2	Изменен brands.
630	2011-03-08 14:19:13.405492+01	1	3	43	ukr	1	
631	2011-03-08 14:19:34.562703+01	1	3	43	ukr	2	Изменен first_name и groups.
632	2011-03-08 14:23:58.030912+01	1	13	488	2011-03-08 07:20:52.443212-488	2	Изменен part_number и invoice_code.
633	2011-03-08 14:36:22.132395+01	1	11	30	Porsche	2	Изменен brands.
634	2011-03-08 14:46:38.467914+01	1	13	508	2011-03-08 07:43:14.525585-508	3	
635	2011-03-08 14:46:38.471655+01	1	13	507	2011-03-08 07:43:14.520281-507	3	
636	2011-03-08 14:46:38.473481+01	1	13	506	2011-03-08 07:43:14.515246-506	3	
637	2011-03-08 14:46:38.475306+01	1	13	505	2011-03-08 07:43:14.509590-505	3	
638	2011-03-08 14:46:38.478152+01	1	13	504	2011-03-08 07:43:14.500885-504	3	
639	2011-03-08 14:46:38.482185+01	1	13	503	2011-03-08 07:43:14.466421-503	3	
640	2011-03-08 14:46:38.484032+01	1	13	502	2011-03-08 07:37:19.212530-502	3	
641	2011-03-08 14:46:38.485844+01	1	13	501	2011-03-08 07:37:19.207186-501	3	
642	2011-03-08 14:46:38.48766+01	1	13	500	2011-03-08 07:37:19.201819-500	3	
643	2011-03-08 14:46:38.490015+01	1	13	499	2011-03-08 07:37:19.194042-499	3	
644	2011-03-08 14:58:28.813495+01	1	11	54	Jaguar	3	
645	2011-03-08 14:59:01.042188+01	1	12	54	Jaguar	3	
646	2011-03-08 14:59:15.606822+01	1	11	17	Jaguar	2	Изменен brands.
647	2011-03-08 15:01:29.018579+01	1	11	77	Ame	1	
648	2011-03-08 15:01:38.03978+01	1	10	2	MSK::DOCAP	2	Изменен area.
649	2011-03-08 15:02:08.488587+01	1	11	77	Ame	2	Изменен brands.
650	2011-03-08 15:26:35.178575+01	1	3	44	v3349017	1	
651	2011-03-08 15:26:49.780167+01	1	3	44	v3349017	2	Изменен first_name и groups.
652	2011-03-08 15:41:45.228383+01	1	3	45	vbr	1	
653	2011-03-08 15:42:07.24101+01	1	3	45	vbr	2	Изменен first_name и groups.
654	2011-03-08 15:43:48.151755+01	1	13	530	2011-03-08 08:42:55.045190-530	3	
655	2011-03-08 15:43:48.165766+01	1	13	529	2011-03-08 08:42:55.040140-529	3	
656	2011-03-08 15:43:48.169122+01	1	13	528	2011-03-08 08:42:55.035651-528	3	
657	2011-03-08 15:43:48.171662+01	1	13	527	2011-03-08 08:42:55.029490-527	3	
658	2011-03-08 15:54:46.104243+01	1	3	46	v3363134	1	
659	2011-03-08 15:54:53.878699+01	1	3	46	v3363134	2	Изменен groups.
660	2011-03-08 15:55:21.673968+01	1	3	47	mbr	1	
661	2011-03-08 15:55:36.054222+01	1	3	47	mbr	2	Изменен first_name и groups.
662	2011-03-08 15:56:58.237201+01	1	3	48	v6657189	1	
663	2011-03-08 15:57:14.046695+01	1	3	48	v6657189	2	Изменен first_name и groups.
664	2011-03-08 16:14:02.369207+01	1	13	545	2011-03-08 08:46:36.545361-545	2	Изменен client, client_order_id и invoice_code.
665	2011-03-08 16:16:28.442627+01	1	3	49	v6501818	1	
666	2011-03-08 16:16:34.396128+01	1	3	49	v6501818	2	Изменен groups.
667	2011-03-08 16:22:09.195971+01	1	12	83	Wix	1	
668	2011-03-08 16:22:33.58199+01	1	12	84	Moog	1	
669	2011-03-08 16:22:54.905833+01	1	12	85	Wills	1	
670	2011-03-08 16:22:57.668927+01	1	11	43	Turboii	2	Изменен brands.
671	2011-03-08 16:23:45.710585+01	1	11	43	Turboii	2	Изменен brands.
672	2011-03-08 16:24:05.938913+01	1	11	62	Rockauto	2	Изменен brands.
673	2011-03-21 16:14:35.177576+01	1	3	50	v3085238	1	
674	2011-03-21 16:15:01.599408+01	1	3	50	v3085238	2	Изменен first_name и groups.
675	2011-03-21 16:33:11.951082+01	1	13	582	2011-03-21 10:20:49.863297-582	2	Изменен price_sale и invoice_code.
676	2011-03-21 16:48:07.596741+01	1	3	51	v6460263	1	
677	2011-03-21 16:48:28.560255+01	1	3	51	v6460263	2	Изменен first_name и groups.
678	2011-03-21 16:51:31.770246+01	1	3	52	pi	1	
679	2011-03-21 16:52:02.76553+01	1	3	52	pi	2	Изменен first_name и groups.
680	2011-03-21 17:14:07.441133+01	1	3	53	v3263556	1	
681	2011-03-21 17:14:32.718746+01	1	3	53	v3263556	2	Изменен first_name и groups.
682	2011-03-21 17:15:35.986507+01	1	3	54	v3726769	1	
683	2011-03-21 17:15:55.33018+01	1	3	54	v3726769	2	Изменен first_name и groups.
684	2011-03-21 17:16:58.656067+01	1	3	55	v3263557	1	
685	2011-03-21 17:17:16.825466+01	1	3	55	v3263557	2	Изменен groups.
686	2011-03-21 17:17:55.949263+01	1	3	56	v6863266	1	
687	2011-03-21 17:18:05.009492+01	1	3	56	v6863266	2	Изменен groups.
688	2011-03-21 17:18:43.65077+01	1	3	57	m7042483	1	
689	2011-03-21 17:18:53.944644+01	1	3	57	m7042483	2	Изменен groups.
690	2011-03-21 17:37:30.052116+01	1	13	632	2011-03-21 11:23:00.050001-632	2	Изменен part_number и invoice_code.
691	2011-03-21 17:37:56.591533+01	1	13	631	2011-03-21 11:23:00.044500-631	2	Изменен part_number и invoice_code.
692	2011-03-21 17:38:27.015616+01	1	13	630	2011-03-21 11:23:00.036789-630	2	Изменен part_number и invoice_code.
693	2011-03-21 17:56:44.328149+01	1	3	58	v7621389	1	
694	2011-03-21 17:56:56.228375+01	1	3	58	v7621389	2	Изменен groups.
695	2011-03-21 18:00:19.501354+01	1	13	649	2011-03-21 11:59:18.281516-649	3	
696	2011-03-21 18:06:05.738422+01	1	3	59	v6262262	1	
697	2011-03-21 18:06:26.078971+01	1	3	59	v6262262	2	Изменен first_name и groups.
698	2011-03-21 18:19:33.50224+01	1	3	60	v3846372	1	
699	2011-03-21 18:20:15.385926+01	1	3	60	v3846372	2	Изменен groups.
700	2011-03-21 18:24:44.27433+01	1	3	61	v7690095	1	
701	2011-03-21 18:24:53.961998+01	1	3	61	v7690095	2	Изменен groups.
702	2011-03-21 18:29:29.280525+01	1	3	62	v6061421	1	
703	2011-03-21 18:29:37.674631+01	1	3	62	v6061421	2	Изменен groups.
704	2011-03-21 18:37:21.100894+01	1	12	86	Airtex	1	
705	2011-03-21 18:38:00.492006+01	1	11	62	Rockauto	2	Изменен brands.
706	2011-03-21 18:38:28.343278+01	1	12	87	Various	1	
707	2011-03-21 18:38:32.325529+01	1	11	62	Rockauto	2	Изменен brands.
708	2011-03-24 11:08:02.723889+01	1	13	695	2011-03-24 05:07:30.419101-695	3	
709	2011-03-24 11:08:02.727879+01	1	13	694	2011-03-24 05:07:30.411371-694	3	
710	2011-03-24 11:08:44.092275+01	1	10	5	US::AFTMARK	2	Изменен add_brand_to_comment.
711	2011-03-24 11:10:34.900745+01	1	13	697	2011-03-24 05:09:02.559721-697	3	
712	2011-03-24 11:10:34.914327+01	1	13	696	2011-03-24 05:09:02.530610-696	3	
713	2011-03-24 20:31:38.736648+01	1	13	699	2011-03-24 14:29:15.981149-699	3	
714	2011-03-24 20:31:38.739482+01	1	13	698	2011-03-24 13:50:43.736925-698	3	
715	2011-03-24 20:36:54.153507+01	1	13	700	2011-03-24 14:36:00.223421-700	3	
716	2011-03-25 12:07:36.379293+01	1	13	692	2011-03-21 13:10:06.035248-692	2	Изменен price_sale и invoice_code.
717	2011-03-25 12:14:55.692769+01	1	13	704	2011-03-25 06:11:03.441116-704	3	
718	2011-03-25 12:14:55.696569+01	1	13	703	2011-03-25 06:11:03.435449-703	3	
719	2011-03-25 12:14:55.698342+01	1	13	702	2011-03-25 06:11:03.431091-702	3	
720	2011-03-25 12:14:55.700107+01	1	13	701	2011-03-25 06:11:03.424095-701	3	
721	2011-03-25 12:25:50.612729+01	1	3	63	v6505474	1	
722	2011-03-25 12:26:08.134482+01	1	3	63	v6505474	2	Изменен groups.
723	2011-03-25 12:26:31.284279+01	1	3	64	v6061423	1	
724	2011-03-25 12:26:40.925953+01	1	3	64	v6061423	2	Изменен groups.
725	2011-03-25 12:31:38.225407+01	1	13	710	2011-03-25 06:31:01.166986-710	3	
726	2011-03-25 12:31:38.257247+01	1	13	709	2011-03-25 06:31:01.161367-709	3	
727	2011-03-25 12:31:38.259194+01	1	13	708	2011-03-25 06:31:01.127459-708	3	
728	2011-03-25 12:31:38.260899+01	1	13	707	2011-03-25 06:28:03.661620-707	3	
729	2011-03-25 12:31:38.262634+01	1	13	706	2011-03-25 06:28:03.652147-706	3	
730	2011-03-25 12:31:38.264315+01	1	13	705	2011-03-25 06:22:31.078873-705	3	
731	2011-03-25 14:00:47.912967+01	1	13	725	2011-03-25 07:48:11.776877-725	3	
732	2011-03-25 14:00:47.927225+01	1	13	724	2011-03-25 07:48:11.770111-724	3	
733	2011-03-25 14:00:47.929351+01	1	13	723	2011-03-25 07:48:11.737062-723	3	
734	2011-03-25 14:00:47.931612+01	1	13	722	2011-03-25 07:41:25.566793-722	3	
735	2011-03-25 14:00:47.934139+01	1	13	721	2011-03-25 07:41:25.562499-721	3	
736	2011-03-25 14:00:47.937754+01	1	13	720	2011-03-25 07:41:25.552346-720	3	
737	2011-03-25 14:00:47.940459+01	1	13	719	2011-03-25 07:41:25.542447-719	3	
738	2011-03-25 14:00:47.943007+01	1	13	718	2011-03-25 07:41:25.534555-718	3	
739	2011-03-25 14:00:47.945538+01	1	13	717	2011-03-25 07:41:25.520713-717	3	
740	2011-03-25 14:15:36.239522+01	1	3	65	v1955818	1	
741	2011-03-25 14:15:59.3838+01	1	3	65	v1955818	2	Изменен first_name и groups.
742	2011-03-25 14:18:22.702821+01	1	3	66	v6667175	1	
743	2011-03-25 14:19:01.036457+01	1	3	66	v6667175	2	Изменен first_name и groups.
744	2011-03-25 14:19:47.98182+01	1	3	67	v3595692	1	
745	2011-03-25 14:20:35.533618+01	1	3	67	v3595692	2	Изменен first_name и groups.
746	2011-03-25 14:21:11.79192+01	1	3	68	v6766268	1	
747	2011-03-25 14:21:28.480171+01	1	3	68	v6766268	2	Изменен first_name и groups.
748	2011-03-25 14:29:15.290234+01	1	3	69	saka	1	
749	2011-03-25 14:29:32.635869+01	1	3	69	saka	2	Изменен first_name и groups.
750	2011-03-25 14:34:12.793529+01	1	10	5	US::AFTMARK	2	Ни одно поле не изменено.
751	2011-03-25 14:40:23.038768+01	1	13	809	2011-03-25 08:37:57.081339-809	3	
752	2011-03-25 14:40:23.053684+01	1	13	808	2011-03-25 08:36:52.009581-808	3	
753	2011-03-25 14:49:20.168402+01	1	13	810	2011-03-25 08:48:01.905207-810	3	
754	2011-03-25 14:56:18.807407+01	1	13	838	2011-03-25 08:54:40.351086-838	2	Изменен part_number и invoice_code.
755	2011-03-25 14:56:40.938172+01	1	13	837	2011-03-25 08:54:40.345114-837	2	Изменен part_number и invoice_code.
756	2011-03-25 14:57:01.553731+01	1	13	836	2011-03-25 08:54:40.339557-836	2	Изменен part_number и invoice_code.
757	2011-03-25 14:57:22.908931+01	1	13	825	2011-03-25 08:54:40.279670-825	2	Изменен part_number и invoice_code.
758	2011-03-25 15:01:59.580346+01	1	3	70	v6221214	1	
759	2011-03-25 15:02:27.33921+01	1	3	70	v6221214	2	Изменен first_name и groups.
760	2011-03-25 21:12:53.764231+01	1	12	88	Sherman	1	
761	2011-03-25 21:13:00.803225+01	1	11	62	Rockauto	2	Изменен brands.
762	2011-03-25 21:24:40.592758+01	1	3	71	l9877361	1	
763	2011-03-25 21:26:15.810799+01	1	3	71	l9877361	2	Изменен groups.
764	2011-03-25 21:28:03.636689+01	1	12	89	Sealed power	1	
765	2011-03-25 21:28:15.975079+01	1	11	62	Rockauto	2	Изменен brands.
766	2011-03-25 21:30:09.726721+01	1	13	858	2011-03-25 15:28:28.522046-858	3	
767	2011-03-25 21:30:09.735768+01	1	13	857	2011-03-25 15:28:28.515978-857	3	
768	2011-03-25 21:30:09.737703+01	1	13	856	2011-03-25 15:28:28.510284-856	3	
769	2011-03-25 21:30:09.741412+01	1	13	855	2011-03-25 15:28:28.505786-855	3	
770	2011-03-25 21:30:09.744038+01	1	13	854	2011-03-25 15:28:28.497741-854	3	
771	2011-03-25 21:43:12.450057+01	1	3	72	v6223820	1	
772	2011-03-25 21:43:37.997543+01	1	3	72	v6223820	2	Изменен first_name и groups.
773	2011-03-25 22:14:01.822841+01	1	3	73	v6591403	1	
774	2011-03-25 22:14:43.332108+01	1	3	73	v6591403	2	Изменен groups.
775	2011-03-28 19:34:49.40087+02	1	3	74	v1818366	1	
776	2011-03-28 19:35:08.1651+02	1	3	74	v1818366	2	Изменен groups.
777	2011-03-28 19:38:54.613846+02	1	12	90	Standard	1	
778	2011-03-28 19:38:58.55162+02	1	11	62	Rockauto	2	Изменен brands.
779	2011-03-28 19:41:17.883371+02	1	3	75	v6580334	1	
780	2011-03-28 19:41:35.285748+02	1	3	75	v6580334	2	Изменен groups.
781	2011-03-28 19:42:30.394995+02	1	12	91	Ultrapower	1	
782	2011-03-28 19:42:57.292719+02	1	11	62	Rockauto	2	Изменен brands.
783	2011-03-28 20:01:19.650545+02	1	3	76	v3444909	1	
784	2011-03-28 20:01:50.859039+02	1	3	76	v3444909	2	Изменен groups.
785	2011-03-28 20:47:50.896472+02	1	11	43	Turboii	2	Изменен brands.
786	2011-03-28 21:07:34.515876+02	1	11	58	Ronayers	2	Изменен brands.
787	2011-03-28 21:16:33.366717+02	1	10	5	US::AFTMARK	2	Изменен area.
788	2011-03-28 21:17:51.132774+02	1	11	52	Magnum	2	Изменен brands.
789	2011-03-28 21:47:58.947191+02	1	11	45	Ekeystone	2	Изменен brands.
790	2011-03-28 21:56:33.683916+02	1	3	25	retail	2	Изменен groups.
791	2011-03-28 23:38:45.101952+02	1	13	372	2011-02-22 14:28:57.441133-372	2	Изменен client.
792	2011-03-28 23:40:15.238282+02	1	13	512	2011-03-08 07:47:05.282129-512	2	Изменен client и invoice_code.
793	2011-03-28 23:49:23.150344+02	1	3	77	M2746754	1	
794	2011-03-28 23:49:48.2092+02	1	3	77	M2746754	2	Изменен first_name и groups.
795	2011-03-28 23:50:23.200284+02	1	3	78	v6716736	1	
796	2011-03-28 23:50:46.28501+02	1	3	78	v6716736	2	Изменен first_name и groups.
797	2011-03-28 23:53:20.099259+02	1	13	1004	2011-03-28 16:52:10.838697-1004	3	
798	2011-03-28 23:53:20.102402+02	1	13	1003	2011-03-28 16:52:10.831849-1003	3	
799	2011-03-28 23:53:20.104124+02	1	13	1002	2011-03-28 16:52:10.824965-1002	3	
800	2011-03-28 23:53:20.105821+02	1	13	1001	2011-03-28 16:52:10.818242-1001	3	
801	2011-03-28 23:53:20.107527+02	1	13	1000	2011-03-28 16:52:10.811344-1000	3	
802	2011-03-28 23:53:20.109184+02	1	13	999	2011-03-28 16:52:10.803046-999	3	
803	2011-03-28 23:53:20.112297+02	1	13	998	2011-03-28 16:52:10.795625-998	3	
804	2011-03-28 23:53:20.114603+02	1	13	997	2011-03-28 16:52:10.788547-997	3	
805	2011-03-28 23:53:20.116513+02	1	13	996	2011-03-28 16:52:10.781567-996	3	
806	2011-03-28 23:53:20.120699+02	1	13	995	2011-03-28 16:52:10.762415-995	3	
807	2011-03-28 23:55:45.702639+02	1	3	77	m2746754	2	Изменен username.
808	2011-03-29 00:01:03.949658+02	1	3	79	v6599513	1	
809	2011-03-29 00:01:23.733871+02	1	3	79	v6599513	2	Изменен groups.
810	2011-03-29 00:02:40.216958+02	1	12	92	National	1	
811	2011-03-29 00:02:43.862158+02	1	11	62	Rockauto	2	Изменен brands.
812	2011-03-29 10:56:29.054883+02	1	11	78	TTI	1	
813	2011-03-29 10:56:56.630293+02	1	12	93	Monroe	1	
814	2011-03-29 10:57:00.499878+02	1	11	78	TTI	2	Изменен brands.
815	2011-03-29 10:57:20.953526+02	1	11	66	PLS	2	Изменен title и brands.
816	2011-03-29 10:59:29.832903+02	1	3	80	v6041857	1	
817	2011-03-29 10:59:44.032839+02	1	3	80	v6041857	2	Изменен groups.
818	2011-03-29 11:01:31.478673+02	1	10	2	MSK::DOCAP	2	Изменен area.
819	2011-03-29 11:02:51.670369+02	1	11	78	Tti	2	Изменен title.
820	2011-03-29 11:03:07.451456+02	1	11	66	Pls	2	Изменен title.
821	2011-03-29 11:05:09.482813+02	1	11	74	Erv : Склад 1	2	Изменен title.
822	2011-03-29 11:05:26.548844+02	1	11	74	Erv : Склад 1	2	Изменен brands.
823	2011-03-29 11:05:58.854564+02	1	11	74	Erv : склад 1	2	Изменен title.
824	2011-03-29 11:06:18.010331+02	1	11	76	Tr	2	Изменен title.
825	2011-03-29 11:09:55.427248+02	1	11	79	Ex	1	
826	2011-03-29 11:10:01.059013+02	1	10	1	MSK::EXAP	2	Изменен area.
827	2011-03-29 11:10:35.428891+02	1	11	79	Ex	2	Изменен brands.
828	2011-03-29 11:22:44.531524+02	1	11	50	Pu	2	Изменен title.
829	2011-03-29 12:00:57.532215+02	1	3	81	v3181445	1	
830	2011-03-29 12:01:14.825947+02	1	3	81	v3181445	2	Изменен groups.
831	2011-03-29 12:06:36.919886+02	1	3	82	v6756191	1	
832	2011-03-29 12:06:51.522613+02	1	3	82	v6756191	2	Изменен groups.
833	2011-03-29 12:07:56.145461+02	1	11	31	Saab	2	Изменен brands.
834	2011-03-29 12:17:35.474372+02	1	12	94	Tr	1	
835	2011-03-29 12:17:39.810322+02	1	11	76	Tr	2	Изменен brands.
836	2011-03-29 12:20:48.436944+02	1	11	76	Tr	3	
837	2011-03-29 12:21:10.684944+02	1	11	49	Tr	2	Изменен brands.
838	2011-03-29 12:25:34.239433+02	1	10	6	US::MOTO	2	Изменен area.
839	2011-03-29 13:24:58.170998+02	1	11	77	Ame	2	Изменен brands.
840	2011-03-29 13:59:03.059189+02	1	13	1114	2011-03-29 06:57:55.038453-1114	3	
841	2011-03-29 13:59:03.101082+02	1	13	1113	2011-03-29 06:57:55.032649-1113	3	
842	2011-03-29 13:59:03.10308+02	1	13	1112	2011-03-29 06:57:55.028177-1112	3	
843	2011-03-29 13:59:03.1048+02	1	13	1111	2011-03-29 06:57:55.021548-1111	3	
844	2011-03-29 13:59:03.10666+02	1	13	1110	2011-03-29 06:57:55.011193-1110	3	
845	2011-03-29 13:59:03.108308+02	1	13	1109	2011-03-29 06:57:54.991166-1109	3	
846	2011-03-29 14:25:27.768914+02	1	3	83	v6533731	1	
847	2011-03-29 14:25:49.526748+02	1	3	83	v6533731	2	Изменен first_name и groups.
848	2011-03-29 14:27:44.276753+02	1	3	84	v6926906	1	
849	2011-03-29 14:27:56.993548+02	1	3	84	v6926906	2	Изменен groups.
850	2011-03-29 14:42:10.936116+02	1	3	85	v6452070	1	
851	2011-03-29 14:42:26.146105+02	1	3	85	v6452070	2	Изменен groups.
852	2011-03-29 14:43:55.100246+02	1	11	62	Rockauto	2	Изменен brands.
853	2011-03-30 14:17:31.790841+02	1	3	86	v5830207	1	
854	2011-03-30 14:17:41.223177+02	1	3	86	v5830207	2	Изменен groups.
855	2011-03-30 14:18:50.457257+02	1	3	87	v6056056	1	
856	2011-03-30 14:19:00.344889+02	1	3	87	v6056056	2	Изменен groups.
857	2011-03-30 14:29:29.417426+02	1	3	88	v6550588	1	
858	2011-03-30 14:29:40.688491+02	1	3	88	v6550588	2	Изменен groups.
859	2011-03-30 14:38:42.51274+02	1	3	89	vl	1	
860	2011-03-30 14:38:59.647054+02	1	3	89	vl	2	Изменен groups.
861	2011-03-30 14:42:44.483736+02	1	12	95	Clevite	1	
862	2011-03-30 14:42:50.59415+02	1	11	52	Magnum	2	Изменен brands.
863	2011-03-30 14:52:55.331547+02	1	3	90	v6500758	1	
864	2011-03-30 14:53:06.527221+02	1	3	90	v6500758	2	Изменен groups.
865	2011-03-30 15:44:51.252183+02	1	3	91	v7003071	1	
866	2011-03-30 15:45:12.315153+02	1	3	91	v7003071	2	Изменен groups.
867	2011-03-30 15:45:59.576526+02	1	3	92	v7026886	1	
868	2011-03-30 15:46:10.185243+02	1	3	92	v7026886	2	Изменен groups.
869	2011-03-30 15:46:48.682749+02	1	3	93	v6298480	1	
870	2011-03-30 15:46:59.77949+02	1	3	93	v6298480	2	Изменен groups.
871	2011-03-30 15:48:26.219205+02	1	3	94	m7003071	1	
872	2011-03-30 15:48:34.68923+02	1	3	94	m7003071	2	Изменен groups.
873	2011-03-30 15:49:48.58841+02	1	12	96	pci	1	
874	2011-03-30 15:49:53.876227+02	1	11	62	Rockauto	2	Изменен brands.
875	2011-03-30 15:50:48.796677+02	1	12	96	Pci	2	Изменен title.
876	2011-03-30 15:52:04.081313+02	1	12	97	K&N	1	
877	2011-03-30 15:52:10.175677+02	1	11	45	Ekeystone	2	Изменен brands.
878	2011-03-30 15:53:40.607642+02	1	12	98	Fram	1	
879	2011-03-30 15:53:46.512185+02	1	11	62	Rockauto	2	Изменен brands.
880	2011-03-30 16:08:47.624163+02	1	3	95	v6017021	1	
881	2011-03-30 16:09:00.393055+02	1	3	95	v6017021	2	Изменен groups.
882	2011-03-30 16:23:23.436012+02	1	3	2	manager	2	Изменен user_permissions.
883	2011-03-30 16:24:54.675438+02	1	3	2	manager	2	Изменен user_permissions.
884	2011-03-30 17:03:50.54566+02	1	13	1350	2011-03-30 09:16:07.842516-1350	3	
885	2011-03-30 17:03:50.558767+02	1	13	1349	2011-03-30 09:16:07.837617-1349	3	
886	2011-03-30 17:05:28.499704+02	1	13	1351	2011-03-30 10:03:43.281366-1351	3	
887	2011-03-30 18:11:42.636938+02	2	3	96	v3485164	1	
888	2011-03-30 18:12:14.823028+02	2	3	96	v3485164	2	Изменен groups.
889	2011-03-30 18:12:57.45471+02	2	3	97	v6657190	1	
890	2011-03-30 18:13:07.914469+02	2	3	97	v6657190	2	Изменен groups.
891	2011-03-30 18:23:11.834059+02	1	3	4	dp	2	Ни одно поле не изменено.
892	2011-03-30 18:30:55.52229+02	1	13	1359	2011-03-30 10:12:58.575224-1359	3	
893	2011-03-30 18:30:55.53592+02	1	13	1358	2011-03-30 10:12:58.568301-1358	3	
894	2011-03-30 18:31:25.323782+02	1	13	1357	2011-03-30 10:12:58.560060-1357	3	
895	2011-03-30 18:31:25.326567+02	1	13	1356	2011-03-30 10:12:58.551063-1356	3	
896	2011-03-30 18:31:25.32837+02	1	13	1355	2011-03-30 10:12:58.544685-1355	3	
897	2011-03-30 18:31:25.330238+02	1	13	1354	2011-03-30 10:12:58.538041-1354	3	
898	2011-03-30 18:31:25.33206+02	1	13	1353	2011-03-30 10:12:58.531292-1353	3	
899	2011-03-30 18:31:25.333852+02	1	13	1352	2011-03-30 10:12:58.515381-1352	3	
900	2011-03-30 18:31:58.264362+02	1	13	1363	2011-03-30 11:29:21.134954-1363	2	Изменен part_number и invoice_code.
901	2011-03-30 19:33:38.628555+02	2	3	98	v7468052	1	
902	2011-03-30 19:33:48.848948+02	2	3	98	v7468052	2	Изменен groups.
903	2011-03-30 21:52:14.938965+02	1	3	99	v3222220	1	
904	2011-03-30 21:52:42.104369+02	1	3	99	v3222220	2	Изменен groups.
905	2011-03-30 21:54:02.595906+02	1	3	100	v6642642	1	
906	2011-03-30 21:54:21.361741+02	1	3	100	v6642642	2	Изменен groups.
907	2011-03-31 17:02:30.92865+02	1	13	1407	2011-03-31 08:10:38.826004-1407	3	
908	2011-03-31 17:02:30.945538+02	1	13	1406	2011-03-31 08:10:38.819051-1406	3	
909	2011-03-31 17:02:30.948392+02	1	13	1405	2011-03-31 08:10:38.811036-1405	3	
910	2011-03-31 17:37:59.530841+02	1	13	1412	2011-03-31 10:36:49.162364-1412	3	
911	2011-04-01 11:11:18.672105+02	1	15	1	aps:Mazda: 25.0	1	
912	2011-04-01 14:52:23.935547+02	1	13	1446	2011-04-01 07:19:23.889710-1446	2	Изменен ponumber и invoice_code.
913	2011-04-01 14:56:16.063442+02	1	13	1448	2011-04-01 07:55:12.661232-1448	2	Изменен ponumber и invoice_code.
1001	2011-04-05 13:21:19.406396+02	1	3	102	kos	1	
914	2011-04-01 14:56:34.820566+02	1	13	1449	2011-04-01 07:55:12.679414-1449	2	Изменен ponumber и invoice_code.
915	2011-04-01 14:59:10.909788+02	1	13	1445	2011-04-01 07:19:23.859279-1445	2	Изменен ponumber и invoice_code.
916	2011-04-01 15:00:36.863234+02	1	13	1446	2011-04-01 07:19:23.889710-1446	2	Изменен ponumber.
917	2011-04-01 15:00:50.085139+02	1	13	1447	2011-04-01 07:19:23.898362-1447	2	Изменен ponumber и invoice_code.
918	2011-04-01 15:01:00.012051+02	1	13	1448	2011-04-01 07:55:12.661232-1448	2	Изменен ponumber.
919	2011-04-01 15:01:13.221596+02	1	13	1449	2011-04-01 07:55:12.679414-1449	2	Изменен ponumber.
920	2011-04-03 16:12:52.772454+02	1	13	1260	2011-03-30 07:48:04.078915-1260	2	Изменен quantity и weight.
921	2011-04-03 16:17:13.546007+02	1	13	1450	2011-04-03 09:16:07.800750-1450	2	Изменен ponumber, client_order_id и invoice_code.
922	2011-04-03 16:18:51.959655+02	1	13	1260	2011-03-30 07:48:04.078915-1260	2	Изменен price_sale и price_discount.
923	2011-04-04 17:59:52.287647+02	1	3	101	sl	1	
924	2011-04-04 18:00:09.39275+02	1	3	101	sl	2	Изменен first_name и groups.
925	2011-04-04 19:41:32.850793+02	1	11	19	Kia	2	Изменен brands.
926	2011-04-04 19:46:59.967931+02	1	15	1	aps:Mazda: 25.0	3	
927	2011-04-04 19:48:42.63331+02	1	13	1473	2011-04-04 12:42:25.225668-1473	2	Изменен price_discount и invoice_code.
928	2011-04-04 19:49:36.042536+02	1	13	1472	2011-04-04 12:42:25.220380-1472	2	Изменен invoice_code.
929	2011-04-04 19:50:26.16266+02	1	13	1471	2011-04-04 12:42:25.215204-1471	2	Изменен price_discount и invoice_code.
930	2011-04-04 19:50:37.217751+02	1	13	1470	2011-04-04 12:42:25.209957-1470	2	Изменен price_discount и invoice_code.
931	2011-04-04 19:50:46.36423+02	1	13	1469	2011-04-04 12:42:25.204969-1469	2	Изменен invoice_code.
932	2011-04-04 19:50:58.711744+02	1	13	1469	2011-04-04 12:42:25.204969-1469	2	Изменен price_discount.
933	2011-04-04 19:51:14.813189+02	1	13	1468	2011-04-04 12:42:25.200177-1468	2	Изменен price_discount и invoice_code.
934	2011-04-04 19:51:36.618602+02	1	13	1467	2011-04-04 12:42:25.195295-1467	2	Изменен price_discount и invoice_code.
935	2011-04-04 19:51:56.780243+02	1	13	1466	2011-04-04 12:42:25.190460-1466	2	Изменен price_discount и invoice_code.
936	2011-04-04 19:52:33.785794+02	1	13	1472	2011-04-04 12:42:25.220380-1472	2	Изменен price_discount и invoice_code.
937	2011-04-04 19:52:52.385976+02	1	13	1465	2011-04-04 12:42:25.185416-1465	2	Изменен price_discount и invoice_code.
938	2011-04-04 19:53:54.380406+02	1	13	1466	2011-04-04 12:42:25.190460-1466	2	Ни одно поле не изменено.
939	2011-04-04 19:54:42.12412+02	1	13	1458	2011-04-04 12:42:25.146715-1458	2	Изменен price_discount и invoice_code.
940	2011-04-04 19:55:13.392841+02	1	13	1450	2011-04-03 09:16:07.800750-1450	2	Изменен price_discount.
941	2011-04-04 19:56:18.992678+02	1	13	1466	2011-04-04 12:42:25.190460-1466	2	Ни одно поле не изменено.
942	2011-04-04 19:58:04.049145+02	1	13	1466	2011-04-04 12:42:25.190460-1466	2	Ни одно поле не изменено.
943	2011-04-04 21:23:43.5988+02	1	11	80	Rum	1	
944	2011-04-04 21:23:53.085548+02	1	10	2	MSK::DOCAP	2	Изменен area.
945	2011-04-04 21:24:37.555675+02	1	11	80	Rum	2	Изменен brands.
946	2011-04-04 21:28:48.668337+02	1	11	81	Германия 2	1	
947	2011-04-04 21:29:09.79037+02	1	10	2	MSK::DOCAP	2	Изменен area.
948	2011-04-04 21:29:32.65703+02	1	11	81	Германия 2	2	Изменен brands.
949	2011-04-04 22:02:29.095852+02	1	13	1474	2011-04-04 14:56:10.962196-1474	2	Изменен manager и invoice_code.
950	2011-04-04 22:14:38.886229+02	1	13	1478	2011-04-04 15:08:05.025920-1478	2	Изменен manager и invoice_code.
951	2011-04-04 22:16:00.739033+02	1	11	63	Kta	2	Изменен brands.
952	2011-04-04 22:16:42.920526+02	1	11	82	Japan5	1	
953	2011-04-04 22:16:46.692134+02	1	10	2	MSK::DOCAP	2	Изменен area.
954	2011-04-04 22:17:17.143344+02	1	11	82	Japan5	2	Изменен brands.
955	2011-04-04 22:17:41.414067+02	1	11	78	Tti	2	Изменен brands.
956	2011-04-04 22:18:27.536722+02	1	11	83	Mja5	1	
957	2011-04-04 22:18:46.577304+02	1	10	2	MSK::DOCAP	2	Изменен area.
958	2011-04-04 22:19:07.378716+02	1	11	83	Mja5	2	Изменен brands.
959	2011-04-04 22:19:43.633775+02	1	11	84	Склад 4	1	
960	2011-04-04 22:20:30.06622+02	1	10	2	MSK::DOCAP	2	Изменен area.
961	2011-04-04 22:20:57.040786+02	1	12	99	Bodyparts	1	
962	2011-04-04 22:21:00.995828+02	1	11	84	Склад 4	2	Изменен brands.
963	2011-04-04 22:21:50.848024+02	1	12	100	Termal	1	
964	2011-04-04 22:21:56.725821+02	1	11	85	Acs	1	
965	2011-04-04 22:22:02.925702+02	1	10	2	MSK::DOCAP	2	Изменен area.
966	2011-04-04 22:23:31.122787+02	1	11	83	Mja5	2	Изменен brands.
967	2011-04-04 22:24:19.849039+02	1	11	86	Jc	1	
968	2011-04-04 22:24:22.386468+02	1	10	2	MSK::DOCAP	2	Изменен area.
969	2011-04-04 22:25:00.082261+02	1	11	87	Usa1	1	
970	2011-04-04 22:25:02.732163+02	1	10	2	MSK::DOCAP	2	Изменен area.
971	2011-04-04 22:25:50.794167+02	1	12	101	Api	1	
972	2011-04-04 22:25:53.358172+02	1	11	67	Склад 34	2	Изменен brands.
973	2011-04-04 22:26:43.569504+02	1	11	88	Mmm1	1	
974	2011-04-04 22:26:48.354992+02	1	10	2	MSK::DOCAP	2	Изменен area.
975	2011-04-04 22:27:31.748107+02	1	11	89	Dmn	1	
976	2011-04-04 22:27:35.481612+02	1	10	2	MSK::DOCAP	2	Изменен area.
977	2011-04-04 22:27:54.997599+02	1	11	86	Jc	2	Изменен brands.
978	2011-04-04 23:08:15.164152+02	1	10	7	US::ONLINE	2	Изменен area.
979	2011-04-04 23:09:29.412625+02	1	12	102	drivetrain.com	1	
980	2011-04-04 23:09:33.123611+02	1	11	53	Other	2	Изменен brands.
981	2011-04-05 11:32:41.684561+02	1	11	79	Ex	2	Изменен brands.
982	2011-04-05 13:12:21.068691+02	1	12	103	Delta Autotechnik	1	
983	2011-04-05 13:12:31.950237+02	1	11	90	As	1	
984	2011-04-05 13:12:35.814377+02	1	10	2	MSK::DOCAP	2	Изменен area.
985	2011-04-05 13:13:28.850873+02	1	11	91	Asm	1	
986	2011-04-05 13:13:48.794118+02	1	10	2	MSK::DOCAP	2	Изменен area.
987	2011-04-05 13:14:12.850632+02	1	11	91	Asm	2	Изменен brands.
988	2011-04-05 13:14:39.558956+02	1	11	92	Piv	1	
989	2011-04-05 13:14:44.21909+02	1	10	2	MSK::DOCAP	2	Изменен area.
990	2011-04-05 13:14:57.957879+02	1	11	92	Piv	2	Изменен brands.
991	2011-04-05 13:15:57.792866+02	1	11	93	Склад 8	1	
992	2011-04-05 13:16:32.042644+02	1	12	104	Textar	1	
993	2011-04-05 13:16:36.147066+02	1	11	93	Склад 8	2	Изменен brands.
994	2011-04-05 13:16:45.338955+02	1	10	2	MSK::DOCAP	2	Изменен area.
995	2011-04-05 13:17:11.242518+02	1	11	94	Kot1	1	
996	2011-04-05 13:17:22.146613+02	1	11	94	Kot1	2	Изменен brands.
997	2011-04-05 13:18:06.184551+02	1	11	95	Склад 5	1	
998	2011-04-05 13:18:27.858082+02	1	12	105	Swag	1	
999	2011-04-05 13:18:31.019216+02	1	11	95	Склад 5	2	Изменен brands.
1000	2011-04-05 13:19:02.277479+02	1	11	4	Bmw	2	Изменен brands.
1002	2011-04-05 13:21:35.106249+02	1	3	102	kos	2	Изменен first_name и groups.
1003	2011-04-05 13:24:37.912446+02	1	12	106	Wagner	1	
1004	2011-04-05 13:24:40.43532+02	1	11	66	Pls	2	Изменен brands.
1005	2011-04-05 13:25:27.809187+02	1	10	2	MSK::DOCAP	2	Изменен area.
1006	2011-04-05 13:26:13.882948+02	1	12	103	Delta autotechnik	2	Изменен title.
1007	2011-04-05 13:26:47.167876+02	1	10	2	MSK::DOCAP	2	Изменен area.
1008	2011-04-05 13:48:36.451789+02	1	10	2	MSK::DOCAP	2	Ни одно поле не изменено.
1009	2011-04-05 14:32:26.997882+02	1	3	103	us	1	
1010	2011-04-05 14:32:46.473451+02	1	3	103	us	2	Изменен first_name и groups.
1011	2011-04-05 14:34:26.231876+02	1	3	104	v6635020	1	
1012	2011-04-05 14:34:50.136581+02	1	3	104	v6635020	2	Изменен first_name и groups.
1013	2011-04-05 17:30:50.664764+02	2	3	105	v5848448	1	
1014	2011-04-05 17:31:00.457852+02	2	3	105	v5848448	2	Изменен groups.
1015	2011-04-05 17:32:52.027213+02	2	3	106	v6844777	1	
1016	2011-04-05 17:33:01.338212+02	2	3	106	v6844777	2	Изменен groups.
1017	2011-04-05 18:48:36.981873+02	1	12	107	Aup	1	
1018	2011-04-06 12:21:34.340395+02	1	11	62	Rockauto	2	Изменен brands.
1019	2011-04-06 12:26:50.676415+02	1	11	79	Ex	2	Изменен brands.
1020	2011-04-06 12:27:29.973762+02	1	11	71	Эмираты f : nll	2	Изменен title.
1021	2011-04-06 18:36:11.419392+02	1	12	108	Akebono	1	
1022	2011-04-06 18:36:29.481706+02	1	11	95	Склад 5	2	Изменен brands.
1023	2011-04-06 18:37:12.525375+02	1	12	109	Dayco	1	
1024	2011-04-06 18:37:15.399513+02	1	11	92	Piv	2	Изменен brands.
1025	2011-04-06 18:44:33.488178+02	1	13	1514	2011-04-06 11:40:01.466122-1514	2	Изменен client и invoice_code.
1026	2011-04-06 18:45:05.43383+02	1	3	106	v6844777	3	
1027	2011-04-06 18:56:37.878729+02	1	12	102	Drivetrain.com	2	Изменен title.
1028	2011-04-06 19:20:13.543256+02	2	3	107	m7766950	1	
1029	2011-04-06 19:20:25.145557+02	2	3	107	m7766950	2	Изменен groups.
1030	2011-04-06 19:22:07.698831+02	1	12	110	Denso	1	
1031	2011-04-06 19:22:12.362763+02	1	11	62	Rockauto	2	Изменен brands.
1032	2011-04-07 14:17:00.511229+02	1	11	96	Эмираты 5	1	
1033	2011-04-07 14:17:11.828806+02	1	10	2	MSK::DOCAP	2	Изменен area.
1034	2011-04-07 14:19:12.321097+02	1	11	96	Эмираты 5	2	Изменен brands.
1035	2011-04-07 15:07:29.286744+02	1	3	108	v1727318	1	
1036	2011-04-07 15:08:06.662621+02	1	3	108	v1727318	2	Изменен first_name, last_name и groups.
1037	2011-04-07 16:19:28.638158+02	2	3	109	v3358598	1	
1038	2011-04-07 16:19:36.11608+02	2	3	109	v3358598	2	Изменен groups.
1039	2011-04-07 16:20:03.409494+02	2	3	110	v3417576	1	
1040	2011-04-07 16:20:08.536944+02	2	3	110	v3417576	2	Изменен groups.
1041	2011-04-07 17:30:16.847543+02	1	13	1557	2011-04-07 09:25:32.655575-1557	2	Изменен ponumber и invoice_code.
1042	2011-04-07 17:30:43.572659+02	1	13	1553	2011-04-07 09:25:32.632245-1553	2	Изменен ponumber и invoice_code.
1043	2011-04-07 17:31:30.486586+02	1	13	1557	2011-04-07 09:25:32.655575-1557	2	Изменен ponumber.
1044	2011-04-07 17:31:45.751708+02	1	13	1553	2011-04-07 09:25:32.632245-1553	2	Изменен ponumber.
1045	2011-04-07 17:56:31.954602+02	2	3	111	v6974360	1	
1046	2011-04-07 17:56:45.537542+02	2	3	111	v6974360	2	Изменен groups.
1047	2011-04-07 17:58:21.495258+02	1	12	111	Sherman	1	
1048	2011-04-07 17:58:24.290835+02	1	11	62	Rockauto	2	Изменен brands.
1049	2011-04-07 18:00:40.087654+02	1	12	111	Sherman	3	
1050	2011-04-07 18:01:06.711638+02	1	11	62	Rockauto	2	Ни одно поле не изменено.
1051	2011-04-08 09:24:08.111523+02	1	10	6	US::MOTO	2	Изменен area.
1052	2011-04-08 09:25:25.024615+02	1	12	112	Bombardier	1	
1053	2011-04-08 09:25:30.044429+02	1	11	51	Wop	2	Изменен brands.
1054	2011-04-08 13:41:35.167616+02	1	3	112	m7559944	1	
1055	2011-04-08 13:41:53.111495+02	1	3	112	m7559944	2	Изменен first_name и groups.
1056	2011-04-08 14:32:56.361998+02	2	3	113	v1563022	1	
1057	2011-04-08 14:33:05.426706+02	2	3	113	v1563022	2	Изменен groups.
1058	2011-04-08 17:44:12.258178+02	1	12	113	Febest	1	
1059	2011-04-08 17:44:19.221266+02	1	11	97	Asva2	1	
1060	2011-04-08 17:44:23.394848+02	1	10	2	MSK::DOCAP	2	Изменен area.
1061	2011-04-08 18:15:28.209763+02	2	3	114	v1449022	1	
1062	2011-04-08 18:15:35.698718+02	2	3	114	v1449022	2	Изменен groups.
1063	2011-04-08 18:17:22.194612+02	1	12	114	Stant	1	
1064	2011-04-08 18:17:24.541424+02	1	11	62	Rockauto	2	Изменен brands.
1065	2011-04-08 18:38:22.421417+02	1	13	1591	2011-04-08 11:17:34.492221-1591	2	Изменен ponumber и invoice_code.
1066	2011-04-08 18:38:49.703666+02	1	13	1593	2011-04-08 11:17:34.575315-1593	2	Изменен ponumber и invoice_code.
1067	2011-04-08 18:39:11.172313+02	1	13	1594	2011-04-08 11:17:34.584105-1594	2	Изменен ponumber и invoice_code.
1068	2011-04-09 12:40:20.298439+02	1	13	1404	2011-03-30 15:08:51.301108-1404	2	Изменен part_number и invoice_code.
1069	2011-04-09 14:08:34.22273+02	1	13	1263	2011-03-30 07:48:04.101730-1263	2	Изменен quantity.
1070	2011-04-09 14:08:55.727366+02	1	13	1258	2011-03-30 07:48:04.064188-1258	3	
1071	2011-04-09 16:11:07.038182+02	1	10	7	US::ONLINE	2	Изменен delivery.
1072	2011-04-09 16:32:48.056778+02	1	10	4	US::OEM	2	Изменен delivery.
1073	2011-04-09 16:33:32.073185+02	1	10	4	US::OEM	2	Ни одно поле не изменено.
1074	2011-04-09 16:35:20.387532+02	1	10	4	US::OEM	2	Изменен delivery.
1075	2011-04-09 17:40:56.257442+02	1	3	6	kp	2	Изменен password.
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_content_type (id, name, app_label, model) FROM stdin;
1	permission	auth	permission
2	group	auth	group
3	user	auth	user
4	message	auth	message
5	content type	contenttypes	contenttype
6	session	sessions	session
7	site	sites	site
8	log entry	admin	logentry
9	Направление	data	direction
10	Группа поставщиков	data	brandgroup
11	Поставщик	data	area
12	Бренд	data	brand
13	Заказанная позиция	data	ordereditem
15	Скидка	data	discount
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
6856c068d7e3011f3fda3cfa944d87bb	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-02-01 01:53:54.467228+01
67ed0c6e255f811a1dd386d8fdc4d6ae	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-01-26 23:02:26.400885+01
20aeb6fec994439dfac6fba36f8229a2	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-01-27 00:03:02.017161+01
11badd7c22ef16cdcdb8566080f2a001	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-01-27 01:26:13.56251+01
a29b77635b1f1305ddd0caf191abca15	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-01-27 22:03:54.029017+01
90ed58a9a70f884f84537d79f6f2fee0	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-01-27 22:46:26.564074+01
d42ed7d6d14c653019f19e195cfc9f96	gAJ9cQEuMDY1MzZkN2M1MDgyMzJlNDRhYTg3YmM3MTk2ZDI3NzE=\n	2011-02-02 20:00:26.150692+01
5ca59c1ffe871cfb28cf4c1d88b2c839	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-01-27 23:28:34.497392+01
e3083b07692a866b32b5421712d1bb19	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-01-28 00:09:34.92063+01
66ea307d97b7f4c64b25e095f32f0de6	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-01-28 01:09:48.468624+01
9787d091400afeac5b6dfd29d4704844	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-01-30 22:31:41.601832+01
e5c6d36ec3affc7a94a2341484415ba2	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-01-31 02:47:48.95705+01
81c54245b7b53a18ab872102c49f288d	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-01-31 21:44:20.826889+01
61f8c1a300e9db91a519e590009d5fe4	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-01-31 21:48:26.13688+01
e4224cb1cb750fe9b05484de4993543f	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-01 00:18:16.157846+01
bdbf8ca7c2a1cdef27e61c02a902f110	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-02-02 20:01:11.855204+01
05097a9047d709d5896669f23588985a	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9p\nZHEESwFVEl9hdXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZHEGdS5iNmM4MjNhYWU1ODZiNDkxMmU5ZTMwZTE0NTQ4YjM4OA==\n	2011-02-02 21:26:19.992566+01
df571da1f489ddad677acf9cba31f7f3	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-02 22:37:13.409063+01
6d3710ff5d8fa2d0b991499f35f9ac62	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-02 23:41:54.060125+01
863df9931957f0d63e91826e5840de5e	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-04 02:19:45.793193+01
a6f98269d73fb6da322d595e1fb12054	gAJ9cQFVCnRlc3Rjb29raWVxAlUGd29ya2VkcQNzLmNmMmJmZjljMGQ2ZjdiZDFlMDg2ZDc4YjVl\nMzFiMmU5\n	2011-02-04 02:55:01.66432+01
8ed9e988681eba970600eebd674a7405	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-02-07 00:05:10.07343+01
4ff66fcec41cb7743a8d2b18f1eb744c	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-07 00:05:38.773651+01
b8364fa8a7fabb179a8d87f5382c0c42	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-07 00:11:15.656127+01
13e520bae435f657c2946872edebeeb1	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-07 23:34:11.51968+01
e4dc1b26cbd7a241b6858e452c8e9b3d	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-16 14:59:27.324928+01
168b6eb80d80b27db04ec259c5f780d5	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-08 23:51:48.152893+01
dcc4c0f64408d9b7d6a74c788dbe7d9d	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1USX2F1dGhfdXNlcl9i\nYWNrZW5kcQRVKWRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQVVDV9h\ndXRoX3VzZXJfaWRxBksBdS45ZGZhNzcyYmQ2ZGQ5ZjhkYjFiZDU5MTQyNGVjNzFlNQ==\n	2011-02-15 14:23:55.989103+01
ed881f49d1d704ff68f792fad4751c0d	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-02-16 15:37:43.898806+01
d829dab3e28f8defd3c6d9c1665405f5	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-16 15:47:21.066824+01
69679a35fddd9c03cf47ea233210f1c9	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-16 16:21:36.488642+01
7a4cf5700b86a0d3debaef3cb0085609	gAJ9cQFVCnRlc3Rjb29raWVxAlUGd29ya2VkcQNzLmNmMmJmZjljMGQ2ZjdiZDFlMDg2ZDc4YjVl\nMzFiMmU5\n	2011-02-18 00:33:21.062147+01
3d41abdf90299c2bfdfa33f8975fd645	gAJ9cQFVCnRlc3Rjb29raWVxAlUGd29ya2VkcQNzLmNmMmJmZjljMGQ2ZjdiZDFlMDg2ZDc4YjVl\nMzFiMmU5\n	2011-03-28 13:35:38.999154+02
0c2f7393b8f933e5a24caa8f4fbf8c0e	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9p\nZHEESwFVEl9hdXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZHEGdS5iNmM4MjNhYWU1ODZiNDkxMmU5ZTMwZTE0NTQ4YjM4OA==\n	2011-02-16 22:33:25.317671+01
c547ba3e61c07d62d9682e48fdd3eb94	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-17 13:55:44.132495+01
9c9a4aef99b9b9ca60d8ff7c4704d925	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-17 00:40:11.261096+01
01a4ab571bdff961eb8b3634b7a0bb2c	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-02-17 01:01:27.600055+01
efaf830c7417f2d7893bd23a03a5747d	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9p\nZHEESwJVEl9hdXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZHEGdS5lM2NkNjA0ZDc1MmFhOTAxM2UyN2U2Yjg0Mzg3NWRlYw==\n	2011-02-17 17:42:11.603184+01
26348893913fbc79829d6e23ec2e8acd	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-17 18:14:42.312996+01
310b599925d120d033985b03056f03c4	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-17 18:14:59.243327+01
9b9ad36764b13c94ff65c1aa037cb496	gAJ9cQEoVQp0ZXN0Y29va2llcQJVBndvcmtlZHEDVRJfYXV0aF91c2VyX2JhY2tlbmRxBFUpZGph\nbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmRxBVUNX2F1dGhfdXNlcl9pZHEG\nSwF1LjQ2NmQxY2Q0OTJlNzQ1MGZlNzA2N2EwZGFhYzlmMzY0\n	2011-02-18 16:52:38.942759+01
0b6945625d8fbf75bfeaf3995ddced1f	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESw11LjRmOGE5NDJlMzEwYzhiZDRkMzdh\nZTcxZGEzYzZlYWMz\n	2011-02-21 13:30:11.738543+01
c82a1d3dc04b99e8188a67cfd8cdf845	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-02-17 20:47:43.306327+01
67cf512d6d9107ddbbc71e4ef196270b	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-17 21:20:14.072023+01
e797c34076ba67c15366b326249603b8	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-17 22:27:00.000311+01
0e9e0b37c3d16e04f53f63fa519cefec	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-17 22:38:33.461842+01
3b10a8723d4185119c781788ac2eb958	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-02-18 15:09:18.793398+01
db2b4a21d4e7e01b490b9986ef485b61	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-02-17 14:06:37.377099+01
dfef64bba9679074e0295bfa7a45d556	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-22 23:21:10.266796+01
aa45253f7f0bb8fa6eca73b35fed257f	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9p\nZHEESwFVEl9hdXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZHEGdS5iNmM4MjNhYWU1ODZiNDkxMmU5ZTMwZTE0NTQ4YjM4OA==\n	2011-02-18 16:17:22.655592+01
c2f51ca881f01f7a4ce028c903ac2aeb	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-17 13:42:28.170401+01
b22b1b4bfc7ea45564034b4d3ae923de	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-02-17 13:46:08.902915+01
4202b0760db5e9c9f7c03894808f8f32	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-02-22 22:02:49.388596+01
1219012bd99b50b89d14d5eda5de5e8f	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-02-22 22:17:28.176123+01
c6f1afaf8a9a9cc4b73d16ce53511a45	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-02-22 23:32:15.923476+01
5d5f3747e515e56282d4ebd5d53077a7	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-02-23 16:57:15.158824+01
a47ee5eeda4ed09506245d03cd1cc039	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-23 16:48:02.76054+01
ff2b299912fb46bd81bf6451cc232fc2	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-02-23 17:07:51.194311+01
25fc9fd9a9a93e01e316b61d682c1dec	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-17 16:38:44.918363+01
d06fc559d6fd5299635ad00c0ab0e958	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-17 17:03:34.965676+01
16114ef72d9a2a0d7471c902cd3fe808	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-02-23 20:15:53.749695+01
4119ac9d070d28e45b84358b23b93bb9	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-02-23 20:17:59.211247+01
2d07a7a8f19bd4b4779a5d7b6187b951	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-02-23 20:34:35.757012+01
d9cbbff444614183c193a6b233a17509	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-23 21:26:03.408273+01
190adf158b27aaf480863d956abd2f47	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-10 11:07:48.288748+01
d568a29b77ddd901bbc26517e2e5c282	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-11 15:46:56.981392+01
a220fc0db06eaef0b4241a152f727e84	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-14 16:55:33.799079+01
2d95749d87feb149c3b54a31a85e63f3	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UJcXNfZmlsdGVycQR9\ncQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0YXEIfXEJKFgVAAAAYXJlYV9fdGl0bGVfX2NvbnRh\naW5zcQpYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzI1cQtYAgAAADEzcQxYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMyNHENWAQAAAAxMy4wcQ5YGwAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzMyN3EPWAIAAAAxM3EQWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8z\nMjZxEVgCAAAAMTNxElgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzIxcRNYAgAAADEzcRRY\nGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMyMHEVWAIAAAAxM3EWWBsAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF8zMjNxF1gCAAAAMTNxGFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMzIycRlYAgAAADEzcRpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMyOXEbWAIAAAAxM3Ec\nWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMjhxHVgCAAAAMTNxHlgWAAAAYnJhbmRfX3Rp\ndGxlX19jb250YWluc3EfWAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMzOXEgWAQA\nAAAxMy4wcSFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMzMnEiWAIAAAAxM3EjWBsAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMzNxJFgCAAAAMTNxJVgbAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfMzMwcSZYAgAAADEzcSdYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMzMXEo\nWAIAAAAxM3EpWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMzZxKlgCAAAAMTNxK1gbAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzM3cSxYAgAAADEzcS1YGwAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzMzNHEuWAIAAAAxM3EvWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMzVx\nMFgCAAAAMTNxMVgJAAAAcXNfZmlsdGVycTJYAQAAADFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzM0OXEzWAQAAAAxMy4wcTRYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM0OHE1WAIA\nAAAxM3E2WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNDdxN1gCAAAAMTNxOFgbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfMzQ2cTlYAgAAADEzcTpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzM0NXE7WAIAAAAxM3E8WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNDRxPVgC\nAAAAMTNxPlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzQzcT9YAgAAADEzcUBYGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM0MnFBWAIAAAAxM3FCWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8zNDFxQ1gCAAAAMTNxRFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzQwcUVY\nBAAAADEzLjBxRlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzU4cUdYAgAAADEzcUhYIAAA\nAHBhcnRfbnVtYmVyX3N1cGVyc2VkZWRfX2NvbnRhaW5zcUlYAAAAAFgbAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMzU2cUpYAgAAADEzcUtYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM1\nN3FMWAIAAAAxM3FNWBYAAABpbnZvaWNlX2NvZGVfX2NvbnRhaW5zcU5YAAAAAFgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMjk5cU9YAgAAADEzcVBYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzI5OHFRWAQAAAAxMy4wcVJYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI5NXFTWAIA\nAAAxM3FUWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8yOTRxVVgCAAAAMTNxVlgbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfMjk3cVdYAgAAADEzcVhYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzI5NnFZWAIAAAAxM3FaWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8yOTFxW1gC\nAAAAMTNxXFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjkwcV1YAgAAADEzcV5YGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI5M3FfWAIAAAAxM3FgWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8yOTJxYVgCAAAAMTNxYlgYAAAAZGVzY3JpcHRpb25fZW5fX2NvbnRhaW5zcWNYAAAA\nAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjgycWRYAgAAADEzcWVYGwAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzI4M3FmWAIAAAAxM3FnWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8yODBxaFgCAAAAMTNxaVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjgxcWpYAgAAADEz\ncWtYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI4NnFsWAIAAAAxM3FtWBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8yODdxblgCAAAAMTNxb1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMjg0cXBYAgAAADEzcXFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI4NXFyWAIAAAAx\nM3FzWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8yODhxdFgCAAAAMTNxdVgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMjg5cXZYAgAAADEzcXdYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzI3OXF4WAIAAAAxM3F5WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8yNzhxelgCAAAA\nMTNxe1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjc3cXxYAgAAADEzcX1YGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzI3NnF+WAIAAAAxM3F/WBsAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8yNzVxgFgCAAAAMTNxgVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjc0cYJYAgAA\nADEzcYNYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI3M3GEWAIAAAAxM3GFWBsAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8yNzJxhlgCAAAAMTNxh1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfMjcxcYhYAgAAADEzcYlYFQAAAHBhcnRfbnVtYmVyX19jb250YWluc3GKWAAAAABYGgAA\nAGNsaWVudF9fdXNlcm5hbWVfX2NvbnRhaW5zcYtYAAAAAFgbAAAAbWFuYWdlcl9fdXNlcm5hbWVf\nX2NvbnRhaW5zcYxYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzM4cY1YAgAAADEz\ncY5YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMwM3GPWAIAAAAxM3GQWBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8zMDJxkVgCAAAAMTNxklgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMzAxcZNYAgAAADEzcZRYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMwMHGVWAIAAAAx\nM3GWWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMDdxl1gCAAAAMTNxmFgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMzA2cZlYAgAAADEzcZpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzMwNXGbWAIAAAAxM3GcWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMDRxnVgCAAAA\nMTNxnlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzA5cZ9YAgAAADEzcaBYGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzMwOHGhWAIAAAAxM3GiWBoAAABjb21tZW50X3N1cHBsaWVyX19j\nb250YWluc3GjWAAAAABYBgAAAHN0YXR1c3GkWA8AAAByZWNlaXZlZF9vZmZpY2VxpVgbAAAAYnJh\nbmRncm91cF9fdGl0bGVfX2NvbnRhaW5zcaZYAAAAAFgYAAAAZGVzY3JpcHRpb25fcnVfX2NvbnRh\naW5zcadYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzEwcahYAgAAADEzcalYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMxMXGqWAIAAAAxM3GrWBsAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF8zMTJxrFgCAAAAMTNxrVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzEz\nca5YAgAAADEzca9YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMxNHGwWAIAAAAxM3GxWBsA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMTVxslgCAAAAMTNxs1gbAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMzE2cbRYAgAAADEzcbVYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMx\nN3G2WAIAAAAxM3G3WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMThxuFgCAAAAMTNxuVgb\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzE5cbpYAgAAADEzcbt1dVUSX2F1dGhfdXNlcl9i\nYWNrZW5kcbxVKWRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcb1VDV9h\ndXRoX3VzZXJfaWRxvksCdS43Zjg0NTA4N2Q1ZmY1ZTgzMDI4NjJiMjFmMjZiODI3MA==\n	2011-02-23 16:54:58.954216+01
667f6ea9e2e93cada5932b58df999260	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-17 11:52:24.832119+01
b9b6cc37ea4016951e250957dfe63389	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-17 19:05:39.354799+01
de849c5c2d1ba4867f9db8ffe5256bf9	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UJcXNfZmlsdGVycQR9\ncQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0YXEIfXEJKFgVAAAAYXJlYV9fdGl0bGVfX2NvbnRh\naW5zcQpYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzI1cQtYAgAAADEzcQxYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMyNHENWAQAAAAxMy4wcQ5YGwAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzMyN3EPWAIAAAAxM3EQWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8z\nMjZxEVgCAAAAMTNxElgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzIxcRNYAgAAADEzcRRY\nGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMyMHEVWAIAAAAxM3EWWBsAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF8zMjNxF1gCAAAAMTNxGFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMzIycRlYAgAAADEzcRpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMyOXEbWAIAAAAxM3Ec\nWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMjhxHVgCAAAAMTNxHlgWAAAAYnJhbmRfX3Rp\ndGxlX19jb250YWluc3EfWAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMzOXEgWAQA\nAAAxMy4wcSFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMzMnEiWAIAAAAxM3EjWBsAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMzNxJFgCAAAAMTNxJVgbAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfMzMwcSZYAgAAADEzcSdYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMzMXEo\nWAIAAAAxM3EpWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMzZxKlgCAAAAMTNxK1gbAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzM3cSxYAgAAADEzcS1YGwAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzMzNHEuWAIAAAAxM3EvWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMzVx\nMFgCAAAAMTNxMVgJAAAAcXNfZmlsdGVycTJYAQAAADFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzM0OXEzWAQAAAAxMy4wcTRYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM0OHE1WAIA\nAAAxM3E2WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNDdxN1gCAAAAMTNxOFgbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfMzQ2cTlYAgAAADEzcTpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzM0NXE7WAIAAAAxM3E8WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNDRxPVgC\nAAAAMTNxPlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzQzcT9YAgAAADEzcUBYGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM0MnFBWAIAAAAxM3FCWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8zNDFxQ1gCAAAAMTNxRFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzQwcUVY\nBAAAADEzLjBxRlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzU4cUdYAgAAADEzcUhYIAAA\nAHBhcnRfbnVtYmVyX3N1cGVyc2VkZWRfX2NvbnRhaW5zcUlYAAAAAFgbAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMzU2cUpYAgAAADEzcUtYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM1\nN3FMWAIAAAAxM3FNWBYAAABpbnZvaWNlX2NvZGVfX2NvbnRhaW5zcU5YAAAAAFgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMjk5cU9YAgAAADEzcVBYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzI5OHFRWAQAAAAxMy4wcVJYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI5NXFTWAIA\nAAAxM3FUWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8yOTRxVVgCAAAAMTNxVlgbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfMjk3cVdYAgAAADEzcVhYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzI5NnFZWAIAAAAxM3FaWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8yOTFxW1gC\nAAAAMTNxXFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjkwcV1YAgAAADEzcV5YGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI5M3FfWAIAAAAxM3FgWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8yOTJxYVgCAAAAMTNxYlgYAAAAZGVzY3JpcHRpb25fZW5fX2NvbnRhaW5zcWNYAAAA\nAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjgycWRYAgAAADEzcWVYGwAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzI4M3FmWAIAAAAxM3FnWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8yODBxaFgCAAAAMTNxaVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjgxcWpYAgAAADEz\ncWtYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI4NnFsWAIAAAAxM3FtWBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8yODdxblgCAAAAMTNxb1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMjg0cXBYAgAAADEzcXFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI4NXFyWAIAAAAx\nM3FzWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8yODhxdFgCAAAAMTNxdVgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMjg5cXZYAgAAADEzcXdYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzI3OXF4WAIAAAAxM3F5WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8yNzhxelgCAAAA\nMTNxe1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjc3cXxYAgAAADEzcX1YGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzI3NnF+WAIAAAAxM3F/WBsAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8yNzVxgFgCAAAAMTNxgVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjc0cYJYAgAA\nADEzcYNYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI3M3GEWAIAAAAxM3GFWBsAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8yNzJxhlgCAAAAMTNxh1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfMjcxcYhYAgAAADEzcYlYFQAAAHBhcnRfbnVtYmVyX19jb250YWluc3GKWAAAAABYGgAA\nAGNsaWVudF9fdXNlcm5hbWVfX2NvbnRhaW5zcYtYAAAAAFgbAAAAbWFuYWdlcl9fdXNlcm5hbWVf\nX2NvbnRhaW5zcYxYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzM4cY1YAgAAADEz\ncY5YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMwM3GPWAIAAAAxM3GQWBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8zMDJxkVgCAAAAMTNxklgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMzAxcZNYAgAAADEzcZRYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMwMHGVWAIAAAAx\nM3GWWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMDdxl1gCAAAAMTNxmFgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMzA2cZlYAgAAADEzcZpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzMwNXGbWAIAAAAxM3GcWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMDRxnVgCAAAA\nMTNxnlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzA5cZ9YAgAAADEzcaBYGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzMwOHGhWAIAAAAxM3GiWBoAAABjb21tZW50X3N1cHBsaWVyX19j\nb250YWluc3GjWAAAAABYBgAAAHN0YXR1c3GkWA8AAAByZWNlaXZlZF9vZmZpY2VxpVgbAAAAYnJh\nbmRncm91cF9fdGl0bGVfX2NvbnRhaW5zcaZYAAAAAFgYAAAAZGVzY3JpcHRpb25fcnVfX2NvbnRh\naW5zcadYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzEwcahYAgAAADEzcalYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMxMXGqWAIAAAAxM3GrWBsAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF8zMTJxrFgCAAAAMTNxrVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzEz\nca5YAgAAADEzca9YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMxNHGwWAIAAAAxM3GxWBsA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMTVxslgCAAAAMTNxs1gbAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMzE2cbRYAgAAADEzcbVYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMx\nN3G2WAIAAAAxM3G3WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMThxuFgCAAAAMTNxuVgb\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzE5cbpYAgAAADEzcbt1dVUNX2F1dGhfdXNlcl9p\nZHG8SwJVEl9hdXRoX3VzZXJfYmFja2VuZHG9VSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZHG+dS5mNDE4ZjBiNzE4NDIxMTI3MzZkYjlmYWJmZmRjZjM3Yg==\n	2011-02-23 16:13:04.961149+01
e4ca9d296f0682ec6c736ca4600b1453	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-18 01:06:39.046428+01
d39a31e7c81ee5c9b053cf4e3de49354	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UJcXNfZmlsdGVycQR9\ncQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0YXEIfXEJKFgVAAAAYXJlYV9fdGl0bGVfX2NvbnRh\naW5zcQpYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzI1cQtYAgAAADEzcQxYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMyNHENWAQAAAAxMy4wcQ5YGwAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzMyN3EPWAIAAAAxM3EQWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8z\nMjZxEVgCAAAAMTNxElgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzIxcRNYAgAAADEzcRRY\nGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMyMHEVWAIAAAAxM3EWWBsAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF8zMjNxF1gCAAAAMTNxGFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMzIycRlYAgAAADEzcRpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMyOXEbWAIAAAAxM3Ec\nWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMjhxHVgCAAAAMTNxHlgWAAAAYnJhbmRfX3Rp\ndGxlX19jb250YWluc3EfWAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMzOXEgWAQA\nAAAxMy4wcSFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMzMnEiWAIAAAAxM3EjWBsAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMzNxJFgCAAAAMTNxJVgbAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfMzMwcSZYAgAAADEzcSdYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMzMXEo\nWAIAAAAxM3EpWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMzZxKlgCAAAAMTNxK1gbAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzM3cSxYAgAAADEzcS1YGwAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzMzNHEuWAIAAAAxM3EvWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMzVx\nMFgCAAAAMTNxMVgJAAAAcXNfZmlsdGVycTJYAQAAADFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzM0OXEzWAQAAAAxMy4wcTRYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM0OHE1WAIA\nAAAxM3E2WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNDdxN1gCAAAAMTNxOFgbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfMzQ2cTlYAgAAADEzcTpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzM0NXE7WAIAAAAxM3E8WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNDRxPVgC\nAAAAMTNxPlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzQzcT9YAgAAADEzcUBYGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM0MnFBWAIAAAAxM3FCWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8zNDFxQ1gCAAAAMTNxRFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzQwcUVY\nBAAAADEzLjBxRlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzU4cUdYAgAAADEzcUhYIAAA\nAHBhcnRfbnVtYmVyX3N1cGVyc2VkZWRfX2NvbnRhaW5zcUlYAAAAAFgbAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMzU2cUpYAgAAADEzcUtYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM1\nN3FMWAIAAAAxM3FNWBYAAABpbnZvaWNlX2NvZGVfX2NvbnRhaW5zcU5YAAAAAFgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMjk5cU9YAgAAADEzcVBYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzI5OHFRWAQAAAAxMy4wcVJYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI5NXFTWAIA\nAAAxM3FUWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8yOTRxVVgCAAAAMTNxVlgbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfMjk3cVdYAgAAADEzcVhYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzI5NnFZWAIAAAAxM3FaWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8yOTFxW1gC\nAAAAMTNxXFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjkwcV1YAgAAADEzcV5YGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI5M3FfWAIAAAAxM3FgWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8yOTJxYVgCAAAAMTNxYlgYAAAAZGVzY3JpcHRpb25fZW5fX2NvbnRhaW5zcWNYAAAA\nAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjgycWRYAgAAADEzcWVYGwAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzI4M3FmWAIAAAAxM3FnWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8yODBxaFgCAAAAMTNxaVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjgxcWpYAgAAADEz\ncWtYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI4NnFsWAIAAAAxM3FtWBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8yODdxblgCAAAAMTNxb1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMjg0cXBYAgAAADEzcXFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI4NXFyWAIAAAAx\nM3FzWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8yODhxdFgCAAAAMTNxdVgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMjg5cXZYAgAAADEzcXdYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzI3OXF4WAIAAAAxM3F5WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8yNzhxelgCAAAA\nMTNxe1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjc3cXxYAgAAADEzcX1YGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzI3NnF+WAIAAAAxM3F/WBsAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8yNzVxgFgCAAAAMTNxgVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjc0cYJYAgAA\nADEzcYNYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI3M3GEWAIAAAAxM3GFWBsAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8yNzJxhlgCAAAAMTNxh1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfMjcxcYhYAgAAADEzcYlYFQAAAHBhcnRfbnVtYmVyX19jb250YWluc3GKWAAAAABYGgAA\nAGNsaWVudF9fdXNlcm5hbWVfX2NvbnRhaW5zcYtYAAAAAFgbAAAAbWFuYWdlcl9fdXNlcm5hbWVf\nX2NvbnRhaW5zcYxYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzM4cY1YAgAAADEz\ncY5YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMwM3GPWAIAAAAxM3GQWBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8zMDJxkVgCAAAAMTNxklgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMzAxcZNYAgAAADEzcZRYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMwMHGVWAIAAAAx\nM3GWWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMDdxl1gCAAAAMTNxmFgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMzA2cZlYAgAAADEzcZpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzMwNXGbWAIAAAAxM3GcWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMDRxnVgCAAAA\nMTNxnlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzA5cZ9YAgAAADEzcaBYGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzMwOHGhWAIAAAAxM3GiWBoAAABjb21tZW50X3N1cHBsaWVyX19j\nb250YWluc3GjWAAAAABYBgAAAHN0YXR1c3GkWA8AAAByZWNlaXZlZF9vZmZpY2VxpVgbAAAAYnJh\nbmRncm91cF9fdGl0bGVfX2NvbnRhaW5zcaZYAAAAAFgYAAAAZGVzY3JpcHRpb25fcnVfX2NvbnRh\naW5zcadYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzEwcahYAgAAADEzcalYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMxMXGqWAIAAAAxM3GrWBsAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF8zMTJxrFgCAAAAMTNxrVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzEz\nca5YAgAAADEzca9YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMxNHGwWAIAAAAxM3GxWBsA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMTVxslgCAAAAMTNxs1gbAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMzE2cbRYAgAAADEzcbVYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMx\nN3G2WAIAAAAxM3G3WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMThxuFgCAAAAMTNxuVgb\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzE5cbpYAgAAADEzcbt1dVUNX2F1dGhfdXNlcl9p\nZHG8SwFVEl9hdXRoX3VzZXJfYmFja2VuZHG9VSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZHG+dS4zOTViMGEyZGNkNGRiMTU0NWMyZTBlY2FhMzcwZjdmMA==\n	2011-02-23 16:14:03.893408+01
b5eb354eb31d5e495e6c104f5b5f717f	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-18 21:37:38.521852+01
33a3672c25dc0ddb3c19a687c5bbb751	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-18 23:02:24.023839+01
0ef54dfec15f01799d7cb1cf26832836	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-21 10:17:44.074576+01
09daba90206770362291ecf5a921e78d	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UJcXNfZmlsdGVycQR9cQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0\nYXEIfXEJKFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDUzcQpYAgAAADEzcQtYGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1MnEMWAIAAAAxM3ENWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF80NTFxDlgCAAAAMTNxD1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDUwcRBY\nAgAAADEzcRFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1N3ESWAQAAAAxMy4wcRNYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1NnEUWAQAAAAxMy4wcRVYGwAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzQ1NXEWWAQAAAAxMy4wcRdYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzQ1NHEYWAQAAAAxMy4wcRlYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1OXEaWAQAAAAx\nMy4wcRtYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1OHEcWAQAAAAxMy4wcR1YFQAAAGFy\nZWFfX3RpdGxlX19jb250YWluc3EeWAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ0\nMHEfWAQAAAAxMy4wcSBYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ0MXEhWAQAAAAxMy4w\ncSJYFgAAAGJyYW5kX190aXRsZV9fY29udGFpbnNxI1gAAAAAWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF80NDNxJFgEAAAAMTMuMHElWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80NDRx\nJlgCAAAAMTNxJ1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDQ1cShYAgAAADEzcSlYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ0NnEqWAIAAAAxM3ErWBsAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF80NDdxLFgCAAAAMTNxLVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDQ4\ncS5YAgAAADEzcS9YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ0OXEwWAIAAAAxM3ExWAkA\nAABxc19maWx0ZXJxMlgBAAAAMVggAAAAcGFydF9udW1iZXJfc3VwZXJzZWRlZF9fY29udGFpbnNx\nM1gAAAAAWBYAAABpbnZvaWNlX2NvZGVfX2NvbnRhaW5zcTRYAAAAAFgbAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfNDYycTVYBAAAADEzLjBxNlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nNDYzcTdYBAAAADEzLjBxOFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDYwcTlYAgAAADEz\ncTpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ2MXE7WAIAAAAxM3E8WBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF80NjRxPVgEAAAAMTMuMHE+WBgAAABkZXNjcmlwdGlvbl9lbl9fY29u\ndGFpbnNxP1gAAAAAWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNjNxQFgCAAAAMTNxQVgb\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzY1cUJYAgAAADEzcUNYGwAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzM2NHFEWAIAAAAxM3FFWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8z\nNjdxRlgEAAAAMTMuMHFHWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNjlxSFgEAAAAMTMu\nMHFJWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNjhxSlgEAAAAMTMuMHFLWBsAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF80MTlxTFgCAAAAMTNxTVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfNDE4cU5YAgAAADEzcU9YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQxN3FQWAIA\nAAAxM3FRWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MTZxUlgCAAAAMTNxU1gbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfNDE1cVRYAgAAADEzcVVYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzQxNHFWWAIAAAAxM3FXWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MTNxWFgC\nAAAAMTNxWVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDEycVpYAgAAADEzcVtYGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQxMXFcWAIAAAAxM3FdWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF80MTBxXlgCAAAAMTNxX1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDI5cWBY\nAgAAADEzcWFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM3NnFiWAQAAAAxMy4wcWNYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM3N3FkWAIAAAAxM3FlWBsAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF8zNzRxZlgCAAAAMTNxZ1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzc1\ncWhYBAAAADEzLjBxaVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzcycWpYAgAAADEzcWtY\nGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM3M3FsWAIAAAAxM3FtWBsAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF8zNzBxblgCAAAAMTNxb1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMzcxcXBYAgAAADEzcXFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM3OHFyWAIAAAAxM3Fz\nWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNzlxdFgCAAAAMTNxdVgVAAAAcGFydF9udW1i\nZXJfX2NvbnRhaW5zcXZYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDA4cXdYAgAA\nADEzcXhYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQwOXF5WAIAAAAxM3F6WBsAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF80MDRxe1gCAAAAMTNxfFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfNDA1cX1YAgAAADEzcX5YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQwNnF/WAIA\nAAAxM3GAWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MDdxgVgCAAAAMTNxglgbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfNDAwcYNYAgAAADEzcYRYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzQwMXGFWAIAAAAxM3GGWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MDJxh1gC\nAAAAMTNxiFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDAzcYlYAgAAADEzcYpYGgAAAGNs\naWVudF9fdXNlcm5hbWVfX2NvbnRhaW5zcYtYAgAAAHZrcYxYGwAAAG1hbmFnZXJfX3VzZXJuYW1l\nX19jb250YWluc3GNWAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ0MnGOWAQAAAAx\nMy4wcY9YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQzMXGQWAIAAAAxM3GRWBsAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF80MzBxklgCAAAAMTNxk1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfNDMzcZRYBAAAADEzLjBxlVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDMycZZY\nAgAAADEzcZdYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQzNXGYWAQAAAAxMy4wcZlYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQzNHGaWAQAAAAxMy4wcZtYGwAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzQzN3GcWAQAAAAxMy4wcZ1YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzQzOXGeWAIAAAAxM3GfWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MzhxoFgCAAAAMTNx\noVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzg5caJYAgAAADEzcaNYGwAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzM4OHGkWAIAAAAxM3GlWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8zODNxplgCAAAAMTNxp1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzgycahYAgAAADEz\ncalYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM4MXGqWAIAAAAxM3GrWBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8zODBxrFgCAAAAMTNxrVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMzg3ca5YAgAAADEzca9YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM4NnGwWAIAAAAx\nM3GxWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zODVxslgCAAAAMTNxs1gbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMzg0cbRYAgAAADEzcbVYGgAAAGNvbW1lbnRfc3VwcGxpZXJfX2Nv\nbnRhaW5zcbZYAAAAAFgGAAAAc3RhdHVzcbdYAAAAAFgbAAAAYnJhbmRncm91cF9fdGl0bGVfX2Nv\nbnRhaW5zcbhYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDI2cblYAgAAADEzcbpY\nGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQyN3G7WAIAAAAxM3G8WBsAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF80MjRxvVgCAAAAMTNxvlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nNDI1cb9YAgAAADEzccBYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQyMnHBWAIAAAAxM3HC\nWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MjNxw1gCAAAAMTNxxFgbAAAAZGVsaXZlcnlf\nc3VwcGxpZXJfaW5wdXRfNDIwccVYAgAAADEzccZYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzQyMXHHWAIAAAAxM3HIWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MjhxyVgCAAAAMTNx\nylgYAAAAZGVzY3JpcHRpb25fcnVfX2NvbnRhaW5zcctYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfMzk4ccxYAgAAADEzcc1YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM5OXHO\nWAIAAAAxM3HPWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zOTBx0FgEAAAAMTMuMHHRWBsA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zOTFx0lgEAAAAMTMuMHHTWBsAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF8zOTJx1FgCAAAAMTNx1VgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMzkzcdZYAgAAADEzcddYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM5NHHYWAIAAAAxM3HZ\nWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zOTVx2lgEAAAAMTMuMHHbWBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8zOTZx3FgEAAAAMTMuMHHdWBsAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8zOTdx3lgCAAAAMTNx33V1VQ1fYXV0aF91c2VyX2lkceBLAlUXY3BfaW5kZXhfaXRlbXNf\ncGVyX3BhZ2Vx4VgDAAAAMTAwceJ1LmQwYTFlZDBlMjc2YzMwZjljNGQ2OTgzZjFlZTM4MjE4\n	2011-03-08 10:38:47.277044+01
7c83d44372b296ce5d8d39a9ffea8963	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-21 17:12:16.675955+01
80a5a53b29dfafd4d00c226ff5509c6c	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UJcXNfZmlsdGVycQR9cQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0\nYXEIfXEJKFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDUzcQpYAgAAADEzcQtYGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1MnEMWAIAAAAxM3ENWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF80NTFxDlgCAAAAMTNxD1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDUwcRBY\nAgAAADEzcRFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1N3ESWAQAAAAxMy4wcRNYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1NnEUWAQAAAAxMy4wcRVYGwAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzQ1NXEWWAQAAAAxMy4wcRdYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzQ1NHEYWAQAAAAxMy4wcRlYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1OXEaWAQAAAAx\nMy4wcRtYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1OHEcWAQAAAAxMy4wcR1YFQAAAGFy\nZWFfX3RpdGxlX19jb250YWluc3EeWAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ0\nMHEfWAQAAAAxMy4wcSBYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ0MXEhWAQAAAAxMy4w\ncSJYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ0MnEjWAQAAAAxMy4wcSRYGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzQ0M3ElWAQAAAAxMy4wcSZYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzQ0NHEnWAIAAAAxM3EoWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80NDVxKVgC\nAAAAMTNxKlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDQ2cStYAgAAADEzcSxYGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ0N3EtWAIAAAAxM3EuWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF80NDhxL1gCAAAAMTNxMFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDQ5cTFY\nAgAAADEzcTJYCQAAAHFzX2ZpbHRlcnEzWAEAAAAxWCAAAABwYXJ0X251bWJlcl9zdXBlcnNlZGVk\nX19jb250YWluc3E0WAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM1OXE1WAIAAAAx\nM3E2WBYAAABpbnZvaWNlX2NvZGVfX2NvbnRhaW5zcTdYAAAAAFgYAAAAZGVzY3JpcHRpb25fZW5f\nX2NvbnRhaW5zcThYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzYxcTlYAgAAADEz\ncTpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM2MHE7WAIAAAAxM3E8WBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8zNjNxPVgCAAAAMTNxPlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMzYycT9YAgAAADEzcUBYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM2NXFBWAIAAAAx\nM3FCWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNjRxQ1gCAAAAMTNxRFgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMzY3cUVYBAAAADEzLjBxRlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfMzY2cUdYAgAAADEzcUhYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM2OXFJWAQA\nAAAxMy4wcUpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM2OHFLWAQAAAAxMy4wcUxYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQxOXFNWAIAAAAxM3FOWBsAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF80MThxT1gCAAAAMTNxUFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDE3\ncVFYAgAAADEzcVJYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQxNnFTWAIAAAAxM3FUWBsA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MTVxVVgCAAAAMTNxVlgbAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfNDE0cVdYAgAAADEzcVhYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQx\nM3FZWAIAAAAxM3FaWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MTJxW1gCAAAAMTNxXFgb\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDExcV1YAgAAADEzcV5YGwAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzQxMHFfWAIAAAAxM3FgWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80\nMjlxYVgCAAAAMTNxYlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzc2cWNYBAAAADEzLjBx\nZFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzc3cWVYAgAAADEzcWZYGwAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzM3NHFnWAIAAAAxM3FoWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8zNzVxaVgEAAAAMTMuMHFqWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNzJxa1gCAAAA\nMTNxbFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzczcW1YAgAAADEzcW5YGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzM3MHFvWAIAAAAxM3FwWBsAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8zNzFxcVgCAAAAMTNxclgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzc4cXNYAgAA\nADEzcXRYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM3OXF1WAIAAAAxM3F2WBUAAABwYXJ0\nX251bWJlcl9fY29udGFpbnNxd1gAAAAAWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MDhx\neFgCAAAAMTNxeVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDA5cXpYAgAAADEzcXtYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQwNHF8WAIAAAAxM3F9WBsAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF80MDVxflgCAAAAMTNxf1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDA2\ncYBYAgAAADEzcYFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQwN3GCWAIAAAAxM3GDWBsA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MDBxhFgCAAAAMTNxhVgbAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfNDAxcYZYAgAAADEzcYdYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQw\nMnGIWAIAAAAxM3GJWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MDNxilgCAAAAMTNxi1ga\nAAAAY2xpZW50X191c2VybmFtZV9fY29udGFpbnNxjFgAAAAAWBsAAABtYW5hZ2VyX191c2VybmFt\nZV9fY29udGFpbnNxjVgAAAAAWBYAAABicmFuZF9fdGl0bGVfX2NvbnRhaW5zcY5YAAAAAFgbAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDMxcY9YAgAAADEzcZBYGwAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzQzMHGRWAIAAAAxM3GSWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MzNx\nk1gEAAAAMTMuMHGUWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MzJxlVgCAAAAMTNxllgb\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDM1cZdYBAAAADEzLjBxmFgbAAAAZGVsaXZlcnlf\nc3VwcGxpZXJfaW5wdXRfNDM0cZlYBAAAADEzLjBxmlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfNDM3cZtYBAAAADEzLjBxnFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDM5cZ1YAgAA\nADEzcZ5YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQzOHGfWAIAAAAxM3GgWBsAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8zODlxoVgCAAAAMTNxolgbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfMzg4caNYAgAAADEzcaRYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM4M3GlWAIA\nAAAxM3GmWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zODJxp1gCAAAAMTNxqFgbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfMzgxcalYAgAAADEzcapYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzM4MHGrWAIAAAAxM3GsWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zODdxrVgC\nAAAAMTNxrlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzg2ca9YAgAAADEzcbBYGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM4NXGxWAIAAAAxM3GyWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8zODRxs1gCAAAAMTNxtFgaAAAAY29tbWVudF9zdXBwbGllcl9fY29udGFpbnNxtVgA\nAAAAWAYAAABzdGF0dXNxtlgPAAAAcmVjZWl2ZWRfb2ZmaWNlcbdYGwAAAGJyYW5kZ3JvdXBfX3Rp\ndGxlX19jb250YWluc3G4WAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQyNnG5WAIA\nAAAxM3G6WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80Mjdxu1gCAAAAMTNxvFgbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfNDI0cb1YAgAAADEzcb5YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzQyNXG/WAIAAAAxM3HAWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MjJxwVgC\nAAAAMTNxwlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDIzccNYAgAAADEzccRYGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQyMHHFWAIAAAAxM3HGWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF80MjFxx1gCAAAAMTNxyFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDI4cclY\nAgAAADEzccpYGAAAAGRlc2NyaXB0aW9uX3J1X19jb250YWluc3HLWAAAAABYGwAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzM5OHHMWAIAAAAxM3HNWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8zOTlxzlgCAAAAMTNxz1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzkwcdBYBAAAADEz\nLjBx0VgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzkxcdJYBAAAADEzLjBx01gbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfMzkycdRYAgAAADEzcdVYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzM5M3HWWAIAAAAxM3HXWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zOTRx2FgC\nAAAAMTNx2VgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzk1cdpYBAAAADEzLjBx21gbAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzk2cdxYBAAAADEzLjBx3VgbAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMzk3cd5YAgAAADEzcd91dVUNX2F1dGhfdXNlcl9pZHHgSwFVF2NwX2luZGV4\nX2l0ZW1zX3Blcl9wYWdlceFYAwAAADEwMHHidS5iMGQ3N2U5ZTU4ZDkyNTQ4MzAwMWIwNzNiNzEx\nZWFiZQ==\n	2011-02-24 00:00:55.296491+01
f2d0be37e392faad2ce6f326b99b2957	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-21 18:13:36.83394+01
f233707fe06cd244fceebd6c891f0ee2	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9p\nZHEESwJVEl9hdXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZHEGdS5lM2NkNjA0ZDc1MmFhOTAxM2UyN2U2Yjg0Mzg3NWRlYw==\n	2011-03-21 18:21:28.686648+01
1f55b8f9d3d37763b7a8cc76412ceb52	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-21 19:16:36.784103+01
dd004db6b3cb2878dcaed7cb3789757e	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-21 20:09:22.039883+01
ad9d3787fd2983b1f4d5d7bd585e9743	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-22 15:00:13.022224+01
729cad4c2bf7526cb0e5497a9b2db295	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-24 09:47:18.337759+01
ea531d5c384430a192395ce1b96ceab9	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9p\nZHEESwJVEl9hdXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZHEGdS5lM2NkNjA0ZDc1MmFhOTAxM2UyN2U2Yjg0Mzg3NWRlYw==\n	2011-03-25 15:23:09.302996+01
02757657b3d2bddbabce656e15e473b9	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-03-24 12:07:03.821329+01
a58cb6b05b8f06818f807cf55f270fc5	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-25 22:00:31.769532+01
569e6e9ba91dbcd312dbd298e79fa47e	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-24 21:35:26.056493+01
09d3d7dcb8b5ad767c9cc70b67ded653	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-25 13:00:27.532258+01
f9f842305b3a5270b0c76b90f2247877	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9p\nZHEESwFVEl9hdXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZHEGdS5iNmM4MjNhYWU1ODZiNDkxMmU5ZTMwZTE0NTQ4YjM4OA==\n	2011-03-25 15:11:08.714747+01
44fcabf6df06287d7cce8abfa723a5e3	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-25 22:22:22.556871+01
2f2ec4e8038ad75a639a2e4a2c1a4849	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-25 23:01:03.763509+01
e63a3419786cfc95b02ec4a71b54013e	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-25 23:22:46.31474+01
e1b73413b32fa77d63d30189c26d33ea	gAJ9cQFVCnRlc3Rjb29raWVxAlUGd29ya2VkcQNzLmNmMmJmZjljMGQ2ZjdiZDFlMDg2ZDc4YjVl\nMzFiMmU5\n	2011-03-28 13:35:39.103697+02
667ab039e64c43221ed2e97d1f43ea12	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-28 20:26:18.071645+02
761ccf795c2a975b935047f1cc6b6276	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-28 21:09:27.396791+02
ec4b183abf3a92f1b1a98839bac2a47a	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-28 21:52:22.863091+02
a84885ed079e917e8e875e977e352b76	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-28 22:13:36.18156+02
aa76b2590440ff6cce3da583696125cf	gAJ9cQEoVQlxc19maWx0ZXJxAn1xAyhVBHBhdGhxBFgEAAAAL2NwL3EFVQRkYXRhcQZ9cQcoWBsA\nAABtYW5hZ2VyX191c2VybmFtZV9fY29udGFpbnNxCFgAAAAAWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF81NzhxCVgCAAAAMTNxClgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTc5cQtY\nAgAAADEzcQxYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU3NHENWAIAAAAxM3EOWBsAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81NzVxD1gCAAAAMTNxEFgbAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfNTc2cRFYAgAAADEzcRJYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU3N3ET\nWAIAAAAxM3EUWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81NzBxFVgEAAAAMTMuMHEWWBsA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81NzFxF1gEAAAAMTMuMHEYWBsAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF81NzJxGVgCAAAAMTNxGlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nNTczcRtYAgAAADEzcRxYCQAAAHFzX2ZpbHRlcnEdWAEAAAAxWBoAAABjb21tZW50X3N1cHBsaWVy\nX19jb250YWluc3EeWAAAAABYBgAAAHN0YXR1c3EfWAAAAABYFgAAAGJyYW5kX190aXRsZV9fY29u\ndGFpbnNxIFgAAAAAWCAAAABwYXJ0X251bWJlcl9zdXBlcnNlZGVkX19jb250YWluc3EhWAAAAABY\nGwAAAGJyYW5kZ3JvdXBfX3RpdGxlX19jb250YWluc3EiWAAAAABYFQAAAHBhcnRfbnVtYmVyX19j\nb250YWluc3EjWAwAAAAyMzA1MzQxODExNjVxJFgWAAAAaW52b2ljZV9jb2RlX19jb250YWluc3El\nWAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU2OXEmWAQAAAAxMy4wcSdYGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU2OHEoWAQAAAAxMy4wcSlYGwAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzU2N3EqWAQAAAAxMy4wcStYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU2\nNnEsWAQAAAAxMy4wcS1YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU2NXEuWAQAAAAxMy4w\ncS9YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU2NHEwWAQAAAAxMy4wcTFYGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzU2M3EyWAQAAAAxMy4wcTNYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzU2MnE0WAIAAAAxM3E1WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81NjFxNlgE\nAAAAMTMuMHE3WBgAAABkZXNjcmlwdGlvbl9ydV9fY29udGFpbnNxOFgAAAAAWBoAAABjbGllbnRf\nX3VzZXJuYW1lX19jb250YWluc3E5WAAAAABYGAAAAGRlc2NyaXB0aW9uX2VuX19jb250YWluc3E6\nWAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU4MHE7WAIAAAAxM3E8WBUAAABhcmVh\nX190aXRsZV9fY29udGFpbnNxPVgAAAAAdXVVDV9hdXRoX3VzZXJfaWRxPksBVRJfYXV0aF91c2Vy\nX2JhY2tlbmRxP1UpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmRxQHUu\nY2JiMjZhNmQ0MDNiYzMxMzYwZDMwZDJlZWMyNTFkN2I=\n	2011-03-08 17:41:57.077193+01
953388d4db036400e88136b615e7fa72	gAJ9cQEuMDY1MzZkN2M1MDgyMzJlNDRhYTg3YmM3MTk2ZDI3NzE=\n	2011-03-10 16:30:56.281031+01
fd057eb85492aff4ea07aa26636d846d	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-13 22:02:34.607172+01
48ea5bd07ec4098a0ffa3459847d786a	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-16 21:29:05.811742+01
8a868ac0c800ec2e487f707cb8fad1af	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-17 16:11:18.841512+01
99fa5038dd594274397fa315b5fa53f0	gAJ9cQEuMDY1MzZkN2M1MDgyMzJlNDRhYTg3YmM3MTk2ZDI3NzE=\n	2011-03-28 13:35:39.132389+02
b3d2b8254c5f1b1281fce9e13d0c566f	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-18 06:49:48.750985+01
43998320cfbb9bdc9d55cacdcccc7deb	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-19 13:00:14.610919+01
7fb916c762c3ac372826e675ad2e8a9d	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9p\nZHEESwFVEl9hdXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZHEGdS5iNmM4MjNhYWU1ODZiNDkxMmU5ZTMwZTE0NTQ4YjM4OA==\n	2011-03-21 17:08:50.963967+01
85f3539b128a3241e105b6a1a3e414f6	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-29 00:34:21.634554+02
08de68ab7bb0a533ef66f73706eea57d	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-03-28 19:04:00.221685+02
c48f66556e5b411b834e11c604b98a21	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-22 07:42:59.124206+01
8566d0d0248f7797ce2b8029b0c669b6	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-24 10:57:50.416391+01
9ff8b696fe745af8c52b458788ca5d66	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-24 19:29:41.182461+01
28b2527a857c3bd8b4c8242747a7e2fb	gAJ9cQFVCnRlc3Rjb29raWVxAlUGd29ya2VkcQNzLmNmMmJmZjljMGQ2ZjdiZDFlMDg2ZDc4YjVl\nMzFiMmU5\n	2011-03-24 21:30:24.34183+01
7fff5a9fb8eec11e777c55fdd0adade4	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-25 13:34:26.992507+01
768546eea4e1ae238c6ee26d13518c2c	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-28 20:05:52.453847+02
9e83d445796c82d22f7fad2fb992f1aa	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-29 00:51:41.508005+02
ac9805f89fa14671e0fac399ea041f82	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-28 08:31:09.671934+02
30b48c4a3750bd6fcfc1a65105169913	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAlUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmI0Mzc4OGQwOGUwOTZlNjU0MGNh\nZThjNGE2NzFjMTRj\n	2011-03-28 23:07:49.169399+02
d4c78c272ba2a5a29bdcd8ed7bfe5d47	gAJ9cQEoVQ5pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9pZHEESwNVEl9h\ndXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFj\na2VuZHEGdS4xYjA4OGQ2ZWZhNzdmNGZkOTFkZWU1NWI1NmMzMmMzNA==\n	2011-03-29 00:41:47.442982+02
9cd1a6dee40a0d14899eceb64e92382e	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-29 11:58:12.466734+02
ce895023e8c0e77d2f5480284260e75d	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UJcXNfZmlsdGVycQR9\ncQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0YXEIfXEJKFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfNTE4cQpYAgAAADEzcQtYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzUxOXEMWAIA\nAAAxM3ENWBUAAABhcmVhX190aXRsZV9fY29udGFpbnNxDlgAAAAAWBsAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF81MTJxD1gCAAAAMTNxEFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTEz\ncRFYBAAAADEzLjBxElgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTEwcRNYBAAAADEzLjBx\nFFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTExcRVYBAAAADEzLjBxFlgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfNTE2cRdYBAAAADEzLjBxGFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfNTE3cRlYBAAAADEzLjBxGlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTE0cRtY\nBAAAADEzLjBxHFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTE1cR1YAgAAADEzcR5YGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU2M3EfWAQAAAAxMy4wcSBYGwAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzUzOXEhWAIAAAAxM3EiWBYAAABicmFuZF9fdGl0bGVfX2NvbnRhaW5zcSNY\nAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTY5cSRYBAAAADEzLjBxJVgbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfNTY4cSZYBAAAADEzLjBxJ1gbAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfNTY3cShYBAAAADEzLjBxKVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTY2\ncSpYBAAAADEzLjBxK1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTY1cSxYBAAAADEzLjBx\nLVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTY0cS5YBAAAADEzLjBxL1gJAAAAcXNfZmls\ndGVycTBYAQAAADFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU2MnExWAIAAAAxM3EyWBsA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81NjFxM1gEAAAAMTMuMHE0WBsAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF81NjBxNVgEAAAAMTMuMHE2WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF80NzRxN1gEAAAAMTMuMHE4WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80NzdxOVgCAAAA\nMTNxOlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDczcTtYBAAAADEzLjBxPFgbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfNDc5cT1YAgAAADEzcT5YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzQ3OHE/WAIAAAAxM3FAWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81NzhxQVgC\nAAAAMTNxQlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTc5cUNYAgAAADEzcURYGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU3NHFFWAIAAAAxM3FGWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF81NzVxR1gCAAAAMTNxSFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTc2cUlY\nAgAAADEzcUpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU3N3FLWAIAAAAxM3FMWBsAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81NzBxTVgEAAAAMTMuMHFOWBsAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF81NzFxT1gEAAAAMTMuMHFQWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81\nNzJxUVgCAAAAMTNxUlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTczcVNYAgAAADEzcVRY\nIAAAAHBhcnRfbnVtYmVyX3N1cGVyc2VkZWRfX2NvbnRhaW5zcVVYAAAAAFgbAAAAZGVsaXZlcnlf\nc3VwcGxpZXJfaW5wdXRfNTQxcVZYAgAAADEzcVdYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzU0MHFYWAIAAAAxM3FZWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81NDNxWlgCAAAAMTNx\nW1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTQycVxYAgAAADEzcV1YGwAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzU0NXFeWAIAAAAxM3FfWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF81NDRxYFgCAAAAMTNxYVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTQ3cWJYAgAAADEz\ncWNYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU0NnFkWAIAAAAxM3FlWBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF81NDlxZlgCAAAAMTNxZ1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfNTQ4cWhYAgAAADEzcWlYFgAAAGludm9pY2VfY29kZV9fY29udGFpbnNxalgAAAAAWBsAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81NTZxa1gCAAAAMTNxbFgbAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfNTU3cW1YAgAAADEzcW5YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU1NHFv\nWAIAAAAxM3FwWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81NTVxcVgCAAAAMTNxclgbAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTUycXNYAgAAADEzcXRYGwAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzU1M3F1WAIAAAAxM3F2WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81NTBx\nd1gCAAAAMTNxeFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTUxcXlYAgAAADEzcXpYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU1OHF7WAQAAAAxMy4wcXxYGwAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzU1OXF9WAQAAAAxMy4wcX5YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzQ5N3F/WAIAAAAxM3GAWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80OTZxgVgCAAAAMTNx\nglgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDk1cYNYAgAAADEzcYRYGwAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzQ5NHGFWAIAAAAxM3GGWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF80OTNxh1gCAAAAMTNxiFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDkycYlYAgAAADEz\ncYpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ5MXGLWAIAAAAxM3GMWBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF80OTBxjVgCAAAAMTNxjlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfNDk4cY9YAgAAADEzcZBYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzUyM3GRWAIAAAAx\nM3GSWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81MjJxk1gCAAAAMTNxlFgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfNTIxcZVYAgAAADEzcZZYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzUyMHGXWAIAAAAxM3GYWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81MjZxmVgCAAAA\nMTNxmlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTI1cZtYAgAAADEzcZxYGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzUyNHGdWAIAAAAxM3GeWBUAAABwYXJ0X251bWJlcl9fY29udGFp\nbnNxn1gAAAAAWBoAAABjbGllbnRfX3VzZXJuYW1lX19jb250YWluc3GgWAAAAABYGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzQ4NHGhWAIAAAAxM3GiWBsAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF80ODVxo1gCAAAAMTNxpFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDg2caVYAgAA\nADEzcaZYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ4N3GnWAIAAAAxM3GoWBsAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF80ODBxqVgCAAAAMTNxqlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfNDgxcatYAgAAADEzcaxYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ4MnGtWAQA\nAAAxMy4wca5YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ4M3GvWAQAAAAxMy4wcbBYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ4OHGxWAIAAAAxM3GyWBsAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF80ODlxs1gCAAAAMTNxtFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTMx\ncbVYAgAAADEzcbZYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzUzMnG3WAIAAAAxM3G4WBsA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81MzNxuVgCAAAAMTNxulgbAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfNTM0cbtYAgAAADEzcbxYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzUz\nNXG9WAIAAAAxM3G+WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81MzZxv1gCAAAAMTNxwFgb\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTM3ccFYAgAAADEzccJYGwAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzUzOHHDWAIAAAAxM3HEWBsAAABtYW5hZ2VyX191c2VybmFtZV9fY29udGFp\nbnNxxVgAAAAAWBoAAABjb21tZW50X3N1cHBsaWVyX19jb250YWluc3HGWAAAAABYBgAAAHN0YXR1\nc3HHWAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzUwOXHIWAQAAAAxMy4wcclYGwAA\nAGJyYW5kZ3JvdXBfX3RpdGxlX19jb250YWluc3HKWAUAAABET0NBUHHLWBgAAABkZXNjcmlwdGlv\nbl9lbl9fY29udGFpbnNxzFgAAAAAWBgAAABkZXNjcmlwdGlvbl9ydV9fY29udGFpbnNxzVgAAAAA\nWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81ODhxzlgCAAAAMTNxz1gbAAAAZGVsaXZlcnlf\nc3VwcGxpZXJfaW5wdXRfNTg1cdBYAgAAADEzcdFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzU4NHHSWAIAAAAxM3HTWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81ODdx1FgCAAAAMTNx\n1VgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTg2cdZYAgAAADEzcddYGwAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzU4MXHYWAIAAAAxM3HZWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF81ODBx2lgCAAAAMTNx21gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTgzcdxYAgAAADEz\ncd1YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU4MnHeWAIAAAAxM3HfdXVVDV9hdXRoX3Vz\nZXJfaWRx4EsBVRJfYXV0aF91c2VyX2JhY2tlbmRx4VUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNr\nZW5kcy5Nb2RlbEJhY2tlbmRx4nUuMTNiYzE5YzQwNmY1MzdiMWUyZTdmYWZiNzQ3YTM5YTA=\n	2011-03-29 04:41:04.551196+02
9cbe51e8640e04ec712a9cdf881d95d3	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-29 12:04:34.039936+02
439a8ed071ef72b9eaa5c38a7c53a855	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-29 13:02:56.031563+02
d0059ce472516bef0c9f240104f00421	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-29 14:25:28.994457+02
452bc6f5916d9a860ec9d753b558b547	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-29 15:24:33.188452+02
3c3cd09d8dbd100e89240e0603c9e1ca	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-29 15:26:37.969811+02
44a6b469033b31905ae025ab46f2d9db	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-29 16:48:59.256399+02
e7e936960ae27e5a62ee74da93dc1c76	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UJcXNfZmlsdGVycQR9\ncQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0YXEIfXEJKFgbAAAAbWFuYWdlcl9fdXNlcm5hbWVf\nX2NvbnRhaW5zcQpYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDM1cQtYBAAAADEz\nLjBxDFgVAAAAYXJlYV9fdGl0bGVfX2NvbnRhaW5zcQ1YAAAAAFgWAAAAaW52b2ljZV9jb2RlX19j\nb250YWluc3EOWAMAAAAjOTRxD1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzgycRBYAgAA\nADEzcRFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM4MXESWAIAAAAxM3ETWBsAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8zODBxFFgCAAAAMTNxFVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfMzAzcRZYAgAAADEzcRdYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMwMnEYWAIA\nAAAxM3EZWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMDFxGlgCAAAAMTNxG1gbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfMzAwcRxYAgAAADEzcR1YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzMwN3EeWAIAAAAxM3EfWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zMDZxIFgC\nAAAAMTNxIVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzA1cSJYAgAAADEzcSNYGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMwNHEkWAIAAAAxM3ElWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8zMDlxJlgCAAAAMTNxJ1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzA4cShY\nAgAAADEzcSlYGgAAAGNvbW1lbnRfc3VwcGxpZXJfX2NvbnRhaW5zcSpYAAAAAFgGAAAAc3RhdHVz\ncStYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzc3cSxYAgAAADEzcS1YFgAAAGJy\nYW5kX190aXRsZV9fY29udGFpbnNxLlgAAAAAWCAAAABwYXJ0X251bWJlcl9zdXBlcnNlZGVkX19j\nb250YWluc3EvWAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM3OHEwWAIAAAAxM3Ex\nWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNzlxMlgCAAAAMTNxM1gbAAAAZGVsaXZlcnlf\nc3VwcGxpZXJfaW5wdXRfNDI2cTRYAgAAADEzcTVYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzQyN3E2WAIAAAAxM3E3WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MjRxOFgCAAAAMTNx\nOVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDI1cTpYAgAAADEzcTtYGwAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzQyMnE8WAIAAAAxM3E9WBsAAABicmFuZGdyb3VwX190aXRsZV9fY29u\ndGFpbnNxPlgAAAAAWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MjFxP1gCAAAAMTNxQFgJ\nAAAAcXNfZmlsdGVycUFYAQAAADFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQyOHFCWAIA\nAAAxM3FDWBgAAABkZXNjcmlwdGlvbl9ydV9fY29udGFpbnNxRFgAAAAAWBsAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF8yOTlxRVgCAAAAMTNxRlgVAAAAcGFydF9udW1iZXJfX2NvbnRhaW5zcUdY\nAAAAAFgaAAAAY2xpZW50X191c2VybmFtZV9fY29udGFpbnNxSFgAAAAAWBsAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF8zMTBxSVgCAAAAMTNxSlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMzExcUtYAgAAADEzcUxYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzMxMnFNWAIAAAAxM3FO\nWBgAAABkZXNjcmlwdGlvbl9lbl9fY29udGFpbnNxT1gAAAAAWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF80MjNxUFgCAAAAMTNxUXV1VQ1fYXV0aF91c2VyX2lkcVJLAVUSX2F1dGhfdXNlcl9i\nYWNrZW5kcVNVKWRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcVR1LjQ4\nMzZlNmJlM2QyOTYwYmQxY2IyNTBjM2M3YjRiYzVj\n	2011-02-24 22:07:06.708942+01
9d00f7e6da5cf1ad4819a41de4d1c506	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-10 18:51:31.793+01
99f016511926993691c5ad22e87c9b58	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-02-27 15:29:44.201365+01
482fb57ed844a860c6d4f4b1d12ee48c	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-02-24 23:23:09.704475+01
6c225b38d108f400cbb5003248dbb936	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-02-27 21:16:07.103693+01
6957ba0a5e0c9265fb2c69fa2d2b2051	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UJcXNfZmlsdGVycQR9\ncQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0YXEIfXEJKFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfNDUzcQpYAgAAADEzcQtYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1MnEMWAIA\nAAAxM3ENWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80NTFxDlgCAAAAMTNxD1gbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfNDUwcRBYAgAAADEzcRFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzQ1N3ESWAQAAAAxMy4wcRNYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1NnEU\nWAQAAAAxMy4wcRVYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1NXEWWAQAAAAxMy4wcRdY\nGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1NHEYWAQAAAAxMy4wcRlYGwAAAG1hbmFnZXJf\nX3VzZXJuYW1lX19jb250YWluc3EaWAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1\nOXEbWAQAAAAxMy4wcRxYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1OHEdWAQAAAAxMy4w\ncR5YFgAAAGJyYW5kX190aXRsZV9fY29udGFpbnNxH1gAAAAAWBUAAABhcmVhX190aXRsZV9fY29u\ndGFpbnNxIFgAAAAAWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80NDVxIVgCAAAAMTNxIlga\nAAAAY29tbWVudF9zdXBwbGllcl9fY29udGFpbnNxI1gAAAAAWAYAAABzdGF0dXNxJFgAAAAAWBsA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80NDJxJVgEAAAAMTMuMHEmWBsAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF80NDNxJ1gEAAAAMTMuMHEoWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF80NDRxKVgCAAAAMTNxKlggAAAAcGFydF9udW1iZXJfc3VwZXJzZWRlZF9fY29udGFpbnNxK1gA\nAAAAWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80NDZxLFgCAAAAMTNxLVgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfNDQ3cS5YAgAAADEzcS9YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzQ0OHEwWAIAAAAxM3ExWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80NDlxMlgCAAAA\nMTNxM1gbAAAAYnJhbmRncm91cF9fdGl0bGVfX2NvbnRhaW5zcTRYAAAAAFgVAAAAcGFydF9udW1i\nZXJfX2NvbnRhaW5zcTVYAAAAAFgWAAAAaW52b2ljZV9jb2RlX19jb250YWluc3E2WAMAAAAjOTRx\nN1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDYwcThYAgAAADEzcTlYGwAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzQ2MXE6WAIAAAAxM3E7WAkAAABxc19maWx0ZXJxPFgBAAAAMVgYAAAA\nZGVzY3JpcHRpb25fcnVfX2NvbnRhaW5zcT1YAAAAAFgaAAAAY2xpZW50X191c2VybmFtZV9fY29u\ndGFpbnNxPlgAAAAAWBgAAABkZXNjcmlwdGlvbl9lbl9fY29udGFpbnNxP1gAAAAAdXVVEl9hdXRo\nX3VzZXJfYmFja2VuZHFAVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2Vu\nZHFBVQ1fYXV0aF91c2VyX2lkcUJLAXUuYmZlN2IxNzgzMWNmZThkNGU5MzVhNjY3N2EzMWFiZjQ=\n	2011-02-25 12:05:24.216779+01
bc57dfa64b811165c5ea9efa391a4fa7	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-02-24 23:38:43.222006+01
773d50f2e630224f0fc6750eae58d866	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-02-25 07:24:57.284111+01
32386313f19d628363bc9e919c5142d6	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-02-25 08:45:51.496363+01
c2bce9d93cf200031c57b0ae3e29daf2	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-02-25 12:23:29.595454+01
cf29b02dc7a5304c161138ec2f954844	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-01 09:51:41.2954+01
a3b0458a705888ad891506ec2e8fa226	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-01 10:37:41.919579+01
c36490eb79322aafd0ec62d1cd1806e9	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UJcXNfZmlsdGVycQR9\ncQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0YXEIfXEJKFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfNDUzcQpYAgAAADEzcQtYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1MnEMWAIA\nAAAxM3ENWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80NTFxDlgCAAAAMTNxD1gbAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfNDUwcRBYAgAAADEzcRFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzQ1N3ESWAQAAAAxMy4wcRNYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1NnEU\nWAQAAAAxMy4wcRVYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1NXEWWAQAAAAxMy4wcRdY\nGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1NHEYWAQAAAAxMy4wcRlYGwAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzQ1OXEaWAQAAAAxMy4wcRtYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzQ1OHEcWAQAAAAxMy4wcR1YFQAAAGFyZWFfX3RpdGxlX19jb250YWluc3EeWAAAAABYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ0MHEfWAQAAAAxMy4wcSBYGwAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzQ0MXEhWAQAAAAxMy4wcSJYFgAAAGJyYW5kX190aXRsZV9fY29udGFpbnNx\nI1gAAAAAWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80NDNxJFgEAAAAMTMuMHElWBsAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80NDRxJlgCAAAAMTNxJ1gbAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfNDQ1cShYAgAAADEzcSlYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ0NnEq\nWAIAAAAxM3ErWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80NDdxLFgCAAAAMTNxLVgbAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDQ4cS5YAgAAADEzcS9YGwAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzQ0OXEwWAIAAAAxM3ExWAkAAABxc19maWx0ZXJxMlgBAAAAMVggAAAAcGFydF9u\ndW1iZXJfc3VwZXJzZWRlZF9fY29udGFpbnNxM1gAAAAAWBYAAABpbnZvaWNlX2NvZGVfX2NvbnRh\naW5zcTRYAwAAACM5NHE1WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80NjBxNlgCAAAAMTNx\nN1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDYxcThYAgAAADEzcTlYGAAAAGRlc2NyaXB0\naW9uX2VuX19jb250YWluc3E6WAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM2MXE7\nWAIAAAAxM3E8WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNjBxPVgCAAAAMTNxPlgbAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzYzcT9YAgAAADEzcUBYGwAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzM2MnFBWAIAAAAxM3FCWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNjVx\nQ1gCAAAAMTNxRFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzY0cUVYAgAAADEzcUZYGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM2N3FHWAQAAAAxMy4wcUhYGwAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzM2OXFJWAQAAAAxMy4wcUpYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzM2OHFLWAQAAAAxMy4wcUxYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQxOXFNWAIAAAAx\nM3FOWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MThxT1gCAAAAMTNxUFgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfNDE3cVFYAgAAADEzcVJYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzQxNnFTWAIAAAAxM3FUWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MTVxVVgCAAAA\nMTNxVlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDE0cVdYAgAAADEzcVhYGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzQxM3FZWAIAAAAxM3FaWBsAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF80MTJxW1gCAAAAMTNxXFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDExcV1YAgAA\nADEzcV5YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQxMHFfWAIAAAAxM3FgWBsAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF80MjlxYVgCAAAAMTNxYlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfMzc2cWNYBAAAADEzLjBxZFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzc3cWVY\nAgAAADEzcWZYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM3NHFnWAIAAAAxM3FoWBsAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNzVxaVgEAAAAMTMuMHFqWBsAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF8zNzJxa1gCAAAAMTNxbFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzcz\ncW1YAgAAADEzcW5YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM3MHFvWAIAAAAxM3FwWBsA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zNzFxcVgCAAAAMTNxclgbAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMzc4cXNYAgAAADEzcXRYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM3\nOXF1WAIAAAAxM3F2WBUAAABwYXJ0X251bWJlcl9fY29udGFpbnNxd1gAAAAAWBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF80MDhxeFgCAAAAMTNxeVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfNDA5cXpYAgAAADEzcXtYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQwNHF8WAIAAAAx\nM3F9WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MDVxflgCAAAAMTNxf1gbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfNDA2cYBYAgAAADEzcYFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzQwN3GCWAIAAAAxM3GDWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MDBxhFgCAAAA\nMTNxhVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDAxcYZYAgAAADEzcYdYGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzQwMnGIWAIAAAAxM3GJWBsAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF80MDNxilgCAAAAMTNxi1gaAAAAY2xpZW50X191c2VybmFtZV9fY29udGFpbnNxjFgAAAAA\nWBsAAABtYW5hZ2VyX191c2VybmFtZV9fY29udGFpbnNxjVgAAAAAWBsAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF80NDJxjlgEAAAAMTMuMHGPWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80\nMzFxkFgCAAAAMTNxkVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDMwcZJYAgAAADEzcZNY\nGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQzM3GUWAQAAAAxMy4wcZVYGwAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzQzMnGWWAIAAAAxM3GXWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF80MzVxmFgEAAAAMTMuMHGZWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MzRxmlgEAAAA\nMTMuMHGbWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MzdxnFgEAAAAMTMuMHGdWBsAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MzlxnlgCAAAAMTNxn1gbAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfNDM4caBYAgAAADEzcaFYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM4OXGi\nWAIAAAAxM3GjWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zODhxpFgCAAAAMTNxpVgbAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzgzcaZYAgAAADEzcadYGwAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzM4MnGoWAIAAAAxM3GpWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zODFx\nqlgCAAAAMTNxq1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzgwcaxYAgAAADEzca1YGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM4N3GuWAIAAAAxM3GvWBsAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF8zODZxsFgCAAAAMTNxsVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzg1\ncbJYAgAAADEzcbNYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM4NHG0WAIAAAAxM3G1WBoA\nAABjb21tZW50X3N1cHBsaWVyX19jb250YWluc3G2WAAAAABYBgAAAHN0YXR1c3G3WAAAAABYGwAA\nAGJyYW5kZ3JvdXBfX3RpdGxlX19jb250YWluc3G4WAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzQyNnG5WAIAAAAxM3G6WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80Mjdxu1gC\nAAAAMTNxvFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDI0cb1YAgAAADEzcb5YGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQyNXG/WAIAAAAxM3HAWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF80MjJxwVgCAAAAMTNxwlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDIzccNY\nAgAAADEzccRYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQyMHHFWAIAAAAxM3HGWBsAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MjFxx1gCAAAAMTNxyFgbAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfNDI4cclYAgAAADEzccpYGAAAAGRlc2NyaXB0aW9uX3J1X19jb250YWluc3HLWAAA\nAABYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM5OHHMWAIAAAAxM3HNWBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8zOTlxzlgCAAAAMTNxz1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMzkwcdBYBAAAADEzLjBx0VgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzkxcdJYBAAA\nADEzLjBx01gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzkycdRYAgAAADEzcdVYGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM5M3HWWAIAAAAxM3HXWBsAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8zOTRx2FgCAAAAMTNx2VgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzk1cdpY\nBAAAADEzLjBx21gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzk2cdxYBAAAADEzLjBx3Vgb\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzk3cd5YAgAAADEzcd91dVUNX2F1dGhfdXNlcl9p\nZHHgSwFVEl9hdXRoX3VzZXJfYmFja2VuZHHhVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZHHidS41NmNjYzM5ZjFlMzBjMzk4ZDA2ZWYzZjU0NzE4ZjBkMA==\n	2011-02-25 17:38:47.767569+01
431bb7910c49936f8453d10256912e24	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-03 19:13:03.932018+01
2caed3d8d84e5396b507b5471c910c20	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-01 11:32:29.489734+01
dd00b62398e02f5ca4b42795eafd996b	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-01 13:33:23.985825+01
a2f87ec08a9e535f7ac35c4f6502d36f	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-03-03 15:02:21.520616+01
826f756ebb157b3b638e1a2b83987a53	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-08 14:30:10.72287+01
88524b60dd36914b5cb8d39c354caeb2	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-03 23:06:05.846816+01
f1cf9030f83a3498880d5f1613903a9b	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-08 14:45:56.448923+01
0235314184644ce9fea8e9d895543101	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-08 15:42:22.039806+01
50cda4fe10eab312419736a27d0baf09	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9p\nZHEESwFVEl9hdXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZHEGdS5iNmM4MjNhYWU1ODZiNDkxMmU5ZTMwZTE0NTQ4YjM4OA==\n	2011-03-08 15:52:02.577226+01
880a2aa466d8289737bae530c67f7fb4	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwFVF2NwX2luZGV4X2l0ZW1zX3Blcl9w\nYWdlcQVYAwAAADEwMHEGdS4yZjg1ZDBhZjc5OTBlYjFhNjI5OWQ5MzE3MzM3YjAxOQ==\n	2011-03-08 17:30:39.16304+01
b576e2637a82d273c2a15b09e11e7af0	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-04-04 17:40:30.558378+02
657a21335524c077084ea3163fc76d92	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-29 12:24:59.155516+02
665e1cc04c59dae85525ecb9d49040cd	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-30 16:52:42.656239+02
0a91b598b9f4bb66d55561ff00973b40	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-31 15:54:25.286111+02
1758fabcffeb4c30a5d7dad05b0a4e1f	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-03-29 14:23:26.269189+02
5a9c2bd169008e71b9da3cd501ddb0a3	gAJ9cQEuMDY1MzZkN2M1MDgyMzJlNDRhYTg3YmM3MTk2ZDI3NzE=\n	2011-03-31 16:25:01.563291+02
b59b88021ca2e8c99f68155bb6a25a42	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-31 16:25:43.590463+02
38c11e499c561c6728bdd1dfb849d2a0	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-30 17:51:03.826805+02
7b0606c891a1bc7ad4c14bd12044b3e2	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-04-01 11:13:43.353862+02
52378be55c9805f9c41836aa1d87efad	gAJ9cQEoVQ5pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9pZHEESwRVEl9h\ndXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFj\na2VuZHEGdS40MWUzNDlkYTYwNTQ4MjZmMGVkMWZkYzk3M2FmMDVjNw==\n	2011-03-30 19:26:17.637461+02
733c65ca2814dc7d2709bd7705be3e35	gAJ9cQFVCnRlc3Rjb29raWVxAlUGd29ya2VkcQNzLmNmMmJmZjljMGQ2ZjdiZDFlMDg2ZDc4YjVl\nMzFiMmU5\n	2011-03-30 19:27:39.698777+02
ba49b3724c997a83240346269265d1fc	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-30 20:21:30.372444+02
eac3d58a9ba06ce8e0c8a137e5e92fbc	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-30 22:00:43.306915+02
e3899f236d03ca28bb8d3752eb8007fd	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-31 18:00:51.505994+02
4473f74648564053dacac35e5e8c6159	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-05 18:19:19.050478+02
244481a2fc0e1c61731f2750ccfa8ba5	gAJ9cQEoVQ5pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9pZHEESwRVEl9h\ndXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFj\na2VuZHEGdS40MWUzNDlkYTYwNTQ4MjZmMGVkMWZkYzk3M2FmMDVjNw==\n	2011-03-31 09:40:22.374541+02
a78f61d569c75771ee79fdfa09fe3a6c	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwR1LjExNzRlZTBkMjQ0NzFmNDI3MzMy\nMDAwOTIzZGUyZjU0\n	2011-03-31 12:02:40.160373+02
2d420b8e5c03bb5d73f0d47749777b78	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-31 18:33:25.054686+02
f08df7e6234c1a993ad5b8d3794c1d4a	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-31 18:35:16.04535+02
efbdc63c9fcc54a90d490fae71d5386c	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-31 22:25:21.313631+02
2827142a75bdf2d8a4f115ffa0ef601c	gAJ9cQEuMDY1MzZkN2M1MDgyMzJlNDRhYTg3YmM3MTk2ZDI3NzE=\n	2011-04-01 11:16:05.735197+02
f023d1d6d9330c3355b9f4103eddd180	gAJ9cQEoVQp0ZXN0Y29va2llcQJVBndvcmtlZHEDVRJfYXV0aF91c2VyX2JhY2tlbmRxBFUpZGph\nbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmRxBVUNX2F1dGhfdXNlcl9pZHEG\nSwJ1LjdkNzQ4Y2IwNzU0MWJkYmUwYWU1N2M2MzQ3YzhlYmZl\n	2011-04-01 11:34:12.257402+02
069c9c8c567a91e7ebeba90591dfa5cf	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-01 12:08:05.421005+02
02b9e4847672bb1ab095ae87bf90a432	gAJ9cQEuMDY1MzZkN2M1MDgyMzJlNDRhYTg3YmM3MTk2ZDI3NzE=\n	2011-04-06 13:18:48.21791+02
e01a291ee26c667ec709642df1504f55	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-08 10:11:03.368179+02
21aebcc57251a8e3a0c66e6ee5bfdfc4	gAJ9cQFVCnRlc3Rjb29raWVxAlUGd29ya2VkcQNzLmNmMmJmZjljMGQ2ZjdiZDFlMDg2ZDc4YjVl\nMzFiMmU5\n	2011-04-01 21:11:18.013658+02
51c75c86f0da2b1d3b14c07a777ce1b7	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-08 21:47:17.419953+02
b89d710ab8af182bae33a512efcfa36d	gAJ9cQEoVQlxc19maWx0ZXJxAn1xAyhVBHBhdGhxBFgEAAAAL2NwL3EFVQRkYXRhcQZ9cQcoWAYA\nAABzdGF0dXNxCFgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMTczcQlYAgAAADEz\ncQpYFgAAAGJyYW5kX190aXRsZV9fY29udGFpbnNxC1gAAAAAWCAAAABwYXJ0X251bWJlcl9zdXBl\ncnNlZGVkX19jb250YWluc3EMWAAAAABYGgAAAGNsaWVudF9fdXNlcm5hbWVfX2NvbnRhaW5zcQ1Y\nAAAAAFgbAAAAbWFuYWdlcl9fdXNlcm5hbWVfX2NvbnRhaW5zcQ5YAAAAAFgbAAAAYnJhbmRncm91\ncF9fdGl0bGVfX2NvbnRhaW5zcQ9YAAAAAFgVAAAAcGFydF9udW1iZXJfX2NvbnRhaW5zcRBYCQAA\nADQ3ODE2MzlBQnERWBYAAABpbnZvaWNlX2NvZGVfX2NvbnRhaW5zcRJYAwAAADEwM3ETWBUAAABh\ncmVhX190aXRsZV9fY29udGFpbnNxFFgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8x\nMjI3cRVYBAAAADEzLjBxFlgYAAAAZGVzY3JpcHRpb25fZW5fX2NvbnRhaW5zcRdYAAAAAFgJAAAA\ncXNfZmlsdGVycRhYAQAAADFYGgAAAGNvbW1lbnRfc3VwcGxpZXJfX2NvbnRhaW5zcRlYAAAAAFgY\nAAAAZGVzY3JpcHRpb25fcnVfX2NvbnRhaW5zcRpYAAAAAHV1VRJfYXV0aF91c2VyX2JhY2tlbmRx\nG1UpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmRxHFUNX2F1dGhfdXNl\ncl9pZHEdSwF1Ljg3YmVjZjk5MTNjMWVmZWRmOTBiOGQ1MWI1ODEwNmQ5\n	2011-04-04 12:27:50.277394+02
17921b7b57c90502194ad7a98d6ba903	gAJ9cQEoVQ5pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9pZHEESwRVEl9h\ndXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFj\na2VuZHEGdS40MWUzNDlkYTYwNTQ4MjZmMGVkMWZkYzk3M2FmMDVjNw==\n	2011-04-03 17:47:32.79881+02
8a1f1ec62159c2183b49a0146c485c43	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-03-30 14:52:13.540112+02
5fc16efb5b91ed2bf93f9eb2e20fc4c7	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-30 15:03:06.099416+02
b4896290850029fe6e870fe4b8018117	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-31 16:28:54.489701+02
c3312bddc8485548146ccb93016e5130	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-30 15:52:23.529552+02
95aa3059a4563ebf4208e2e8fa47f559	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAlUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmI0Mzc4OGQwOGUwOTZlNjU0MGNh\nZThjNGE2NzFjMTRj\n	2011-03-30 17:18:46.372787+02
445e4902638b6dd9b4eff6e78473b414	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-30 18:03:34.488456+02
7b9b13eb4065d8b86d641e4bdf87af96	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx\nNjkyMDY1MzI2MjI3\n	2011-03-30 18:31:02.595672+02
f174d1a1f82aaf908dbb3ab4a5f4686a	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-30 18:37:33.367838+02
6efe8b457d60b6c33f946c20c554c320	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-30 19:22:38.539866+02
18f09de2eb07c6a1ff5ec1d0adbacd40	gAJ9cQEoVQ5pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9pZHEESwRVEl9h\ndXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFj\na2VuZHEGdS40MWUzNDlkYTYwNTQ4MjZmMGVkMWZkYzk3M2FmMDVjNw==\n	2011-03-31 17:26:27.666323+02
1f5b583252787b72ea10aad6a505bfc6	gAJ9cQFVCnRlc3Rjb29raWVxAlUGd29ya2VkcQNzLmNmMmJmZjljMGQ2ZjdiZDFlMDg2ZDc4YjVl\nMzFiMmU5\n	2011-03-30 19:23:53.174529+02
6f0219de0e0849c8413c0238f74c2a6d	gAJ9cQEoVQ5pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9pZHEESwRVEl9h\ndXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFj\na2VuZHEGdS40MWUzNDlkYTYwNTQ4MjZmMGVkMWZkYzk3M2FmMDVjNw==\n	2011-04-02 12:05:06.453509+02
3bff13c3d04372e6fb0e6dfc842333b0	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-30 21:42:35.58717+02
eb1919b163e0a2ae23a227a6f7fb7639	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-30 22:22:36.619583+02
40dda089816ffb762b6d02acede9a330	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-03-30 22:41:38.972713+02
be62a9a85f1632958b9b32328f196960	gAJ9cQEoVQp0ZXN0Y29va2llcQJVBndvcmtlZHEDVRJfYXV0aF91c2VyX2JhY2tlbmRxBFUpZGph\nbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmRxBVUNX2F1dGhfdXNlcl9pZHEG\nSwJ1LjdkNzQ4Y2IwNzU0MWJkYmUwYWU1N2M2MzQ3YzhlYmZl\n	2011-03-30 22:43:08.532559+02
4f0e5f4622994a5ab17aff8c66e54fa5	gAJ9cQEoVQ5pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9pZHEESwRVEl9h\ndXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFj\na2VuZHEGdS40MWUzNDlkYTYwNTQ4MjZmMGVkMWZkYzk3M2FmMDVjNw==\n	2011-03-31 10:40:53.244254+02
0650464a299f70335de45c71a2608fff	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-31 18:07:19.024796+02
098dbecd271ac99565d615d04a277b3b	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-03-31 16:09:54.112034+02
d871feb1dce8c1b618e1211a5232fd70	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQRVF2NwX2luZGV4X2l0ZW1zX3Blcl9w\nYWdlcQVYAwAAADEwMHEGdS45OTg1ODM3Nzc1M2ExMzhhODBkZmE1MTFlMGVmMGJlNA==\n	2011-04-01 00:01:04.916335+02
c5e96529f379331088a2a99ec809cdd6	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-05 19:16:11.100291+02
0d26b0b855f1af32c762b1779a9b7e00	gAJ9cQEuMDY1MzZkN2M1MDgyMzJlNDRhYTg3YmM3MTk2ZDI3NzE=\n	2011-04-01 11:16:03.725538+02
f1456fd7be87bf78a9661c697fbad74a	gAJ9cQEuMDY1MzZkN2M1MDgyMzJlNDRhYTg3YmM3MTk2ZDI3NzE=\n	2011-03-31 22:41:37.632601+02
9dd7ba118fe1acb790e27082a20d6d83	gAJ9cQEoVQ5pdGVtc19wZXJfcGFnZXECWAIAAAA1MHEDVQ1fYXV0aF91c2VyX2lkcQRLBFUSX2F1\ndGhfdXNlcl9iYWNrZW5kcQVVKWRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNr\nZW5kcQZ1LmY2ODIwMjlhMTA1NjhmNDQ2NDM4NGQyOWE0Zjg3N2Q3\n	2011-04-06 10:09:10.367132+02
1a223272f150dca961f83a0462efe47c	gAJ9cQEoVQ5pdGVtc19wZXJfcGFnZXECWAIAAAA1MHEDVQ1fYXV0aF91c2VyX2lkcQRLBFUSX2F1\ndGhfdXNlcl9iYWNrZW5kcQVVKWRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNr\nZW5kcQZ1LmY2ODIwMjlhMTA1NjhmNDQ2NDM4NGQyOWE0Zjg3N2Q3\n	2011-04-06 17:24:24.652139+02
abdff5d01a7ce0aa3fae3c83d6f9c24f	gAJ9cQEoVQ5pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9pZHEESwNVEl9h\ndXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFj\na2VuZHEGdS4xYjA4OGQ2ZWZhNzdmNGZkOTFkZWU1NWI1NmMzMmMzNA==\n	2011-04-01 13:36:30.501567+02
65efa9eefe4257eb01c5d1ff3d295b90	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UJcXNfZmlsdGVycQR9\ncQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0YXEIfXEJKFgVAAAAYXJlYV9fdGl0bGVfX2NvbnRh\naW5zcQpYAAAAAFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQyOHELWAIAAAAxM3EMWBwA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDI5cQ1YAgAAADEzcQ5YHAAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzE0MjBxD1gEAAAAMTMuMHEQWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8xNDIxcRFYAgAAADEzcRJYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MjJxE1gCAAAA\nMTNxFFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQyM3EVWAIAAAAxM3EWWBwAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8xNDI0cRdYAgAAADEzcRhYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzE0MjVxGVgCAAAAMTNxGlgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQyNnEb\nWAIAAAAxM3EcWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDI3cR1YAgAAADEzcR5YFgAA\nAGJyYW5kX190aXRsZV9fY29udGFpbnNxH1gAAAAAWAkAAABxc19maWx0ZXJxIFgBAAAAMVgcAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQzOXEhWAIAAAAxM3EiWBwAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF8xNDM4cSNYAgAAADEzcSRYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0\nMzNxJVgCAAAAMTNxJlgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQzMnEnWAIAAAAxM3Eo\nWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDMxcSlYAgAAADEzcSpYHAAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzE0MzBxK1gCAAAAMTNxLFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMTQzN3EtWAIAAAAxM3EuWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDM2cS9YAgAA\nADEzcTBYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MzVxMVgCAAAAMTNxMlgcAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQzNHEzWAIAAAAxM3E0WBwAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8xNDA0cTVYBAAAADEzLjBxNlgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQw\nMnE3WAIAAAAxM3E4WBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDAzcTlYAgAAADEzcTpY\nHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MDBxO1gCAAAAMTNxPFgcAAAAZGVsaXZlcnlf\nc3VwcGxpZXJfaW5wdXRfMTQwMXE9WAIAAAAxM3E+WBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8xNDA4cT9YBAAAADEzLjBxQFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQwOXFBWAQA\nAAAxMy4wcUJYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzOTZxQ1gCAAAAMTNxRFgcAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM5N3FFWAIAAAAxM3FGWBwAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF8xMzk0cUdYAgAAADEzcUhYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEz\nOTVxSVgCAAAAMTNxSlgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM5MnFLWAIAAAAxM3FM\nWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzkzcU1YAgAAADEzcU5YHAAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzEzOTBxT1gCAAAAMTNxUFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMTM5MXFRWAIAAAAxM3FSWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzk4cVNYAgAA\nADEzcVRYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzOTlxVVgCAAAAMTNxVlggAAAAcGFy\ndF9udW1iZXJfc3VwZXJzZWRlZF9fY29udGFpbnNxV1gAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8xMzc4cVhYAgAAADEzcVlYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzNzlx\nWlgCAAAAMTNxW1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM3NHFcWAIAAAAxM3FdWBwA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzc1cV5YAgAAADEzcV9YHAAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzEzNzZxYFgCAAAAMTNxYVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMTM3N3FiWAIAAAAxM3FjWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzcwcWRYAgAAADEz\ncWVYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzNzFxZlgCAAAAMTNxZ1gcAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMTM3MnFoWAIAAAAxM3FpWBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xMzczcWpYAgAAADEzcWtYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MTFxbFgC\nAAAAMTNxbVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQxMHFuWAQAAAAxMy4wcW9YHAAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MTNxcFgCAAAAMTNxcVgcAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMTQxNXFyWAIAAAAxM3FzWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8x\nNDE0cXRYAgAAADEzcXVYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MTdxdlgCAAAAMTNx\nd1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQxNnF4WAIAAAAxM3F5WBwAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8xNDE5cXpYAgAAADEzcXtYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzE0MThxfFgCAAAAMTNxfVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM4MXF+WAIA\nAAAxM3F/WBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzgwcYBYAgAAADEzcYFYHAAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzODNxglgCAAAAMTNxg1gcAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfMTM4MnGEWAIAAAAxM3GFWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzg1\ncYZYAgAAADEzcYdYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzODRxiFgCAAAAMTNxiVgc\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM4N3GKWAIAAAAxM3GLWBwAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF8xMzg2cYxYAgAAADEzcY1YHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzEzODlxjlgCAAAAMTNxj1gWAAAAaW52b2ljZV9jb2RlX19jb250YWluc3GQWAAAAABYHAAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzODhxkVgCAAAAMTNxklgcAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfMTMzN3GTWAIAAAAxM3GUWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzY5\ncZVYAgAAADEzcZZYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzNjhxl1gCAAAAMTNxmFgc\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM2N3GZWAIAAAAxM3GaWBwAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF8xMzY2cZtYAgAAADEzcZxYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzEzNjVxnVgCAAAAMTNxnlgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM2NHGfWAIAAAAx\nM3GgWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzYzcaFYAgAAADEzcaJYHAAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzEzNjJxo1gCAAAAMTNxpFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfMTM2MXGlWAQAAAAxMy4wcaZYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzNjBx\np1gEAAAAMTMuMHGoWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDQycalYAgAAADEzcapY\nHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NDNxq1gCAAAAMTNxrFgcAAAAZGVsaXZlcnlf\nc3VwcGxpZXJfaW5wdXRfMTQ0MHGtWAIAAAAxM3GuWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8xNDQxca9YAgAAADEzcbBYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NDRxsVgCAAAA\nMTNxslgaAAAAY2xpZW50X191c2VybmFtZV9fY29udGFpbnNxs1gDAAAAYXBzcbRYGwAAAG1hbmFn\nZXJfX3VzZXJuYW1lX19jb250YWluc3G1WAAAAABYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzEzNDVxtlgEAAAAMTMuMHG3WBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzQ0cbhYBAAA\nADEzLjBxuVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM0N3G6WAQAAAAxMy4wcbtYHAAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzNDZxvFgEAAAAMTMuMHG9WBwAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF8xMzQxcb5YBAAAADEzLjBxv1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMTM0MHHAWAIAAAAxM3HBWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzQzccJYBAAA\nADEzLjBxw1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM0MnHEWAIAAAAxM3HFWBwAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzQ4ccZYBAAAADEzLjBxx1gaAAAAY29tbWVudF9zdXBw\nbGllcl9fY29udGFpbnNxyFgAAAAAWAYAAABzdGF0dXNxyVgAAAAAWBsAAABicmFuZGdyb3VwX190\naXRsZV9fY29udGFpbnNxylgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzMwcctY\nBAAAADEzLjBxzFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTMzMXHNWAIAAAAxM3HOWBwA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzMycc9YAgAAADEzcdBYHAAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzEzMzNx0VgCAAAAMTNx0lgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMTMzNHHTWAQAAAAxMy4wcdRYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzMzVx1VgCAAAA\nMTNx1lgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTMzNnHXWAQAAAAxMy4wcdhYGAAAAGRl\nc2NyaXB0aW9uX2VuX19jb250YWluc3HZWAAAAABYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzEzMzhx2lgCAAAAMTNx21gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTMzOXHcWAIAAAAx\nM3HdWBgAAABkZXNjcmlwdGlvbl9ydV9fY29udGFpbnNx3lgAAAAAWBUAAABwYXJ0X251bWJlcl9f\nY29udGFpbnNx31gAAAAAdXVVDV9hdXRoX3VzZXJfaWRx4EsBVRJfYXV0aF91c2VyX2JhY2tlbmRx\n4VUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmRx4nUuYzczMzc0YTJl\nMTVmYmM3MWE4MWMxNzZiYTExNjlkZTU=\n	2011-04-01 13:46:38.294731+02
748c94da5ea1fb60f881ae6a020b6d67	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-01 15:07:19.993651+02
8a5144c7b192e050d25082475694d384	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-07 17:13:09.110244+02
402ea2348050521306c3041b3bf8aa4b	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-04-03 20:09:19.679429+02
fbe52d09f1610cac20cc60da9ac3db03	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-04-03 21:31:43.085148+02
7d3000ed5bcc8f25b847e33ca83991d1	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-04-04 14:09:49.02179+02
0e5c6c8070c729656898edab3c19d16b	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAlUJcXNfZmlsdGVycQN9cQQoVQRwYXRocQVYBAAAAC9j\ncC9xBlUEZGF0YXEHfXEIKFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI3M3EJWAQAAAAx\nMy4wcQpYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyMjlxC1gCAAAAMTNxDFgbAAAAbWFu\nYWdlcl9fdXNlcm5hbWVfX2NvbnRhaW5zcQ1YAAAAAFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMTE4NHEOWAIAAAAxM3EPWBgAAABkZXNjcmlwdGlvbl9lbl9fY29udGFpbnNxEFgAAAAAWBwA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjgxcRFYBAAAADEzLjBxElgcAAAAZGVsaXZlcnlf\nc3VwcGxpZXJfaW5wdXRfMTIwMHETWAIAAAAxM3EUWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8xMjAxcRVYAgAAADEzcRZYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNjhxF1gEAAAA\nMTMuMHEYWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjY5cRlYBAAAADEzLjBxGlgcAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTE4N3EbWAIAAAAxM3EcWBUAAABhcmVhX190aXRsZV9f\nY29udGFpbnNxHVgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMTg1cR5YAgAAADEz\ncR9YHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyMDdxIFgCAAAAMTNxIVgcAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMTIwOHEiWAIAAAAxM3EjWBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xMjA5cSRYAgAAADEzcSVYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNjBxJlgC\nAAAAMTNxJ1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTE4OHEoWAIAAAAxM3EpWBwAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjY2cSpYAgAAADEzcStYHAAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzEyNDFxLFgCAAAAMTNxLVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI2\nNHEuWAIAAAAxM3EvWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjY1cTBYAgAAADEzcTFY\nHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyMzhxMlgCAAAAMTNxM1gcAAAAZGVsaXZlcnlf\nc3VwcGxpZXJfaW5wdXRfMTE3MHE0WAIAAAAxM3E1WBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8xMTc3cTZYAgAAADEzcTdYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzExNzVxOFgCAAAA\nMTNxOVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTIzMHE6WAIAAAAxM3E7WBwAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8xMTc4cTxYAgAAADEzcT1YHAAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzExNzlxPlgCAAAAMTNxP1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTIzNHFA\nWAIAAAAxM3FBWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjM3cUJYAgAAADEzcUNYHAAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyMTBxRFgCAAAAMTNxRVgcAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMTI0MnFGWAIAAAAxM3FHWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8x\nMjkzcUhYAgAAADEzcUlYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEwNzJxSlgCAAAAMTNx\nS1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI3NHFMWAQAAAAxMy4wcU1YHAAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzExODBxTlgCAAAAMTNxT1gaAAAAY29tbWVudF9zdXBwbGllcl9f\nY29udGFpbnNxUFgAAAAAWAYAAABzdGF0dXNxUVgAAAAAWBYAAABicmFuZF9fdGl0bGVfX2NvbnRh\naW5zcVJYAAAAAFggAAAAcGFydF9udW1iZXJfc3VwZXJzZWRlZF9fY29udGFpbnNxU1gAAAAAWBwA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMTczcVRYAgAAADEzcVVYHAAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzEyMTdxVlgCAAAAMTNxV1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMTIxM3FYWAIAAAAxM3FZWBsAAABicmFuZGdyb3VwX190aXRsZV9fY29udGFpbnNxWlgAAAAAWBwA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMTkwcVtYAgAAADEzcVxYFQAAAHBhcnRfbnVtYmVy\nX19jb250YWluc3FdWAAAAABYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzExOTJxXlgCAAAA\nMTNxX1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTE5M3FgWAIAAAAxM3FhWBwAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8xMjcxcWJYBAAAADEzLjBxY1gcAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfMTE5NXFkWAIAAAAxM3FlWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjE1\ncWZYAgAAADEzcWdYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNzJxaFgEAAAAMTMuMHFp\nWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMTk5cWpYAgAAADEzcWtYHAAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzEyMTlxbFgCAAAAMTNxbVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMTIxOHFuWAIAAAAxM3FvWAkAAABxc19maWx0ZXJxcFgBAAAAMVgcAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMTI5MnFxWAIAAAAxM3FyWBgAAABkZXNjcmlwdGlvbl9ydV9fY29udGFpbnNx\nc1gAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjc1cXRYBAAAADEzLjBxdVgcAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTE4M3F2WAIAAAAxM3F3WBYAAABpbnZvaWNlX2NvZGVf\nX2NvbnRhaW5zcXhYAwAAADEwM3F5WBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjI4cXpY\nBAAAADEzLjBxe1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTIxMnF8WAIAAAAxM3F9WBoA\nAABjbGllbnRfX3VzZXJuYW1lX19jb250YWluc3F+WAIAAABkcHF/WBwAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF8xMjI3cYBYBAAAADEzLjBxgVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMTIyNHGCWAIAAAAxM3GDWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjI1cYRYAgAAADEz\ncYVYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyMjNxhlgCAAAAMTNxh1gcAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMTE5MXGIWAIAAAAxM3GJWBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xMjgwcYpYBAAAADEzLjBxi1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTIyNnGM\nWAIAAAAxM3GNWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMTA4cY5YAgAAADEzcY9YHAAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzExNjlxkFgCAAAAMTNxkVgcAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMTE2OHGSWAIAAAAxM3GTWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8x\nMjc2cZRYBAAAADEzLjBxlVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTE2NXGWWAQAAAAx\nMy4wcZdYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzExOTRxmFgCAAAAMTNxmVgcAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI4MnGaWAQAAAAxMy4wcZtYHAAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzEyODNxnFgCAAAAMTNxnVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI4\nNHGeWAIAAAAxM3GfWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMTA2caBYAgAAADEzcaF1\ndVUSX2F1dGhfdXNlcl9iYWNrZW5kcaJVKWRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9k\nZWxCYWNrZW5kcaNVF2NwX2luZGV4X2l0ZW1zX3Blcl9wYWdlcaRYAwAAADEwMHGldS42NzE2MWY0\nZGJhMGQ4MDY4YWZlNTc1Y2UyY2VjZThhZg==\n	2011-04-04 14:02:46.654161+02
fe2fb09837a4d6caeac06a859e8275d1	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UJcXNfZmlsdGVycQR9cQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0\nYXEIfXEJKFgYAAAAZGVzY3JpcHRpb25fZW5fX2NvbnRhaW5zcQpYAAAAAFgVAAAAYXJlYV9fdGl0\nbGVfX2NvbnRhaW5zcQtYAAAAAFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQyOHEMWAIA\nAAAxM3ENWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDI5cQ5YAgAAADEzcQ9YHAAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MjBxEFgEAAAAMTMuMHERWBwAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF8xNDIxcRJYAgAAADEzcRNYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0\nMjJxFFgCAAAAMTNxFVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQyM3EWWAIAAAAxM3EX\nWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDI0cRhYAgAAADEzcRlYHAAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzE0MjVxGlgCAAAAMTNxG1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMTQyNnEcWAIAAAAxM3EdWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDI3cR5YAgAA\nADEzcR9YFgAAAGJyYW5kX190aXRsZV9fY29udGFpbnNxIFgAAAAAWAkAAABxc19maWx0ZXJxIVgB\nAAAAMVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQzOXEiWAIAAAAxM3EjWBwAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8xNDM4cSRYAgAAADEzcSVYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzE0MzNxJlgCAAAAMTNxJ1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQzMnEo\nWAIAAAAxM3EpWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDMxcSpYAgAAADEzcStYHAAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MzBxLFgCAAAAMTNxLVgcAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMTQzN3EuWAIAAAAxM3EvWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8x\nNDM2cTBYAgAAADEzcTFYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MzVxMlgCAAAAMTNx\nM1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQzNHE0WAIAAAAxM3E1WBwAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8xNDA0cTZYBAAAADEzLjBxN1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfMTQwMnE4WAIAAAAxM3E5WBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDAzcTpY\nAgAAADEzcTtYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MDBxPFgCAAAAMTNxPVgcAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQwMXE+WAIAAAAxM3E/WBwAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF8xNDA4cUBYBAAAADEzLjBxQVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMTQwOXFCWAQAAAAxMy4wcUNYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzOTZxRFgCAAAA\nMTNxRVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM5N3FGWAIAAAAxM3FHWBwAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8xMzk0cUhYAgAAADEzcUlYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzEzOTVxSlgCAAAAMTNxS1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM5MnFM\nWAIAAAAxM3FNWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzkzcU5YAgAAADEzcU9YHAAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzOTBxUFgCAAAAMTNxUVgcAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMTM5MXFSWAIAAAAxM3FTWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8x\nMzk4cVRYAgAAADEzcVVYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzOTlxVlgCAAAAMTNx\nV1ggAAAAcGFydF9udW1iZXJfc3VwZXJzZWRlZF9fY29udGFpbnNxWFgAAAAAWBwAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8xNDY0cVlYAgAAADEzcVpYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzE0NjVxW1gCAAAAMTNxXFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ2NnFdWAIA\nAAAxM3FeWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDY3cV9YAgAAADEzcWBYHAAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NjBxYVgCAAAAMTNxYlgcAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfMTQ2MXFjWAIAAAAxM3FkWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDYy\ncWVYAgAAADEzcWZYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NjNxZ1gCAAAAMTNxaFgc\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM3NHFpWAIAAAAxM3FqWBwAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF8xMzc1cWtYAgAAADEzcWxYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzEzNzZxbVgCAAAAMTNxblgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM3N3FvWAIAAAAx\nM3FwWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzcwcXFYAgAAADEzcXJYHAAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzEzNzFxc1gCAAAAMTNxdFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfMTM3MnF1WAIAAAAxM3F2WBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzczcXdY\nAgAAADEzcXhYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MTFxeVgCAAAAMTNxelgcAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQxMHF7WAQAAAAxMy4wcXxYHAAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzE0MTNxfVgCAAAAMTNxflgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMTQxNXF/WAIAAAAxM3GAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDE0cYFYAgAAADEz\ncYJYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MTdxg1gCAAAAMTNxhFgcAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMTQxNnGFWAIAAAAxM3GGWBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xNDE5cYdYAgAAADEzcYhYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MThxiVgC\nAAAAMTNxilgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM4MXGLWAIAAAAxM3GMWBwAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzgwcY1YAgAAADEzcY5YHAAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzEzODNxj1gCAAAAMTNxkFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTM4\nMnGRWAIAAAAxM3GSWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzg1cZNYAgAAADEzcZRY\nHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzODRxlVgCAAAAMTNxllgcAAAAZGVsaXZlcnlf\nc3VwcGxpZXJfaW5wdXRfMTM4N3GXWAIAAAAxM3GYWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8xMzg2cZlYAgAAADEzcZpYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzODlxm1gCAAAA\nMTNxnFgWAAAAaW52b2ljZV9jb2RlX19jb250YWluc3GdWAAAAABYHAAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzEzNzlxnlgCAAAAMTNxn1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ3\nM3GgWAIAAAAxM3GhWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDcycaJYAgAAADEzcaNY\nHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NzFxpFgCAAAAMTNxpVgcAAAAZGVsaXZlcnlf\nc3VwcGxpZXJfaW5wdXRfMTQ3MHGmWAIAAAAxM3GnWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8xNDY4cahYAgAAADEzcalYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NjlxqlgCAAAA\nMTNxq1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ0MnGsWAIAAAAxM3GtWBwAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8xNDQzca5YAgAAADEzca9YHAAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzE0NDBxsFgCAAAAMTNxsVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ0MXGy\nWAIAAAAxM3GzWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDQ2cbRYBAAAADEzLjBxtVgc\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ0N3G2WAIAAAAxM3G3WBwAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF8xNDQ0cbhYAgAAADEzcblYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzE0NDVxulgEAAAAMTMuMHG7WBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDQ4cbxYAgAA\nADEzcb1YHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NDlxvlgCAAAAMTNxv1gaAAAAY2xp\nZW50X191c2VybmFtZV9fY29udGFpbnNxwFgAAAAAWBsAAABtYW5hZ2VyX191c2VybmFtZV9fY29u\ndGFpbnNxwVgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzc4ccJYAgAAADEzccNY\nGgAAAGNvbW1lbnRfc3VwcGxpZXJfX2NvbnRhaW5zccRYAAAAAFgGAAAAc3RhdHVzccVYAAAAAFgb\nAAAAYnJhbmRncm91cF9fdGl0bGVfX2NvbnRhaW5zccZYBQAAAERPQ0FQccdYHAAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzEzODhxyFgCAAAAMTNxyVgYAAAAZGVzY3JpcHRpb25fcnVfX2NvbnRh\naW5zccpYAAAAAFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ1OXHLWAIAAAAxM3HMWBwA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDU4cc1YAgAAADEzcc5YFQAAAHBhcnRfbnVtYmVy\nX19jb250YWluc3HPWAAAAABYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NTVx0FgCAAAA\nMTNx0VgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ1NHHSWAIAAAAxM3HTWBwAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8xNDU3cdRYAgAAADEzcdVYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzE0NTZx1lgCAAAAMTNx11gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ1MXHY\nWAIAAAAxM3HZWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDUwcdpYAgAAADEzcdtYHAAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NTNx3FgCAAAAMTNx3VgcAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMTQ1MnHeWAIAAAAxM3HfdXVVDV9hdXRoX3VzZXJfaWRx4EsBVRdjcF9pbmRl\neF9pdGVtc19wZXJfcGFnZXHhWAMAAAAxMDBx4nUuM2JmY2NmNDA0ZjM5YjhmNGE2MjRmNGM2YzAx\nMzUzMmI=\n	2011-04-04 22:22:18.994465+02
ba508f4827692eeb2586009a800f06cc	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwFVF2NwX2luZGV4X2l0ZW1zX3Blcl9w\nYWdlcQVYAwAAADEwMHEGdS4yZjg1ZDBhZjc5OTBlYjFhNjI5OWQ5MzE3MzM3YjAxOQ==\n	2011-04-05 00:15:26.399189+02
35773cecfcbbd65e66dd3ac6ccebb682	gAJ9cQEoVQlxc19maWx0ZXJxAn1xAyhVBHBhdGhxBFgEAAAAL2NwL3EFVQRkYXRhcQZ9cQcoWBsA\nAABtYW5hZ2VyX191c2VybmFtZV9fY29udGFpbnNxCFgAAAAAWBgAAABkZXNjcmlwdGlvbl9lbl9f\nY29udGFpbnNxCVgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjgxcQpYBAAAADEz\nLjBxC1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI2OHEMWAQAAAAxMy4wcQ1YHAAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNjlxDlgEAAAAMTMuMHEPWBUAAABhcmVhX190aXRsZV9f\nY29udGFpbnNxEFgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjYwcRFYAgAAADEz\ncRJYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNjZxE1gCAAAAMTNxFFgcAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMTI0MnEVWAIAAAAxM3EWWBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xMjY1cRdYAgAAADEzcRhYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNjRxGVgC\nAAAAMTNxGlgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI5M3EbWAIAAAAxM3EcWBwAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjkycR1YAgAAADEzcR5YGgAAAGNvbW1lbnRfc3VwcGxp\nZXJfX2NvbnRhaW5zcR9YAAAAAFgGAAAAc3RhdHVzcSBYAAAAAFgWAAAAYnJhbmRfX3RpdGxlX19j\nb250YWluc3EhWAAAAABYIAAAAHBhcnRfbnVtYmVyX3N1cGVyc2VkZWRfX2NvbnRhaW5zcSJYAAAA\nAFgbAAAAYnJhbmRncm91cF9fdGl0bGVfX2NvbnRhaW5zcSNYAAAAAFgcAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMTI3NXEkWAQAAAAxMy4wcSVYFQAAAHBhcnRfbnVtYmVyX19jb250YWluc3Em\nWAAAAABYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNzZxJ1gEAAAAMTMuMHEoWBYAAABp\nbnZvaWNlX2NvZGVfX2NvbnRhaW5zcSlYAwAAADEwM3EqWBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xMjczcStYBAAAADEzLjBxLFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI3MnEt\nWAQAAAAxMy4wcS5YCQAAAHFzX2ZpbHRlcnEvWAEAAAAxWBgAAABkZXNjcmlwdGlvbl9ydV9fY29u\ndGFpbnNxMFgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjc0cTFYBAAAADEzLjBx\nMlgaAAAAY2xpZW50X191c2VybmFtZV9fY29udGFpbnNxM1gDAAAANjQ1cTRYHAAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzEyODBxNVgEAAAAMTMuMHE2WBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xMjcxcTdYBAAAADEzLjBxOFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI4MnE5\nWAQAAAAxMy4wcTpYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyODNxO1gCAAAAMTNxPFgc\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI4NHE9WAIAAAAxM3E+dXVVEl9hdXRoX3VzZXJf\nYmFja2VuZHE/VSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHFAVQ1f\nYXV0aF91c2VyX2lkcUFLAnUuNmMxMjQyMTIwYjAyMmY4MmZkZWJjZGIyNTEyZmQ5MmI=\n	2011-04-05 13:10:20.281557+02
1ef2494b29163c390daf8101eb5e269d	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UJcXNfZmlsdGVycQR9\ncQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0YXEIfXEJKFgGAAAAc3RhdHVzcQpYAAAAAFgWAAAA\nYnJhbmRfX3RpdGxlX19jb250YWluc3ELWAAAAABYIAAAAHBhcnRfbnVtYmVyX3N1cGVyc2VkZWRf\nX2NvbnRhaW5zcQxYAAAAAFgaAAAAY2xpZW50X191c2VybmFtZV9fY29udGFpbnNxDVgAAAAAWBsA\nAABtYW5hZ2VyX191c2VybmFtZV9fY29udGFpbnNxDlgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8xMDM1cQ9YAgAAADEzcRBYGwAAAGJyYW5kZ3JvdXBfX3RpdGxlX19jb250YWluc3ER\nWAUAAABET0NBUHESWBUAAABwYXJ0X251bWJlcl9fY29udGFpbnNxE1gAAAAAWBYAAABpbnZvaWNl\nX2NvZGVfX2NvbnRhaW5zcRRYAAAAAFgVAAAAYXJlYV9fdGl0bGVfX2NvbnRhaW5zcRVYAAAAAFgY\nAAAAZGVzY3JpcHRpb25fZW5fX2NvbnRhaW5zcRZYAAAAAFgJAAAAcXNfZmlsdGVycRdYAQAAADFY\nGgAAAGNvbW1lbnRfc3VwcGxpZXJfX2NvbnRhaW5zcRhYAAAAAFgYAAAAZGVzY3JpcHRpb25fcnVf\nX2NvbnRhaW5zcRlYAAAAAHV1VQ1fYXV0aF91c2VyX2lkcRpLAVUSX2F1dGhfdXNlcl9iYWNrZW5k\ncRtVKWRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcRx1LjMwMjhkYmU3\nZWY5Y2YzYzlkNjE3MTY5ZTZjMzUwNmNl\n	2011-04-05 14:20:14.454773+02
b8b66698c6e3ac792d00274e92c35d7e	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUJcXNfZmlsdGVycQN9cQQoVQRwYXRocQVYBAAAAC9j\ncC9xBlUEZGF0YXEHfXEIKFgGAAAAc3RhdHVzcQlYAAAAAFgWAAAAYnJhbmRfX3RpdGxlX19jb250\nYWluc3EKWAAAAABYIAAAAHBhcnRfbnVtYmVyX3N1cGVyc2VkZWRfX2NvbnRhaW5zcQtYAAAAAFga\nAAAAY2xpZW50X191c2VybmFtZV9fY29udGFpbnNxDFgDAAAAYXBzcQ1YGwAAAG1hbmFnZXJfX3Vz\nZXJuYW1lX19jb250YWluc3EOWAAAAABYGwAAAGJyYW5kZ3JvdXBfX3RpdGxlX19jb250YWluc3EP\nWAAAAABYFQAAAHBhcnRfbnVtYmVyX19jb250YWluc3EQWAAAAABYFgAAAGludm9pY2VfY29kZV9f\nY29udGFpbnNxEVgDAAAAMTAzcRJYFQAAAGFyZWFfX3RpdGxlX19jb250YWluc3ETWAAAAABYGAAA\nAGRlc2NyaXB0aW9uX2VuX19jb250YWluc3EUWAAAAABYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzEwNzJxFVgCAAAAMTNxFlgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI2MHEXWAIA\nAAAxM3EYWAkAAABxc19maWx0ZXJxGVgBAAAAMVgaAAAAY29tbWVudF9zdXBwbGllcl9fY29udGFp\nbnNxGlgAAAAAWBgAAABkZXNjcmlwdGlvbl9ydV9fY29udGFpbnNxG1gAAAAAdXVVEl9hdXRoX3Vz\nZXJfYmFja2VuZHEcVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHEd\nVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXEeWAMAAAAxMDBxH3UuYTM0YWEyYjNiNTA4YjJmZjhm\nMzFmMzZmM2U4ZmM1YTk=\n	2011-04-04 21:00:57.189941+02
a99dcc9cfb675f055674650166115f2b	gAJ9cQEuMDY1MzZkN2M1MDgyMzJlNDRhYTg3YmM3MTk2ZDI3NzE=\n	2011-04-05 19:33:00.019178+02
5f3aeb2288a1b18c38863637da4532fb	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAlUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmI0Mzc4OGQwOGUwOTZlNjU0MGNh\nZThjNGE2NzFjMTRj\n	2011-04-05 19:45:32.961287+02
1624d2a2c1f71f0204a78273483f7a90	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-08 18:43:15.554063+02
7cb1c23d6e334d8a9bed55f4a392134b	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9p\nZHEESwFVEl9hdXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZHEGdS5iNmM4MjNhYWU1ODZiNDkxMmU5ZTMwZTE0NTQ4YjM4OA==\n	2011-04-06 20:16:12.392415+02
228b3e575031ec08fe7dbab83e92a198	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwR1LjExNzRlZTBkMjQ0NzFmNDI3MzMy\nMDAwOTIzZGUyZjU0\n	2011-04-07 15:29:55.891962+02
164c1e60737e649383652bc14e0a06f9	gAJ9cQEoVQ5pdGVtc19wZXJfcGFnZXECWAIAAAA1MHEDVQ1fYXV0aF91c2VyX2lkcQRLBFUSX2F1\ndGhfdXNlcl9iYWNrZW5kcQVVKWRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNr\nZW5kcQZ1LmY2ODIwMjlhMTA1NjhmNDQ2NDM4NGQyOWE0Zjg3N2Q3\n	2011-04-08 12:00:57.679808+02
162bad99d797ac38f7dbfaee94127aca	gAJ9cQEoVQlxc19maWx0ZXJxAn1xAyhVBHBhdGhxBFgEAAAAL2NwL3EFVQRkYXRhcQZ9cQcoWBsA\nAABtYW5hZ2VyX191c2VybmFtZV9fY29udGFpbnNxCFgAAAAAWBgAAABkZXNjcmlwdGlvbl9lbl9f\nY29udGFpbnNxCVgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjgxcQpYBAAAADEz\nLjBxC1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI2OHEMWAQAAAAxMy4wcQ1YHAAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNjlxDlgEAAAAMTMuMHEPWBUAAABhcmVhX190aXRsZV9f\nY29udGFpbnNxEFgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjYwcRFYAgAAADEz\ncRJYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNjZxE1gCAAAAMTNxFFgcAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMTI0MnEVWAIAAAAxM3EWWBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xMjY1cRdYAgAAADEzcRhYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNjRxGVgC\nAAAAMTNxGlgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI5M3EbWAIAAAAxM3EcWBwAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjkycR1YAgAAADEzcR5YGgAAAGNvbW1lbnRfc3VwcGxp\nZXJfX2NvbnRhaW5zcR9YAAAAAFgGAAAAc3RhdHVzcSBYAAAAAFgWAAAAYnJhbmRfX3RpdGxlX19j\nb250YWluc3EhWAAAAABYIAAAAHBhcnRfbnVtYmVyX3N1cGVyc2VkZWRfX2NvbnRhaW5zcSJYAAAA\nAFgbAAAAYnJhbmRncm91cF9fdGl0bGVfX2NvbnRhaW5zcSNYAAAAAFgcAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMTI3NXEkWAQAAAAxMy4wcSVYFQAAAHBhcnRfbnVtYmVyX19jb250YWluc3Em\nWAAAAABYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNzZxJ1gEAAAAMTMuMHEoWBYAAABp\nbnZvaWNlX2NvZGVfX2NvbnRhaW5zcSlYAwAAADEwM3EqWBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xMjczcStYBAAAADEzLjBxLFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI3MnEt\nWAQAAAAxMy4wcS5YCQAAAHFzX2ZpbHRlcnEvWAEAAAAxWBgAAABkZXNjcmlwdGlvbl9ydV9fY29u\ndGFpbnNxMFgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjc0cTFYBAAAADEzLjBx\nMlgaAAAAY2xpZW50X191c2VybmFtZV9fY29udGFpbnNxM1gHAAAANjU5MTQwM3E0WBwAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8xMjgwcTVYBAAAADEzLjBxNlgcAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfMTI3MXE3WAQAAAAxMy4wcThYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEy\nODJxOVgEAAAAMTMuMHE6WBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjgzcTtYAgAAADEz\ncTxYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyODRxPVgCAAAAMTNxPnV1VRJfYXV0aF91\nc2VyX2JhY2tlbmRxP1UpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmRx\nQFUNX2F1dGhfdXNlcl9pZHFBSwJ1LjgyMThmNzk0MDI3OTBiMDJlMzEyMmI2NmZlYjNjMDE0\n	2011-04-04 15:25:26.691041+02
cc0ed0451af7a04d402a256823ca3fd5	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwN1LjgyMjc4NmUzNjdhMDlhMTgxOGUx\nMjcxYTg1MmU1Yjlm\n	2011-04-04 20:03:01.582207+02
173ce775981ebab046fffabca57b1b81	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-04-05 07:08:19.313757+02
3e94576f833520e7d9ce211ac6e396b7	gAJ9cQEoVQ5pdGVtc19wZXJfcGFnZXECWAIAAAA1MHEDVQ1fYXV0aF91c2VyX2lkcQRLBFUSX2F1\ndGhfdXNlcl9iYWNrZW5kcQVVKWRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNr\nZW5kcQZ1LmY2ODIwMjlhMTA1NjhmNDQ2NDM4NGQyOWE0Zjg3N2Q3\n	2011-04-05 14:36:33.936515+02
235f7c711baca21b362e87ca43b2904d	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAIAAAA1MHEDVQlxc19maWx0ZXJxBH1x\nBShVBHBhdGhxBlgEAAAAL2NwL3EHVQRkYXRhcQh9cQkoWAYAAABzdGF0dXNxClgAAAAAWBYAAABi\ncmFuZF9fdGl0bGVfX2NvbnRhaW5zcQtYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nODMxcQxYAgAAADEzcQ1YIAAAAHBhcnRfbnVtYmVyX3N1cGVyc2VkZWRfX2NvbnRhaW5zcQ5YAAAA\nAFgaAAAAY2xpZW50X191c2VybmFtZV9fY29udGFpbnNxD1gAAAAAWBsAAABtYW5hZ2VyX191c2Vy\nbmFtZV9fY29udGFpbnNxEFgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNTc0cRFY\nAgAAADEzcRJYGwAAAGJyYW5kZ3JvdXBfX3RpdGxlX19jb250YWluc3ETWAAAAABYFQAAAHBhcnRf\nbnVtYmVyX19jb250YWluc3EUWAAAAABYFgAAAGludm9pY2VfY29kZV9fY29udGFpbnNxFVgAAAAA\nWBUAAABhcmVhX190aXRsZV9fY29udGFpbnNxFlgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xMDkycRdYAgAAADEzcRhYGAAAAGRlc2NyaXB0aW9uX2VuX19jb250YWluc3EZWAAAAABY\nCQAAAHFzX2ZpbHRlcnEaWAEAAAAxWBoAAABjb21tZW50X3N1cHBsaWVyX19jb250YWluc3EbWAAA\nAABYGAAAAGRlc2NyaXB0aW9uX3J1X19jb250YWluc3EcWAAAAAB1dVUNX2F1dGhfdXNlcl9pZHEd\nSwFVEl9hdXRoX3VzZXJfYmFja2VuZHEeVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1v\nZGVsQmFja2VuZHEfdS5mODE2YjdiZDg4NWVjZDRiNTk4ODBhZjYzNTk1NDMyMA==\n	2011-04-07 18:35:48.174302+02
f699273cd6a7dc8e287dfe413afe1423	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-05 19:39:28.98192+02
1d2f40684efd3b0c6c1642e76b0ded03	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwR1LjExNzRlZTBkMjQ0NzFmNDI3MzMy\nMDAwOTIzZGUyZjU0\n	2011-04-06 18:05:20.789226+02
289c82da1da0268cb4a4e5ce659bd18b	gAJ9cQEoVQp0ZXN0Y29va2llcQJVBndvcmtlZHEDVRJfYXV0aF91c2VyX2JhY2tlbmRxBFUpZGph\nbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmRxBVUNX2F1dGhfdXNlcl9pZHEG\nSwF1LjQ2NmQxY2Q0OTJlNzQ1MGZlNzA2N2EwZGFhYzlmMzY0\n	2011-04-06 19:08:30.230348+02
5bd194bf1f0096231755b9816d7dd98a	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESxl1LjQ3ZjVhMmM5N2I3MmI2NmRmZTM0\nZjM2N2Q5YjY1MzQ2\n	2011-04-06 21:34:57.956661+02
8279b136bf1cd9b5dbc9bdcd3c701c7e	gAJ9cQEuMDY1MzZkN2M1MDgyMzJlNDRhYTg3YmM3MTk2ZDI3NzE=\n	2011-04-09 12:03:57.285188+02
f55e01a653fbc456a01bb57a3606ef0a	gAJ9cQEuMDY1MzZkN2M1MDgyMzJlNDRhYTg3YmM3MTk2ZDI3NzE=\n	2011-04-09 13:49:51.804105+02
bb77bc09c90cacd42d909d497bafa6ff	gAJ9cQEoVQlxc19maWx0ZXJxAn1xAyhVBHBhdGhxBFgEAAAAL2NwL3EFVQRkYXRhcQZ9cQcoWAYA\nAABzdGF0dXNxCFgAAAAAWBYAAABicmFuZF9fdGl0bGVfX2NvbnRhaW5zcQlYAAAAAFggAAAAcGFy\ndF9udW1iZXJfc3VwZXJzZWRlZF9fY29udGFpbnNxClgAAAAAWBoAAABjbGllbnRfX3VzZXJuYW1l\nX19jb250YWluc3ELWAAAAABYGwAAAG1hbmFnZXJfX3VzZXJuYW1lX19jb250YWluc3EMWAAAAABY\nGwAAAGJyYW5kZ3JvdXBfX3RpdGxlX19jb250YWluc3ENWAAAAABYFQAAAHBhcnRfbnVtYmVyX19j\nb250YWluc3EOWAAAAABYFgAAAGludm9pY2VfY29kZV9fY29udGFpbnNxD1gAAAAAWBUAAABhcmVh\nX190aXRsZV9fY29udGFpbnNxEFgAAAAAWAkAAABxc19maWx0ZXJxEVgBAAAAMVgYAAAAZGVzY3Jp\ncHRpb25fZW5fX2NvbnRhaW5zcRJYAAAAAFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTUw\nM3ETWAIAAAAxM3EUWBoAAABjb21tZW50X3N1cHBsaWVyX19jb250YWluc3EVWAAAAABYGAAAAGRl\nc2NyaXB0aW9uX3J1X19jb250YWluc3EWWAAAAAB1dVUNX2F1dGhfdXNlcl9pZHEXSwFVEl9hdXRo\nX3VzZXJfYmFja2VuZHEYVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2Vu\nZHEZdS5jNzc3MmFhNDRlOTFjYzRlMTEzODVmZmNmMzhmYmJlYg==\n	2011-04-05 16:04:57.151167+02
06ec6311ec3356851aead97c365a66eb	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwR1LjExNzRlZTBkMjQ0NzFmNDI3MzMy\nMDAwOTIzZGUyZjU0\n	2011-04-06 13:13:48.015215+02
10604bde917fbe38c7267ba69b6d84bf	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-09 17:13:48.809314+02
5ee523a15f175a1854c61dbc48e4e195	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-06 22:23:30.574004+02
d71b84a4facd2a426ebc70b8086a9c3d	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-04-07 15:41:50.799459+02
ba060c791ceaf610abe06d5df2c74556	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-08 14:41:13.424296+02
fca70648c2fd1334fe03af6df2a0100d	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UNX2F1dGhfdXNlcl9p\nZHEESwJVEl9hdXRoX3VzZXJfYmFja2VuZHEFVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRz\nLk1vZGVsQmFja2VuZHEGdS5lM2NkNjA0ZDc1MmFhOTAxM2UyN2U2Yjg0Mzg3NWRlYw==\n	2011-04-08 19:18:07.236028+02
724b59872b9a37371a5af096d145b1e2	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUJcXNfZmlsdGVycQN9cQQoVQRwYXRocQVYBAAAAC9j\ncC9xBlUEZGF0YXEHfXEIKFgbAAAAbWFuYWdlcl9fdXNlcm5hbWVfX2NvbnRhaW5zcQlYAAAAAFgV\nAAAAYXJlYV9fdGl0bGVfX2NvbnRhaW5zcQpYAAAAAFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMjgzcQtYAgAAADEzcQxYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI4MXENWAIAAAAx\nM3EOWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8yODZxD1gCAAAAMTNxEFgbAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMjg0cRFYAgAAADEzcRJYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzI4NXETWAIAAAAxM3EUWBoAAABjb21tZW50X3N1cHBsaWVyX19jb250YWluc3EVWAAAAABY\nBgAAAHN0YXR1c3EWWAAAAABYFgAAAGJyYW5kX190aXRsZV9fY29udGFpbnNxF1gAAAAAWCAAAABw\nYXJ0X251bWJlcl9zdXBlcnNlZGVkX19jb250YWluc3EYWAAAAABYGwAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzI3OHEZWAIAAAAxM3EaWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8yNzdx\nG1gCAAAAMTNxHFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjc2cR1YAgAAADEzcR5YGwAA\nAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzI3NXEfWAIAAAAxM3EgWBsAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF8yNzRxIVgCAAAAMTNxIlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMjcz\ncSNYAgAAADEzcSRYGwAAAGJyYW5kZ3JvdXBfX3RpdGxlX19jb250YWluc3ElWAAAAABYFQAAAHBh\ncnRfbnVtYmVyX19jb250YWluc3EmWAAAAABYFgAAAGludm9pY2VfY29kZV9fY29udGFpbnNxJ1gD\nAAAAIzk1cShYCQAAAHFzX2ZpbHRlcnEpWAEAAAAxWBgAAABkZXNjcmlwdGlvbl9ydV9fY29udGFp\nbnNxKlgAAAAAWBoAAABjbGllbnRfX3VzZXJuYW1lX19jb250YWluc3ErWAAAAABYGAAAAGRlc2Ny\naXB0aW9uX2VuX19jb250YWluc3EsWAAAAAB1dVUSX2F1dGhfdXNlcl9iYWNrZW5kcS1VKWRqYW5n\nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcS5VF2NwX2luZGV4X2l0ZW1zX3Bl\ncl9wYWdlcS9YAgAAADIwcTB1LjBhYjUwN2MxNDJjNGEzYWNmYjRmZDE1YmFkZTllNDUw\n	2011-04-06 06:28:24.396504+02
184dadbca8ec52a6504e5038b8172390	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-04-08 15:19:01.652464+02
a7aec5d3abf95bafd74ddc0569c1f63e	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwJ1LmVkN2EyN2Y0NDU4MWVkN2IyMzIw\nYTQ3NjIxNzhkYmNm\n	2011-04-06 19:33:38.089748+02
ac8ba41a69047dc8e08beebfc1b4e173	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-06 23:02:18.471796+02
cacfd0ee74d17210229ea42e16155dab	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUJcXNfZmlsdGVycQN9cQQoVQRwYXRocQVYBAAAAC9j\ncC9xBlUEZGF0YXEHfXEIKFgVAAAAYXJlYV9fdGl0bGVfX2NvbnRhaW5zcQlYAAAAAFgcAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQyOHEKWAIAAAAxM3ELWBwAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8xNDI5cQxYAgAAADEzcQ1YHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MjBx\nDlgEAAAAMTMuMHEPWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDgycRBYAgAAADEzcRFY\nHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MjJxElgCAAAAMTNxE1gcAAAAZGVsaXZlcnlf\nc3VwcGxpZXJfaW5wdXRfMTQyM3EUWAIAAAAxM3EVWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8xNDI0cRZYAgAAADEzcRdYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MjVxGFgCAAAA\nMTNxGVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQyNnEaWAIAAAAxM3EbWBwAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8xNDI3cRxYAgAAADEzcR1YFgAAAGJyYW5kX190aXRsZV9fY29u\ndGFpbnNxHlgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDg4cR9YAgAAADEzcSBY\nHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0ODlxIVgCAAAAMTNxIlgcAAAAZGVsaXZlcnlf\nc3VwcGxpZXJfaW5wdXRfMTQ4NnEjWAIAAAAxM3EkWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8xNDg3cSVYAgAAADEzcSZYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0ODRxJ1gCAAAA\nMTNxKFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ4NXEpWAIAAAAxM3EqWAkAAABxc19m\naWx0ZXJxK1gBAAAAMVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ4M3EsWAIAAAAxM3Et\nWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDgwcS5YAgAAADEzcS9YHAAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzE0ODFxMFgCAAAAMTNxMVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMTQzOXEyWAIAAAAxM3EzWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDM4cTRYAgAA\nADEzcTVYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MzNxNlgCAAAAMTNxN1gcAAAAZGVs\naXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQzMnE4WAIAAAAxM3E5WBwAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8xNDMxcTpYAgAAADEzcTtYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MzBx\nPFgCAAAAMTNxPVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQzN3E+WAIAAAAxM3E/WBwA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDM2cUBYAgAAADEzcUFYHAAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzE0MzVxQlgCAAAAMTNxQ1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMTQzNHFEWAIAAAAxM3FFWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDkxcUZYAgAAADEz\ncUdYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0OTBxSFgCAAAAMTNxSVgcAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMTQ5M3FKWAIAAAAxM3FLWBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xNDkycUxYAgAAADEzcU1YHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0OTVxTlgC\nAAAAMTNxT1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ5NHFQWAIAAAAxM3FRWBwAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDk3cVJYAgAAADEzcVNYHAAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzE0OTZxVFgCAAAAMTNxVVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQw\nNHFWWAQAAAAxMy4wcVdYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MDJxWFgCAAAAMTNx\nWVgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQwM3FaWAIAAAAxM3FbWBwAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8xNDAwcVxYAgAAADEzcV1YHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lu\ncHV0XzE0MDFxXlgCAAAAMTNxX1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQwOHFgWAQA\nAAAxMy4wcWFYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MDlxYlgEAAAAMTMuMHFjWBwA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzk2cWRYAgAAADEzcWVYHAAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzEzOTdxZlgCAAAAMTNxZ1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMTM5NHFoWAIAAAAxM3FpWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMzk1cWpYAgAAADEz\ncWtYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEzOThxbFgCAAAAMTNxbVgcAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMTM5OXFuWAIAAAAxM3FvWCAAAABwYXJ0X251bWJlcl9zdXBlcnNl\nZGVkX19jb250YWluc3FwWAAAAABYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NjRxcVgC\nAAAAMTNxclgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ2NXFzWAIAAAAxM3F0WBwAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDY2cXVYAgAAADEzcXZYHAAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzE0Njdxd1gCAAAAMTNxeFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ2\nMHF5WAIAAAAxM3F6WBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDYxcXtYAgAAADEzcXxY\nHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NjJxfVgCAAAAMTNxflgcAAAAZGVsaXZlcnlf\nc3VwcGxpZXJfaW5wdXRfMTQ2M3F/WAIAAAAxM3GAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF8xNDY4cYFYAgAAADEzcYJYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0Njlxg1gCAAAA\nMTNxhFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQxMXGFWAIAAAAxM3GGWBwAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8xNDEwcYdYBAAAADEzLjBxiFgcAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfMTQxM3GJWAIAAAAxM3GKWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDE1\ncYtYAgAAADEzcYxYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MTRxjVgCAAAAMTNxjlgc\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQxN3GPWAIAAAAxM3GQWBwAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF8xNDE2cZFYAgAAADEzcZJYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzE0MTlxk1gCAAAAMTNxlFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQxOHGVWAIAAAAx\nM3GWWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDIxcZdYAgAAADEzcZhYFgAAAGludm9p\nY2VfY29kZV9fY29udGFpbnNxmVgDAAAAMTA0cZpYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzE0Nzdxm1gCAAAAMTNxnFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ3NnGdWAIAAAAx\nM3GeWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDc1cZ9YAgAAADEzcaBYHAAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzE0NzRxoVgCAAAAMTNxolgcAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfMTQ3M3GjWAIAAAAxM3GkWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDcycaVY\nAgAAADEzcaZYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NzFxp1gCAAAAMTNxqFgcAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ3MHGpWAIAAAAxM3GqWBwAAABkZWxpdmVyeV9zdXBw\nbGllcl9pbnB1dF8xNDc5catYAgAAADEzcaxYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0\nNzhxrVgCAAAAMTNxrlgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ0MnGvWAIAAAAxM3Gw\nWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDQzcbFYAgAAADEzcbJYHAAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzE0NDBxs1gCAAAAMTNxtFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5w\ndXRfMTQ0MXG1WAIAAAAxM3G2WBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDQ2cbdYBAAA\nADEzLjBxuFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ0N3G5WAIAAAAxM3G6WBwAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDQ0cbtYAgAAADEzcbxYHAAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzE0NDVxvVgEAAAAMTMuMHG+WBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8x\nNDQ4cb9YAgAAADEzccBYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NDlxwVgCAAAAMTNx\nwlgaAAAAY2xpZW50X191c2VybmFtZV9fY29udGFpbnNxw1gAAAAAWBsAAABtYW5hZ2VyX191c2Vy\nbmFtZV9fY29udGFpbnNxxFgAAAAAWBoAAABjb21tZW50X3N1cHBsaWVyX19jb250YWluc3HFWAAA\nAABYBgAAAHN0YXR1c3HGWAAAAABYGwAAAGJyYW5kZ3JvdXBfX3RpdGxlX19jb250YWluc3HHWAAA\nAABYGAAAAGRlc2NyaXB0aW9uX2VuX19jb250YWluc3HIWAAAAABYGAAAAGRlc2NyaXB0aW9uX3J1\nX19jb250YWluc3HJWAAAAABYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NTlxylgCAAAA\nMTNxy1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ1OHHMWAIAAAAxM3HNWBUAAABwYXJ0\nX251bWJlcl9fY29udGFpbnNxzlgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDU1\ncc9YAgAAADEzcdBYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0NTRx0VgCAAAAMTNx0lgc\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ1N3HTWAIAAAAxM3HUWBwAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF8xNDU2cdVYAgAAADEzcdZYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzE0NTFx11gCAAAAMTNx2FgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQ1MHHZWAIAAAAx\nM3HaWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xNDUzcdtYAgAAADEzcdxYHAAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzE0NTJx3VgCAAAAMTNx3nV1VRJfYXV0aF91c2VyX2JhY2tlbmRx\n31UpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmRx4FUXY3BfaW5kZXhf\naXRlbXNfcGVyX3BhZ2Vx4VgDAAAAMTAwceJ1LjJhMzExNDJhZTlmMTU1Zjc5YmQwMzQ4NDAzMjg3\nYzZm\n	2011-04-09 06:43:08.851111+02
fa8a45b5c1109288a59c1f42e5bc0bf6	gAJ9cQEoVQlxc19maWx0ZXJxAn1xAyhVBHBhdGhxBFgEAAAAL2NwL3EFVQRkYXRhcQZ9cQcoWAYA\nAABzdGF0dXNxCFgAAAAAWBYAAABicmFuZF9fdGl0bGVfX2NvbnRhaW5zcQlYAAAAAFggAAAAcGFy\ndF9udW1iZXJfc3VwZXJzZWRlZF9fY29udGFpbnNxClgAAAAAWBoAAABjbGllbnRfX3VzZXJuYW1l\nX19jb250YWluc3ELWAAAAABYGwAAAG1hbmFnZXJfX3VzZXJuYW1lX19jb250YWluc3EMWAAAAABY\nGwAAAGJyYW5kZ3JvdXBfX3RpdGxlX19jb250YWluc3ENWAAAAABYFQAAAHBhcnRfbnVtYmVyX19j\nb250YWluc3EOWAAAAABYFgAAAGludm9pY2VfY29kZV9fY29udGFpbnNxD1gAAAAAWBUAAABhcmVh\nX190aXRsZV9fY29udGFpbnNxEFgEAAAARWJheXERWBgAAABkZXNjcmlwdGlvbl9lbl9fY29udGFp\nbnNxElgAAAAAWAkAAABxc19maWx0ZXJxE1gBAAAAMVgaAAAAY29tbWVudF9zdXBwbGllcl9fY29u\ndGFpbnNxFFgAAAAAWBgAAABkZXNjcmlwdGlvbl9ydV9fY29udGFpbnNxFVgAAAAAdXVVEl9hdXRo\nX3VzZXJfYmFja2VuZHEWVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2Vu\nZHEXVQ1fYXV0aF91c2VyX2lkcRhLAnUuMmU0M2JhZWZhZDY4NTJhY2M2YWUxMWY5OTgxMjY0MDE=\n	2011-04-07 19:06:21.383004+02
a87d55916e2e1f60874df57fc495f6b6	gAJ9cQEoVQ5pdGVtc19wZXJfcGFnZXECWAIAAAA1MHEDVQ1fYXV0aF91c2VyX2lkcQRLBFUSX2F1\ndGhfdXNlcl9iYWNrZW5kcQVVKWRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNr\nZW5kcQZ1LmY2ODIwMjlhMTA1NjhmNDQ2NDM4NGQyOWE0Zjg3N2Q3\n	2011-04-09 14:31:27.851103+02
c99037b8eacdf4d3796bf9e9ce298490	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAIAAAA1MHEDVQlxc19maWx0ZXJxBH1x\nBShVBHBhdGhxBlgEAAAAL2NwL3EHVQRkYXRhcQh9cQkoWBsAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF80NTNxClgCAAAAMTNxC1gbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTMxcQxYAgAA\nADEzcQ1YGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1MXEOWAIAAAAxM3EPWBsAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF80NTBxEFgCAAAAMTNxEVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJf\naW5wdXRfNTQ3cRJYAgAAADEzcRNYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ3MnEUWAQA\nAAAxMy4wcRVYGwAAAG1hbmFnZXJfX3VzZXJuYW1lX19jb250YWluc3EWWAAAAABYGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzQzM3EXWAQAAAAxMy4wcRhYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVy\nX2lucHV0XzUxOXEZWAIAAAAxM3EaWBUAAABhcmVhX190aXRsZV9fY29udGFpbnNxG1gAAAAAWBsA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81MTBxHFgEAAAAMTMuMHEdWBsAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF81MTFxHlgEAAAAMTMuMHEfWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1\ndF81MTZxIFgEAAAAMTMuMHEhWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81NzFxIlgEAAAA\nMTMuMHEjWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF81NTlxJFgEAAAAMTMuMHElWAkAAABx\nc19maWx0ZXJxJlgBAAAAMVgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNTYzcSdYBAAAADEz\nLjBxKFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDQ4cSlYAgAAADEzcSpYGwAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzU2MHErWAQAAAAxMy4wcSxYGgAAAGNvbW1lbnRfc3VwcGxpZXJf\nX2NvbnRhaW5zcS1YAAAAAFgGAAAAc3RhdHVzcS5YAAAAAFgWAAAAYnJhbmRfX3RpdGxlX19jb250\nYWluc3EvWAAAAABYIAAAAHBhcnRfbnVtYmVyX3N1cGVyc2VkZWRfX2NvbnRhaW5zcTBYAAAAAFgb\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDQ2cTFYAgAAADEzcTJYGwAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzQ0N3EzWAIAAAAxM3E0WBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8z\nMzJxNVgCAAAAMTNxNlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDQ5cTdYAgAAADEzcThY\nGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM1N3E5WAIAAAAxM3E6WBsAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF81MDlxO1gEAAAAMTMuMHE8WBsAAABicmFuZGdyb3VwX190aXRsZV9fY29u\ndGFpbnNxPVgAAAAAWBUAAABwYXJ0X251bWJlcl9fY29udGFpbnNxPlgAAAAAWBsAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF81NDJxP1gCAAAAMTNxQFgWAAAAaW52b2ljZV9jb2RlX19jb250YWlu\nc3FBWAMAAAAjOTVxQlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDIwcUNYAgAAADEzcURY\nGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzU0NnFFWAIAAAAxM3FGWBsAAABkZWxpdmVyeV9z\ndXBwbGllcl9pbnB1dF81NDhxR1gCAAAAMTNxSFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nNTY0cUlYBAAAADEzLjBxSlgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfNDY2cUtYBAAAADEz\nLjBxTFgYAAAAZGVzY3JpcHRpb25fcnVfX2NvbnRhaW5zcU1YAAAAAFgaAAAAY2xpZW50X191c2Vy\nbmFtZV9fY29udGFpbnNxTlgAAAAAWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8zOTJxT1gC\nAAAAMTNxUFgbAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMzkzcVFYAgAAADEzcVJYGwAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM5NXFTWAQAAAAxMy4wcVRYGwAAAGRlbGl2ZXJ5X3N1cHBs\naWVyX2lucHV0XzM5NnFVWAQAAAAxMy4wcVZYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzM5\nMHFXWAQAAAAxMy4wcVhYGwAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzQ1MnFZWAIAAAAxM3Fa\nWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80ODJxW1gEAAAAMTMuMHFcWBgAAABkZXNjcmlw\ndGlvbl9lbl9fY29udGFpbnNxXVgAAAAAWBsAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF80MzRx\nXlgEAAAAMTMuMHFfdXVVDV9hdXRoX3VzZXJfaWRxYEsBVRJfYXV0aF91c2VyX2JhY2tlbmRxYVUp\nZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmRxYnUuZTQ4MWZkYjVjN2Zi\nN2RiNTc4ZWUyNDZmNDRhYWI0MGQ=\n	2011-04-06 14:35:31.532421+02
136c23152c9f41dc39f2b2f1449db038	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UJcXNfZmlsdGVycQR9\ncQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0YXEIfXEJKFgGAAAAc3RhdHVzcQpYAAAAAFgWAAAA\nYnJhbmRfX3RpdGxlX19jb250YWluc3ELWAAAAABYIAAAAHBhcnRfbnVtYmVyX3N1cGVyc2VkZWRf\nX2NvbnRhaW5zcQxYAAAAAFgaAAAAY2xpZW50X191c2VybmFtZV9fY29udGFpbnNxDVgAAAAAWBsA\nAABtYW5hZ2VyX191c2VybmFtZV9fY29udGFpbnNxDlgAAAAAWBsAAABicmFuZGdyb3VwX190aXRs\nZV9fY29udGFpbnNxD1gAAAAAWBUAAABwYXJ0X251bWJlcl9fY29udGFpbnNxEFgAAAAAWBYAAABp\nbnZvaWNlX2NvZGVfX2NvbnRhaW5zcRFYAAAAAFgVAAAAYXJlYV9fdGl0bGVfX2NvbnRhaW5zcRJY\nAAAAAFgYAAAAZGVzY3JpcHRpb25fZW5fX2NvbnRhaW5zcRNYAAAAAFgbAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfNDYwcRRYAgAAADEzcRVYCQAAAHFzX2ZpbHRlcnEWWAEAAAAxWBoAAABjb21t\nZW50X3N1cHBsaWVyX19jb250YWluc3EXWAAAAABYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzE1MDFxGFgCAAAAMTNxGVgYAAAAZGVzY3JpcHRpb25fcnVfX2NvbnRhaW5zcRpYAAAAAHV1VQ1f\nYXV0aF91c2VyX2lkcRtLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcRxVKWRqYW5nby5jb250cmliLmF1\ndGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcR11LjUyMjgwZTY5MmEwZDBlOGFiNDNiZGI4YzQ3MGFh\nOGY3\n	2011-04-07 16:12:14.016289+02
e31fead6a8083fe81c3de9db18163920	gAJ9cQEoVQlxc19maWx0ZXJxAn1xAyhVBHBhdGhxBFgEAAAAL2NwL3EFVQRkYXRhcQZ9cQcoWBsA\nAABtYW5hZ2VyX191c2VybmFtZV9fY29udGFpbnNxCFgAAAAAWBgAAABkZXNjcmlwdGlvbl9lbl9f\nY29udGFpbnNxCVgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjgxcQpYBAAAADEz\nLjBxC1gcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI2OHEMWAQAAAAxMy4wcQ1YHAAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNjlxDlgEAAAAMTMuMHEPWBUAAABhcmVhX190aXRsZV9f\nY29udGFpbnNxEFgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjYwcRFYAgAAADEz\ncRJYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNjZxE1gCAAAAMTNxFFgcAAAAZGVsaXZl\ncnlfc3VwcGxpZXJfaW5wdXRfMTI0MnEVWAIAAAAxM3EWWBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xMjY1cRdYAgAAADEzcRhYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNjRxGVgC\nAAAAMTNxGlgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI5M3EbWAIAAAAxM3EcWBwAAABk\nZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjkycR1YAgAAADEzcR5YGgAAAGNvbW1lbnRfc3VwcGxp\nZXJfX2NvbnRhaW5zcR9YAAAAAFgGAAAAc3RhdHVzcSBYAAAAAFgWAAAAYnJhbmRfX3RpdGxlX19j\nb250YWluc3EhWAAAAABYIAAAAHBhcnRfbnVtYmVyX3N1cGVyc2VkZWRfX2NvbnRhaW5zcSJYAAAA\nAFgbAAAAYnJhbmRncm91cF9fdGl0bGVfX2NvbnRhaW5zcSNYAAAAAFgcAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMTI3NXEkWAQAAAAxMy4wcSVYFQAAAHBhcnRfbnVtYmVyX19jb250YWluc3Em\nWAAAAABYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyNzZxJ1gEAAAAMTMuMHEoWBYAAABp\nbnZvaWNlX2NvZGVfX2NvbnRhaW5zcSlYAwAAADEwM3EqWBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xMjczcStYBAAAADEzLjBxLFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI3MnEt\nWAQAAAAxMy4wcS5YCQAAAHFzX2ZpbHRlcnEvWAEAAAAxWBgAAABkZXNjcmlwdGlvbl9ydV9fY29u\ndGFpbnNxMFgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjc0cTFYBAAAADEzLjBx\nMlgaAAAAY2xpZW50X191c2VybmFtZV9fY29udGFpbnNxM1gDAAAANjIycTRYHAAAAGRlbGl2ZXJ5\nX3N1cHBsaWVyX2lucHV0XzEyODBxNVgEAAAAMTMuMHE2WBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xMjcxcTdYBAAAADEzLjBxOFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI4MnE5\nWAQAAAAxMy4wcTpYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyODNxO1gCAAAAMTNxPFgc\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTI4NHE9WAIAAAAxM3E+dXVVDV9hdXRoX3VzZXJf\naWRxP0sCVRJfYXV0aF91c2VyX2JhY2tlbmRxQFUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxQXUuZDEzZTBmNzM3MzBjN2Y1MTgxNDI5YTllMWM3ZjgwZjg=\n	2011-04-06 16:28:25.385242+02
fa0cadca15038e99ded6472f8f8ecdd7	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-07 22:07:02.63771+02
5795926b16a2ab6443f5d3295c74b25f	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-08 19:44:24.524785+02
34ac555878a4a6b4099ca7d9b7dc1e86	gAJ9cQEuMDY1MzZkN2M1MDgyMzJlNDRhYTg3YmM3MTk2ZDI3NzE=\n	2011-04-09 19:43:25.794784+02
2490d3b89c62cc0a4c515202e8162b74	gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAlUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j\nb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmI0Mzc4OGQwOGUwOTZlNjU0MGNh\nZThjNGE2NzFjMTRj\n	2011-04-07 17:25:12.362661+02
88fc5253ea921f91c2b5e57db573fcb3	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz\nYzE1YmQxNGQ2MDFi\n	2011-04-08 17:23:54.667658+02
74a9d3177ae497b596f81d312ce0db20	gAJ9cQEoVQlxc19maWx0ZXJxAn1xAyhVBHBhdGhxBFgEAAAAL2NwL3EFVQRkYXRhcQZ9cQcoWBsA\nAABtYW5hZ2VyX191c2VybmFtZV9fY29udGFpbnNxCFgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8xMTgycQlYAgAAADEzcQpYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyMDJx\nC1gCAAAAMTNxDFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTIwM3ENWAIAAAAxM3EOWBwA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjA0cQ9YAgAAADEzcRBYHAAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzEyMDVxEVgCAAAAMTNxElgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMTIwNnETWAIAAAAxM3EUWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMTg5cRVYAgAAADEz\ncRZYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzExNzJxF1gEAAAAMTMuMHEYWBwAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8xMTcxcRlYBAAAADEzLjBxGlgcAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfMTE3NnEbWAIAAAAxM3EcWBUAAABhcmVhX190aXRsZV9fY29udGFpbnNxHVgAAAAA\nWBoAAABjb21tZW50X3N1cHBsaWVyX19jb250YWluc3EeWAAAAABYBgAAAHN0YXR1c3EfWAAAAABY\nFgAAAGJyYW5kX190aXRsZV9fY29udGFpbnNxIFgAAAAAWCAAAABwYXJ0X251bWJlcl9zdXBlcnNl\nZGVkX19jb250YWluc3EhWAAAAABYGwAAAGJyYW5kZ3JvdXBfX3RpdGxlX19jb250YWluc3EiWAAA\nAABYFQAAAHBhcnRfbnVtYmVyX19jb250YWluc3EjWAoAAAAwMDAwMThCUDAxcSRYHAAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzEyMTFxJVgCAAAAMTNxJlgWAAAAaW52b2ljZV9jb2RlX19jb250\nYWluc3EnWAMAAAAxMDRxKFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTE5NnEpWAIAAAAx\nM3EqWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMTk3cStYAgAAADEzcSxYCQAAAHFzX2Zp\nbHRlcnEtWAEAAAAxWBgAAABkZXNjcmlwdGlvbl9ydV9fY29udGFpbnNxLlgAAAAAWBoAAABjbGll\nbnRfX3VzZXJuYW1lX19jb250YWluc3EvWAAAAABYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0\nXzExODFxMFgCAAAAMTNxMVgYAAAAZGVzY3JpcHRpb25fZW5fX2NvbnRhaW5zcTJYAAAAAFgcAAAA\nZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTE4NnEzWAIAAAAxM3E0dXVVEl9hdXRoX3VzZXJfYmFj\na2VuZHE1VSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHE2VQ1fYXV0\naF91c2VyX2lkcTdLAXUuNjNiMjRiYzVmZmY0YWZkNjFmNDU4MzFkOWIxZWMxNTU=\n	2011-04-09 06:49:46.997866+02
58244aed8da778baf89175e17ab91f30	gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k\ncy5Nb2RlbEJhY2tlbmRxA1UJcXNfZmlsdGVycQR9cQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0\nYXEIfXEJKFgGAAAAc3RhdHVzcQpYAAAAAFgWAAAAYnJhbmRfX3RpdGxlX19jb250YWluc3ELWAAA\nAABYIAAAAHBhcnRfbnVtYmVyX3N1cGVyc2VkZWRfX2NvbnRhaW5zcQxYAAAAAFgVAAAAcGFydF9u\ndW1iZXJfX2NvbnRhaW5zcQ1YAAAAAFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTQyMHEO\nWAQAAAAxMy4wcQ9YGwAAAG1hbmFnZXJfX3VzZXJuYW1lX19jb250YWluc3EQWAAAAABYHAAAAGRl\nbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzE0MDRxEVgEAAAAMTMuMHESWBsAAABicmFuZGdyb3VwX190\naXRsZV9fY29udGFpbnNxE1gAAAAAWBoAAABjb21tZW50X3N1cHBsaWVyX19jb250YWluc3EUWAAA\nAABYGgAAAGNsaWVudF9fdXNlcm5hbWVfX2NvbnRhaW5zcRVYAAAAAFgcAAAAZGVsaXZlcnlfc3Vw\ncGxpZXJfaW5wdXRfMTM0N3EWWAQAAAAxMy4wcRdYFgAAAGludm9pY2VfY29kZV9fY29udGFpbnNx\nGFgEAAAAIzEwNHEZWBUAAABhcmVhX190aXRsZV9fY29udGFpbnNxGlgAAAAAWBwAAABkZWxpdmVy\neV9zdXBwbGllcl9pbnB1dF8xMjMxcRtYAgAAADEzcRxYGAAAAGRlc2NyaXB0aW9uX2VuX19jb250\nYWluc3EdWAAAAABYCQAAAHFzX2ZpbHRlcnEeWAEAAAAxWBwAAABkZWxpdmVyeV9zdXBwbGllcl9p\nbnB1dF8xMjg1cR9YAgAAADEzcSBYGAAAAGRlc2NyaXB0aW9uX3J1X19jb250YWluc3EhWAAAAAB1\ndVUNX2F1dGhfdXNlcl9pZHEiSwFVF2NwX2luZGV4X2l0ZW1zX3Blcl9wYWdlcSNYAwAAADEwMHEk\ndS43MDQwMDQ1YWFhZWYzOWEwMDA5OTQ2NDVlODg4Yjg1Mg==\n	2011-04-09 15:11:27.883105+02
ef97cda3cad565c74f1d98bfb25a8f1e	gAJ9cQEoVRdjcF9pbmRleF9pdGVtc19wZXJfcGFnZXECWAMAAAAxMDBxA1UJcXNfZmlsdGVycQR9\ncQUoVQRwYXRocQZYBAAAAC9jcC9xB1UEZGF0YXEIfXEJKFgGAAAAc3RhdHVzcQpYAAAAAFgWAAAA\nYnJhbmRfX3RpdGxlX19jb250YWluc3ELWAAAAABYIAAAAHBhcnRfbnVtYmVyX3N1cGVyc2VkZWRf\nX2NvbnRhaW5zcQxYAAAAAFgaAAAAY2xpZW50X191c2VybmFtZV9fY29udGFpbnNxDVgAAAAAWBsA\nAABtYW5hZ2VyX191c2VybmFtZV9fY29udGFpbnNxDlgAAAAAWBsAAABicmFuZGdyb3VwX190aXRs\nZV9fY29udGFpbnNxD1gAAAAAWBUAAABwYXJ0X251bWJlcl9fY29udGFpbnNxEFgAAAAAWBYAAABp\nbnZvaWNlX2NvZGVfX2NvbnRhaW5zcRFYBAAAACMxMDRxElgVAAAAYXJlYV9fdGl0bGVfX2NvbnRh\naW5zcRNYAAAAAFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTE5OHEUWAIAAAAxM3EVWBgA\nAABkZXNjcmlwdGlvbl9lbl9fY29udGFpbnNxFlgAAAAAWAkAAABxc19maWx0ZXJxF1gBAAAAMVga\nAAAAY29tbWVudF9zdXBwbGllcl9fY29udGFpbnNxGFgAAAAAWBgAAABkZXNjcmlwdGlvbl9ydV9f\nY29udGFpbnNxGVgAAAAAdXVVDV9hdXRoX3VzZXJfaWRxGksBVRJfYXV0aF91c2VyX2JhY2tlbmRx\nG1UpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmRxHHUuNTFmMmUzMjY3\nODFlYTllZDQ4NjBiZTc3NTVkYjk0MTA=\n	2011-04-09 14:03:06.920966+02
c1782dfa8b31cd7f68e7bcb166e6ffbc	gAJ9cQEoVQlxc19maWx0ZXJxAn1xAyhVBHBhdGhxBFgEAAAAL2NwL3EFVQRkYXRhcQZ9cQcoWBsA\nAABtYW5hZ2VyX191c2VybmFtZV9fY29udGFpbnNxCFgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGll\ncl9pbnB1dF8xMTgycQlYAgAAADEzcQpYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzEyMDJx\nC1gCAAAAMTNxDFgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTIwM3ENWAIAAAAxM3EOWBwA\nAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMjA0cQ9YAgAAADEzcRBYHAAAAGRlbGl2ZXJ5X3N1\ncHBsaWVyX2lucHV0XzEyMDVxEVgCAAAAMTNxElgcAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRf\nMTIwNnETWAIAAAAxM3EUWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMTg5cRVYAgAAADEz\ncRZYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzExNzJxF1gEAAAAMTMuMHEYWBwAAABkZWxp\ndmVyeV9zdXBwbGllcl9pbnB1dF8xMTcxcRlYBAAAADEzLjBxGlgcAAAAZGVsaXZlcnlfc3VwcGxp\nZXJfaW5wdXRfMTE3NnEbWAIAAAAxM3EcWBUAAABhcmVhX190aXRsZV9fY29udGFpbnNxHVgAAAAA\nWBoAAABjb21tZW50X3N1cHBsaWVyX19jb250YWluc3EeWAAAAABYBgAAAHN0YXR1c3EfWAAAAABY\nFgAAAGJyYW5kX190aXRsZV9fY29udGFpbnNxIFgAAAAAWCAAAABwYXJ0X251bWJlcl9zdXBlcnNl\nZGVkX19jb250YWluc3EhWAAAAABYGwAAAGJyYW5kZ3JvdXBfX3RpdGxlX19jb250YWluc3EiWAAA\nAABYFQAAAHBhcnRfbnVtYmVyX19jb250YWluc3EjWAoAAAA5MjE4MjFBQTBDcSRYHAAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzEyMTFxJVgCAAAAMTNxJlgWAAAAaW52b2ljZV9jb2RlX19jb250\nYWluc3EnWAAAAABYHAAAAGRlbGl2ZXJ5X3N1cHBsaWVyX2lucHV0XzExOTZxKFgCAAAAMTNxKVgc\nAAAAZGVsaXZlcnlfc3VwcGxpZXJfaW5wdXRfMTE5N3EqWAIAAAAxM3ErWAkAAABxc19maWx0ZXJx\nLFgBAAAAMVgYAAAAZGVzY3JpcHRpb25fcnVfX2NvbnRhaW5zcS1YAAAAAFgaAAAAY2xpZW50X191\nc2VybmFtZV9fY29udGFpbnNxLlgAAAAAWBwAAABkZWxpdmVyeV9zdXBwbGllcl9pbnB1dF8xMTgx\ncS9YAgAAADEzcTBYGAAAAGRlc2NyaXB0aW9uX2VuX19jb250YWluc3ExWAAAAABYHAAAAGRlbGl2\nZXJ5X3N1cHBsaWVyX2lucHV0XzExODZxMlgCAAAAMTNxM3V1VRJfYXV0aF91c2VyX2JhY2tlbmRx\nNFUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmRxNVUNX2F1dGhfdXNl\ncl9pZHE2SwF1LjNlN2MyNGY5OTc5YjhiMzNiYzIzMjA1ODRiNWQzNGQ5\n	2011-04-09 06:46:06.872199+02
\.


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: -
--

COPY django_site (id, domain, name) FROM stdin;
1	example.com	example.com
\.


--
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions_group_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_key UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_message_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auth_message
    ADD CONSTRAINT auth_message_pkey PRIMARY KEY (id);


--
-- Name: auth_permission_content_type_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_key UNIQUE (content_type_id, codename);


--
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_key UNIQUE (user_id, group_id);


--
-- Name: auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_key UNIQUE (user_id, permission_id);


--
-- Name: auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: data_area_brands_area_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY data_area_brands
    ADD CONSTRAINT data_area_brands_area_id_key UNIQUE (area_id, brand_id);


--
-- Name: data_area_brands_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY data_area_brands
    ADD CONSTRAINT data_area_brands_pkey PRIMARY KEY (id);


--
-- Name: data_area_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY data_area
    ADD CONSTRAINT data_area_pkey PRIMARY KEY (id);


--
-- Name: data_brand_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY data_brand
    ADD CONSTRAINT data_brand_pkey PRIMARY KEY (id);


--
-- Name: data_brandgroup_area_brandgroup_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY data_brandgroup_area
    ADD CONSTRAINT data_brandgroup_area_brandgroup_id_key UNIQUE (brandgroup_id, area_id);


--
-- Name: data_brandgroup_area_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY data_brandgroup_area
    ADD CONSTRAINT data_brandgroup_area_pkey PRIMARY KEY (id);


--
-- Name: data_brandgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY data_brandgroup
    ADD CONSTRAINT data_brandgroup_pkey PRIMARY KEY (id);


--
-- Name: data_direction_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY data_direction
    ADD CONSTRAINT data_direction_pkey PRIMARY KEY (id);


--
-- Name: data_discount_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY data_discount
    ADD CONSTRAINT data_discount_pkey PRIMARY KEY (id);


--
-- Name: data_discount_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY data_discount
    ADD CONSTRAINT data_discount_user_id_key UNIQUE (user_id, area_id);


--
-- Name: data_ordereditem_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY data_ordereditem
    ADD CONSTRAINT data_ordereditem_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type_app_label_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_key UNIQUE (app_label, model);


--
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: auth_message_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX auth_message_user_id ON auth_message USING btree (user_id);


--
-- Name: auth_permission_content_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX auth_permission_content_type_id ON auth_permission USING btree (content_type_id);


--
-- Name: data_brandgroup_direction_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_brandgroup_direction_id ON data_brandgroup USING btree (direction_id);


--
-- Name: data_discount_area_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_discount_area_id ON data_discount USING btree (area_id);


--
-- Name: data_discount_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_discount_user_id ON data_discount USING btree (user_id);


--
-- Name: data_ordereditem_area_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_ordereditem_area_id ON data_ordereditem USING btree (area_id);


--
-- Name: data_ordereditem_brand_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_ordereditem_brand_id ON data_ordereditem USING btree (brand_id);


--
-- Name: data_ordereditem_brandgroup_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_ordereditem_brandgroup_id ON data_ordereditem USING btree (brandgroup_id);


--
-- Name: data_ordereditem_client_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_ordereditem_client_id ON data_ordereditem USING btree (client_id);


--
-- Name: data_ordereditem_manager_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_ordereditem_manager_id ON data_ordereditem USING btree (manager_id);


--
-- Name: django_admin_log_content_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX django_admin_log_content_type_id ON django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX django_admin_log_user_id ON django_admin_log USING btree (user_id);


--
-- Name: auth_group_permissions_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_fkey FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_message_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_message
    ADD CONSTRAINT auth_message_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: content_type_id_refs_id_728de91f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT content_type_id_refs_id_728de91f FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: data_area_brands_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY data_area_brands
    ADD CONSTRAINT data_area_brands_area_id_fkey FOREIGN KEY (area_id) REFERENCES data_area(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: data_area_brands_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY data_area_brands
    ADD CONSTRAINT data_area_brands_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES data_brand(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: data_brandgroup_area_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY data_brandgroup_area
    ADD CONSTRAINT data_brandgroup_area_area_id_fkey FOREIGN KEY (area_id) REFERENCES data_area(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: data_brandgroup_area_brandgroup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY data_brandgroup_area
    ADD CONSTRAINT data_brandgroup_area_brandgroup_id_fkey FOREIGN KEY (brandgroup_id) REFERENCES data_brandgroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: data_brandgroup_direction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY data_brandgroup
    ADD CONSTRAINT data_brandgroup_direction_id_fkey FOREIGN KEY (direction_id) REFERENCES data_direction(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: data_discount_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY data_discount
    ADD CONSTRAINT data_discount_area_id_fkey FOREIGN KEY (area_id) REFERENCES data_area(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: data_discount_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY data_discount
    ADD CONSTRAINT data_discount_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: data_ordereditem_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY data_ordereditem
    ADD CONSTRAINT data_ordereditem_area_id_fkey FOREIGN KEY (area_id) REFERENCES data_area(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: data_ordereditem_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY data_ordereditem
    ADD CONSTRAINT data_ordereditem_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES data_brand(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: data_ordereditem_brandgroup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY data_ordereditem
    ADD CONSTRAINT data_ordereditem_brandgroup_id_fkey FOREIGN KEY (brandgroup_id) REFERENCES data_brandgroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: data_ordereditem_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY data_ordereditem
    ADD CONSTRAINT data_ordereditem_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: data_ordereditem_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY data_ordereditem
    ADD CONSTRAINT data_ordereditem_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_content_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_fkey FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

