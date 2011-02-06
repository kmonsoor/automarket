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

SELECT pg_catalog.setval('auth_message_id_seq', 138, true);


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

SELECT pg_catalog.setval('auth_user_groups_id_seq', 20, true);


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

SELECT pg_catalog.setval('auth_user_id_seq', 13, true);


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

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 1, false);


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

SELECT pg_catalog.setval('data_area_brands_id_seq', 98, true);


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

SELECT pg_catalog.setval('data_area_id_seq', 62, true);


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

SELECT pg_catalog.setval('data_brand_id_seq', 66, true);


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

SELECT pg_catalog.setval('data_brandgroup_area_id_seq', 99, true);


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

SELECT pg_catalog.setval('data_discount_id_seq', 1, false);


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

SELECT pg_catalog.setval('data_ordereditem_id_seq', 106, true);


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

SELECT pg_catalog.setval('django_admin_log_id_seq', 188, true);


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
3	aps	Александр Моисеевич			sha1$84f79$648cd3d934c6bc8506a3b4efee8a13daa1abb914	f	t	f	2011-01-31 20:53:07.919444+01	2011-01-28 00:28:31+01
4	dp	Дмитрий			sha1$ddb80$8cb17d1fae19ea395eae587e8b6d4e7d557c1605	f	t	f	2011-02-02 19:32:24+01	2011-02-02 19:32:24+01
5	vk	Кирилл			sha1$ddb80$e61d2165fba9751dda13b359e037fcdc5df7052d	f	t	f	2011-02-02 19:34:27+01	2011-02-02 19:34:27+01
6	kp	Константин			sha1$80e59$6c7faa6bdad265803110788f1774030a9b3146e5	f	t	f	2011-02-02 19:36:05+01	2011-02-02 19:36:05+01
7	sx	Александр			sha1$ddb80$3bf60245ce0693cca42a4799d5ff04007ca171e2	f	t	f	2011-02-02 19:37:05+01	2011-02-02 19:37:05+01
10	iv	Игорь			sha1$80e59$d4a9ec3f95a90fdc8dc769feea5a208878df2ddf	f	t	f	2011-02-02 19:42:09+01	2011-02-02 19:42:09+01
13	sg	Сергей			sha1$ddb80$a5e2d326b5346aa65bc95cb39ef23c7e7eb6c8dc	f	t	f	2011-02-02 21:34:48+01	2011-02-02 21:34:48+01
2	user				sha1$cc3c1$7db0411f4e18c13dc6d4874110700ee7e92e8fbd	t	t	f	2011-02-04 01:19:08.670427+01	2011-01-26 23:06:24+01
1	admin			admin@admin.com	sha1$086ae$25886355d6bd8dec52e30ea4bb6411314c1e26ba	t	t	t	2011-02-04 01:19:45.782054+01	2011-01-27 20:59:18.656846+01
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
3	3	1
4	4	1
5	5	1
6	6	1
7	7	1
11	10	1
19	13	1
20	2	1
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: data_area; Type: TABLE DATA; Schema: public; Owner: -
--

COPY data_area (id, title) FROM stdin;
3	Audi
4	Bmw
5	Buick
6	Cadillac
7	Chevrolet/geo
8	Chrysler
9	Dodge
10	Eagle
16	Isuzu
17	Jaguar
18	Jeep
19	Kia
20	Land rover
22	Lincoln
24	Mercury
25	Mitsubishi
27	Oldsmobile
28	Plymouth
29	Pontiac
30	Porsche
31	Saab
32	Saturn
36	Volkswagen
37	Volvo
38	Scion
39	Mercedes-benz
40	Daewoo
41	Hummer
42	Mini
49	Tr
50	Pu
53	Other
58	Ronayers
57	Summit
55	Weathertech
51	Wop
52	Magnum
54	Jaguar
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
43	Turboii
48	Ebay
61	Empireauto
46	Nexpart
62	Rockauto
45	Ekeystone
\.


--
-- Data for Name: data_area_brands; Type: TABLE DATA; Schema: public; Owner: -
--

COPY data_area_brands (id, area_id, brand_id) FROM stdin;
13	58	8
14	58	6
15	58	7
16	57	11
17	57	12
18	57	13
22	55	47
30	51	8
31	51	9
32	51	10
33	51	11
34	51	7
35	52	8
36	52	9
37	52	10
38	52	11
39	52	7
58	54	54
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
85	43	58
86	48	59
87	61	60
88	46	61
89	46	62
93	62	64
94	62	58
95	62	63
96	45	64
97	45	58
98	45	63
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
7	Chevrolet/geo
8	Chrysler
9	Dodge
10	Eagle
11	Ford
12	Gm
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
54	Jaguar
55	Weathertech
56	Bentley
58	Dorman
59	Ebay
60	Taiwan
61	Acdelco
62	Motorcraft
63	Raybestos
64	Anchor
\.


--
-- Data for Name: data_brandgroup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY data_brandgroup (id, direction_id, title, description, delivery, add_brand_to_comment) FROM stdin;
6	2	MOTO		0	f
2	1	DOCAP		0	f
1	1	EXAP		0	f
4	2	OEM		0	f
3	1	DOCVP		0	f
7	2	ONLINE		0	f
5	2	AFTMARK		13	f
\.


--
-- Data for Name: data_brandgroup_area; Type: TABLE DATA; Schema: public; Owner: -
--

COPY data_brandgroup_area (id, brandgroup_id, area_id) FROM stdin;
7	6	4
8	6	5
9	6	6
10	6	7
23	2	52
24	2	53
25	2	54
26	2	55
28	2	57
30	1	57
31	1	58
33	1	55
56	4	33
57	4	2
58	4	35
59	4	40
60	4	11
61	4	12
62	4	13
63	4	14
64	4	15
65	4	34
66	4	17
67	4	19
68	4	20
69	4	21
70	4	23
71	4	25
72	4	26
73	4	47
74	4	30
75	4	31
76	3	23
81	7	48
95	5	46
96	5	43
97	5	61
98	5	62
99	5	45
\.


--
-- Data for Name: data_direction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY data_direction (id, title, po) FROM stdin;
1	MSK	MP
2	US	SP
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
32	4	2	2	1	08L33STX2C0R1	\N			1	\N	\N	4	1	1	Заглушки	END CAP SET	44.219999999999999	39.799999999999997	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.160325+01	2011-02-02 20:34:10.252216+01	
33	4	47	47	1	4609106	\N			1	\N	\N	4	1	1	Концевик двери	Door jamb switch	8.5999999999999996	7.7400000000000002	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.173168+01	2011-02-02 20:34:10.296434+01	
34	4	13	13	1	17220RGLA00	\N			1	\N	\N	4	1	1	Фильтр воздушный	Air filter	23.879999999999999	21.489999999999998	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.182328+01	2011-02-02 20:34:10.313153+01	
35	4	13	13	1	71140TE0A00	\N			1	\N	\N	4	1	1	Ресница бампера	Side support	16.77	15.09	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.190463+01	2011-02-02 20:34:10.326941+01	
36	4	13	13	1	72141TA5A11	\N			1	\N	\N	4	1	1	Ручка двери	Handle outside	12.65	11.390000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.205398+01	2011-02-02 20:34:10.342997+01	
37	4	13	13	1	72142TA5A01	\N			1	\N	\N	4	1	1	Ручка двери	Base	16.27	14.640000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.214936+01	2011-02-02 20:34:10.368611+01	
38	4	13	13	1	72143TA5A11	\N			1	\N	\N	4	1	1	Заглушка ручки	Cover	9.5299999999999994	8.5800000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.229591+01	2011-02-02 20:34:10.478581+01	
39	4	13	13	1	72144TA5A11	\N			1	\N	\N	4	1	1	Прокладка	Holder	3.7200000000000002	3.3500000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.237642+01	2011-02-02 20:34:10.49503+01	
40	4	2	2	1	11910PR3010	\N			1	\N	\N	4	1	1	Кронштейн	BRACKET	53.57	48.210000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.246021+01	2011-02-02 20:34:10.511988+01	
41	4	47	47	1	68001696AA	\N			1	\N	\N	7	1	1	Датчик давления шин	Tire pressure sensor 	55.450000000000003	55.450000000000003	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.256908+01	2011-02-02 20:34:10.529822+01	
42	4	34	34	1	5520078J01	\N			1	\N	\N	4	1	1	Колодки тормозные	Brake pads	84.510000000000005	76.060000000000002	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.268749+01	2011-02-02 20:34:10.545042+01	
43	4	21	21	1	177110P022	\N			1	\N	\N	4	1	1	Корпус фильтра	CASE AIR CLEANER	63.049999999999997	56.75	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.278911+01	2011-02-02 20:34:10.560006+01	
44	4	34	34	1	5580078J03	\N			1	\N	\N	4	1	1	Колодки тормозные	Brake pads	90.599999999999994	81.540000000000006	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.291357+01	2011-02-02 20:34:10.578567+01	
45	4	13	13	1	80341SNEA01	\N			1	\N	\N	4	1	1	Трубка кондиционера	Ac line	130.05000000000001	117.05	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.299112+01	2011-02-02 20:34:10.594628+01	
46	4	13	13	1	80316SNEA01	\N			1	\N	\N	4	1	1	Трубка кондиционера	Discharge hose	46.899999999999999	42.210000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.307874+01	2011-02-02 20:34:10.609552+01	
47	4	13	13	1	84437SWA003ZA	\N			1	\N	\N	4	1	1	Пластик	Access cover	4.5700000000000003	4.1100000000000003	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.318358+01	2011-02-02 20:34:10.62352+01	
48	4	13	13	1	81634STKA01ZE	\N			1	\N	\N	4	1	1	Пластик	Trim cover 	12.98	11.68	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.330536+01	2011-02-02 20:34:10.637957+01	
49	4	13	13	1	77900STKA02	\N			1	\N	\N	4	1	1	Датчик в руль	Clockspring	56.079999999999998	50.469999999999999	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.346325+01	2011-02-02 20:34:10.652817+01	
50	4	33	33	1	28393AG00C	\N			1	\N	\N	6	1	1	ШРУС	cv JOINT	147.97	125.77	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.356886+01	2011-02-02 20:34:10.672159+01	
51	4	15	15	1	H0564JG00A	\N			1	\N	\N	6	1	1	ключ	key blank	20.949999999999999	17.809999999999999	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.367302+01	2011-02-02 20:34:10.685027+01	
53	4	23	23	1	L50110230	\N			1	\N	\N	3	1	1	прокладка клапанной крышки	valve cover gasket	23.890000000000001	19.59	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.390708+01	2011-02-02 20:34:10.701068+01	
54	4	26	26	1	284B1CA511	\N			1	\N	\N	4	1	1	контроллер	CONTROLLER ASSY	354.10000000000002	318.69	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.404109+01	2011-02-02 20:34:10.719559+01	
55	4	23	23	1	GK2A44410C	\N			2	\N	\N	3	1	1	трос ручного тормоза	parking brake lever	40.159999999999997	32.93	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.416092+01	2011-02-02 20:34:10.734318+01	
56	4	23	23	1	ZZCA27165	\N			1	\N	\N	3	1	1	сальник полуоси	oil seal	17.59	14.43	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.425836+01	2011-02-02 20:34:10.748822+01	
57	4	23	23	1	AC0127238	\N			2	\N	\N	3	1	1	сальник полуоси	oil seal	9.7599999999999998	8	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.438587+01	2011-02-02 20:34:10.76398+01	
58	4	14	14	1	924022C720	\N			1	\N	\N	3	1	1	фонарь задний	taillight	221.68000000000001	188.43000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.449165+01	2011-02-02 20:34:10.781135+01	
59	4	23	23	1	EC0143980D	\N			4	\N	\N	3	1	1	шланг тормозной	brake hose	14.65	12.015000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.470795+01	2011-02-02 20:34:10.794231+01	
60	4	11	11	1	YF1Z6268AA	\N			3	\N	\N	3	1	1	цепь грм	timing chain	58.920000000000002	48.310000000000002	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.561415+01	2011-02-02 20:34:10.809785+01	
61	4	23	23	1	000018BP01	\N			40	\N	\N	3	1	1	свеча зажигания	spark plug	4.0300000000000002	3.2999999999999998	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.584279+01	2011-02-02 20:34:10.824314+01	
62	4	23	23	1	L3K912201A	\N			1	\N	\N	3	1	1	цепь грм	timing chain	39.759999999999998	32.609999999999999	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.608409+01	2011-02-02 20:34:10.837379+01	
63	4	23	23	1	L3K9124X0C	\N			1	\N	\N	3	1	1	актуатор	actuator 	127.38	104.45999999999999	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.61873+01	2011-02-02 20:34:10.849908+01	
64	4	47	47	1	4743713AB	\N			1	\N	\N	3	1	1	крышка диска	сenter cap	57.700000000000003	47.32	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.631576+01	2011-02-02 20:34:10.866492+01	
65	4	14	14	1	770030W010	\N			1	\N	\N	4	1	1	Дверь задняя	PANEL ASSY-RR DR LH	691.33000000000004	622.20000000000005	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.640093+01	2011-02-02 20:34:10.880997+01	
52	5	43	58	\N	905505	\N			2	\N	\N	7	\N	1	cайлентблок плавающий	Knuckle Bushing	19.98	32.5	\N	\N	\N	\N	\N	in_processing	2011-02-02 20:36:00.994558+01	\N	2011-02-02 20:25:57.380027+01	2011-02-02 20:36:01.001822+01	
66	4	23	23	1	LFH115940A	\N			1	\N	\N	3	1	1	ролик обводной	idler pulley	53.490000000000002	43.869999999999997	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.649361+01	2011-02-02 20:34:10.897945+01	
67	4	23	23	1	ZZC027238	\N			2	\N	\N	3	1	1	сальник полуоси	oil seal	17.649999999999999	14.470000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.657992+01	2011-02-02 20:34:10.915288+01	
68	4	23	23	1	LF0114320A9U	\N			1	\N	\N	3	1	1	крышка фильтра	filter civer	17.149999999999999	14.07	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.669829+01	2011-02-02 20:34:10.936754+01	
69	4	13	13	1	73860TE0A01	\N	V6684658		1	\N	\N	2	1	1	молдинг стекла четверти левого	Seal Left 	9.8000000000000007	10	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.678872+01	2011-02-02 20:34:10.957319+01	
70	4	13	13	1	72270TE0A01	\N	V6684658		1	\N	\N	2	1	1	направляющая стекла передняя лев	Sash channel	13.550000000000001	14	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.688372+01	2011-02-02 20:34:10.975587+01	
71	4	13	13	1	72271TE0A01	\N	V6684658		1	\N	\N	2	1	1	направляющая стекла задняя лев	Sash channel	4.7800000000000002	5	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.697872+01	2011-02-02 20:34:10.991606+01	
72	4	13	13	1	72150TE0A11	\N	V6684658		1	\N	\N	2	1	1	замок двери лев	Lock assy Left	47.539999999999999	50	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.71018+01	2011-02-02 20:34:11.06167+01	
73	4	15	15	1	40202CG11B	\N	V6633927		1	\N	\N	2	1	1	ступица переднияя	hub assy front	179.15000000000001	180	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.722907+01	2011-02-02 20:34:11.08851+01	
74	4	47	47	1	4721010AA	\N			1	\N	\N	10	1	1	ступица переднияя	hub assy front	259	259	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.733535+01	2011-02-02 20:34:11.101887+01	
75	4	47	47	1	68078768AA	\N			1	\N	\N	10	1	1	датчик давления колеса	sensor pressure	58.450000000000003	58.450000000000003	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.743939+01	2011-02-02 20:34:11.119381+01	
76	4	14	14	1	924010W050	\N			1	\N	\N	4	1	1	Фонарь задний	Tail lamp assy Left 	167.31999999999999	150.59	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.755778+01	2011-02-02 20:34:11.133941+01	
77	4	2	2	1	71198TK4A00	\N	V6531911		1	\N	\N	2	1	1	держатель крыла	Retainer	5.75	6	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.768349+01	2011-02-02 20:34:11.148824+01	
78	4	2	2	1	71598TK4A00	\N	V6531911		1	\N	\N	2	1	1	кронштейн    	retainer Left	7.2199999999999998	7	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.780161+01	2011-02-02 20:34:11.161605+01	
79	4	2	2	1	50810TK4A01	\N	V6531911		1	\N	\N	2	1	1	подушка двигателя	Rear mount	157.31999999999999	157	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.792369+01	2011-02-02 20:34:11.178937+01	
80	4	2	2	1	51360TK4A01	\N	V6531911		1	\N	\N	2	1	1	рычаг нижний левый	control arm	260.76999999999998	248.77000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.800028+01	2011-02-02 20:34:11.192537+01	
81	4	2	2	1	67510STKA90ZZ	\N			1	\N	\N	5	1	1	дверь задняя правая/RDX синий	rear door	658.73000000000002	592	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.813712+01	2011-02-02 20:34:11.211654+01	
82	4	2	2	1	75120STKA01	\N			2	\N	\N	5	1	1	молдинг капота	moulding	50.670000000000002	48.979999999999997	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.826852+01	2011-02-02 20:34:11.226512+01	
83	4	2	2	1	60400STKA00ZZ	\N			2	\N	\N	5	1	1	рамка крепления радиаторов	support	381.10000000000002	342.95999999999998	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.83822+01	2011-02-02 20:34:11.242067+01	
84	4	2	2	1	71135STKA00ZZ	\N			2	\N	\N	5	1	1	крепление усилителя бампера прав	bracket	19.18	18.539999999999999	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.850399+01	2011-02-02 20:34:11.256403+01	
85	4	2	2	1	60650STKA00ZZ	\N			1	\N	\N	5	1	1	внутренняя часть крыла правая	appron	99.170000000000002	95.849999999999994	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.864685+01	2011-02-02 20:34:11.271194+01	
86	4	2	2	1	71140STKA00	\N			1	\N	\N	5	1	1	крепление бампера верх прав	bracket	13.720000000000001	13.26	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.878584+01	2011-02-02 20:34:11.285938+01	
87	4	35	35	1	8879022131	\N			1	\N	\N	4	1	1	Датчик	Ambient temp sensor	16.309999999999999	14.68	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.890892+01	2011-02-02 20:34:11.30218+01	
88	4	2	2	1	71190STKA00	\N			1	\N	\N	5	1	1	крепление бампера верх лев	bracket	13.720000000000001	13.26	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.907392+01	2011-02-02 20:34:11.315916+01	
89	4	2	2	1	71193STKA01	\N			1	\N	\N	5	1	1	крепление бампера бок прав	bracket	1.9299999999999999	1.8600000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.922086+01	2011-02-02 20:34:11.332015+01	
90	4	2	2	1	71198STKA01	\N			1	\N	\N	5	1	1	крепление бампера бок лев	bracket	1.9299999999999999	1.8600000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:57.937356+01	2011-02-02 20:34:11.347465+01	
91	4	2	2	1	71185STKA00ZZ	\N			1	\N	\N	5	1	1	крепление усилителя бампера лев	bracket	19.18	18.530000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:58.007338+01	2011-02-02 20:34:11.362752+01	
92	4	2	2	1	74125STKA00	\N			1	\N	\N	5	1	1	накладка замка капота	latch cover	6.5499999999999998	6.3300000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:58.017895+01	2011-02-02 20:34:11.377215+01	
93	4	2	2	1	71121STKA01ZA	\N			1	\N	\N	5	1	1	основа решётки радиатора	grille base	20.629999999999999	19.940000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:58.070913+01	2011-02-02 20:34:11.391489+01	
94	4	2	2	1	71122STKA01ZA	\N			1	\N	\N	5	1	1	решётка радиатора	grille base	61.299999999999997	59.25	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:58.117336+01	2011-02-02 20:34:11.409331+01	
95	4	2	2	1	38615RWCA01	\N			1	\N	\N	5	1	1	диффузор вентилятора правый	shroud	31.199999999999999	30.149999999999999	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:58.12603+01	2011-02-02 20:34:11.434057+01	
98	4	13	13	1	08P08SNA100R1	\N			1	\N	\N	4	1	1	Брызговики	Mud guard - Sedan 	47.229999999999997	42.509999999999998	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:58.158455+01	2011-02-02 20:34:11.45035+01	
102	4	13	13	1	83753SNXA01ZA	\N			1	\N	\N	4	1	1	Обшивка двери	LNG, L. RR. NH167L	160.25	144.22	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:58.206295+01	2011-02-02 20:34:11.468548+01	
103	4	11	11	1	8L8Z17K707A	\N			1	\N	\N	4	1	1	Стекло зеркала	Mirror glass	32.979999999999997	29.68	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:58.21497+01	2011-02-02 20:34:11.484419+01	
96	4	2	2	2	19015RWCA01	\N			1	\N	\N	5	2	1	диффузор вентилятора левый	shroud	40.899999999999999	39.530000000000001	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:58.135108+01	2011-02-02 20:35:07.598239+01	
97	7	48	59	3	270676970734	\N			1	\N	\N	5	3	1	радиатор	radiator	190.31999999999999	281.48000000000002	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:58.148305+01	2011-02-02 20:39:10.005171+01	
99	7	48	59	3	190438342627	\N	V6684658		1	\N	\N	2	2	1	стекло левое 	glass left	74.950000000000003	138	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 20:25:58.171421+01	2011-02-02 20:39:10.055047+01	
104	5	61	60	4	T7162	\N			1	\N	\N	10	2	1	бампер задний	bumper rear	94	160	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 21:00:48.073599+01	2011-02-02 21:01:04.397729+01	
105	5	46	61	5	A697C	\N	V3181444		1	\N	\N	2	3	1	фильтр воздушный	air filter	5.4199999999999999	25	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 21:00:48.099364+01	2011-02-02 21:01:09.506585+01	
106	5	43	58	6	905505	\N			2	\N	\N	7	2	1	cайлентблок плавающий	Knuckle Bushing	19.98	32.5	\N	\N	\N	\N	\N	in_processing	\N	\N	2011-02-02 21:09:18.22946+01	2011-02-02 21:09:30.613262+01	
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

