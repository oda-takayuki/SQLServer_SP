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
					update_date = getdate()
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
					getdate()
					);
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
END CATCH

