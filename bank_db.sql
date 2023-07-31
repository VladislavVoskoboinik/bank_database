BEGIN;


CREATE TABLE public.account
(
    account_id integer NOT NULL IDENTITY(1,1),
    current_balance integer NOT NULL,
    account_type_id smallint NOT NULL,
    account_status_type_id smallint NOT NULL,
    interest_savings_rate_id smallint NOT NULL,
    PRIMARY KEY (account_id)
);

CREATE TABLE public.account_status_type
(
    account_status_type_id smallint NOT NULL IDENTITY(1,1),
    account_status_description character varying(30),
    PRIMARY KEY (account_status_type_id)
);

CREATE TABLE public.account_type
(
    account_type_id smallint NOT NULL IDENTITY(1,1),
    account_type_description character varying(30),
    PRIMARY KEY (account_type_id)
);

CREATE TABLE public.customer
(
    account_id integer NOT NULL,
    customer_address_1 character varying(30),
    customer_address_2 character varying(30),
    customer_first_name character varying(30) NOT NULL,
    customer_middle_initial character(1) NOT NULL,
    customer_last_name character varying(30) NOT NULL,
    city character varying(20) NOT NULL,
    zipcode character varying(10) NOT NULL,
    email_address character varying(100) NOT NULL,
    home_phone character(10) NOT NULL,
    cell_phone character(10) NOT NULL,
    work_phone character(10),
    ssn character(9) NOT NULL,
    user_login_id smallint NOT NULL,
    customer_id integer NOT NULL IDENTITY(1,1),
    PRIMARY KEY (customer_id)
);

CREATE TABLE public.customer_account
(
    account_id integer NOT NULL,
    customer_id integer NOT NULL
);

CREATE TABLE public.employee
(
    employee_id integer NOT NULL IDENTITY(1,1),
    employee_first_name character varying(25),
    employee_middle_initial character(1),
    employee_last_name character varying(25),
    employeeis_manager bit(1),
    PRIMARY KEY (employee_id)
);

CREATE TABLE public.failed_transaction_error_type
(
    failed_transaction_error_type_id smallint NOT NULL IDENTITY(1,1),
    failed_transaction_description character varying(50),
    PRIMARY KEY (failed_transaction_error_type_id)
);

CREATE TABLE public.failed_transaction_log
(
    failed_transaction_id integer NOT NULL IDENTITY(1,1),
    failed_transaction_error_type_id smallint NOT NULL,
    failed_transaction_error_time timestamp without time zone NOT NULL,
    failed_transaction_xml xml NOT NULL,
    PRIMARY KEY (failed_transaction_id)
);

CREATE TABLE public.login_account
(
    user_login_id smallint NOT NULL,
    account_id integer NOT NULL
);

CREATE TABLE public.login_error_log
(
    error_log_id integer NOT NULL IDENTITY(1,1),
    error_time timestamp without time zone NOT NULL,
    failed_transaction_xml xml NOT NULL,
    PRIMARY KEY (error_log_id)
);

CREATE TABLE public.over_draft_log
(
    account_id integer NOT NULL,
    over_draft_date timestamp without time zone,
    over_draft_amount money,
    over_draft_transaction_xml xml,
    PRIMARY KEY (account_id)
);

CREATE TABLE public.savings_interest_rates
(
    interest_savings_rate_id smallint NOT NULL IDENTITY(1,1),
    interest_rate_value numeric(9, 9) NOT NULL,
    interest_rate_description character varying(30),
    PRIMARY KEY (interest_savings_rate_id)
);

CREATE TABLE public.transaction_log
(
    transaction_id integer NOT NULL,
    transaction_data timestamp without time zone NOT NULL,
    transaction_type_id smallint NOT NULL,
    transaction_amount money NOT NULL,
    new_balance money NOT NULL,
    account_id integer NOT NULL,
    customer_id integer NOT NULL,
    employee_id integer NOT NULL,
    user_login_id smallint NOT NULL,
    PRIMARY KEY (transaction_id)
);

CREATE TABLE public.transaction_type
(
    transaction_type_id smallint NOT NULL IDENTITY(1,1),
    transaction_type_name character(10) NOT NULL,
    transaction_type_description character varying(50),
    transaction_fee_amount money NOT NULL,
    PRIMARY KEY (transaction_type_id)
);

CREATE TABLE public.user_logins
(
    user_login_id smallint NOT NULL,
    user_login character(15) NOT NULL,
    user_password character varying(20) NOT NULL,
    PRIMARY KEY (user_login_id)
);

CREATE TABLE public.user_security_answers
(
    user_login_id smallint NOT NULL IDENTITY(1,1),
    user_security_answer character varying(25) NOT NULL,
    user_security_question_id smallint NOT NULL,
    PRIMARY KEY (user_login_id)
);

CREATE TABLE public.user_security_questions
(
    user_security_question_id smallint NOT NULL IDENTITY(1,1),
    user_security_question character varying(50),
    PRIMARY KEY (user_security_question_id)
);

ALTER TABLE public.account
    ADD FOREIGN KEY (account_status_type_id)
    REFERENCES public.account_status_type (account_status_type_id)
    NOT VALID;


ALTER TABLE public.account
    ADD FOREIGN KEY (account_type_id)
    REFERENCES public.account_type (account_type_id)
    NOT VALID;


ALTER TABLE public.account
    ADD FOREIGN KEY (interest_savings_rate_id)
    REFERENCES public.savings_interest_rates (interest_savings_rate_id)
    NOT VALID;


ALTER TABLE public.customer_account
    ADD FOREIGN KEY (account_id)
    REFERENCES public.account (account_id)
    NOT VALID;


ALTER TABLE public.customer_account
    ADD FOREIGN KEY (customer_id)
    REFERENCES public.customer (customer_id)
    NOT VALID;


ALTER TABLE public.failed_transaction_log
    ADD FOREIGN KEY (failed_transaction_error_type_id)
    REFERENCES public.failed_transaction_error_type (failed_transaction_error_type_id)
    NOT VALID;


ALTER TABLE public.login_account
    ADD FOREIGN KEY (account_id)
    REFERENCES public.account (account_id)
    NOT VALID;


ALTER TABLE public.login_account
    ADD FOREIGN KEY (user_login_id)
    REFERENCES public.user_logins (user_login_id)
    NOT VALID;


ALTER TABLE public.over_draft_log
    ADD FOREIGN KEY (account_id)
    REFERENCES public.account (account_id)
    NOT VALID;


ALTER TABLE public.transaction_log
    ADD FOREIGN KEY (account_id)
    REFERENCES public.account (account_id)
    NOT VALID;


ALTER TABLE public.transaction_log
    ADD FOREIGN KEY (customer_id)
    REFERENCES public.customer (customer_id)
    NOT VALID;


ALTER TABLE public.transaction_log
    ADD FOREIGN KEY (employee_id)
    REFERENCES public.employee (employee_id)
    NOT VALID;


ALTER TABLE public.transaction_log
    ADD FOREIGN KEY (transaction_type_id)
    REFERENCES public.transaction_type (transaction_type_id)
    NOT VALID;


ALTER TABLE public.transaction_log
    ADD FOREIGN KEY (user_login_id)
    REFERENCES public.user_logins (user_login_id)
    NOT VALID;


ALTER TABLE public.user_security_answers
    ADD FOREIGN KEY (user_login_id)
    REFERENCES public.user_logins (user_login_id)
    NOT VALID;


ALTER TABLE public.user_security_answers
    ADD FOREIGN KEY (user_security_question_id)
    REFERENCES public.user_security_questions (user_security_question_id)
    NOT VALID;

END;