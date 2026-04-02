1. bash script to execute
```
#!/usr/bin/env bash
set -e
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#Initialize functions and Constants
BIN_DIR="$(dirname "$BASH_SOURCE")"
PROJECT_ROOT_DIR=${BIN_DIR}/..

PACKAGE_EGG_FILE=dist/dataproc_templates_distribution.egg

. ${BIN_DIR}/dataproc_template_functions.sh

check_required_envvar GCP_PROJECT
check_required_envvar REGION
check_required_envvar GCS_STAGING_LOCATION

# Remove trailing forward slash
GCS_STAGING_LOCATION=`echo $GCS_STAGING_LOCATION | sed 's/\/*$//'`

# Do not rebuild when SKIP_BUILD is specified
# Usage: export SKIP_BUILD=true
if [ -z "$SKIP_BUILD" ]; then
    python3 ${PROJECT_ROOT_DIR}/setup.py bdist_egg --output=$PACKAGE_EGG_FILE
fi

if [ $4 = "--template=HBASETOGCS" ] || [ $4 = "--template=GCSTOBIGTABLE" ]; then
  OPT_SPARK_VERSION="--version=1.0.29"
else
  OPT_SPARK_VERSION="--version=1.1"
fi

OPT_PROJECT="--project=${GCP_PROJECT}"
OPT_REGION="--region=${REGION}"
OPT_JARS="--jars=file:///usr/lib/spark/external/spark-avro.jar"
OPT_LABELS="--labels=job_type=dataproc_template"
OPT_DEPS_BUCKET="--deps-bucket=${GCS_STAGING_LOCATION}"
OPT_PY_FILES="--py-files=${PROJECT_ROOT_DIR}/${PACKAGE_EGG_FILE}"

# Optional arguments
if [ -n "${SUBNET}" ]; then
  OPT_SUBNET="--subnet=${SUBNET}"
fi
if [ -n "${CLUSTER}" ]; then
  OPT_CLUSTER="--cluster=${CLUSTER}"
fi
if [ -n "${HISTORY_SERVER_CLUSTER}" ]; then
  OPT_HISTORY_SERVER_CLUSTER="--history-server-cluster=${HISTORY_SERVER_CLUSTER}"
fi
if [ -n "${METASTORE_SERVICE}" ]; then
  OPT_METASTORE_SERVICE="--metastore-service=${METASTORE_SERVICE}"
fi
if [ -n "${JARS}" ]; then
  OPT_JARS="${OPT_JARS},${JARS}"
fi
if [ -n "${FILES}" ]; then
  OPT_FILES="--files=${FILES}"
fi
if [ -n "${PY_FILES}" ]; then
  OPT_PY_FILES="${OPT_PY_FILES},${PY_FILES}"
fi
if [ -n "${SPARK_PROPERTIES}" ]; then
  OPT_PROPERTIES="--properties=${SPARK_PROPERTIES}"
fi
if [ -z "${JOB_TYPE}" ]; then
  JOB_TYPE=SERVERLESS
fi

#if Hbase catalog is passed, then required hbase dependency are copied to staging location and added to jars
if [ -n "${CATALOG}" ]; then
  echo "Downloading Hbase jar dependency"
  wget https://repo1.maven.org/maven2/org/apache/hbase/hbase-client/2.4.12/hbase-client-2.4.12.jar
  wget https://repo1.maven.org/maven2/org/apache/hbase/hbase-shaded-mapreduce/2.4.12/hbase-shaded-mapreduce-2.4.12.jar
  wget https://repo1.maven.org/maven2/org/apache/htrace/htrace-core4/4.2.0-incubating/htrace-core4-4.2.0-incubating.jar
  gsutil copy hbase-client-2.4.12.jar ${GCS_STAGING_LOCATION}/hbase-client-2.4.12.jar
  gsutil copy hbase-shaded-mapreduce-2.4.12.jar ${GCS_STAGING_LOCATION}/hbase-shaded-mapreduce-2.4.12.jar
  gsutil copy htrace-core4-4.2.0-incubating.jar ${GCS_STAGING_LOCATION}/htrace-core4-4.2.0-incubating.jar
  echo "Passing downloaded dependency jars"
  OPT_JARS="${OPT_JARS},${GCS_STAGING_LOCATION}/hbase-client-2.4.12.jar,${GCS_STAGING_LOCATION}/hbase-shaded-mapreduce-2.4.12.jar,${GCS_STAGING_LOCATION}/htrace-core4-4.2.0-incubating.jar,file:///usr/lib/spark/external/hbase-spark.jar"
  rm hbase-client-2.4.12.jar
  rm hbase-shaded-mapreduce-2.4.12.jar
  rm htrace-core4-4.2.0-incubating.jar
fi

if [ -n "${HBASE_SITE_PATH}" ]; then
  check_required_envvar SKIP_IMAGE_BUILD
  if [ "${SKIP_IMAGE_BUILD}" = "FALSE" ]; then
    echo "Building Custom Image"
    #Copy the hbase-site.xml to docker context
    cp $HBASE_SITE_PATH .
    export HBASE_SITE_NAME=`basename $HBASE_SITE_PATH`
    docker build -t "${IMAGE}" -f dataproc_templates/hbase/Dockerfile --build-arg HBASE_SITE_NAME=${HBASE_SITE_NAME} .
    rm $HBASE_SITE_NAME
    docker push "${IMAGE}"
  fi
fi

# Construct the command based on JOB_TYPE
if [ "${JOB_TYPE}" == "CLUSTER" ]; then
  echo "JOB_TYPE is CLUSTER, so will submit on an existing Dataproc cluster"
  check_required_envvar CLUSTER
  command=$(cat << EOF
  gcloud dataproc jobs submit pyspark \
      ${PROJECT_ROOT_DIR}/main.py \
      ${OPT_PROJECT} \
      ${OPT_REGION} \
      ${OPT_CLUSTER} \
      ${OPT_JARS} \
      ${OPT_LABELS} \
      ${OPT_FILES} \
      ${OPT_PY_FILES} \
      ${OPT_PROPERTIES}
EOF
)
elif [ "${JOB_TYPE}" == "SERVERLESS" ]; then
  echo "JOB_TYPE is SERVERLESS, so will submit on serverless Spark"
  command=$(cat << EOF
  gcloud beta dataproc batches submit pyspark \
      ${PROJECT_ROOT_DIR}/main.py \
      ${OPT_SPARK_VERSION} \
      ${OPT_PROJECT} \
      ${OPT_REGION} \
      ${OPT_JARS} \
      ${OPT_LABELS} \
      ${OPT_DEPS_BUCKET} \
      ${OPT_FILES} \
      ${OPT_PY_FILES} \
      ${OPT_PROPERTIES} \
      ${OPT_SUBNET} \
      ${OPT_HISTORY_SERVER_CLUSTER} \
      ${OPT_METASTORE_SERVICE}
EOF
)
else
  echo "Unknown JOB_TYPE \"${JOB_TYPE}\""
  exit 1
fi

echo "Triggering Spark Submit job"
echo ${command} "$@"
${command} "$@"
spark_status=$?

check_status $spark_status "\n Spark Command ran successful \n" "\n It seems like there are some issues in running spark command. Requesting you to please go through the error to identify issues in your code \n"

echo "We will love to hear your feedback at: https://forms.gle/XXCJeWeCJJ9fNLQS6"
echo "Email us at: dataproc-templates-support-external@googlegroups.com"
```
2. pyspark script
```
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from typing import Dict, Any, Type

import logging
import sys

from pyspark.sql import SparkSession

from dataproc_templates import BaseTemplate, TemplateName
from dataproc_templates.gcs.gcs_to_jdbc import GCSToJDBCTemplate
from dataproc_templates.mongo.mongo_to_gcs import MongoToGCSTemplate
from dataproc_templates.mongo.mongo_to_bq import MongoToBigQueryTemplate
from dataproc_templates.util import get_template_name, get_log_level, track_template_invocation
from dataproc_templates.gcs.gcs_to_bigquery import GCSToBigQueryTemplate
from dataproc_templates.gcs.gcs_to_gcs import GCSToGCSTemplate
from dataproc_templates.gcs.gcs_to_mongo import GCSToMONGOTemplate
from dataproc_templates.gcs.gcs_to_bigtable import GCSToBigTableTemplate
from dataproc_templates.bigquery.bigquery_to_gcs import BigQueryToGCSTemplate
from dataproc_templates.hive.hive_to_bigquery import HiveToBigQueryTemplate
from dataproc_templates.hive.hive_to_gcs import HiveToGCSTemplate
from dataproc_templates.gcs.text_to_bigquery import TextToBigQueryTemplate
from dataproc_templates.hbase.hbase_to_gcs import HbaseToGCSTemplate
from dataproc_templates.jdbc.jdbc_to_jdbc import JDBCToJDBCTemplate
from dataproc_templates.jdbc.jdbc_to_gcs import JDBCToGCSTemplate
from dataproc_templates.jdbc.jdbc_to_bigquery import JDBCToBigQueryTemplate
from dataproc_templates.snowflake.snowflake_to_gcs import SnowflakeToGCSTemplate
from dataproc_templates.redshift.redshift_to_gcs import RedshiftToGCSTemplate
from dataproc_templates.cassandra.cassandra_to_bigquery import CassandraToBQTemplate
from dataproc_templates.hive.util.hive_ddl_extractor import HiveDDLExtractorTemplate
from dataproc_templates.kafka.kafka_to_gcs import KafkaToGCSTemplate
from dataproc_templates.kafka.kafka_to_bq import KafkaToBigQueryTemplate
from dataproc_templates.s3.s3_to_bigquery import S3ToBigQueryTemplate
from dataproc_templates.cassandra.cassandra_to_gcs import CassandraToGCSTemplate
from dataproc_templates.pubsublite.pubsublite_to_gcs import PubSubLiteToGCSTemplate
from dataproc_templates.azure.azure_blob_storage_to_bigquery import AzureBlobStorageToBigQueryTemplate
from dataproc_templates.pubsublite.pubsublite_to_bigtable import PubSubLiteToBigtableTemplate
from dataproc_templates.elasticsearch.elasticsearch_to_gcs import ElasticsearchToGCSTemplate
from dataproc_templates.elasticsearch.elasticsearch_to_bq import ElasticsearchToBQTemplate
from dataproc_templates.elasticsearch.elasticsearch_to_bigtable import ElasticsearchToBigTableTemplate

LOGGER: logging.Logger = logging.getLogger('dataproc_templates')

# Maps each TemplateName to its corresponding implementation
# of BaseTemplate
TEMPLATE_IMPLS: Dict[TemplateName, Type[BaseTemplate]] = {
    TemplateName.GCSTOBIGQUERY: GCSToBigQueryTemplate,
    TemplateName.GCSTOGCS: GCSToGCSTemplate,
    TemplateName.GCSTOBIGTABLE: GCSToBigTableTemplate,
    TemplateName.BIGQUERYTOGCS: BigQueryToGCSTemplate,
    TemplateName.HIVETOBIGQUERY: HiveToBigQueryTemplate,
    TemplateName.HIVETOGCS: HiveToGCSTemplate,
    TemplateName.TEXTTOBIGQUERY: TextToBigQueryTemplate,
    TemplateName.GCSTOJDBC: GCSToJDBCTemplate,
    TemplateName.GCSTOMONGO: GCSToMONGOTemplate,
    TemplateName.HBASETOGCS: HbaseToGCSTemplate,
    TemplateName.JDBCTOJDBC: JDBCToJDBCTemplate,
    TemplateName.JDBCTOGCS: JDBCToGCSTemplate,
    TemplateName.JDBCTOBIGQUERY: JDBCToBigQueryTemplate,
    TemplateName.MONGOTOGCS: MongoToGCSTemplate,
    TemplateName.MONGOTOBIGQUERY: MongoToBigQueryTemplate,
    TemplateName.SNOWFLAKETOGCS: SnowflakeToGCSTemplate,
    TemplateName.REDSHIFTTOGCS: RedshiftToGCSTemplate,
    TemplateName.CASSANDRATOBQ: CassandraToBQTemplate,
    TemplateName.AZUREBLOBSTORAGETOBQ: AzureBlobStorageToBigQueryTemplate,
    TemplateName.CASSANDRATOGCS: CassandraToGCSTemplate,
    TemplateName.HIVEDDLEXTRACTOR: HiveDDLExtractorTemplate,
    TemplateName.KAFKATOGCS: KafkaToGCSTemplate,
    TemplateName.KAFKATOBQ: KafkaToBigQueryTemplate,
    TemplateName.S3TOBIGQUERY: S3ToBigQueryTemplate,
    TemplateName.PUBSUBLITETOGCS: PubSubLiteToGCSTemplate,
    TemplateName.PUBSUBLITETOBIGTABLE: PubSubLiteToBigtableTemplate,
    TemplateName.ELASTICSEARCHTOGCS: ElasticsearchToGCSTemplate,
    TemplateName.ELASTICSEARCHTOBQ: ElasticsearchToBQTemplate,
    TemplateName.ELASTICSEARCHTOBIGTABLE: ElasticsearchToBigTableTemplate

}


def create_spark_session(template_name: TemplateName) -> SparkSession:
    """
    Creates the SparkSession object.

    It also sets the Spark logging level to info. We could
    consider parametrizing the log level in the future.

    Args:
        template_name (str): The name of the template being
            run. Used to set the Spark app name.

    Returns:
        pyspark.sql.SparkSession: The set up SparkSession.
    """

    spark = SparkSession.builder \
        .appName(template_name.value) \
        .enableHiveSupport() \
        .getOrCreate()

    log4j = spark.sparkContext._jvm.org.apache.log4j
    log4j_level: log4j.Level = log4j.Level.toLevel(get_log_level())

    log4j.LogManager.getRootLogger().setLevel(log4j_level)
    log4j.LogManager.getLogger("org.apache.spark").setLevel(log4j_level)
    spark.sparkContext.setLogLevel(get_log_level())

    return spark


def run_template(template_name: TemplateName) -> None:
    """
    Executes a template given it's template name.

    Args:
        template_name (TemplateName): The TemplateName of the template
            that should be run.

    Returns:
        None
    """

    # pylint: disable=broad-except

    template_impl: Type[BaseTemplate] = TEMPLATE_IMPLS[template_name]

    template_instance: BaseTemplate = template_impl.build()

    try:
        args: Dict[str, Any] = template_instance.parse_args()
        
        spark: SparkSession = create_spark_session(template_name=template_name)

        track_template_invocation(spark=spark, template_name=template_name)

        template_instance.run(spark=spark, args=args)
    except Exception:
        LOGGER.exception(
            'An error occurred while running %s template',
            template_name
        )
        sys.exit(1)


if __name__ == '__main__':

    run_template(
        template_name=get_template_name()
    )
```