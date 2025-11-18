/*
source: tom bailey Udemy course
*/
CREATE TABLE document_metadata
(
relative_path string,
author string,
published_on date,
topics array
);

COPY INTO document_metadata
FROM
(SELECT
$1:relative_path,
$1:author,
$1:published_on::date,
$1:topics
FROM
@documents_stage/document_metadata.json)
FILE_FORMAT = (type = json);

CREATE VIEW document_catalog AS
(
SELECT
author,
published_on,
get_presigned_url(@documents_stage, relative_path) as presigned_url,
topics
FROM
documents_table
);
