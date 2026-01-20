<html>

<head>
    <title>Database</title>
    <link rel="stylesheet" type="text/css" href="/style.css">
</head>
<body>

<?php

$gender = $_GET['gender'] ?? '';

if ($gender == '') {
    echo '<p>全て表示しています。</p><br>';
    
    // リンクを入力ボックスに変更
    echo '<input type="text" id="genderInput"> のみ ';
    echo '<input type="button" value="表示" onclick="selectGender()">';

    $query = "SELECT * FROM fish";
} else {
    $query = "SELECT * FROM fish WHERE gender = '$gender'";
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

<script type="text/javascript">
    function selectGender() {
        const gender = document.getElementById("genderInput").value;
        window.location.href = "/fishTable/v3.php?gender=" + gender;
    }
</script>

</body>
</html>
