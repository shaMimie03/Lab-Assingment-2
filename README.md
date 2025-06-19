# Worker Task Management System (WTMS)

This mobile application is developed using **Flutter**, **PHP**, and **MySQL** for STIWK2114 Mobile Programming Assignment 2 at Universiti Utara Malaysia (UUM). It allows workers to register, log in, and manage their profile with session persistence.

### 🔐 Phase 1 – Core Features
- Worker **Registration** & **Login** (with SHA1 password encryption)
- Profile screen with worker details
- Session persistence using **SharedPreferences**

### ✅ Phase 2 – Midterm Enhancements
- Worker **Task List** from `tbl_works`
- Submit **Completion Report** per task into `tbl_submissions`

## Technologies Used

- **Frontend**: Flutter (Dart)
- **Backend**: PHP (REST API)
- **Database**: MySQL
- **Storage**: SharedPreferences (for login sesgit add .
git commit -m "Finalize project"
sions)

## Getting Started

1. Clone or download this repository.
2. Set up your MySQL database and create the required `workers` table.
3. Edit the PHP files and Flutter config (`config.dart`) to match your local server settings.
4. Run the Flutter project on an emulator or physical device.


## 📱 App Features

### Authentication
- Register new workers
- Log in with "Remember Me"
- View personal profile after login

### Task Management (Phase 2)
- View tasks assigned to the logged-in worker
- Display: Title, Description, Due Date, Status
- Submit a report for a selected task
- Track submission date/time

## Author

- Name: Nur Shamimie Suriatie binti Juraini(299971)
- Course: STIWK2114 Mobile Programming
- Assignment: Lab Assignment 2 & Midterm Assingment 
- Project: Worker Task Management System (WTMS)
