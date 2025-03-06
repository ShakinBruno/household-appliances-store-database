DROP DATABASE IF EXISTS HOUSEHOLD_APPLIANCES;
CREATE DATABASE HOUSEHOLD_APPLIANCES;

DROP SCHEMA IF EXISTS MANAGEMENT CASCADE;
CREATE SCHEMA IF NOT EXISTS MANAGEMENT;
SET SEARCH_PATH TO MANAGEMENT;

DROP TABLE IF EXISTS MANAGEMENT.COUNTRY;
CREATE TABLE IF NOT EXISTS MANAGEMENT.COUNTRY
(
    COUNTRY_ID      INTEGER GENERATED ALWAYS AS IDENTITY,
    COUNTRY_NAME    VARCHAR(50) NOT NULL,
    COUNTRY_CODE    CHAR(2),
    CONSTRAINT      PK_COUNTRY_COUNTRY_ID PRIMARY KEY(COUNTRY_ID),
    CONSTRAINT      UNQ_COUNTRY_COUNTRY_NAME UNIQUE(COUNTRY_NAME),
    CONSTRAINT      CHK_COUNTRY_COUNTRY_CODE_VALIDATION CHECK(COUNTRY_CODE IS NULL OR COUNTRY_CODE ~ '^[A-Z]{2}$')
);

DROP TABLE IF EXISTS MANAGEMENT.BRAND;
CREATE TABLE IF NOT EXISTS MANAGEMENT.BRAND
(
    BRAND_ID        INTEGER GENERATED ALWAYS AS IDENTITY,
    BRAND_NAME      VARCHAR(50) NOT NULL,
    COUNTRY         INTEGER,
    FOUNDED_YEAR    SMALLINT DEFAULT EXTRACT (YEAR FROM CURRENT_DATE),
    WEBSITE         VARCHAR(100),
    CONSTRAINT      PK_BRAND_BRAND_ID PRIMARY KEY(BRAND_ID),
    CONSTRAINT      FK_COUNTRY_COUNTRY_COUNTRY_ID FOREIGN KEY(COUNTRY) REFERENCES MANAGEMENT.COUNTRY(COUNTRY_ID),
    CONSTRAINT      CHK_BRAND_FOUNDED_YEAR_IN_VALID_RANGE CHECK(FOUNDED_YEAR IS NULL OR FOUNDED_YEAR BETWEEN 1800 AND EXTRACT (YEAR FROM CURRENT_DATE)),
    CONSTRAINT      CHK_BRAND_WEBSITE_VALIDATION CHECK(WEBSITE IS NULL OR WEBSITE ~ '^(?:HTTPS?:\/\/)?(?:WWW\.)?[A-Z0-9-]+\.[A-Z]{2,}$')
);

DROP TABLE IF EXISTS MANAGEMENT.MODEL;
CREATE TABLE IF NOT EXISTS MANAGEMENT.MODEL
(
    MODEL_ID        INTEGER GENERATED ALWAYS AS IDENTITY,
    MODEL_NAME      VARCHAR(50) NOT NULL,
    BRAND           INTEGER NOT NULL,
    RELEASE_YEAR    SMALLINT DEFAULT EXTRACT (YEAR FROM CURRENT_DATE),
    CONSTRAINT      PK_MODEL_MODEL_ID PRIMARY KEY(MODEL_ID),
    CONSTRAINT      FK_BRAND_BRAND_BRAND_ID FOREIGN KEY(BRAND) REFERENCES MANAGEMENT.BRAND(BRAND_ID),
    CONSTRAINT      UNQ_MODEL_MODEL_NAME_BRAND UNIQUE(MODEL_NAME, BRAND),
    CONSTRAINT      CHK_MODEL_RELEASE_YEAR_IN_VALID_RANGE CHECK(RELEASE_YEAR IS NULL OR RELEASE_YEAR BETWEEN 1800 AND EXTRACT (YEAR FROM CURRENT_DATE))
);

DROP TABLE IF EXISTS MANAGEMENT.CATEGORY;
CREATE TABLE IF NOT EXISTS MANAGEMENT.CATEGORY
(
    CATEGORY_ID     INTEGER GENERATED ALWAYS AS IDENTITY,
    CATEGORY_NAME   VARCHAR(30) NOT NULL,
    DESCRIPTION     TEXT,
    CONSTRAINT      PK_CATEGORY_CATEGORY_ID PRIMARY KEY(CATEGORY_ID),
    CONSTRAINT      UNQ_CATEGORY_CATEGORY_NAME UNIQUE(CATEGORY_NAME)
);

DROP TABLE IF EXISTS MANAGEMENT.APPLIANCE;
CREATE TABLE IF NOT EXISTS MANAGEMENT.APPLIANCE
(
    APPLIANCE_ID    INTEGER GENERATED ALWAYS AS IDENTITY,
    PRODUCT_NAME    VARCHAR(100) NOT NULL,
    MODEL           INTEGER NOT NULL,
    CATEGORY        INTEGER,
    DESCRIPTION     TEXT,
    CONSTRAINT      PK_APPLIANCE_APPLIANCE_ID PRIMARY KEY(APPLIANCE_ID),
    CONSTRAINT      FK_MODEL_MODEL_MODEL_ID FOREIGN KEY(MODEL) REFERENCES MANAGEMENT.MODEL(MODEL_ID),
    CONSTRAINT      FK_CATEGORY_CATEGORY_CATEGORY_ID FOREIGN KEY(CATEGORY) REFERENCES MANAGEMENT.CATEGORY(CATEGORY_ID),
    CONSTRAINT      UNQ_APPLIANCE_PRODUCT_NAME_MODEL UNIQUE(PRODUCT_NAME, MODEL)
);

DROP TABLE IF EXISTS MANAGEMENT.SUPPLIER;
CREATE TABLE IF NOT EXISTS MANAGEMENT.SUPPLIER
(
    SUPPLIER_ID     INTEGER GENERATED ALWAYS AS IDENTITY,
    SUPPLIER_NAME   VARCHAR(50) NOT NULL,
    PHONE_NUMBER    VARCHAR(15),
    EMAIL           VARCHAR(100),
    CONSTRAINT      PK_SUPPLIER_SUPPLIER_ID PRIMARY KEY(SUPPLIER_ID),
    CONSTRAINT      CHK_SUPPLIER_PHONE_NUMBER_VALIDATION CHECK(PHONE_NUMBER IS NULL OR PHONE_NUMBER ~ '^\+?[0-9\S\-\(\)]{7,15}$'),
    CONSTRAINT      CHK_SUPPLIER_EMAIL_VALIDATION CHECK(EMAIL IS NULL OR EMAIL ~ '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$')
);

DROP TABLE IF EXISTS MANAGEMENT.APPLIANCE_SUPPLY;
CREATE TABLE IF NOT EXISTS MANAGEMENT.APPLIANCE_SUPPLY
(
    APPLIANCE       INTEGER,
    SUPPLIER        INTEGER,
    PRICE           DECIMAL(7, 2),
    STOCK_QUANTITY  SMALLINT DEFAULT 0,
    CONSTRAINT      PK_APPLIANCE_SUPPLY_APPLIANCE_SUPPLIER PRIMARY KEY(APPLIANCE, SUPPLIER),
    CONSTRAINT      FK_APPLIANCE_APPLIANCE_APPLIANCE_ID FOREIGN KEY(APPLIANCE) REFERENCES MANAGEMENT.APPLIANCE(APPLIANCE_ID),
    CONSTRAINT      FK_SUPPLIER_SUPPLIER_SUPPLIER_ID FOREIGN KEY(SUPPLIER) REFERENCES MANAGEMENT.SUPPLIER(SUPPLIER_ID),
    CONSTRAINT      CHK_APPLIANCE_SUPPLY_PRICE_ABOVE_OR_EQUAL_0 CHECK(PRICE IS NULL OR PRICE >= 0),
    CONSTRAINT      CHK_APPLIANCE_SUPPLY_STOCK_QUANTITY_ABOVE_OR_EQUAL_0 CHECK(STOCK_QUANTITY IS NULL OR STOCK_QUANTITY >= 0)
);

DROP TABLE IF EXISTS MANAGEMENT.CUSTOMER;
CREATE TABLE IF NOT EXISTS MANAGEMENT.CUSTOMER
(
    CUSTOMER_ID     INTEGER GENERATED ALWAYS AS IDENTITY,
    FIRST_NAME      VARCHAR(50) NOT NULL,
    LAST_NAME       VARCHAR(50) NOT NULL,
    PHONE_NUMBER    VARCHAR(15),
    EMAIL           VARCHAR(100),
    CONSTRAINT      PK_CUSTOMER_CUSTOMER_ID PRIMARY KEY(CUSTOMER_ID),
    CONSTRAINT      CHK_CUSTOMER_PHONE_NUMBER_VALIDATION CHECK(PHONE_NUMBER IS NULL OR PHONE_NUMBER ~ '^\+?[0-9\S\-\(\)]{7,15}$'),
    CONSTRAINT      CHK_CUSTOMER_EMAIL_VALIDATION CHECK(EMAIL IS NULL OR EMAIL ~ '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$')
);

DROP TABLE IF EXISTS MANAGEMENT.EMPLOYEE;
CREATE TABLE IF NOT EXISTS MANAGEMENT.EMPLOYEE
(
    EMPLOYEE_ID     INTEGER GENERATED ALWAYS AS IDENTITY,
    FIRST_NAME      VARCHAR(50) NOT NULL,
    LAST_NAME       VARCHAR(50) NOT NULL,
    PHONE_NUMBER    VARCHAR(15),
    EMAIL           VARCHAR(100),
    JOB_POSITION    VARCHAR(30),
    HIRE_DATE       DATE DEFAULT CURRENT_DATE,
    CONSTRAINT      PK_EMPLOYEE_EMPLOYEE_ID PRIMARY KEY(EMPLOYEE_ID),
    CONSTRAINT      CHK_EMPLOYEE_PHONE_NUMBER_VALIDATION CHECK(PHONE_NUMBER IS NULL OR PHONE_NUMBER ~ '^\+?[0-9\S\-\(\)]{7,15}$'),
    CONSTRAINT      CHK_EMPLOYEE_EMAIL_VALIDATION CHECK(EMAIL IS NULL OR EMAIL ~ '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'),
    CONSTRAINT      CHK_EMPLOYEE_HIRE_DATE_SINCE_JULY_2024 CHECK(HIRE_DATE IS NULL OR HIRE_DATE >= '2024-07-01')
);

DROP TABLE IF EXISTS MANAGEMENT.APPLIANCE_ORDER;
CREATE TABLE IF NOT EXISTS MANAGEMENT.APPLIANCE_ORDER
(
    APPLIANCE_ORDER_ID  INTEGER GENERATED ALWAYS AS IDENTITY,
    CUSTOMER            INTEGER NOT NULL,
    EMPLOYEE            INTEGER NOT NULL,
    ORDER_DATE          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TOTAL_AMOUNT        DECIMAL(8, 2),
    ORDER_STATUS        VARCHAR(20) DEFAULT 'PENDING',
    CONSTRAINT          PK_APPLIANCE_ORDER_APPLIANCE_ORDER_ID PRIMARY KEY(APPLIANCE_ORDER_ID),
    CONSTRAINT          FK_CUSTOMER_CUSTOMER_CUSTOMER_ID FOREIGN KEY(CUSTOMER) REFERENCES MANAGEMENT.CUSTOMER(CUSTOMER_ID),
    CONSTRAINT          FK_EMPLOYEE_EMPLOYEE_EMPLOYEE_ID FOREIGN KEY(EMPLOYEE) REFERENCES MANAGEMENT.EMPLOYEE(EMPLOYEE_ID),
    CONSTRAINT          CHK_APPLIANCE_ORDER_ORDER_DATE_SINCE_JULY_2024 CHECK(ORDER_DATE >= '2024-07-01'),
    CONSTRAINT          CHK_APPLIANCE_ORDER_TOTAL_AMOUNT_ABOVE_OR_EQUAL_0 CHECK(TOTAL_AMOUNT >= 0),
    CONSTRAINT          CHK_APPLIANCE_ORDER_ORDER_STATUS_VALIDATION CHECK(ORDER_STATUS IS NULL OR ORDER_STATUS IN ('PENDING', 'PAID', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'RETURNED'))
);

DROP TABLE IF EXISTS MANAGEMENT.ORDER_ITEM;
CREATE TABLE IF NOT EXISTS MANAGEMENT.ORDER_ITEM
(
    APPLIANCE_ORDER INTEGER,
    APPLIANCE       INTEGER,
    QUANTITY        SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT      PK_ORDER_ITEM_APPLIANCE_ORDER_APPLIANCE PRIMARY KEY(APPLIANCE_ORDER, APPLIANCE),
    CONSTRAINT      FK_APPLIANCE_ORDER_APPLIANCE_ORDER_APPLIANCE_ORDER_ID FOREIGN KEY(APPLIANCE_ORDER) REFERENCES MANAGEMENT.APPLIANCE_ORDER(APPLIANCE_ORDER_ID),
    CONSTRAINT      FK_APPLIANCE_APPLIANCE_APPLIANCE_ID FOREIGN KEY(APPLIANCE) REFERENCES MANAGEMENT.APPLIANCE(APPLIANCE_ID),
    CONSTRAINT      CHK_ORDER_ITEM_QUANTITY_ABOVE_0 CHECK(QUANTITY > 0)
);

-- Definition of function which updates data of specified column in 'appliance_order' table.
DROP FUNCTION IF EXISTS MANAGEMENT.UPDATE_APPLIANCE_ORDER_RECORD(VARCHAR, ANYELEMENT, INTEGER);
CREATE OR REPLACE FUNCTION MANAGEMENT.UPDATE_APPLIANCE_ORDER_RECORD(IN P_COLUMN_NAME VARCHAR, IN P_NEW_VALUE ANYELEMENT, IN P_PRIMARY_KEY_VALUE INTEGER)
RETURNS MANAGEMENT.APPLIANCE_ORDER
LANGUAGE PLPGSQL
AS $FUNC$
DECLARE
    V_INF_SCHEMA_REC    RECORD;
    V_UPDATED_REC       RECORD;
BEGIN
    SELECT  COLUMN_NAME,
            DATA_TYPE
    INTO    V_INF_SCHEMA_REC
    FROM    INFORMATION_SCHEMA.COLUMNS
    WHERE   TABLE_CATALOG = 'household_appliances' AND
            TABLE_SCHEMA = 'management' AND
            TABLE_NAME = 'appliance_order' AND
            COLUMN_NAME = LOWER(P_COLUMN_NAME);

    IF V_INF_SCHEMA_REC IS NULL THEN
        RAISE EXCEPTION 'COLUMN WITH NAME "%" DOES NOT EXIST IN HOUSEHOLD_APPLIANCES.MANAGEMENT.APPLIANCE_ORDER', P_COLUMN_NAME;
    END IF;

    IF PG_TYPEOF(P_NEW_VALUE)::TEXT != V_INF_SCHEMA_REC.DATA_TYPE THEN
        RAISE EXCEPTION 'THE DATA TYPE OF NEW VALUE IS NOT COMPATIBLE WITH DATA TYPE OF %. SHOULD BE: %', V_INF_SCHEMA_REC.COLUMN_NAME, V_INF_SCHEMA_REC.DATA_TYPE;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM MANAGEMENT.APPLIANCE_ORDER WHERE APPLIANCE_ORDER_ID = P_PRIMARY_KEY_VALUE) THEN
        RAISE EXCEPTION 'THE PRIMARY KEY COLUMN DOES NOT CONTAIN SUCH VALUE: %', P_PRIMARY_KEY_VALUE;
    END IF;

    EXECUTE FORMAT($$UPDATE MANAGEMENT.APPLIANCE_ORDER SET %I = $1 WHERE APPLIANCE_ORDER_ID = $2 RETURNING *$$, P_COLUMN_NAME)
    USING   P_NEW_VALUE,
            P_PRIMARY_KEY_VALUE
    INTO    V_UPDATED_REC;

    RETURN V_UPDATED_REC;
END;
$FUNC$;

-- Definition of function with transaction block which inserts a new row in 'appliance_order' table. When an error occurs while inserting a new row, whole transaction is rollbacked.
DROP FUNCTION IF EXISTS MANAGEMENT.BEGIN_NEW_ORDER(VARCHAR(100), VARCHAR(100), VARCHAR(100)[]);
CREATE OR REPLACE FUNCTION MANAGEMENT.BEGIN_NEW_ORDER(IN P_CUSTOMER_EMAIL VARCHAR(100), IN P_EMPLOYEE_EMAIL VARCHAR(100), IN P_APPLIANCE_NAMES VARCHAR(100)[])
RETURNS MANAGEMENT.APPLIANCE_ORDER
LANGUAGE PLPGSQL
AS $$
DECLARE
    V_CUSTOMER_ID       INTEGER;
    V_EMPLOYEE_ID       INTEGER;
    V_APPLIANCE_ID      INTEGER;
    V_APPLIANCE_NAME    VARCHAR(100);
    V_ORDER_REC         RECORD;
BEGIN
    IF CARDINALITY(P_APPLIANCE_NAMES) = 0 THEN
        RAISE EXCEPTION 'ARRAY OF APPLIANCES TO ORDER CANNOT BE EMPTY.';
    END IF;

    SELECT  CUSTOMER_ID
    INTO    V_CUSTOMER_ID
    FROM    MANAGEMENT.CUSTOMER
    WHERE   UPPER(EMAIL) = UPPER(P_CUSTOMER_EMAIL);

    IF V_CUSTOMER_ID IS NULL THEN
        RAISE EXCEPTION 'CUSTOMER WITH EMAIL "%" WAS NOT FOUND.', P_CUSTOMER_EMAIL;
    END IF;

    SELECT  EMPLOYEE_ID
    INTO    V_EMPLOYEE_ID
    FROM    MANAGEMENT.EMPLOYEE
    WHERE   UPPER(EMAIL) = UPPER(P_EMPLOYEE_EMAIL);

    IF V_EMPLOYEE_ID IS NULL THEN
        RAISE EXCEPTION 'EMPLOYEE WITH EMAIL "%" WAS NOT FOUND.', P_EMPLOYEE_EMAIL;
    END IF;

    BEGIN
        INSERT INTO MANAGEMENT.APPLIANCE_ORDER (CUSTOMER, EMPLOYEE)
        VALUES      (V_CUSTOMER_ID, V_EMPLOYEE_ID)
        RETURNING   *
        INTO        V_ORDER_REC;

        FOREACH V_APPLIANCE_NAME IN ARRAY P_APPLIANCE_NAMES LOOP
            SELECT  APPLIANCE_ID
            INTO    V_APPLIANCE_ID
            FROM    MANAGEMENT.APPLIANCE
            WHERE   UPPER(PRODUCT_NAME) = UPPER(V_APPLIANCE_NAME);

            IF V_APPLIANCE_ID IS NULL THEN
                RAISE EXCEPTION 'APPLIANCE WITH NAME "%" WAS NOT FOUND.', V_APPLIANCE_NAME;
            END IF;

            INSERT INTO MANAGEMENT.ORDER_ITEM (APPLIANCE_ORDER, APPLIANCE)
            VALUES      (V_ORDER_REC.APPLIANCE_ORDER_ID, V_APPLIANCE_ID);
        END LOOP;
    EXCEPTION WHEN OTHERS THEN
        RAISE EXCEPTION 'ERROR WHEN INSERTING NEW ORDER RECORD: %', SQLERRM;
    END;

    RETURN V_ORDER_REC;
END;
$$;

-- Definition of view which displays various statistical measures for each company producing appliances. The analytics are displayed for the latest quarter of year which most recent order was processed.
DROP VIEW IF EXISTS MANAGEMENT.QUATERLY_COMPANY_REPORT;
CREATE OR REPLACE VIEW MANAGEMENT.QUATERLY_COMPANY_REPORT AS
WITH RECENT_QUARTER AS
(
    SELECT  EXTRACT (QUARTER FROM MAX(ORDER_DATE))  AS LATEST_QUARTER,
            EXTRACT (YEAR FROM MAX(ORDER_DATE))     AS LATEST_YEAR
    FROM    MANAGEMENT.APPLIANCE_ORDER
)
SELECT          BRAND.BRAND_NAME                    AS BRAND,
                COUNT(APPL_ORD.APPLIANCE_ORDER_ID)  AS TOTAL_ORDERS,
                SUM(ORD_ITEM.QUANTITY)              AS TOTAL_UNITS_SOLD,
                AVG(APPL_ORD.TOTAL_AMOUNT)          AS AVERAGE_ORDER_PROFIT,
                SUM(APPL_ORD.TOTAL_AMOUNT)          AS TOTAL_REVENUE
FROM            MANAGEMENT.BRAND            AS BRAND
LEFT OUTER JOIN MANAGEMENT.MODEL            AS MODEL    ON BRAND.BRAND_ID = MODEL.BRAND
LEFT OUTER JOIN MANAGEMENT.APPLIANCE        AS APPL     ON MODEL.MODEL_ID = APPL.MODEL
LEFT OUTER JOIN MANAGEMENT.ORDER_ITEM       AS ORD_ITEM ON APPL.APPLIANCE_ID = ORD_ITEM.APPLIANCE
LEFT OUTER JOIN MANAGEMENT.APPLIANCE_ORDER  AS APPL_ORD ON ORD_ITEM.APPLIANCE_ORDER = APPL_ORD.APPLIANCE_ORDER_ID
CROSS JOIN      RECENT_QUARTER              AS REC_QUART
WHERE           EXTRACT (QUARTER FROM CURRENT_DATE) = REC_QUART.LATEST_QUARTER AND
                EXTRACT (YEAR FROM CURRENT_DATE) = REC_QUART.LATEST_YEAR
GROUP BY        BRAND.BRAND_ID,
                BRAND.BRAND_NAME
ORDER BY        TOTAL_REVENUE DESC;

-- Definition of read-only role for a manager, his permissions are: connecting and logging into database, ability to use 'management' schema and viewing the content of all tables.
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM PG_ROLES WHERE ROLNAME = 'manager') THEN
        DROP OWNED BY MANAGER;
        DROP ROLE MANAGER;
    END IF;

    CREATE ROLE MANAGER WITH LOGIN PASSWORD 'mgrpasswd';
    GRANT CONNECT ON DATABASE HOUSEHOLD_APPLIANCES TO MANAGER;
    GRANT USAGE ON SCHEMA MANAGEMENT TO MANAGER;
    GRANT SELECT ON ALL TABLES IN SCHEMA MANAGEMENT TO MANAGER;
END;
$$;