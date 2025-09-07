-- Simplified Example
CREATE TABLE comprehensive_example (

    -- ===== Numeric Types =====
    item_id SERIAL PRIMARY KEY, -- Auto-incrementing integer (4 bytes). In MySQL: INT AUTO_INCREMENT. In SQL Server: INT IDENTITY(1,1).
    regular_count INTEGER,       -- The standard choice for whole numbers.
    exact_price NUMERIC(10, 2),  -- For fixed-point numbers. Ideal for currency. (e.g., 12345678.99)
    precise_measurement DOUBLE PRECISION, -- Double-precision floating-point number (8 bytes).

    -- ===== Character / Text Types =====
    variable_code VARCHAR(50),   -- Variable-length string with a maximum limit. The most common string type.
    item_description TEXT,       -- Variable-length string with no predefined limit.

    -- ===== Date and Time Types =====
    manufacture_date DATE,       -- Stores only the date (year, month, day).
    sale_time TIME,              -- Stores only the time of day (no date).
    purchase_timestamp TIMESTAMP,  -- Stores both date and time.
    log_timestamp TIMESTAMPTZ,   -- Stores date and time, WITH time zone information. Very useful for applications with global users.
    warranty_period INTERVAL,    -- Stores a duration or time span (e.g., '30 days', '1 year').

    -- ===== Boolean Type =====
    is_active BOOLEAN,           -- Stores TRUE or FALSE values.

    -- ===== Structured / Special Types (Often PostgreSQL-specific) =====
    metadata_json JSON,          -- Stores JSON text. Good for flexibility, but less efficient to query.
);


-- This SQL query creates a table to demonstrate a wide variety of data types.
-- The syntax is primarily for PostgreSQL, which has a rich set of types,
-- but comments are included for common variations in other SQL databases.

-- First, let's create a custom ENUM type to use in our table.
-- Not all SQL databases support ENUMs in this way. MySQL does, but
-- in SQL Server, you would typically use a CHECK constraint instead.
CREATE TYPE item_status AS ENUM ('new', 'in_progress', 'completed', 'cancelled');

-- Now, create the main table.
CREATE TABLE comprehensive_example (

    -- ===== Numeric Types =====
    item_id SERIAL PRIMARY KEY, -- Auto-incrementing integer (4 bytes). In MySQL: INT AUTO_INCREMENT. In SQL Server: INT IDENTITY(1,1).
    large_item_id BIGSERIAL,     -- Auto-incrementing large integer (8 bytes). In MySQL: BIGINT AUTO_INCREMENT.

    small_count SMALLINT,        -- For small whole numbers (-32768 to +32767).
    regular_count INTEGER,       -- The standard choice for whole numbers.
    large_count BIGINT,          -- For very large whole numbers.

    exact_price NUMERIC(10, 2),  -- For fixed-point numbers. Ideal for currency. (e.g., 12345678.99)
    scientific_value DECIMAL(8, 4), -- Another name for NUMERIC, used for exact calculations.

    approx_measurement REAL,     -- Single-precision floating-point number (4 bytes).
    precise_measurement DOUBLE PRECISION, -- Double-precision floating-point number (8 bytes).

    -- ===== Character / Text Types =====
    fixed_code CHAR(8),           -- Fixed-length string. Pads with spaces if the input is shorter.
    variable_code VARCHAR(50),   -- Variable-length string with a maximum limit. The most common string type.
    item_description TEXT,       -- Variable-length string with no predefined limit.

    -- ===== Date and Time Types =====
    manufacture_date DATE,       -- Stores only the date (year, month, day).
    sale_time TIME,              -- Stores only the time of day (no date).
    purchase_timestamp TIMESTAMP,  -- Stores both date and time.
    log_timestamp TIMESTAMPTZ,   -- Stores date and time, WITH time zone information. Very useful for applications with global users.
    warranty_period INTERVAL,    -- Stores a duration or time span (e.g., '30 days', '1 year').

    -- ===== Boolean Type =====
    is_active BOOLEAN,           -- Stores TRUE or FALSE values.

    -- ===== Binary Data Type =====
    item_image BYTEA,             -- For storing binary data, like an image file. (BLOB in other databases).

    -- ===== Structured / Special Types (Often PostgreSQL-specific) =====
    unique_identifier UUID,      -- For storing universally unique identifiers.
    current_status item_status,   -- Uses the custom ENUM type we created earlier.

    metadata_json JSON,          -- Stores JSON text. Good for flexibility, but less efficient to query.
    metadata_jsonb JSONB,        -- Stores JSON in a decomposed binary format. More efficient for indexing and querying.

    technical_specs XML,         -- For storing XML data.

    contact_emails TEXT[],       -- An array of TEXT values. A powerful PostgreSQL feature.

    location_point POINT,        -- A geometric type for a 2D point.
    shipping_route LINE,         -- A geometric type for a line.

    ip_address INET,             -- For storing an IPv4 or IPv6 host address.
    mac_address MACADDR          -- For storing a MAC address.
);
