/* 
dwh_silver.sql focued on creating the table 
===========================================
steps taken
1) Silver schema was created
2) dropping existing tables so avoid duplication 

============================================
*/

-- silver
-- Creating all customer related table of silver
if OBJECT_ID ('silver.crm_cust_info','U') IS NOT NULL
DROP TABLE silver.crm_cust_info;
Go
-- first customer information
Create table silver.crm_cust_info(
	cst_id	INT,
	cst_key	NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),	
	cst_marital_status	NVARCHAR(50),
	cst_gndr	NVARCHAR(50),
	cst_create_date date,
	dwh_create_date DATETIME2 default getdate()
);
-- checking file if its already present or not
if OBJECT_ID ('silver.crm_prd_info','U') IS NOT NULL
DROP TABLE silver.crm_prd_info;
go
-- Table for Product information
create table silver.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),	
	prd_nm NVARCHAR(50),
	prd_cost NVARCHAR(50),
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME,
	dwh_create_date DATETIME2 default getdate()
);
go
-- checking file if its already present or not
if OBJECT_ID ('silver.crm_sales_details','U') IS NOT NULL
DROP TABLE silver.crm_sales_details;
go
-- Table for Sales details
create table silver.crm_sales_details(
	sls_ord_num	NVARCHAR(50),
	sls_prd_key	NVARCHAR(50),
	sls_cust_id Integer,
	sls_order_dt Integer,
	sls_ship_dt Integer,
	sls_due_dt integer,
	sls_sales	integer, 
	sls_quantity integer,
	sls_price integer,
	dwh_create_date DATETIME2 default getdate()
);
go
-- Creating table for emplyoee table
-- checking file if its already present or not
if OBJECT_ID ('silver.erm_cust_AZ12','U') IS NOT NULL
DROP TABLE silver.erm_cust_AZ12;
go
-- Creating table for emplyoyee details
create table silver.erm_cust_AZ12(
	CID	NVARCHAR(50),
	BDATE date,
	GEN NVARCHAR(50),
	dwh_create_date DATETIME2 default getdate()
);
go
-- checking file if its already present or not
if OBJECT_ID ('silver.erm_loc_A101','U') IS NOT NULL
DROP TABLE silver.erm_loc_A101;
go
-- creating table for emplyoee location
create table silver.erm_loc_A101(
	CID	NVARCHAR(50),
	CNTRY NVARCHAR(50),
	dwh_create_date DATETIME2 default getdate()
);
go
-- checking file if its already present or not
if OBJECT_ID ('silver.erm_px_cat_G1V2','U') IS NOT NULL
DROP TABLE silver.erm_px_cat_G1V2;
go
--  creating table for product categories
create table silver.erm_px_cat_G1V2(
	ID	NVARCHAR(50),
	CAT	NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50),
	dwh_create_date DATETIME2 default getdate()
);
