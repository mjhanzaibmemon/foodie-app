<?php
$servername = 'db'; // container hostname = service name
$username   = getenv('MYSQL_USER');
$password   = getenv('MYSQL_PASSWORD');
$dbname     = "foodie_prod";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Run SELECT query
$sql = "SELECT * FROM socialmedia_posts LIMIT 2";
$result = $conn->query($sql);

// Output results
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        echo "<pre>";
        print_r($row);
        echo "</pre>";
    }
} else {
    echo "No results found.";
}

$conn->close();
?>
