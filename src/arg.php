<html>

<head>
    <title>Database</title>
</head>
<body>
    
<?php

// URL経由で渡されたパラメータの取得
//   ex.) http://localhost:8080/arg.php?gender=F
$gender = $_GET["gender"];
// HTML側の実装によってはPOSTになる場合もある
// $gender = $_POST["regDate"]; 

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


echo "<h2>PHPでの実装</h2>";
$query = "SELECT * FROM fish";
$stmt = $dbh->query($query);
foreach ($stmt as $row) {
    if ($row['gender'] == $gender) {
        echo "fishId: " . $row['fishId'] . ", ";
        echo "number: " . $row['number'] . ", ";
        echo "name: " . $row['name'] . ", ";
        echo "gender: " . $row['gender'] . "<br>";
    }
}


echo "<h2>SQLでの実装</h2>";
$query = "SELECT * FROM fish WHERE gender = '$gender'";
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
