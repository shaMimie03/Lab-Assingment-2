<?php 
include("dbconnect.php");
header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);
$worker_id = intval($data['worker_id'] ?? 0);

if ($worker_id <= 0) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid worker ID']);
    exit;
}

$sql = "SELECT id AS workerId, username, full_name, email, phone FROM tbl_works WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $worker_id);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode(['status' => 'success', 'data' => $row]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Worker not found']);
}
?>
