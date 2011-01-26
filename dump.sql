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

--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('auth_group_id_seq', 1, true);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('auth_message_id_seq', 42, true);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('auth_permission_id_seq', 42, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 1, true);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('auth_user_id_seq', 2, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 1, false);


--
-- Name: data_area_brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('data_area_brands_id_seq', 34, true);


--
-- Name: data_area_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('data_area_id_seq', 4, true);


--
-- Name: data_brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('data_brand_id_seq', 5, true);


--
-- Name: data_brandgroup_area_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('data_brandgroup_area_id_seq', 33, true);


--
-- Name: data_brandgroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('data_brandgroup_id_seq', 7, true);


--
-- Name: data_direction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('data_direction_id_seq', 2, true);


--
-- Name: data_ordereditem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('data_ordereditem_id_seq', 5, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 49, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('django_content_type_id_seq', 14, true);


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ermol
--

SELECT pg_catalog.setval('django_site_id_seq', 1, true);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: ermol
--

INSERT INTO auth_group VALUES (1, 'Пользователи', 0);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: ermol
--

INSERT INTO django_content_type VALUES (1, 'permission', 'auth', 'permission');
INSERT INTO django_content_type VALUES (2, 'group', 'auth', 'group');
INSERT INTO django_content_type VALUES (3, 'user', 'auth', 'user');
INSERT INTO django_content_type VALUES (4, 'message', 'auth', 'message');
INSERT INTO django_content_type VALUES (5, 'content type', 'contenttypes', 'contenttype');
INSERT INTO django_content_type VALUES (6, 'session', 'sessions', 'session');
INSERT INTO django_content_type VALUES (7, 'site', 'sites', 'site');
INSERT INTO django_content_type VALUES (8, 'log entry', 'admin', 'logentry');
INSERT INTO django_content_type VALUES (9, 'Направление', 'data', 'direction');
INSERT INTO django_content_type VALUES (10, 'Группа поставщиков', 'data', 'brandgroup');
INSERT INTO django_content_type VALUES (11, 'Поставщик', 'data', 'area');
INSERT INTO django_content_type VALUES (12, 'Бренд', 'data', 'brand');
INSERT INTO django_content_type VALUES (13, 'Марка авто', 'data', 'car');
INSERT INTO django_content_type VALUES (14, 'Заказанная позиция', 'data', 'ordereditem');


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: ermol
--

INSERT INTO auth_permission VALUES (1, 'Can add permission', 1, 'add_permission');
INSERT INTO auth_permission VALUES (2, 'Can change permission', 1, 'change_permission');
INSERT INTO auth_permission VALUES (3, 'Can delete permission', 1, 'delete_permission');
INSERT INTO auth_permission VALUES (4, 'Can add group', 2, 'add_group');
INSERT INTO auth_permission VALUES (5, 'Can change group', 2, 'change_group');
INSERT INTO auth_permission VALUES (6, 'Can delete group', 2, 'delete_group');
INSERT INTO auth_permission VALUES (7, 'Can add user', 3, 'add_user');
INSERT INTO auth_permission VALUES (8, 'Can change user', 3, 'change_user');
INSERT INTO auth_permission VALUES (9, 'Can delete user', 3, 'delete_user');
INSERT INTO auth_permission VALUES (10, 'Can add message', 4, 'add_message');
INSERT INTO auth_permission VALUES (11, 'Can change message', 4, 'change_message');
INSERT INTO auth_permission VALUES (12, 'Can delete message', 4, 'delete_message');
INSERT INTO auth_permission VALUES (13, 'Can add content type', 5, 'add_contenttype');
INSERT INTO auth_permission VALUES (14, 'Can change content type', 5, 'change_contenttype');
INSERT INTO auth_permission VALUES (15, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO auth_permission VALUES (16, 'Can add session', 6, 'add_session');
INSERT INTO auth_permission VALUES (17, 'Can change session', 6, 'change_session');
INSERT INTO auth_permission VALUES (18, 'Can delete session', 6, 'delete_session');
INSERT INTO auth_permission VALUES (19, 'Can add site', 7, 'add_site');
INSERT INTO auth_permission VALUES (20, 'Can change site', 7, 'change_site');
INSERT INTO auth_permission VALUES (21, 'Can delete site', 7, 'delete_site');
INSERT INTO auth_permission VALUES (22, 'Can add log entry', 8, 'add_logentry');
INSERT INTO auth_permission VALUES (23, 'Can change log entry', 8, 'change_logentry');
INSERT INTO auth_permission VALUES (24, 'Can delete log entry', 8, 'delete_logentry');
INSERT INTO auth_permission VALUES (25, 'Can add Направление', 9, 'add_direction');
INSERT INTO auth_permission VALUES (26, 'Can change Направление', 9, 'change_direction');
INSERT INTO auth_permission VALUES (27, 'Can delete Направление', 9, 'delete_direction');
INSERT INTO auth_permission VALUES (28, 'Can add Группа поставщиков', 10, 'add_brandgroup');
INSERT INTO auth_permission VALUES (29, 'Can change Группа поставщиков', 10, 'change_brandgroup');
INSERT INTO auth_permission VALUES (30, 'Can delete Группа поставщиков', 10, 'delete_brandgroup');
INSERT INTO auth_permission VALUES (31, 'Can add Поставщик', 11, 'add_area');
INSERT INTO auth_permission VALUES (32, 'Can change Поставщик', 11, 'change_area');
INSERT INTO auth_permission VALUES (33, 'Can delete Поставщик', 11, 'delete_area');
INSERT INTO auth_permission VALUES (34, 'Can add Бренд', 12, 'add_brand');
INSERT INTO auth_permission VALUES (35, 'Can change Бренд', 12, 'change_brand');
INSERT INTO auth_permission VALUES (36, 'Can delete Бренд', 12, 'delete_brand');
INSERT INTO auth_permission VALUES (37, 'Can add Марка авто', 13, 'add_car');
INSERT INTO auth_permission VALUES (38, 'Can change Марка авто', 13, 'change_car');
INSERT INTO auth_permission VALUES (39, 'Can delete Марка авто', 13, 'delete_car');
INSERT INTO auth_permission VALUES (40, 'Can add Заказанная позиция', 14, 'add_ordereditem');
INSERT INTO auth_permission VALUES (41, 'Can change Заказанная позиция', 14, 'change_ordereditem');
INSERT INTO auth_permission VALUES (42, 'Can delete Заказанная позиция', 14, 'delete_ordereditem');


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: ermol
--



--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: ermol
--

INSERT INTO auth_user VALUES (2, 'user', '', '', '', 'sha1$cc3c1$7db0411f4e18c13dc6d4874110700ee7e92e8fbd', false, true, false, '2011-01-27 01:03:12.66906+02', '2011-01-27 00:06:24+02');
INSERT INTO auth_user VALUES (1, 'admin', '', '', 'admin@admin.com', 'sha1$69cbc$78b4f059743760b3b7808034d42ffb6edae44e2c', true, true, true, '2011-01-27 01:03:22.977789+02', '2011-01-26 22:46:51.877667+02');


--
-- Data for Name: auth_message; Type: TABLE DATA; Schema: public; Owner: ermol
--



--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: ermol
--

INSERT INTO auth_user_groups VALUES (1, 2, 1);


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: ermol
--



--
-- Data for Name: data_area; Type: TABLE DATA; Schema: public; Owner: ermol
--

INSERT INTO data_area VALUES (2, 'Acura');
INSERT INTO data_area VALUES (3, 'Audi');
INSERT INTO data_area VALUES (4, 'Bmw');
INSERT INTO data_area VALUES (5, 'Buick');
INSERT INTO data_area VALUES (6, 'Cadillac');
INSERT INTO data_area VALUES (7, 'Chevrolet/geo');
INSERT INTO data_area VALUES (8, 'Chrysler');
INSERT INTO data_area VALUES (9, 'Dodge');
INSERT INTO data_area VALUES (10, 'Eagle');
INSERT INTO data_area VALUES (11, 'Ford');
INSERT INTO data_area VALUES (12, 'Gm');
INSERT INTO data_area VALUES (13, 'Honda');
INSERT INTO data_area VALUES (14, 'Hyundai');
INSERT INTO data_area VALUES (15, 'Infiniti');
INSERT INTO data_area VALUES (16, 'Isuzu');
INSERT INTO data_area VALUES (17, 'Jaguar');
INSERT INTO data_area VALUES (18, 'Jeep');
INSERT INTO data_area VALUES (19, 'Kia');
INSERT INTO data_area VALUES (20, 'Land rover');
INSERT INTO data_area VALUES (21, 'Lexus');
INSERT INTO data_area VALUES (22, 'Lincoln');
INSERT INTO data_area VALUES (23, 'Mazda');
INSERT INTO data_area VALUES (24, 'Mercury');
INSERT INTO data_area VALUES (25, 'Mitsubishi');
INSERT INTO data_area VALUES (26, 'Nissan');
INSERT INTO data_area VALUES (27, 'Oldsmobile');
INSERT INTO data_area VALUES (28, 'Plymouth');
INSERT INTO data_area VALUES (29, 'Pontiac');
INSERT INTO data_area VALUES (30, 'Porsche');
INSERT INTO data_area VALUES (31, 'Saab');
INSERT INTO data_area VALUES (32, 'Saturn');
INSERT INTO data_area VALUES (33, 'Subaru');
INSERT INTO data_area VALUES (34, 'Suzuki');
INSERT INTO data_area VALUES (35, 'Toyota');
INSERT INTO data_area VALUES (36, 'Volkswagen');
INSERT INTO data_area VALUES (37, 'Volvo');
INSERT INTO data_area VALUES (38, 'Scion');
INSERT INTO data_area VALUES (39, 'Mercedes-benz');
INSERT INTO data_area VALUES (40, 'Daewoo');
INSERT INTO data_area VALUES (41, 'Hummer');
INSERT INTO data_area VALUES (42, 'Mini');
INSERT INTO data_area VALUES (43, 'Turboii');
INSERT INTO data_area VALUES (44, 'Rockauto');
INSERT INTO data_area VALUES (45, 'Ekeystone');
INSERT INTO data_area VALUES (46, 'Nexpart');
INSERT INTO data_area VALUES (47, 'Mopar');
INSERT INTO data_area VALUES (48, 'Ebay');
INSERT INTO data_area VALUES (49, 'Tr');
INSERT INTO data_area VALUES (50, 'Pu');
INSERT INTO data_area VALUES (52, 'Magnum');
INSERT INTO data_area VALUES (53, 'Other');
INSERT INTO data_area VALUES (54, 'Jaguar');
INSERT INTO data_area VALUES (59, 'AutoMarket');
INSERT INTO data_area VALUES (58, 'Ronayers');
INSERT INTO data_area VALUES (57, 'Summit');
INSERT INTO data_area VALUES (55, 'Weathertech');
INSERT INTO data_area VALUES (56, 'Bentley');
INSERT INTO data_area VALUES (51, 'Wop');


--
-- Data for Name: data_brand; Type: TABLE DATA; Schema: public; Owner: ermol
--

INSERT INTO data_brand VALUES (2, 'Acura');
INSERT INTO data_brand VALUES (3, 'Audi');
INSERT INTO data_brand VALUES (4, 'Bmw');
INSERT INTO data_brand VALUES (5, 'Buick');
INSERT INTO data_brand VALUES (6, 'Cadillac');
INSERT INTO data_brand VALUES (7, 'Chevrolet/geo');
INSERT INTO data_brand VALUES (8, 'Chrysler');
INSERT INTO data_brand VALUES (9, 'Dodge');
INSERT INTO data_brand VALUES (10, 'Eagle');
INSERT INTO data_brand VALUES (11, 'Ford');
INSERT INTO data_brand VALUES (12, 'Gm');
INSERT INTO data_brand VALUES (13, 'Honda');
INSERT INTO data_brand VALUES (14, 'Hyundai');
INSERT INTO data_brand VALUES (15, 'Infiniti');
INSERT INTO data_brand VALUES (16, 'Isuzu');
INSERT INTO data_brand VALUES (17, 'Jaguar');
INSERT INTO data_brand VALUES (18, 'Jeep');
INSERT INTO data_brand VALUES (19, 'Kia');
INSERT INTO data_brand VALUES (20, 'Land rover');
INSERT INTO data_brand VALUES (21, 'Lexus');
INSERT INTO data_brand VALUES (22, 'Lincoln');
INSERT INTO data_brand VALUES (23, 'Mazda');
INSERT INTO data_brand VALUES (24, 'Mercury');
INSERT INTO data_brand VALUES (25, 'Mitsubishi');
INSERT INTO data_brand VALUES (26, 'Nissan');
INSERT INTO data_brand VALUES (27, 'Oldsmobile');
INSERT INTO data_brand VALUES (28, 'Plymouth');
INSERT INTO data_brand VALUES (29, 'Pontiac');
INSERT INTO data_brand VALUES (30, 'Porsche');
INSERT INTO data_brand VALUES (31, 'Saab');
INSERT INTO data_brand VALUES (32, 'Saturn');
INSERT INTO data_brand VALUES (33, 'Subaru');
INSERT INTO data_brand VALUES (34, 'Suzuki');
INSERT INTO data_brand VALUES (35, 'Toyota');
INSERT INTO data_brand VALUES (36, 'Volkswagen');
INSERT INTO data_brand VALUES (37, 'Volvo');
INSERT INTO data_brand VALUES (38, 'Scion');
INSERT INTO data_brand VALUES (39, 'Mercedes-benz');
INSERT INTO data_brand VALUES (40, 'Daewoo');
INSERT INTO data_brand VALUES (41, 'Hummer');
INSERT INTO data_brand VALUES (42, 'Mini');
INSERT INTO data_brand VALUES (43, 'Turboii');
INSERT INTO data_brand VALUES (44, 'Rockauto');
INSERT INTO data_brand VALUES (45, 'Ekeystone');
INSERT INTO data_brand VALUES (46, 'Nexpart');
INSERT INTO data_brand VALUES (47, 'Mopar');
INSERT INTO data_brand VALUES (48, 'Ebay');
INSERT INTO data_brand VALUES (49, 'Tr');
INSERT INTO data_brand VALUES (50, 'Pu');
INSERT INTO data_brand VALUES (51, 'Wop');
INSERT INTO data_brand VALUES (52, 'Magnum');
INSERT INTO data_brand VALUES (53, 'Other');
INSERT INTO data_brand VALUES (54, 'Jaguar');
INSERT INTO data_brand VALUES (55, 'Weathertech');
INSERT INTO data_brand VALUES (56, 'Bentley');
INSERT INTO data_brand VALUES (57, 'Summit');
INSERT INTO data_brand VALUES (58, 'Ronayers');
INSERT INTO data_brand VALUES (59, 'AutoMarket');


--
-- Data for Name: data_area_brands; Type: TABLE DATA; Schema: public; Owner: ermol
--

INSERT INTO data_area_brands VALUES (10, 59, 3);
INSERT INTO data_area_brands VALUES (11, 59, 4);
INSERT INTO data_area_brands VALUES (12, 59, 5);
INSERT INTO data_area_brands VALUES (13, 58, 8);
INSERT INTO data_area_brands VALUES (14, 58, 6);
INSERT INTO data_area_brands VALUES (15, 58, 7);
INSERT INTO data_area_brands VALUES (16, 57, 11);
INSERT INTO data_area_brands VALUES (17, 57, 12);
INSERT INTO data_area_brands VALUES (18, 57, 13);
INSERT INTO data_area_brands VALUES (19, 55, 44);
INSERT INTO data_area_brands VALUES (20, 55, 45);
INSERT INTO data_area_brands VALUES (21, 55, 46);
INSERT INTO data_area_brands VALUES (22, 55, 47);
INSERT INTO data_area_brands VALUES (23, 56, 5);
INSERT INTO data_area_brands VALUES (24, 56, 6);
INSERT INTO data_area_brands VALUES (25, 56, 7);
INSERT INTO data_area_brands VALUES (26, 56, 8);
INSERT INTO data_area_brands VALUES (27, 56, 9);
INSERT INTO data_area_brands VALUES (28, 56, 10);
INSERT INTO data_area_brands VALUES (29, 56, 11);
INSERT INTO data_area_brands VALUES (30, 51, 8);
INSERT INTO data_area_brands VALUES (31, 51, 9);
INSERT INTO data_area_brands VALUES (32, 51, 10);
INSERT INTO data_area_brands VALUES (33, 51, 11);
INSERT INTO data_area_brands VALUES (34, 51, 7);


--
-- Data for Name: data_direction; Type: TABLE DATA; Schema: public; Owner: ermol
--

INSERT INTO data_direction VALUES (1, 'MSK', 'MP');
INSERT INTO data_direction VALUES (2, 'US', 'SP');


--
-- Data for Name: data_brandgroup; Type: TABLE DATA; Schema: public; Owner: ermol
--

INSERT INTO data_brandgroup VALUES (7, 2, 'ONLINE', '', 0, false);
INSERT INTO data_brandgroup VALUES (6, 2, 'MOTO', '', 0, false);
INSERT INTO data_brandgroup VALUES (5, 2, 'AFTMARK', '', 0, false);
INSERT INTO data_brandgroup VALUES (4, 2, 'OEM', '', 0, false);
INSERT INTO data_brandgroup VALUES (3, 1, 'DOCVP', '', 0, false);
INSERT INTO data_brandgroup VALUES (2, 1, 'DOCAP', '', 0, false);
INSERT INTO data_brandgroup VALUES (1, 1, 'EXAP', '', 0, false);


--
-- Data for Name: data_brandgroup_area; Type: TABLE DATA; Schema: public; Owner: ermol
--

INSERT INTO data_brandgroup_area VALUES (3, 7, 2);
INSERT INTO data_brandgroup_area VALUES (4, 7, 3);
INSERT INTO data_brandgroup_area VALUES (5, 7, 4);
INSERT INTO data_brandgroup_area VALUES (6, 7, 5);
INSERT INTO data_brandgroup_area VALUES (7, 6, 4);
INSERT INTO data_brandgroup_area VALUES (8, 6, 5);
INSERT INTO data_brandgroup_area VALUES (9, 6, 6);
INSERT INTO data_brandgroup_area VALUES (10, 6, 7);
INSERT INTO data_brandgroup_area VALUES (11, 4, 25);
INSERT INTO data_brandgroup_area VALUES (12, 4, 26);
INSERT INTO data_brandgroup_area VALUES (13, 4, 27);
INSERT INTO data_brandgroup_area VALUES (14, 4, 28);
INSERT INTO data_brandgroup_area VALUES (15, 4, 29);
INSERT INTO data_brandgroup_area VALUES (16, 4, 30);
INSERT INTO data_brandgroup_area VALUES (17, 3, 5);
INSERT INTO data_brandgroup_area VALUES (18, 3, 6);
INSERT INTO data_brandgroup_area VALUES (19, 3, 7);
INSERT INTO data_brandgroup_area VALUES (20, 3, 8);
INSERT INTO data_brandgroup_area VALUES (21, 3, 9);
INSERT INTO data_brandgroup_area VALUES (22, 3, 10);
INSERT INTO data_brandgroup_area VALUES (23, 2, 52);
INSERT INTO data_brandgroup_area VALUES (24, 2, 53);
INSERT INTO data_brandgroup_area VALUES (25, 2, 54);
INSERT INTO data_brandgroup_area VALUES (26, 2, 55);
INSERT INTO data_brandgroup_area VALUES (27, 2, 56);
INSERT INTO data_brandgroup_area VALUES (28, 2, 57);
INSERT INTO data_brandgroup_area VALUES (29, 1, 56);
INSERT INTO data_brandgroup_area VALUES (30, 1, 57);
INSERT INTO data_brandgroup_area VALUES (31, 1, 58);
INSERT INTO data_brandgroup_area VALUES (32, 1, 59);
INSERT INTO data_brandgroup_area VALUES (33, 1, 55);


--
-- Data for Name: data_ordereditem; Type: TABLE DATA; Schema: public; Owner: ermol
--



--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: ermol
--



--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: ermol
--

INSERT INTO django_session VALUES ('67ed0c6e255f811a1dd386d8fdc4d6ae', 'gAJ9cQEoVQ1fYXV0aF91c2VyX2lkcQJLAVUSX2F1dGhfdXNlcl9iYWNrZW5kcQNVKWRqYW5nby5j
b250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kcQR1LmU1YjM1ZTgxYTdkZDZiMDU2NzYx
NjkyMDY1MzI2MjI3
', '2011-01-27 00:02:26.400885+02');
INSERT INTO django_session VALUES ('20aeb6fec994439dfac6fba36f8229a2', 'gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k
cy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz
YzE1YmQxNGQ2MDFi
', '2011-01-27 01:03:02.017161+02');
INSERT INTO django_session VALUES ('11badd7c22ef16cdcdb8566080f2a001', 'gAJ9cQEoVRJfYXV0aF91c2VyX2JhY2tlbmRxAlUpZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5k
cy5Nb2RlbEJhY2tlbmRxA1UNX2F1dGhfdXNlcl9pZHEESwF1LjM2NDAxMDI4ZWUxZDQ1Yzk1NTEz
YzE1YmQxNGQ2MDFi
', '2011-01-27 02:26:13.56251+02');


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: ermol
--

INSERT INTO django_site VALUES (1, 'example.com', 'example.com');


--
-- PostgreSQL database dump complete
--

