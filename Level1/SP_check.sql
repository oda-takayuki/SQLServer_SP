/* DELETE SP “®ìŠm”F */
DECLARE @ErrorMessage VARCHAR (100);

EXEC TestDelete
	4,
	@ErrorMessage OUTPUT;

PRINT @ErrorMessage;