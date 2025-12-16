'''
Docstring for python.use-cases.schema-aware-normalization

CREATE empty set for all field names

FOR each row:
    ADD all keys to the schema set

FOR each row:
    CREATE new row with all schema fields
    IF value exists:
        CONVERT to integer if possible
    ELSE:
        SET value to None
'''

def normalize_rows(rows):
    """
    Normalizes rows to the same schema and converts numbers.
    """

    # Collect all unique field names
    schema = set()
    for row in rows:
        for key in row:
            schema.add(key)

    normalized_rows = []

    for row in rows:
        new_row = {}

        for field in schema:
            value = row.get(field)

            # Convert strings like "123" to integers
            if isinstance(value, str) and value.isdigit():
                value = int(value)

            # Missing fields become None
            new_row[field] = value

        normalized_rows.append(new_row)

    return normalized_rows