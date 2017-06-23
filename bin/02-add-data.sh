#!/bin/bash

#################################################
# Setup script for the Cloudera Navigator demo. #
#################################################


# Determine location of this script.
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


# Set variables.
target_host=
username=training
password=training


# Download policies.sql off S3.
wget -q https://s3-us-west-2.amazonaws.com/foe-demo/NavigatorDemo/policies.sql
if [ $? -ne 0 ]; then
  echo "Downloading 'policies' from 'foe-demo' S3 bucket failed! Exiting..."
  exit 1
fi


# Determine Navigator metaserver database name.
# navigator_db=`mysql -u root -pcloudera -e "select schema_name from information_schema.schemata where schema_name like 'navigatormetaserver%';" | grep navigatormetaserver`
navigator_db=`mysql -u cmdbadmin -pcmdbadmin -e "select schema_name from information_schema.schemata where schema_name like 'navmeta%';" | grep navmeta`
if [ $? -ne 0 ]; then
  echo "Determining name of Navigator Metaserver DB failed! Exiting..."
  exit 1
fi


# Execute policies.sql
mysql -u cmdbadmin -pcmdbadmin -D $navigator_db < policies.sql
if [ $? -ne 0 ]; then
  echo "Executing policies.sql failed! Exiting..."
  exit 1
fi


# Download data off S3.
wget -q https://s3-us-west-2.amazonaws.com/foe-demo/NavigatorDemo/training.tar.gz
if [ $? -ne 0 ]; then
  echo "Downloading 'training.tar.gz' from 'foe-demo' S3 bucket failed! Exiting..."
  exit 1
fi


# Untar/Unzip data files.
tar -xf training.tar.gz
if [ $? -ne 0 ]; then
  echo "Un-tarring 'training.tar.gz' failed! Exiting..."
  exit 1
fi

## THESE COMMANDS MOVED TO JENKINS SCRIPT
# Create "/realestate", "/dualcore", and user's HDFS home directory.
#hadoop fs -mkdir /user/$username /dualcore /realestate
#if [ $? -ne 0 ]; then
#  echo "Creating subdirectories in HDFS failed! Exiting..."
#  exit 1
#fi


# Chown "/realestate", "/dualcore", and user's HDFS home directory to user.
#hadoop fs -chown -R $username:supergroup /user/$username /dualcore /realestate
#if [ $? -ne 0 ]; then
#  echo "Chowning subdirectories in HDFS failed! Exiting..."
#  exit 1
#fi


# Put ex1data.csv data into HDFS.
hadoop fs -put $dir/../data/ex1data.csv /realestate/
if [ $? -ne 0 ]; then
  echo "Putting 'ex1data.csv' into '/realestate/' failed! Exiting..."
  exit 1
fi


# Create ex1 Hive table.
hive -f $dir/../hive/ex1createHiveTables.sql
if [ $? -ne 0 ]; then
  echo "ex1createHiveTables.sql failed! Exiting..."
  exit 1
fi


# Load ex1 Hive table.
hive -f $dir/../hive/ex1loadHiveTables.sql
if [ $? -ne 0 ]; then
  echo "ex1loadHiveTables.sql failed! Exiting..."
  exit 1
fi


# Create more tables.
hive -f $dir/../hive/create_tables.hql
if [ $? -ne 0 ]; then
  echo "create_tables.hql failed! Exiting..."
  exit 1
fi


# Put static_data/* data into HDFS.
hadoop fs -put scripts/analyst/static_data/* /dualcore/
if [ $? -ne 0 ]; then
  echo "Putting 'ex1data.csv' into '/realestate/' failed! Exiting..."
  exit 1
fi


# Run Hive commands.
hive -e "create table sales_by_region as SELECT s_neighbor, sum(s_price) as Price FROM salesdata GROUP BY s_neighbor; create table count_by_region as SELECT s_neighbor, count(s_price) as property_count FROM salesdata GROUP BY s_neighbor; create table invalid_salesdata as SELECT s_price FROM salesdata WHERE s_neighbor LIKE '%UNKNOWN%';"
if [ $? -ne 0 ]; then
  echo "Hive statements failed! Exiting..."
  exit 1
fi


# Run catchup.sh
echo 10 | ./scripts/analyst/catchup.sh
if [ $? -ne 0 ]; then
  echo "catchup.sh failed! Exiting..."
  exit 1
fi


# Run pig commands.
pig -f training_materials/analyst/exercises/disparate_datasets/sample_solution/count_orders_by_period.pig
if [ $? -ne 0 ]; then
  echo "count_orders_by_period.pig failed! Exiting..."
  exit 1
fi

pig -f training_materials/analyst/exercises/disparate_datasets/sample_solution/count_tablet_orders_by_period.pig
if [ $? -ne 0 ]; then
  echo "count_tablet_orders_by_period.pig failed! Exiting..."
  exit 1
fi


# Run more Hive stuff.
beeline -u 'jdbc:hive2://localhost:10000/default;training training' -f training_materials/analyst/exercises/interactive/sample_solution/abandoned_checkout_profit.sql
beeline -u 'jdbc:hive2://localhost:10000/default;training training' -f training_materials/analyst/exercises/interactive/sample_solution/abandoned_checkout_revenue.sql
beeline -u 'jdbc:hive2://localhost:10000/default;training training' -f training_materials/analyst/exercises/interactive/sample_solution/avg_profit_per_order_1000.sql
beeline -u 'jdbc:hive2://localhost:10000/default;training training' -f training_materials/analyst/exercises/interactive/sample_solution/avg_profit_per_order_all.sql
beeline -u 'jdbc:hive2://localhost:10000/default;training training' -f training_materials/analyst/exercises/interactive/sample_solution/avg_shipping_cost.sql
beeline -u 'jdbc:hive2://localhost:10000/default;training training' -f training_materials/analyst/exercises/interactive/sample_solution/avg_shipping_cost_50000.sql
beeline -u 'jdbc:hive2://localhost:10000/default;training training' -f training_materials/analyst/exercises/interactive/sample_solution/checkout_profit_by_step.sql
beeline -u 'jdbc:hive2://localhost:10000/default;training training' -f training_materials/analyst/exercises/interactive/sample_solution/completed_checkout_profit.sql
beeline -u 'jdbc:hive2://localhost:10000/default;training training' -f training_materials/analyst/exercises/interactive/sample_solution/potential_profit_50000.sql
beeline -u 'jdbc:hive2://localhost:10000/default;training training' -f training_materials/analyst/exercises/interactive/sample_solution/total_profit_completed_orders.sql


# Denied access commands.
hadoop fs -mkdir /hbase/copy
hadoop fs -mkdir /hbase/stolen_data
hadoop fs -rm /hbase/data/hbase/meta/.tabledesc/.tableinfo.0000000001


# Run Impala query.
IMPALA_HOST=`hostname | sed 's/-1.gce.cloudera.com/-2.gce.cloudera.com/g'`
impala-shell -i $IMPALA_HOST:21000 -q "invalidate metadata; create table top_10 as select s_neighbor, avg(s_price) as average from salesdata group by s_neighbor order by avg(s_price) desc limit 10;"
if [ $? -ne 0 ]; then
  echo "Impala query failed! Exiting..."
  exit 1
fi

#Setup Redact for SSN
curl -X PUT -H "Content-Type:application/json" -u admin:admin \
  -d '{ "items": [
        { "name": "redaction_policy_enabled", "value": true},
        { "name": "redaction_policy", "value" : "{\n  \"version\": 1,\n  \"rules\": [\n    {\n      \"description\": \"Social Security numbers (with separator)\",\n      \"search\": \"\\\\d{3}[^\\\\w]\\\\d{2}[^\\\\w]\\\\d{4}\",\n      \"caseSensitive\": true,\n      \"replace\": \"con-fi-dent\"\n    }\n  ]\n}"}] }' \
        'http://localhost:7180/api/v1/clusters/Cluster%201/services/HDFS-1/config?view=full'
#Need to restart cluster - sorry for additional time!
curl -X POST -H "Content-Type:application/json" -u admin:admin 'http://localhost:7180/api/v1/clusters/Cluster%201/commands/restart'
 

# Done!
echo "Navigator demo setup complete!"









