<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include("dbconnect.php");

try {
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['worker_id']) || !is_numeric($data['worker_id'])) {
        http_response_code(400);
        throw new Exception("Invalid or missing 'worker_id'.");
    }

    $worker_id = intval($data['worker_id']);

    $stmt = $conn->prepare("
        SELECT 
            s.id,
            s.work_id,
            w.title AS task_title,
            s.submission_text,
            s.submitted_at
        FROM tbl_submissions s
        INNER JOIN tbl_works w ON s.work_id = w.id
        WHERE s.worker_id = ?
        ORDER BY s.submitted_at DESC
    ");
    
    if (!$stmt) {
        throw new Exception("Query preparation failed: " . $conn->error);
    }

    $stmt->bind_param("i", $worker_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $submissions = [];
    while ($row = $result->fetch_assoc()) {
        $submissions[] = $row;
    }

    echo json_encode([
        "status" => "success",
        "submissions" => $submissions
    ]);

    $stmt->close();
    $conn->close();

} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}
