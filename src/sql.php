<html>

<head>
    <title>Database</title>
</head>
<body>
    
<?php
/**
 * SQLへの接続とデータの取得
 * 
 * mysql> use database test;
 * mysql> SELECT * FROM fish;
 * 
 * 相当の内容を実行
 */

// PDOオブジェクトの作成
// dbnameに指定している「test」は各自の設定に合わせて変更してください
$dbh = new PDO('mysql:host=db;dbname=test;charset=utf8', 'root', 'password');
// SQLの実行
$query = "SELECT * FROM fish";
$stmt = $dbh->query($query);

foreach ($stmt as $row) {
    echo "fishId: " . $row['fishId'] . ", ";
    echo "number: " . $row['number'] . ", ";
    echo "name: " . $row['name'] . ", ";
    echo "gender: " . $row['gender'] . "<br>";
}

?>

</body>
</html>
