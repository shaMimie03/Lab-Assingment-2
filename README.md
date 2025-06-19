# Worker Task Management System (WTMS)

This mobile application is developed using **Flutter**, **PHP**, and **MySQL** for STIWK2114 Mobile Programming Assignment.

### 🔐 Phase 1 – Core Features
- Worker **Registration** & **Login** (with SHA1 password encryption)
- Profile screen with worker details
- Session persistence using **SharedPreferences**

### ✅ Phase 2 – Midterm Enhancements
- Worker **Task List** from `tbl_works`
- Submit **Completion Report** per task into `tbl_submissions`

### 🔄 Phase 3 – Final Enhancements
-  The final phase focuses on submission history, editing features, profile updates, and improved navigation UI.

      ### 📜 Submission History
      - View list of previous task submissions
      - Shows: **Task Title**, **Submission Date**, **Preview Text**
      - Tap to **expand and edit** submission
      - Includes **confirmation prompt** before saving
      
      ### ✏️ Edit Submission
      - Access via **History Tab**
      - Workers can **update** past submissions
      - Changes saved through `edit_submission.php`
      
      ### 👤 Profile Update
      - View current **Name**, **Email**, **Phone**
      - Edit and save changes (Username not editable)
      - Uses `update_profile.php`
      
      ### 🧭 Improved Navigation
      - **BottomNavigationBar** / **TabBar** interface
      - Tabs:
        - 📝 **Tasks**
        - 📜 **History**
        - 👤 **Profile**
      - Optional **Drawer** for future features

## ⚙️ Technologies Used

| Component | Technology        |
|----------|-------------------|
| Frontend | Flutter (Dart)    |
| Backend  | PHP (REST API)    |
| Database | MySQL             |
| Storage  | SharedPreferences |

## 📡 Backend API (Phase 3)

| API File             | Description                                    |
|----------------------|------------------------------------------------|
| `get_submissions.php`| Fetch all submissions for logged-in worker     |
| `edit_submission.php`| Update an existing submission                  |
| `get_profile.php`    | Retrieve worker profile data                   |
| `update_profile.php` | Save updated profile data                      |


## Getting Started
1. Clone or download this repository.
2. Set up a MySQL database and import the SQL schema.
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
- Assignment: Lab Assignment 2 & Midterm Assignment & Final Assingment 
- Project: Worker Task Management System (WTMS)
  
### 🎥 YouTube Demo Videos
- 🔗 [Demo  – Phase 1](https://youtu.be/cb5e07KMcjU)
- 🔗 [Demo 2 – Phase 2 ](https://youtu.be/yC-wW3xcRQc)
- 🔗 [Demo 3 – Phase 3](https://youtu.be/mx3fEaJ_Ubo)
