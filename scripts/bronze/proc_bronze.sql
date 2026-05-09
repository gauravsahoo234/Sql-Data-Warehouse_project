-- create procedure: Daily refreshing the table and loading it before stating of any future analysis
CREATE or ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		print '==============================================';
		print 'Loading bronze layer';
		print '==============================================';
		-- CRM
		-- first truncate the table, then load the info

		print '-----------------------------------------------';
		print 'CRM';
		print '-----------------------------------------------';
		set @start_time = GETDATE();
		Print '>>> truncating bronze.crm_cust_info';

		TRUNCATE TABLE bronze.crm_cust_info; 
	
		Print '>>> Inserting bronze.crm_cust_info';

		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Downloads\Downloads\XIME-KOC\sql\PROJECT WITH BARAA\Warehouse\CRM\cust_info.csv'
		WITH (
		FIRSTROW =2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		set @end_time = GETDATE();
		print 'PRINT >> LOAD_DURATION: '+ cast(datediff(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		--  checking the quality of the table (modifying by removing the comments)
		-- SELECT * FROM bronze.crm_cust_info;
	
		set @start_time = GETDATE();
		Print '>>> truncating bronze.crm_prd_info';

		-- Product info
		-- truncate the table, then load the info
		TRUNCATE TABLE bronze.crm_prd_info; 

		Print'>>> Inserting bronze.crm_prd_info';

		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Downloads\Downloads\XIME-KOC\sql\PROJECT WITH BARAA\Warehouse\CRM\prd_info.csv'
		WITH (
		FIRSTROW =2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		set @end_time = GETDATE();
		print'PRINT >> LOAD_DURATION: '+ cast(datediff(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		
		--  checking the quality of the table
		-- SELECT * FROM bronze.crm_prd_info;
	
	    set @start_time = GETDATE();

		Print'>>> truncating bronze.crm_sales_details';
		-- Sales details
		-- truncate the table, then load the info
		TRUNCATE TABLE bronze.crm_sales_details; 

		Print'>>> Inserting bronze.crm_prd_info';

		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Downloads\Downloads\XIME-KOC\sql\PROJECT WITH BARAA\Warehouse\CRM\sales_details.csv'
		WITH (
		FIRSTROW =2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		set @end_time = GETDATE();
		print'PRINT >> LOAD_DURATION: '+ cast(datediff(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		--  checking the quality of the table
		-- SELECT * FROM bronze.crm_sales_details;

		print'-----------------------------------------------';
		print'ERM';
		print'-----------------------------------------------';

		-- ERM
		-- customer information
		-- truncate the table, then load the info
	
		set @start_time = GETDATE();

		Print'>>> Truncating bronze.erm_cust_AZ12';

		TRUNCATE TABLE bronze.erm_cust_AZ12; 
	
		Print'>>> Inserting bronze.erm_cust_AZ12';

		BULK INSERT bronze.erm_cust_AZ12
		FROM 'D:\Downloads\Downloads\XIME-KOC\sql\PROJECT WITH BARAA\Warehouse\ERM\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE();
		print'PRINT >> LOAD_DURATION: '+ cast(datediff(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		--  checking the quality of the table
		-- SELECT * FROM bronze.erm_cust_AZ12;

		-- location
		-- truncate the table, then load the info

		set @start_time = GETDATE();

		Print'>>> Truncating bronze.erm_loc_A101';

		TRUNCATE TABLE bronze.erm_loc_A101; 

		Print'>>> Inserting bronze.erm_loc_A101';

		BULK INSERT bronze.erm_loc_A101
		FROM 'D:\Downloads\Downloads\XIME-KOC\sql\PROJECT WITH BARAA\Warehouse\ERM\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE();
		print'PRINT >> LOAD_DURATION: '+ cast(datediff(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		--  checking the quality of the table
		-- SELECT * FROM bronze.erm_loc_A101;

		-- Product categories
		-- truncate the table, then load the info

		set @start_time = GETDATE();
		Print'>>> Truncating bronze.erm_px_cat_G1V2';

		TRUNCATE TABLE bronze.erm_px_cat_G1V2; 

		Print'>>> Inserting bronze.erm_px_cat_G1V2';
		BULK INSERT bronze.erm_px_cat_G1V2
		FROM 'D:\Downloads\Downloads\XIME-KOC\sql\PROJECT WITH BARAA\Warehouse\ERM\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE();
		print'PRINT >> LOAD_DURATION: '+ cast(datediff(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		--  checking the quality of the table
		-- SELECT * FROM bronze.erm_px_cat_G1V2;

	END TRY
	Begin CATCH
		print 'Error occuried durning loading bronze layer'
		print 'error messege' + error_message();
		print 'error messege' + CAST(error_number() AS NVARCHAR);
		print 'error messege' + CAST(error_state() AS NVARCHAR);
	END CATCH
END;
GO
EXEC bronze.load_bronze;
