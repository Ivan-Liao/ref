/*
source: tom bailey Udemy course
*/
import requests
response = requests.get(“https://go44755.eu-west-2.aws.snowflakecomputing.com/api/files/DB/SCHEMA/STAGE/img.jpg”,
headers={
"User-Agent": "reg-tests",
"Accept": "*/*",
"X-Snowflake-Authorization-Token-Type": "OAUTH",
"Authorization": """Bearer {}""".format(token)
},
allow_redirects=True)
print(response.status_code)
print(response.content)