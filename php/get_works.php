<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include 'dbconnect.php';

try {

    $data = json_decode(file_get_contents("php://input"), true);
    

    if (!isset($data['worker_id']) || !is_numeric($data['worker_id'])) {
        throw new Exception("Valid worker_id is required.");
    }

    $workerId = intval($data['worker_id']);

    $stmt = $conn->prepare("SELECT * FROM tbl_works WHERE assigned_to = ?");
    $stmt->bind_param("i", $workerId);
    $stmt->execute();
    $result = $stmt->get_result();

    $tasks = [];
    while ($row = $result->fetch_assoc()) {
        $tasks[] = $row;
    }

    echo json_encode([
        "status" => "success",
        "data" => $tasks 
    ]);

    $stmt->close();
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}

$conn->close();
?>
