/* Delete SP */
CREATE PROCEDURE TestDelete
	@user_id VARCHAR,
	@ErrorMessage VARCHAR(100) OUTPUT
AS
BEGIN

	IF NOT EXISTS
		(SELECT *
		 FROM Test_TBL
		 WHERE user_id = @user_id)

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