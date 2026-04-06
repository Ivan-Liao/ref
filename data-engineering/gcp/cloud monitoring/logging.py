# This function could be part of a Dataflow DoFn or a Spark map function.

def process_transaction(element):
  # In a real application, the client is often initialized once per worker.
  from google.cloud import logging as gcp_logging
  log_client = gcp_logging.Client()
  logger = log_client.logger("financial_pipeline_logs")
  # The correlation_id would be passed in as a pipeline argument from
  # the Cloud Composer DAG, e.g., using context variables like dag_run.run_id
  correlation_id = "scheduled__2025-08-29T14:00:00+00:00"
  try:
      # Business logic to validate the transaction
      amount = element.get("amount")
      # CORRECTED: Check for None first to avoid a TypeError
      if amount is None or not isinstance(amount, (int, float)) or amount < 0:
          raise ValueError("Invalid or missing transaction amount.") # Using ValueError is more specific here
      #... more validation...
  except Exception as e:
      # Log a structured payload for actionable, queryable insights
      error_payload = {
          "message": f"Transaction validation failed: {str(e)}",
          "severity": "ERROR",
          "transaction_id": element.get("transaction_id"),
          "pipeline_stage": "validation",
          "correlation_id": correlation_id
      }
      logger.log_struct(error_payload)
      # Optionally, you would then yield this element to a Dead Letter Queue.
      return  # Stop processing this record
  #... continue processing valid record...