<html>

<head>
    <title>Database</title>
    <link rel="stylesheet" type="text/css" href="/style.css">
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

echo '<table>';
foreach ($stmt as $row) {
    echo '<tr>';    // Tableの行を開始
    
    // <td></td>タグで列を囲む
    echo "<td>fishId</td>   <td>{$row['fishId']}</td>";
    echo "<td>number</td>   <td>{$row['number']}</td>";
    echo "<td>name</td>     <td>{$row['name']}</td>";
    echo "<td>gender</td>   <td>{$row['gender']}</td>";

    echo '</tr>';   // Tableの行を終了
}
echo '</table>';

?>

</body>
</html>
