-- =====================================================
-- STATES
-- =====================================================


INSERT INTO state_master
(
state_code,
state_name,
country_id
)
VALUES

('CA','California',1),
('TX','Texas',1),
('NY','New York',1),
('FL','Florida',1),
('WA','Washington',1),
('IL','Illinois',1),
('AZ','Arizona',1),
('CO','Colorado',1);



-- =====================================================
-- CITIES
-- =====================================================


INSERT INTO city_master
(
city_name,
state_id
)

SELECT

'City_' || g,

((g % 8)+1)

FROM generate_series(1,500) g;





-- =====================================================
-- GENERATE CITIZENS
-- =====================================================


INSERT INTO citizen
(
citizen_id,
ssn,
first_name,
middle_name,
last_name,
date_of_birth,
gender_id,
status_id,
email,
phone_number,
birth_city_id
)


SELECT

uuid_generate_v4(),

'SSN-' || g,

'FirstName_' || g,

'M',

'LastName_' || (g % 50000),


DATE '1950-01-01'
+
((random()*25000)::INTEGER),


CASE

WHEN g % 3 = 0
THEN 1

WHEN g % 3 = 1
THEN 2

ELSE 3

END,


1,


'citizen' || g || '@example.com',


'555-' || g,


((random()*499)+1)::INTEGER


FROM generate_series(1,1000000) g;



INSERT INTO citizen_address
(
address_id,
citizen_id,
address_type,
street,
city,
state,
zip_code,
latitude,
longitude,
is_current
)


SELECT


uuid_generate_v4(),


c.citizen_id,


CASE

WHEN x = 1 THEN 'HOME'

WHEN x = 2 THEN 'WORK'

ELSE 'PREVIOUS'

END,


'Street_' || g,


'City_' || ((g%500)+1),


'California',


LPAD((g%99999)::text,5,'0'),


(random()*90)::numeric(10,7),


(random()*180)::numeric(10,7),


x=1


FROM citizen c


CROSS JOIN generate_series(1,3) x

JOIN generate_series(1,1000000) g

ON g =
(
row_number()
OVER()
);




INSERT INTO citizen_identification
(
identification_id,
citizen_id,
document_type_id,
document_number,
issue_date
)


SELECT

uuid_generate_v4(),

citizen_id,

1,

'DOC-'||row_number() over(),

CURRENT_DATE - INTERVAL '5 years'


FROM citizen;



INSERT INTO employer
(
employer_name,
industry,
company_size
)

SELECT

'Company_'||g,

'Technology',

(g%10000)+10

FROM generate_series(1,10000) g;



INSERT INTO employment_history
(
employment_id,
citizen_id,
employer_id,
job_title,
annual_salary,
start_date,
currently_employed
)


SELECT

uuid_generate_v4(),

c.citizen_id,

(
SELECT employer_id
FROM employer
ORDER BY random()
LIMIT 1
),


'Software Engineer',


(random()*150000)::numeric(12,2),


DATE '2000-01-01'
+
((random()*8000)::integer),


true


FROM citizen c,


generate_series(1,5);


INSERT INTO government_transaction
(
citizen_id,
transaction_type_id,
transaction_status,
transaction_amount,
transaction_date,
payload
)


SELECT


c.citizen_id,


((random()*3)+1)::integer,


CASE

WHEN random()<0.8
THEN 'SUCCESS'

ELSE 'FAILED'

END,


(random()*500)::numeric(12,2),


CURRENT_TIMESTAMP -
(random()*INTERVAL '1000 days'),



jsonb_build_object(

'type',
'government',

'channel',
'ONLINE',

'ip',
'192.168.1.'||(g%255)

)


FROM citizen c


CROSS JOIN generate_series(1,20) g;


INSERT INTO audit_event
(
entity_name,
entity_id,
operation,
old_data,
new_data
)


SELECT


'citizen',


citizen_id::text,


'UPDATE',


'{}'::jsonb,


jsonb_build_object(

'status',
'ACTIVE'

)


FROM citizen;