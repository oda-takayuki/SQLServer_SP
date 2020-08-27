-- UPDATE & INSERT����SP

-- @�p�����[�^�Œl��n��
CREATE PROCEDURE test2_update_insert
	@user_id VARCHAR(7),
	@acct_id VARCHAR(12),
	@amount DECIMAL(12,3),
	@interest_rate DECIMAL(6,3)
AS
-- @�ϐ��̐錾
DECLARE
	-- �ϐ�@base_date��錾���Ċ����GEDATE()�Ŏ擾���đ��
	@base_date DATETIME = GETDATE(),
	@create_date DATETIME,
	@update_date DATETIME,
	@serial_number DECIMAL(5,0),
	@proc_type DECIMAL(1,0)
-- SQL�G���[�����������ꍇ��ROLLBACK���ăG���[���o�� (TRY-CATCH)
BEGIN TRY
	BEGIN TRANSACTION
		BEGIN
			-- CASE����p���ĒʔԂ��擾����serial_number�ɑ��
			SET @serial_number = (SELECT CASE WHEN MAX(serial_number) IS NULL THEN 1 ELSE MAX(serial_number)+1 END FROM history)
			-- ������������ϐ�@base_date��create_date��update_date���ꂼ��ɑ��
			SET @create_date = @base_date
			SET @update_date = @base_date
		END;
	-- IF����p����user_id�̑��݃`�F�b�N
		IF EXISTS(
			SELECT *
			FROM test2
			WHERE user_id = @user_id
			)
			-- user_id�����ɑ��݂����ꍇ��amount��interest_rate��UPDATE
			BEGIN
				UPDATE test2
				SET
				amount = @amount,
				interest_rate = @interest_rate,
				update_date = @update_date
				WHERE user_id = @user_id
				-- UPDATE�̏ꍇ��@proc_type��2����
				BEGIN
					SET @proc_type = 2
				END;
			END;
		ELSE
			BEGIN
				-- user_id�����݂��Ȃ������ꍇ�̓p�����[�^�œn�����l��INSERT
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
				-- INSERT�̏ꍇ��@proc_type��1����
				BEGIN
					SET @proc_type = 1
				END;
			END;
	
		BEGIN		
			-- history�e�[�u����INSERT
			INSERT INTO history(
				serial_number,
				user_id,
				acct_id,
				proc_type,
				create_date 
				)
			-- test2�e�[�u������user_id��acct_id���擾�B���̑��͕ϐ��̒l���擾�B
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