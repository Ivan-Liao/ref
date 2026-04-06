import apache_beam as beam
from apache_beam.transforms.deduplicate import Deduplicate

# Example PCollection with duplicate records
with beam.Pipeline() as p:
    raw_data = p | 'Create' >> beam.Create([
        {'id': 1, 'value': 'A'},
        {'id': 2, 'value': 'B'},
        {'id': 1, 'value': 'A'}, # Duplicate record
        {'id': 3, 'value': 'C'},
        {'id': 2, 'value': 'B'}  # Another duplicate
    ])
    
    # Deduplicate based on the 'id' field
    deduplicated_data = raw_data | 'Deduplicate' >> Deduplicate.by(lambda row: row['id'])

    # Log the results
    deduplicated_data | 'Log' >> beam.Map(print)