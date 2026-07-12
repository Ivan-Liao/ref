# Azure Synapse Extract
1. Create new pipeline
2. Copy Data activity
   1. Source: Synapse lake database or view
   2. Sink: ADLS Gen2 dataset with format DelimitedText (CSV)
   3. Filename: 
      1. First row as header checked
3. Test flow to see csv file in storage container
4. Web activity action linked to Success path
   1. URL: HTTP POST URL from Logic App trigger
   2. Method: POST
   3. Body: {"status": "run"}
      1. Required even if data inside is not used or parsed
5. Add Trigger 
   1. Type Schedule
6. Publish All


# Logic App
1. Consumption-based Logic App
2. Trigger when an HTTP request is recieved
3. Save the app immediately to generate a unique HTTP POST URL
4. ADLS Gen2 connector 
   1. Get file content and point to storage path
5. Send an email (V2)
   1. To:
   2. Subject:
   3. Body:
   4. Add new parameter and check attachments
      1. File content dynamic token

# References
1. Watch file size as Office 365 OUtlook cap attachments at rougly 20 - 35 MB
   1. Use SAS URL to the file instead of attaching raw CSV
```
Add a new action
Search for Azure Blob Storage connector and select Create SAS URI by path

In the new SAS action block, define how secure you want this link to be:

Blob path: Click the folder icon to browse to your container, or use a dynamic token if your Synapse pipeline passes the file name dynamically.

Permissions: Set this strictly to Read. You only want the email recipient to view/download the file, not overwrite or delete it.

Expiry Time: This field requires an ISO 8601 timestamp. Instead of hardcoding a date, click into the field, select the Expression tab, and enter this formula to make it valid for exactly 24 hours from the moment it runs:

addHours(utcNow(), 24)

Type out a friendly message, like: "Your automated Synapse report is ready. Click the link below to download it. This link will expire in 24 hours."

Under the text, look at the Dynamic Content pop-up box on the right.

Look under the Create SAS URI by path section and select Web URL. This inserts a token that will dynamically turn into your secure, tokenized download link when the email fires.
```