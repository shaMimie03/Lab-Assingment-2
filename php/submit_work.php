<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include 'dbconnect.php';

try {
    $rawInput = file_get_contents("php://input");
    $data = json_decode($rawInput, true);

    $workId = $data['work_id'] ?? null;
    $workerId = $data['worker_id'] ?? null;
    $submissionText = $data['submission_text'] ?? null;

    if (!$workId || !$workerId || !$submissionText) {
        throw new Exception("All fields are required");
    }

    $stmt = $conn->prepare("INSERT INTO tbl_submissions (work_id, worker_id, submission_text) VALUES (?, ?, ?)");
    $stmt->bind_param("iis", $workId, $workerId, $submissionText);

    if ($stmt->execute()) {
        $updateStmt = $conn->prepare("UPDATE tbl_works SET status = 'completed' WHERE id = ? AND assigned_to = ?");
        $updateStmt->bind_param("ii", $workId, $workerId);
        $updateStmt->execute();
        $updateStmt->close();

        echo json_encode(["status" => "success", "message" => "Submission saved"]);
    } else {
        throw new Exception("Error saving submission");
    }

    $stmt->close();
} catch (Exception $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}

$conn->close();
?>
