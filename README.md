# データベース演習資料

## 基本的な使用方法
### MySQLのrootパスワードの設定
```shell
$ echo MYSQL_ROOT_PASSWORD=password > ./pod/db/variables.env
```

### 仮想環境の起動
```shell
$ podman compose up
```

### MYSQLコンテナへのアクセス
`Enter password`の後に`./pod/db/variables.env`に指定した`MYSQL_ROOT_PASSWORD`を入力
```shell
$ podman compose exec db mysql -u root -p
Enter password:
```
