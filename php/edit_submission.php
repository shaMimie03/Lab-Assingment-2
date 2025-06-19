<?php
include("dbconnect.php");
header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);

$submission_id = intval($data['submission_id'] ?? 0);
$submission_text = trim($data['submission_text'] ?? '');

if ($submission_id <= 0 || empty($submission_text)) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid data']);
    exit;
}

$sql = "UPDATE tbl_submissions SET submission_text = ? WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("si", $submission_text, $submission_id);

if ($stmt->execute()) {
    echo json_encode(['status' => 'success', 'message' => 'Submission updated']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Update failed']);
}

$stmt->close();
$conn->close();
?>