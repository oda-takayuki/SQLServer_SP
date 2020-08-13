/*
ユーザーIDが既に存在した場合は、金額と利率をUPDATE
ユーザーIDが存在しなかった場合は、INSERT
*/
CREATE PROCEDURE test2_update_insert
	@user_id VARCHAR(7),
	@acct_id VARCHAR(12),
	@amount DECIMAL(12,3),
	@interest_rate DECIMAL(6,3)
AS
BEGIN TRY
	BEGIN TRANSACTION
		DECLARE @update_date DATETIME = getdate(),
				@create_date DATETIME = getdate()
		MERGE INTO test2 AS A
			USING (
				SELECT
				@user_id AS user_id,
				@acct_id AS acct_id,
				@amount AS amount,
				@interest_rate AS interest_rate
				)AS B
			ON
				(A.user_id = B.user_id)
			WHEN MATCHED THEN
				UPDATE
				SET
					amount = B.amount,
					interest_rate = B.interest_rate,
					update_date = @update_date
			WHEN NOT MATCHED THEN
				INSERT (
					user_id,
					acct_id,
					amount,
					interest_rate,
					create_date
					)
				VALUES (
					B.user_id,
					B.acct_id,
					B.amount,
					B.interest_rate,
					@create_date
					);
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO


-- INSERT後に履歴テーブルにデータを挿入するトリガー
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

-- UPDATE後に履歴テーブルにデータを挿入するトリガー
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