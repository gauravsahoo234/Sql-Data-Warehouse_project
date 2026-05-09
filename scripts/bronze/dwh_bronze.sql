-- Creating all customer related table
if OBJECT_ID ('bronze.crm_cust_info','U') IS NOT NULL
DROP TABLE bronze.crm_cust_info;
Go
-- first customer information
Create table bronze.crm_cust_info(
	cst_id	INT,
	cst_key	NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),	
	cst_marital_status	NVARCHAR(50),
	cst_gndr	NVARCHAR(50),
	cst_create_date date
);
-- checking file if its already present or not
if OBJECT_ID ('bronze.crm_prd_info','U') IS NOT NULL
DROP TABLE bronze.crm_prd_info;
go
-- Table for Product information
create table bronze.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),	
	prd_nm NVARCHAR(50),
	prd_cost NVARCHAR(50),
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);
go
-- checking file if its already present or not
if OBJECT_ID ('bronze.crm_sales_details','U') IS NOT NULL
DROP TABLE bronze.crm_sales_details;
go
-- Table for Sales details
create table bronze.crm_sales_details(
	sls_ord_num	NVARCHAR(50),
	sls_prd_key	NVARCHAR(50),
	sls_cust_id Integer,
	sls_order_dt Integer,
	sls_ship_dt Integer,
	sls_due_dt integer,
	sls_sales	integer, 
	sls_quantity integer,
	sls_price integer
);
go
-- Creating table for emplyoee table
-- checking file if its already present or not
if OBJECT_ID ('bronze.erm_cust_AZ12','U') IS NOT NULL
DROP TABLE bronze.erm_cust_AZ12;
go
-- Creating table for emplyoyee details
create table bronze.erm_cust_AZ12(
	CID	NVARCHAR(50),
	BDATE date,
	GEN NVARCHAR(50)
);
go
-- checking file if its already present or not
if OBJECT_ID ('bronze.erm_loc_A101','U') IS NOT NULL
DROP TABLE bronze.erm_loc_A101;
go
-- creating table for emplyoee location
create table bronze.erm_loc_A101(
	CID	NVARCHAR(50),
	CNTRY NVARCHAR(50)
);
go
-- checking file if its already present or not
if OBJECT_ID ('bronze.erm_px_cat_G1V2','U') IS NOT NULL
DROP TABLE bronze.erm_px_cat_G1V2;
go
--  creating table for product categories
create table bronze.erm_px_cat_G1V2(
	ID	NVARCHAR(50),
	CAT	NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50)
);
