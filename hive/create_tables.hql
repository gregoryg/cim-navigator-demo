DROP TABLE customers;

CREATE EXTERNAL TABLE customers(
  cust_id int, 
  fname string, 
  lname string, 
  address string, 
  city string, 
  state string, 
  zipcode string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '\t' 
  LINES TERMINATED BY '\n' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/dualcore/customers';

CREATE EXTERNAL TABLE order_details(
  order_id int, 
  prod_id int)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '\t' 
  LINES TERMINATED BY '\n' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/dualcore/order_details';

CREATE EXTERNAL TABLE orders(
  order_id int, 
  cust_id int, 
  order_date timestamp)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '\t' 
  LINES TERMINATED BY '\n' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/dualcore/orders';

CREATE EXTERNAL TABLE products(
  prod_id int, 
  brand string, 
  name string, 
  price int, 
  cost int, 
  shipping_wt int)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '\t' 
  LINES TERMINATED BY '\n' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/dualcore/products';

CREATE EXTERNAL TABLE employees(
  emp_id string, 
  fname string, 
  lname string, 
  address string, 
  city string, 
  state string, 
  zipcode string, 
  job_title string, 
  email string, 
  active string, 
  salary int)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '\t' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/dualcore/employees';

