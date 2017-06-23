CREATE TABLE IF NOT EXISTS salesdata (
  s_num	      FLOAT,
  s_borough   INT,
  s_neighbor  STRING,
  s_b_class   STRING,
  s_c_p       STRING,
  s_block     STRING,
  s_lot       STRING,
  s_easement  STRING,
  w_c_p_2     STRING,
  s_address   STRING,
  s_app_num   STRING,
  s_zip	      STRING,
  s_res_units STRING,
  s_com_units STRING,
  s_tot_units INT,
  s_sq_ft     FLOAT,
  s_g_sq_ft   FLOAT,
  s_yr_built  INT,
  s_tax_c     INT,
  s_b_class2  STRING,
  s_price     FLOAT,
  s_sales_dt  STRING
  
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

