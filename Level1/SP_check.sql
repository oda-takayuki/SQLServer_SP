-- INSERTするSPの動作確認
DECLARE @ErrorMessage VARCHAR (100);

EXEC TestInsert
	1, 1, 12, 100, 1.1, 
	@ErrorMessage OUTPUT;

PRINT @ErrorMessage;


-- UPDATEするSPの動作確認
DECLARE @ErrorMessage VARCHAR (100);

EXEC TestUpdate
	1, 1000, 1.2,
	@ErrorMessage OUTPUT;

PRINT @ErrorMessage;


-- DELETEするSPの動作確認
DECLARE @ErrorMessage VARCHAR (100);

EXEC TestDelete
	1,
	@ErrorMessage OUTPUT;

PRINT @ErrorMessage;