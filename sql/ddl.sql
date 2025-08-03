CREATE database my_database;
CREATE schema my_schema;

USE my_database;
use my_schema; 

CREATE TABLE authors (
	author_name varchar(60),
	author_email varchar(70),
	author_pay int
)

-- example 2
USE playground;
CREATE TABLE bookings (
	id int,
    guest_id int,
    listing_id int,
    date_check_in date,
    date_check_out date,
    ds_book text
)