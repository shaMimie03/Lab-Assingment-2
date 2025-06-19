<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

header('Content-Type: application/json');

include_once("dbconnect.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'] ?? '';
    $password = sha1($_POST['password'] ?? '');

    if (empty($email) || empty($_POST['password'])) {
        echo json_encode(["status" => "error", "message" => "Email and password required"]);
        exit();
    }

    $sql = "SELECT * FROM workers WHERE email = '$email' AND password = '$password'";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $worker = [
            "id" => $row["id"],
            "full_name" => $row["full_name"],
            "username" => $row["username"],
            "email" => $row["email"],
            "phone" => $row["phone"],
            "address" => $row["address"]
        ];
        echo json_encode(["status" => "success", "data" => $worker]);
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid credentials"]);
    }

} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
    exit();
}

