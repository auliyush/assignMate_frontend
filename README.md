# AssignMate
AssignMate is an assignment submission app designed to streamline the process of submitting, managing, and reviewing assignments for students and instructors. Built with a user-friendly interface, the app aims to make assignment tracking more efficient and organized.

# Features
- Student Assignment Submission: Students can submit assignments directly through the app.
- Instructor Review: Instructors can review and grade assignments.
- Cloud Storage Integration: Integrates with Cloudinary to store assignments and additional resources.
- Notifications: Notifies users on assignment deadlines and updates.

# Tech parts
- Frontend: Flutter, Dart
- Backend: Spring Boot, MongoDB
- Deployment : Render
- Storage: Supabase for document storage
- APIs: RESTful API for backend communication
- Other Libraries: (Include libraries such as Provider, Dio, Cloudinary Flutter, etc.)

# Installation
git clone https://github.com/auliyush/assignMate_frontend.git
cd assignMate
flutter pub get
flutter run

# Usage
there is login screen for login if you do't have account create account go to sign Up page
there is two options of signup User and Admin
if you signup as user then signup as normally
if you signup as admin then use my Code 'codingAge1'
# ADMIN
you see first home screen as assignment screen that show you your assignment which you created
tap of any assignment to see the details and how much students submitted your submission
tap of any submission and you update their status to reviewed or rejected and also give feedback
second screen is for create assignment where you can create assignment
third screen is more screen which shows you your data and top of screen notifications
In more screen you log out and see your assignments
# USER
you see first home screen as assignment screen that show you assignment which assigned you
tap of any assignment and see their details if you submitted then shows your submission else create submission button
if you not submitted then tap on create submission and create submission and submittted it
after come back to home screen 
the next screen is more screen which shows you your data and top of screen notifications
In more screen you log out and see your submissions
