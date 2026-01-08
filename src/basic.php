<html>

<head>
    <title>Database</title>
</head>
<body>
    
<?php

function judge($num) {
    if ($num % 2 == 0) {
        return "Even";
    } else {
        return "Odd";
    }
}

$sum = 0;

for ($i = 1; $i <= 10; $i++) {
    $sum += $i;
    echo "i=" . $i . " is " . judge($i) . ".<br>";
}
echo "SUM: " . $sum . "<br>";

?>
</body>

</html>
