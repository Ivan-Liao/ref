CREATE database my_database;
CREATE schema my_schema;

USE my_database;
use my_schema; 

CREATE TABLE authors (
	author_name varchar(60),
	author_email varchar(70),
	author_pay int
)

USE playground;
CREATE TABLE bookings (
	id int,
    guest_id int,
    listing_id int,
    date_check_in date,
    date_check_out date,
    ds_book text
)

ALTER TABLE table_name RENAME new_table_name
ALTER TABLE "table_name" RENAME COLUMN <column_1> TO <column_2>;
ALTER TABLE "table_name" DROP COLUMN <column_1>; 
ALTER TABLE table_name ADD COLUMN column data_type;
ALTER TABLE table_name ALTER COLUMN column SET DATA TYPE data_type;