REM Workbench Table Data copy script
REM Workbench Version: 6.3.6
REM
REM Execute this to copy table data from a source RDBMS to MySQL.
REM Edit the options below to customize it. You will need to provide passwords, at least.
REM
REM Source DB:  (Microsoft Access)
REM Target DB: Mysql@localhost:3306


@ECHO OFF
REM Source and target DB passwords
set arg_source_password=
set arg_target_password=sa123

IF [%arg_source_password%] == [] (
    IF [%arg_target_password%] == [] (
        ECHO WARNING: Both source and target RDBMSes passwords are empty. You should edit this file to set them.
    )
)
set arg_worker_count=1
REM Uncomment the following options according to your needs

REM Whether target tables should be truncated before copy
REM set arg_truncate_target=--truncate-target
REM Enable debugging output
REM set arg_debug_output=--log-level=debug3


REM Creation of file with table definitions for copytable

set table_file="%TMP%\wb_tables_to_migrate.txt"
TYPE NUL > "%TMP%\wb_tables_to_migrate.txt"
ECHO 	[New Product Progress Data]	`CHEMFIL1_DEVELOPMENT`	`New_Product_Progress_Data`	[Product Code]	`Product Code`	[Product Code], [Product Name], [Start Date], `Sales Request?`, [Priority], `EMail Notification?`, [Requested By], [Customer], [Disc Nature-Duration-Complexity], [Disc Nature-Duration-Complexity YN], [Disc Nature-Duration-Complexity Date], [Disc Consequences of Failure], [Disc Consequences of Failure YN], [Disc Consequences of Failure Date], [TDS MSDS YN], [TDS MSDS Date], [TDS MSDS Com], [Formula YN], [Formula Date], [Formula Com], [Test Proc Rec YN], [Test Proc Rec Date], [Test Proc Rec Com], [Prod Spec YN], [Prod Spec Date], [Prod Spec Com], [Form to Purch Mang YN], [Form to Purch Mang Date], [Form to Purch Mang Com], [Test proc Forw YN], [Test proc Forw Date], [Test proc Forw Com], [OK on Raws YN], [OK on Raws Date], [OK on Raws Com], [Prod Code Entered YN], [Prod Code Entered Date], [Prod Code Entered Com], [MSDS Init YN], [MSDS Init Date], [MSDS Init Com], [Lab Batch YN], [Lab Batch Date], [Lab Batch Com], [QC Tests Entered YN], [QC Tests Entered Date], [QC Tests Entered Com], [Formula Entered YN], [Formula Entered Date], [Formula Entered Com], [Comments], [Status], [Env_Aspects_YN], [Env_Aspects_Date], [Env_Aspects_Com], [Cust_Req_YN], [Cust_Req_Date], [Cust_Req_Com], [Cust_Specs_YN], [Cust_Specs_Date], [Cust_Specs_Com], [MOC_YN], [MOC_Date], [MOC_Com], [Sr_Mgmt_Rev_YN], [Sr_Mgmt_Rev_Date], [Sr_Mgmt_Rev_Com], [Sr_Mgmt_Rev_BY], [Sales to Date] >> "%TMP%\wb_tables_to_migrate.txt"


wbcopytables.exe --dont-disable-triggers --odbc-source="DSN=CHEMFIL1 A97" --progress --source-rdbms-type=MsAccess --source-charset=cp1252 --target="root@localhost:3306" --source-password="%arg_source_password%" --target-password="%arg_target_password%" --table-file="%table_file%" --thread-count=%arg_worker_count% %arg_truncate_target% %arg_debug_output%

REM Removes the file with the table definitions
DEL "%TMP%\wb_tables_to_migrate.txt"
