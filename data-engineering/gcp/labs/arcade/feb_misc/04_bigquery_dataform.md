1. Create a dataform repository
   1. note the service account id and roles
      1. service-711719450501@gcp-sa-dataform.iam.gserviceaccount.com
      2. roles/bigquery.jobUser, roles/bigquery.dataViewer, roles/bigquery.dataEditor
2. Create a repository workspace
3. Create a definition .sqlx files
```
-- source view
config {
  type: "view"
}

SELECT
  "apples" AS fruit,
  2 AS count
UNION ALL
SELECT
  "oranges" AS fruit,
  5 AS count
UNION ALL
SELECT
  "pears" AS fruit,
  1 AS count
UNION ALL
SELECT
  "bananas" AS fruit,
  0 AS count


-- destination table
config {
  type: "table"
}

SELECT
  fruit,
  SUM(count) as count
FROM ${ref("quickstart-source")}
GROUP BY 1
```
4. Grant Dataform access to BigQuery
5. Start execution in workspace for all actions