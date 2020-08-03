-- INSERTするSP 動作確認
DECLARE @ErrorMessage VARCHAR (100);

EXEC TestInsert
	1, 1, 12, 100, 1.1, 
	@ErrorMessage OUTPUT;

PRINT @ErrorMessage;


-- UPDATEするSP 動作確認
DECLARE @ErrorMessage VARCHAR (100);

EXEC TestUpdate
	1, 100, 1.1,
	@ErrorMessage OUTPUT;

PRINT @ErrorMessage;


-- DELETEするSP 動作確認
DECLARE @ErrorMessage VARCHAR (100);

EXEC TestDelete
	1,
	@ErrorMessage OUTPUT;

PRINT @ErrorMessage;