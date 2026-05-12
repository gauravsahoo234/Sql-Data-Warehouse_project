/*
Stored procedure: can be implemented by EXEC silver.load_silver
==============================================================
It follows ETL (Extract,Transform, Load) menthod from bronze table
==============================================================
Actions:
1) truncates Solver table
2) Transformed and cleansed data from Bronze schema
*/

CREATE or ALTER PROCEDURE silver.load_silver AS
BEGIN 
	declare @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		print '==============================================';
		print 'Loading Silver layer';
		print '==============================================';

		
		print '-----------------------------------------------';
		print 'CRM';
		print '-----------------------------------------------';

		
		print ' silver.crm_cust_info';
		

		SET @start_time  = GETDATE()
		PRINT '>> Truncating Data Into: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT '>> Inserting Data Into: silver.crm_cust_info';

		INSERT INTO silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)

		SELECT
			cst_id,
			cst_key,

			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,

			CASE
				WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
				ELSE 'n/a'
			END AS cst_marital_status,

			CASE
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				ELSE 'n/a'
			END AS cst_gndr,

			cst_create_date

		FROM (
			SELECT
				*,
				ROW_NUMBER() OVER (
					PARTITION BY cst_id
					ORDER BY cst_create_date DESC
				) AS flag_last

			FROM bronze.crm_cust_info

			WHERE cst_id IS NOT NULL
		) t

		WHERE flag_last = 1;
		SET @end_time = GETDATE();
		-- print those getdate
		print '>> LOAD_DURATION: '+ cast(datediff(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		print 'silver.crm_prd_inf';

		set @start_time = GETDATE();

		PRINT '>>> Truncating silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT '>>> Inserting silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info(
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
			)
		SELECT
		prd_id, 
		replace(substring(prd_key,1,5),'-','_') as cat_id,
		substring(prd_key,7,len(prd_key)) as prd_key,
		prd_nm,
		ISnull(prd_cost,0) as prd_cost,
		case when trim(upper(prd_line)) = 'M' then 'Mountain'
			 when trim(upper(prd_line)) = 'R' then 'Road'
			 when trim(upper(prd_line)) = 'S' then 'Other sales'
			 when trim(upper(prd_line)) = 'T' then 'Tourning'
			 ELSE 'n/a'
		END AS prd_line,
		CAST(prd_start_dt as date) as prd_start_dt,
		cast(lead(prd_start_dt) OVER( partition by prd_key order by prd_start_dt) - 1 as date) as prd_end_dt
		from bronze.crm_prd_info;

		set @end_time = GETDATE();
		print '>> LOAD_DURATION: '+ cast(datediff(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT'silver.crm_sales_details';

		set @start_time = getdate();

		PRINT '>>> Truncating silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>>> Inserting silver.crm_sales_details';

		insert into silver.crm_sales_details(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales, 
			sls_quantity,
			sls_price
		)
		select sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE when 
			sls_order_dt <= 0 or len(sls_order_dt) != 8 then NULL
			else cast(CAST(sls_order_dt AS VARCHAR) AS DATE)
		END AS sls_order_dt,
		CASE when 
			sls_ship_dt <= 0 or len(sls_ship_dt) != 8 then NULL
			else cast(CAST(sls_ship_dt AS VARCHAR) AS DATE)
		END AS sls_ship_dt,
		CASE when 
			sls_due_dt <= 0 or len(sls_due_dt) != 8 then NULL
			else cast(CAST(sls_due_dt AS VARCHAR) AS DATE)
		END AS sls_due_dt,
		case when sls_sales IS NULL or sls_sales <= 0 or sls_sales != sls_quantity * ABS(sls_price) then sls_quantity * ABS(sls_price)
			else sls_sales
		END as sls_sales,
		sls_quantity,
		case when sls_price IS NULL oR sls_price <= 0 then
			sls_sales/nullif(sls_quantity,0)
			else sls_price
		end as sls_price
		from bronze.crm_sales_details;
		set @end_time = getdate();
		print '>>> LOAD_DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds';

		print '-----------------------------------------------';
		print 'ERM';
		print '-----------------------------------------------';

		print 'silver.erm_cust_AZ12'

		set @start_time = GETDATE();

		PRINT '>>> Truncating silver.erm_cust_AZ12';
		TRUNCATE TABLE silver.erm_cust_AZ12;
		PRINT '>>> Inserting silver.erm_cust_AZ12';

		insert INTO silver.erm_cust_AZ12(
		CID,
			ID,
			cst_key,
			BDATE,
			GEN
		)
		select
		CID,
		trim(upper(substring(CID,4,len(CID)))) AS ID,
		trim(upper(substring(CID,9,len(CID)))) as cst_key,  
		case when BDATE > GETDATE() then NULL
		else BDATE
		END AS BDATE,
		CASE when UPPER(trim(GEN)) = 'M' or UPPER(trim(GEN))  ='Male' THEN 'Male'
		WHEN UPPER(trim(GEN))  = 'F' or UPPER(trim(GEN))  ='Female' THEN 'Female'
		Else 'n/a'
		end as GEN
		from bronze.erm_cust_AZ12;
		set @end_time = GETDATE();
		print '>>> LOAD_DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds';

		print'Truncating silver.erm_loc_A101'

		set @start_time = GETdate();

		PRINT '>>> Truncating silver.erm_loc_A101';
		TRUNCATE TABLE silver.erm_loc_A101;
		PRINT '>>> silver.erm_loc_A101';

		Insert into silver.erm_loc_A101(
		CID,
		CNTRY
		)
		select replace(CID,'-',''), 
		case when trim(CNTRY) = 'DE' then 'GERMANY'
			when trim(CNTRY) IN ('US','USA') THEN 'United States'
			when trim(cntry) = '' OR cntry IS NULL then 'n/a'
			ELSE trim(cntry)
		END AS CNTRY
		from bronze.erm_loc_A101;
		set @end_time = GETDATE();
		print '>>> LOAD_DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds';

		print'silver.erm_px_cat_G1V2'
		
		set @start_time = GETDATE();

		PRINT '>>> silver.erm_px_cat_G1V2';
		TRUNCATE TABLE silver.erm_px_cat_G1V2;
		PRINT '>>> silver.erm_px_cat_G1V2';

		INSERT INTO silver.erm_px_cat_G1V2 (
		ID, 
		CAT, 
		SUBCAT, 
		MAINTENANCE 
		)
		SELECT 
		ID, 
		CAT, 
		SUBCAT, 
		MAINTENANCE 
		from bronze.erm_px_cat_G1V2;
		set @end_time = GETDATE();
		print '>>> LOAD_DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds';

		SET @batch_end_time = GETDATE();
		print '>>>>> completed silver layer <<<<<'
		print '>>> BATCH_LOAD_DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds';
		print '>>>>>>>>>>>         <<<<<<<<<<<<<'


	end try
	Begin CATCH
		print 'Error occuried durning loading silver layer'
		print 'error messege' + error_message();
		print 'error messege' + CAST(error_number() AS NVARCHAR);
		print 'error messege' + CAST(error_state() AS NVARCHAR);
	END CATCH
END
