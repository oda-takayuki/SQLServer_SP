-- UPDATE & INSERTするSP

-- @パラメータで値を渡す
CREATE PROCEDURE test2_update_insert
	@user_id VARCHAR(7),
	@acct_id VARCHAR(12),
	@amount DECIMAL(12,3),
	@interest_rate DECIMAL(6,3)
AS
-- @変数の宣言
DECLARE
	-- 変数@base_dateを宣言して基準日をGEDATE()で取得して代入
	@base_date DATETIME = GETDATE(),
	@create_date DATETIME,
	@update_date DATETIME,
	@serial_number DECIMAL(5,0),
	@proc_type DECIMAL(1,0)
-- SQLエラーが発生した場合はROLLBACKしてエラーを出力 (TRY-CATCH)
BEGIN TRY
	BEGIN TRANSACTION
		BEGIN
			-- CASE文を用いて通番を取得してserial_numberに代入
			SET @serial_number = (SELECT CASE WHEN MAX(serial_number) IS NULL THEN 1 ELSE MAX(serial_number)+1 END FROM history)
			-- 基準日を代入した変数@base_dateをcreate_dateとupdate_dateそれぞれに代入
			SET @create_date = @base_date
			SET @update_date = @base_date
		END;
	-- IF文を用いてuser_idの存在チェック
		IF EXISTS(
			SELECT *
			FROM test2
			WHERE user_id = @user_id
			)
			-- user_idが既に存在した場合はamountとinterest_rateをUPDATE
			BEGIN
				UPDATE test2
				SET
				amount = @amount,
				interest_rate = @interest_rate,
				update_date = @update_date
				WHERE user_id = @user_id
				-- UPDATEの場合は@proc_typeに2を代入
				BEGIN
					SET @proc_type = 2
				END;
			END;
		ELSE
			BEGIN
				-- user_idが存在しなかった場合はパラメータで渡した値をINSERT
				INSERT INTO test2(
					user_id,
					acct_id,
					amount,
					interest_rate,
					create_date
					)
				VALUES(
					@user_id,
					@acct_id,
					@amount,
					@interest_rate,
					@create_date
					);
				-- INSERTの場合は@proc_typeに1を代入
				BEGIN
					SET @proc_type = 1
				END;
			END;
	
		BEGIN		
			-- historyテーブルにINSERT
			INSERT INTO history(
				serial_number,
				user_id,
				acct_id,
				proc_type,
				create_date 
				)
			-- test2テーブルからuser_idとacct_idを取得。その他は変数の値を取得。
			SELECT	
				@serial_number,
				user_id,
				acct_id,
				@proc_type,
				@create_date
			FROM test2
			WHERE user_id = @user_id
		END;
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	SELECT ERROR_MESSAGE() AS ErrorMessage;
	SELECT ERROR_LINE() AS ErrorLine;
END CATCH