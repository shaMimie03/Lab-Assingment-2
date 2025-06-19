<?php
include("dbconnect.php");
header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);

$worker_id = intval($data['worker_id'] ?? 0);
$full_name = trim($data['full_name'] ?? '');
$username = trim($data['username'] ?? '');
$email = trim($data['email'] ?? '');
$phone = trim($data['phone'] ?? '');

if ($worker_id <= 0) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid worker ID']);
    exit;
}

if (empty($full_name) || empty($email) || empty($phone)) {
    echo json_encode(['status' => 'error', 'message' => 'All fields are required']);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid email format']);
    exit;
}

$sql = "UPDATE workers SET full_name = ?, email = ?, phone = ? WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("sssi", $full_name, $email, $phone, $worker_id);

if ($stmt->execute()) {
    echo json_encode([
        'status' => 'success', 
        'message' => 'Profile updated successfully',
        'data' => [
            'full_name' => $full_name,
            'email' => $email,
            'phone' => $phone
        ]
    ]);
} else {
    echo json_encode([
        'status' => 'error', 
        'message' => 'Update failed: ' . $conn->error
    ]);
}

$stmt->close();
$conn->close();
?>