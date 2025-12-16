'''
Docstring for python.use-cases.scd-type2

FOR each incoming record:
    FIND current active record
    IF record does not exist or has changed:
        CLOSE old record
        INSERT new record with current timestamp
'''

from datetime import datetime

def scd_type2_update(existing_records, new_records):
    """
    Updates a Type 2 Slowly Changing Dimension table.
    """

    now = datetime.datetime.now(datetime.timezone.utc) # to use other timezones e.g. datetime.timezone(timedelta(hours=-5), name='EST') 

    # Find currently active records
    active_records = {}
    for record in existing_records:
        if record["valid_to"] is None:
            active_records[record["user_id"]] = record

    results = list(existing_records)

    for new in new_records:
        user_id = new["user_id"]
        new_email = new["email"]

        current = active_records.get(user_id)

        # If no record exists or the email changed
        if current is None or current["email"] != new_email:
            if current:
                # Close the old record
                current["valid_to"] = now

            # Insert new version
            results.append({
                "user_id": user_id,
                "email": new_email,
                "valid_from": now,
                "valid_to": None
            })

    return results
