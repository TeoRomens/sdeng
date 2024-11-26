# Sdeng - Sports Team Management App 🏀

**Sdeng** is a cross-platform mobile application designed to revolutionize the way sports organizations manage their administrative and athlete-related tasks. The app digitizes processes traditionally handled with paper, offering streamlined features for data management, payments, medical records, and more.

![App Screenshot Placeholder](link_to_screenshot)

## Features 🌟

- **User Authentication**: Secure sign-in with Google OAuth.
- **Team Management**: Organize athletes into teams with ease.
- **Athlete Profiles**: Store and manage athlete information, including:
    - Personal details.
    - Medical records with expiration alerts.
    - Payment histories.
    - Associated documents.
- **Payment Tracking**: Add payments manually or use pre-defined formulas.
- **Document Generation**: Automatically create pre-filled documents for quick sharing.
- **Notifications**: Built-in event reminders and expiration alerts.
- **Cross-Platform**: Available on both Android and iOS devices.

## Technologies Stack 

- **Frontend**: [Flutter](https://flutter.dev/) and Dart.
- **Backend**: [Supabase](https://supabase.com/) (PostgreSQL-based).
- **Architecture**: Two-tier design with state management using Cubit.
- **Testing**: Flutter's testing framework and Mocktail for widget and user-based testing.

## Screenshots 📷
- Login  
  <img alt="Login Screenshot" height="400" src="https://github.com/TeoRomens/sdeng/blob/main/screenshots/login.png?raw=true"/>
- Home
  <img alt="Home Screenshot" height="400" src="https://github.com/TeoRomens/sdeng/blob/main/screenshots/home.png?raw=true"/>
- Athlete Management  
  <img alt="Athlete Screenshot" height="400" src="https://github.com/TeoRomens/sdeng/blob/main/screenshots/athlete.png?raw=true"/>
- Athlete Payments Management  
  <img alt="Athlete Payments Screenshot" height="400" src="https://github.com/TeoRomens/sdeng/blob/main/screenshots/athlete-payments.png?raw=true"/>

## Desktop Screenshots 📷
- Home
  <img alt="Home Screenshot" height="400" src="https://github.com/TeoRomens/sdeng/blob/main/screenshots/home-desktop.png?raw=true">
- Athlete Management  
  <img alt="Athlete Screenshot" height="400" src="https://github.com/TeoRomens/sdeng/blob/main/screenshots/athlete-desktop.png?raw=true"/>
- Medical Visits  
  <img alt="Medical Screenshot" height="400" src="https://github.com/TeoRomens/sdeng/blob/main/screenshots/med-visits-desktop.png?raw=true"/>


## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/sdeng.git

2. Navigate to the project directory:
   ```bash
   cd sdeng
   
3. Install dependencies:
   ```bash
   flutter pub get
   
4. Run the app:
   ```bash
   flutter run

## Architecture Overview 
- **Client**: A Flutter-based app handling user interaction and state management (BloC). 
- **Backend**: Supabase for real-time database, authentication, and file storage. 
- **Integration**: Direct interaction with Supabase via APIs for CRUD operations.

## Roadmap
- Core Features (Athlete Management, Payments, Notifications). 
- User Authentication via Google OAuth. 
- Push Notifications for event alerts. 
- Extended Desktop Support.

## Contact
Developed by **Matteo Roman** as part of an academic year 2023/2024 project.
Feel free to reach out via email: [matteoroman4@gmail.com].