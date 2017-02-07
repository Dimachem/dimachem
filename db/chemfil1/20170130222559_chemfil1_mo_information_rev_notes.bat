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
REM   Source_Schema => left blank
REM   Source_Table      Target_Schema           Target_Table                Source PK       Target PK       Select_Expression
ECHO 	[MO Information]	`CHEMFIL1_DEVELOPMENT`	`mo_information_rev_notes`	[PRODUCT CODE]	`PRODUCT CODE`	[PRODUCT CODE], [REV NOTES] >> "%TMP%\wb_tables_to_migrate.txt"


wbcopytables.exe --dont-disable-triggers --odbc-source="DSN=CHEMFIL1 A97" --progress --source-rdbms-type=MsAccess --source-charset=cp1252 --target="root@localhost:3306" --source-password="%arg_source_password%" --target-password="%arg_target_password%" --table-file="%table_file%" --thread-count=%arg_worker_count% %arg_truncate_target% %arg_debug_output%

REM Removes the file with the table definitions
DEL "%TMP%\wb_tables_to_migrate.txt"
