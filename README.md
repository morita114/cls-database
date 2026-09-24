# データベース演習資料

## 環境構築
### 1. Ubuntu 24.04.4 LTS on Windows Subsystem for Linux 用のセットアップ手順
`lemp_setup.sh`をroot権限で実行してください．
```shell
$ sudo ./lemp_setup.sh
```

正常修了できた場合は， 仮想環境の起動と，各サービスへアクセス出来るかを確認してください．

### 1. Mac...




---
## 仮想環境の起動
WSLをシャットダウンするまでは起動したままになるので，演習時に一度実行してください．
```shell
$ ./lemp_start.sh
```

---
## 各サービスへのアクセス方法
### Webページ
- ブラウザで __http://localhost__ 以下のURLヘアクセスしてください．
- ファイル名を指定しない場合は，指定したディレクトリ内の _index.php_ → _index.html_ → _index.htm_ の順に試行しアクセスできたものが表示される．
- `http://localhost/` ヘアクセスすると，WSL上の `/var/www/html/` をルートディレクトリとしてアクセス出来る．

### MySQLデータベース
`Enter password`の後に`lemp_setup.sh`の`MYSQL_ROOT_PASSWORD`に指定した文字列をパスワードとして入力する．
```shell
$ mysql -u root -p
Enter password: ここにパスワードを入力（入力した文字は表示されませんが，入力はされています）
```

---
## サンプルコード
### MySQLの動作確認
[/sql/12_init.sql]() の内容を順番に実行出来るかを確認する．

```shell
$ mysql -u root -p

$ (mysql) create database test;
Query OK, 1 row affected (0.01 sec)

$ use test;
Database changed
(後は省略)
```

### Nginx + PHP + MySQLの動作確認
次のコマンドで，各ファイルを `/var/www/html/` 直下にコピー後に権限を修正してしてアクセスしてください．
```shell
$ sudo rsync -avh --progress ./php/ /var/www/html/
$ sudo chown -R www-data:www-data /var/www/html/
```

### 基本動作の確認
1. [./php/hello.html](/php/hello.html)	→ http://localhost:8080/hello.html
1. [./php/info.php](/php/info.php)		→ http://localhost:8080/info.php
1. [./php/hello.php](/php/hello.php)
1. [./php/basic.php](/php/basic.php)
1. [./php/sql.php](/php/sql.php)
    - 実行前に，MySQLの動作確認を完了しておいてください．
1. [./php/arg.php](/php/arg.php)


### 発展的な挙動の説明用
1. [./php/fishTable/v0.php]
1. [./php/fishTable/v1.php]
1. [./php/fishTable/v2.php]
1. [./php/fishTable/v3.php]
