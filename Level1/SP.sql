-- INSERT����SP
CREATE PROCEDURE TestInsert
	@user_id VARCHAR(7),
	@data_kbn VARCHAR(2),
	@acct_id VARCHAR(12),
	@amount DECIMAL(12,3),
	@interest_rate DECIMAL(6,3),
	@ErrorMessage VARCHAR(100) OUTPUT
AS
BEGIN
	IF EXISTS(
		SELECT *
		FROM Test_TBL
		WHERE user_id = @user_id
		)
		BEGIN
			SET @ErrorMessage = '���[�U�[ID���d�����邽�ߓo�^�ł��܂���B';
		END
	ELSE
		BEGIN
			INSERT INTO Test_TBL(
				user_id,
				data_kbn,
				acct_id,
				amount,
				interest_rate,
				create_date
				)
			VALUES(
				@user_id,
				@data_kbn,
				@acct_id,
				@amount,
				@interest_rate,
				getdate()
				);
		END
END;


-- UPDATE����SP
CREATE PROCEDURE TestUpdate
	@user_id VARCHAR(7),
	@amount DECIMAL(12,3),
	@interest_rate DECIMAL(6,3),	
	@ErrorMessage VARCHAR(100) OUTPUT
AS
BEGIN
	IF NOT EXISTS(
		SELECT *
		FROM Test_TBL
		WHERE user_id = @user_id
		)
		BEGIN
			SET @ErrorMessage = '���[�U�[ID�����݂��Ȃ����ߍX�V�ł��܂���B';
		END
	ELSE
		BEGIN
			UPDATE Test_TBL
			SET
			amount = @amount,
			interest_rate = @interest_rate,
			update_date = getdate()
			WHERE user_id = @user_id;
		END
END;


-- DELETE����SP
CREATE PROCEDURE TestDelete
	@user_id VARCHAR,
	@ErrorMessage VARCHAR(100) OUTPUT
AS
BEGIN
	IF NOT EXISTS(
		SELECT *
		FROM Test_TBL
		WHERE user_id = @user_id
		)
		BEGIN
			SET @ErrorMessage = '���[�U�[ID�����݂��Ȃ����ߍ폜�ł��܂���B';
		END
	ELSE
		BEGIN
			DELETE
			FROM Test_TBL
			WHERE user_id = @user_id;
		END
END;