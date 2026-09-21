Create a materialized view using KQL for fabric eventhouse with the following columns where possible.  Restrict the data to be 1 month in the past to 1 month into the future.

   1. Rx ID # note that this is ordered_id
   2. Pharmacy # note this is location_name
   3. Product # note this is name from stg_product_flat
   5. Client # note this is name from stg_client_flat
   6. Reason Code # note this is code from stg_reasoncode_flat
   7. Reason # note this is description from stg_reasoncode_flat
   11. Dose Activity # note this is actual_activity in stg_ordered_flat
   12. Cal Date # note this is calibration_date in stg_ordered_flat
   13. Cal Time # note this is calibration_time in stg_ordered_flat
   14. Order Date # note this is order_date in stg_ordered_flat
   15. Order Time # note this is order_time in stg_ordered_flat
   16. Filled Date # note this is filled_date in stg_ordered_flat
   17. Filled Time # note this is the filled_time in stg_ordered_flat
   18. Packed Date # note this is the packed_date in stg_shipcontainer_flat
   19. Packed Time # note this is the packed_time in stg_shipcontainer_flat
   20. Shipped Date # note this is the shipped_date in stg_shipment_flat
   21. Shipped Time # note this is the shipped_time in stg_shipment_flat
   22. Delivery Date # note this is the delivered_date in stg_shipcontainer_flat
   23. Delivery Time # note this is the delivered_time in stg_shipcontainer_flat
There is an example of a query from the original database that shows the joins pasted.


