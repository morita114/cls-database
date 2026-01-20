<html>

<head>
    <title>Database</title>
    <link rel="stylesheet" type="text/css" href="/style.css">
</head>
<body>

<?php

// URLパラメータの取得
$gender = $_GET['gender'] ?? '';

if ($gender == '') {
    echo '<p>全て表示しています。</p><br>';
    echo '<p>';
    echo '<a href="/fishTable/v2.php?gender=F">メスのみ表示</a>';
    echo '  /  ';
    echo '<a href="/fishTable/v2.php?gender=M">オスのみ表示</a><br>';
    echo '</p>';

    $query = "SELECT * FROM fish";     // QueryにWHEREを追加
} else {
    $query = "SELECT * FROM fish WHERE gender = '$gender'";     // QueryにWHEREを追加
    if ($gender == 'F') {
        echo '<p>メスのみ表示しています。</p>';
    } elseif ($gender == 'M') {
        echo '<p>オスのみ表示しています。</p>';
    } else {
        echo '<p>不正なパラメータです。</p>';
        return;
    }
}


$dbh = new PDO('mysql:host=db;dbname=test;charset=utf8', 'root', 'password');
$stmt = $dbh->query($query);

echo '<table>';
foreach ($stmt as $row) {
    echo '<tr>';
    
    echo "<td>fishId</td>   <td>{$row['fishId']}</td>";
    echo "<td>number</td>   <td>{$row['number']}</td>";
    echo "<td>name</td>     <td>{$row['name']}</td>";
    echo "<td>gender</td>   <td>{$row['gender']}</td>";

    echo '</tr>';
}
echo '</table>';

?>

</body>
</html>
