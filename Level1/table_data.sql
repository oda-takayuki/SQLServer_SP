/* テーブル作成 */
CREATE TABLE Test_TBL(
	user_id VARCHAR(7) NOT NULL,
	data_kbn VARCHAR(2) NOT NULL,
	acct_id VARCHAR(12) NOT NULL,
	amount DECIMAL(12, 3) DEFAULT NULL,
	interest_rate DECIMAL(6, 3) DEFAULT NULL,
	create_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	update_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(user_id)
	);


/* データ挿入 */
INSERT INTO
	Test_TBL (user_id, data_kbn, acct_id, amount, interest_rate)
	VALUES
	(1, 1, 1, 1.0, 1.1),
	(2, 2, 12, 10.0, 1.2),
	(3, 3, 123, 100.0, 1.3);