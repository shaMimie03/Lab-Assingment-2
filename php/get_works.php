<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include 'dbconnect.php';

try {
    $data = json_decode(file_get_contents("php://input"), true);
    $workerId = $data['worker_id'] ?? null;

    if (!$workerId) {
        throw new Exception("Worker ID required");
    }

    $stmt = $conn->prepare("SELECT * FROM tbl_works WHERE assigned_to = ?");
    $stmt->bind_param("i", $workerId);
    $stmt->execute();
    $result = $stmt->get_result();

    $tasks = array();
    while ($row = $result->fetch_assoc()) {
        $tasks[] = $row;
    }

    echo json_encode([
        "status" => "success",
        "tasks" => $tasks
    ]);
    $stmt->close();
} catch (Exception $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
$conn->close();
?>
