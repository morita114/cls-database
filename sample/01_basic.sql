-- テスト用DBの作成
CREATE DATABASE sample;
-- DBの確認
SHOW DATABASES;
-- DBの切り替え
USE sample;

-- 例示用テーブルを作成
CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  name VARCHAR(50),
  salary DECIMAL(10,2)
);
-- テーブルの確認
SHOW TABLES;

-- テストデータを挿入
INSERT INTO employee VALUES
(1, 'Tanaka', 300000),
(2, 'Sato',   280000),
(3, 'Suzuki', 320000);
-- 挿入したデータの確認
SELECT * FROM employee;


-- デリミタ（終端文字）を「;」から「//」へ一時的に変更
DELIMITER //

-- カーソルとFETCHを使うストアドプロシージャを作成
CREATE PROCEDURE copy_employee_names()
BEGIN
  -- 変数宣言
  DECLARE v_name VARCHAR(50);
  DECLARE done INT DEFAULT 0;

  -- カーソル定義
  DECLARE emp_cursor CURSOR FOR
    SELECT name FROM employee;

  -- 終了条件ハンドラを定義
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  -- カーソルを開く
  OPEN emp_cursor;

  -- ループ開始
  read_loop: LOOP
    FETCH emp_cursor INTO v_name;   -- 1行取り出す
    IF done THEN
      LEAVE read_loop;              -- データがなくなったらループ終了
    END IF;
    SELECT v_name AS employee_name;  -- 取り出した名前を出力
  END LOOP;

  -- カーソルを閉じる
  CLOSE emp_cursor;
END //

-- デリミタの変更を元に戻す
DELIMITER ;

