# Snap n' Score

Snap n' Score is a Flutter-based project designed to manage attendance using QR codes. It consists of an admin web app and a student Android app.
Website Link: https://snapnscore-web.vercel.app/

## Features

- QR code-based attendance marking
- Dynamic matching between students and professors
- Scalable database schema with ORM concepts
- Secure and time-limited QR codes to prevent proxy attendance

## Technology Stack

- **Frontend:** Flutter
- **Backend:** Supabase
- **Database:** PostgreSQL (managed by Supabase)

## Screenshots

### Admin Web App
<img width="1379" alt="Screenshot 2024-07-13 at 9 10 04 AM" src="https://github.com/user-attachments/assets/1cd8b37a-683c-482c-b238-17d8f3bd31a2">
<img width="1376" alt="Screenshot 2024-07-13 at 9 10 19 AM" src="https://github.com/user-attachments/assets/fe156edd-3829-4496-853d-7e56493314e1">
<img width="1375" alt="Screenshot 2024-07-13 at 9 25 58 AM" src="https://github.com/user-attachments/assets/950bd575-66e2-4403-a2ff-6a2b288ee708">


### Student Android App
![Untitled design (1)](https://github.com/user-attachments/assets/6db02fae-b9a1-4fe5-aa99-d6a854e08816)

## Demo

Here are some demo videos showcasing the project:

### Admin Web App Demo


https://github.com/user-attachments/assets/22fc3c3d-df11-4b37-8f01-dc60c5984421

### App Demo



https://github.com/user-attachments/assets/3e0ce486-198e-4ca5-b09a-7f7f34df97b1






## Setup Instructions

1. Clone the repository
    ```bash
    git clone https://github.com/Mobilon-Mobile-Technologies/snap-n-score.git
    ```
2. Navigate to the project directory
    ```bash
    cd snap-n-score
    ```
3. Install dependencies
    ```bash
    flutter pub get
    ```
4. Run the app
    ```bash
    flutter run
    ```

## Usage

1. Professor logs into the web app and generates a QR code.
2. Students use the Android app to scan the QR code.
3. The system checks the validity of the QR code and marks attendance accordingly.

## Contributing

Feel free to submit issues and pull requests.


