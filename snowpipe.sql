create database snowpipe2;

--aws========IAM ROLE===========>snowflake
--AWS<=======aws user arn and external id=============snowflake #foronnection

--storage integeration 
--craete i am role
--permisson s3 full acess

CREATE OR REPLACE STORAGE INTEGRATION my_s3_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = '<aws iam role arn'
  STORAGE_ALLOWED_LOCATIONS = ('s3://<bucket name>');

--copy aws user arn and external id and past in in iam role>>trust relationshhip 

DESC INTEGRATION my_s3_integration;

--stage
--allow s3 to load data on stage
CREATE OR REPLACE STAGE my_s3_stage
  URL='s3://<bucket name>'--must be the file loation 
  STORAGE_INTEGRATION = my_s3_integration;

--file format

CREATE OR REPLACE FILE FORMAT my_csv_format
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1;

--table

CREATE OR REPLACE TABLE my_table (
    Field string,
    Keywords string,
    Info string
);

--snowpipe

CREATE OR REPLACE PIPE my_pipe
  AUTO_INGEST = TRUE
  AS
  COPY INTO my_table
  FROM @my_s3_stage
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

--copy notifictaion channel and past in to s3 event notification destination sqs arn field
show pipes;



select * from my_table;







