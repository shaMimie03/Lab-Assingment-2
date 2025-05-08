<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header('Content-Type: application/json');

include_once("dbconnect.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['full_name'] ?? '';
    $email = $_POST['email'] ?? '';
    $password = sha1($_POST['password'] ?? '');
    $phone = $_POST['phone'] ?? '';
    $address = $_POST['address'] ?? '';


    if (empty($name) || empty($email) || empty($_POST['password']) || empty($phone) || empty($address)) {
        echo json_encode(["status" => "error", "message" => "All fields required"]);
        exit();
    }

    $check = "SELECT * FROM workers WHERE email = '$email'";
    $result = $conn->query($check);
    if ($result && $result->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "Email already registered"]);
        exit();
    }

    $sql = "INSERT INTO workers (full_name, email, password, phone, address) 
            VALUES ('$name', '$email', '$password', '$phone', '$address')";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Registration successful"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Database error: " . $conn->error]);
    }

} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
    exit();
}
?>
