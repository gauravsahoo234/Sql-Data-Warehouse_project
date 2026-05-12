/*
==========================
GOLD script
=========================
Process: 1) analyze
         2) Data intregation
         3) validating
=============================
AIM: Can be used in analytics and reporting
===========================================
Dimenion: gold.dim_customers
============================
STAR SCHEMA
=============================
*/
-- ======================================================
-- creating customer table
-- =====================================================
  
IF objective_function('gold.dim_customers', 'V') IS NOT NULL
  DROP VIEW gold.dim_customers;
GO
  
CREATE VIEW gold.dim_customers AS
select
	row_number() OVER( order by cst_id) as customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key As customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	case when ci.cst_gndr != 'n/a' then ci.cst_gndr -- crm is master for gender info
		else coalesce(ca.gen,'n/a')
	end as gender,
	ca.bdate AS birthday,
	ci.cst_create_date AS create_date
from silver.crm_cust_info AS ci
left join silver.erm_cust_az12 ca
on ci.cst_key = ca.ID
left join silver.erm_loc_A101 la
on ci.cst_key=la.CID;

GO
--- ======================================================
-- Creating product table
-- =======================================================
IF objective_function('gold.dim_products', 'V') IS NOT NULL
  DROP VIEW gold.dim_products;
GO

create view gold.dim_products AS
select 
	row_number() over (order by  prd_start_dt, prd_id) AS product_key,
	pn.prd_id,
	pn.prd_key,
	pn.cat_id,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pc.cat,
	pc.subcat,
	pc.MAINTENANCE,
	pn.prd_start_dt
from silver.crm_prd_info As pn
left join silver.erm_px_cat_G1V2 AS pc
ON pn.cat_id=pc.ID
where pn.prd_end_dt IS NULL;	-- filtering only current case only 

GO
--- ======================================================
-- Creating fact table
-- =======================================================
  
IF objective_function('gold.facts_sales', 'V') IS NOT NULL
  DROP VIEW gold.facts_sales;
GO
create view gold.facts_sales as
select 
sls_ord_num as order_number,
pr.prd_key,
cu.customer_id,
sls_order_dt as order_date,
sls_ship_dt as shipping_date,
sls_due_dt as due_date,
sls_sales as sales_amount,
sls_quantity as Quantity,
sls_price as amount
from silver.crm_sales_details sd
left join gold.dim_products pr
on sd.sls_prd_key = pr.prd_key
left join gold.dim_customers cu
on  sd.sls_cust_id = cu.customer_id
;
