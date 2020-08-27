-- テーブル作成
CREATE TABLE test2(
	user_id VARCHAR(7) NOT NULL,
	acct_id VARCHAR(12) NOT NULL,
	amount DECIMAL(12, 3) DEFAULT NULL,
	interest_rate DECIMAL(6, 3) DEFAULT NULL,
	create_date DATETIME DEFAULT GETDATE(),
	update_date DATETIME,
	PRIMARY KEY(user_id, acct_id)
);


-- データ挿入
INSERT INTO
	test2(user_id, acct_id, amount, interest_rate)
VALUES
	(1, 1, 1.0, 1.1),
	(2, 12, 10.0, 1.2),
	(3, 123, 100.0, 1.3)
;


-- 履歴テーブル作成
CREATE TABLE history(
	serial_number DECIMAL(5, 0) NOT NULL PRIMARY KEY,
	user_id VARCHAR(7) NOT NULL,
	acct_id VARCHAR(12) NOT NULL,
	proc_type DECIMAL(1, 0) NOT NULL,
	create_date DATETIME
);
