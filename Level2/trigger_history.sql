CREATE TRIGGER trg_history_insert
ON test2
AFTER INSERT
AS
BEGIN	
	DECLARE 
		@create_date DATETIME = GETDATE(),
		@serial_number DECIMAL(5,0) = (SELECT MAX(serial_number)+1 from history)
	INSERT INTO history(
		serial_number,
		user_id,
		acct_id,
		proc_type,
		create_date
	)
	SELECT	
		@serial_number,
		user_id,
		acct_id,
		1 AS proc_type,
		@create_date
	FROM inserted;
END
GO
CREATE TRIGGER trg_history_update
ON test2
AFTER UPDATE
AS
BEGIN
	DECLARE
		@create_date DATETIME = GETDATE(),
		@serial_number DECIMAL(5,0) = (SELECT MAX(serial_number)+1 from history)
	INSERT INTO history(
		serial_number,
		user_id,
		acct_id,
		proc_type,
		create_date 
	)
	SELECT 
		@serial_number,
		user_id,
		acct_id,
		2 AS proc_type,
		@create_date
	FROM inserted;
END