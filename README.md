# Merlin

Merlin is an intelligent AI personal assistant built with Serverpod and Flutter. It helps users manage their calendar and emails through natural language conversations, powered by Google's Gemini AI.

## Features

### AI-Powered Assistant
- Natural language conversations using Google Gemini AI
- Context-aware responses based on calendar and email data
- Conversation history management

### Calendar Management
- View calendar events for any date range
- Create new calendar events with details (title, date, time, location, attendees)
- Update and delete existing events
- Find available time slots for scheduling
- Sync with Google Calendar

### Email Management
- Read and search emails
- Send new emails
- Sync with Gmail

## Architecture

Merlin is built using a three-tier architecture:

- **merlin_server**: Serverpod backend server handling business logic, AI integration, and Google API interactions
- **merlin_client**: Generated Serverpod client library for type-safe API communication
- **merlin_flutter**: Flutter mobile application providing the user interface

## Prerequisites

Before you begin, ensure you have the following installed:

- **Dart SDK** (^3.8.0)
- **Flutter SDK** (^3.32.0)
- **Docker** and **Docker Compose** (for PostgreSQL and Redis)
- **Google Cloud Project** with:
  - Google Calendar API enabled
  - Gmail API enabled
  - Google Generative AI (Gemini) API enabled
  - OAuth 2.0 credentials configured

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/suchithms19/merlin_ai
cd merlin_ai
```

### 2. Configure Google OAuth

1. Create a Google Cloud Project at [Google Cloud Console](https://console.cloud.google.com/)
2. Enable the following APIs:
   - Google Calendar API
   - Gmail API
   - Generative AI API (Gemini)
3. Create OAuth 2.0 credentials (Web application)
4. Add authorized redirect URIs:
   - `http://localhost:8082/auth/google/callback` (for local development - web server port)
   - Your production callback URL (for production)

### 3. Configure Server Secrets

Copy the example passwords file and fill in your actual values:

```bash
cd merlin_server
cp config/passwords.yaml.example config/passwords.yaml
```

Then edit `config/passwords.yaml` and replace all placeholder values with your actual secrets:

- **Database password**: Must match `POSTGRES_PASSWORD` in `docker-compose.yaml`
- **Redis password**: Must match the password in `docker-compose.yaml`
- **Google OAuth credentials**: Get from [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
- **Gemini API Key**: Get from [Google AI Studio](https://aistudio.google.com/app/apikey)
- **Authentication secrets**: Generate secure random strings for JWT and email authentication

**Important**: The `passwords.yaml` file is git-ignored and should never be committed to version control. Only commit `passwords.yaml.example`.

### 4. Start Infrastructure Services

Start PostgreSQL and Redis using Docker Compose:

```bash
cd merlin_server
docker compose up --build --detach
```

### 5. Install Dependencies

Install server dependencies:

```bash
cd merlin_server
dart pub get
```

Install Flutter dependencies:

```bash
cd merlin_flutter
flutter pub get
```

### 6. Configure Flutter App

Update `merlin_flutter/assets/config.json` with your server URL:

```json
{
  "apiUrl": "http://localhost:8080/"
}
```

## Running the Project

### Start the Server

```bash
cd merlin_server
dart bin/main.dart
```

### Run the Flutter App

In a new terminal:

```bash
cd merlin_flutter
flutter run
```

### Stop Services

To stop the server, press `Ctrl-C` in the server terminal.

To stop PostgreSQL and Redis:

```bash
cd merlin_server
docker compose stop
```

## Project Structure

```
merlin/
├── merlin_server/          # Serverpod backend server
│   ├── bin/                # Server entry point
│   ├── lib/
│   │   └── src/
│   │       ├── endpoints/  # API endpoints
│   │       ├── services/   # Business logic services
│   │       └── generated/  # Generated Serverpod code
│   ├── config/             # Configuration files
│   ├── migrations/         # Database migrations
│   └── docker-compose.yaml # Infrastructure setup
│
├── merlin_client/          # Generated Serverpod client
│   └── lib/               # Client library code
│
└── merlin_flutter/        # Flutter mobile application
    ├── lib/
    │   ├── screens/       # App screens
    │   ├── widgets/       # Reusable widgets
    │   ├── providers/     # State management
    │   └── config/        # App configuration
    └── assets/            # App assets
```

## Production Url

- **Production URL:** https://aimerlin.netlify.app/

### Login Credentials (Production)

The username and password are already provided on the **Sign In** page.  
Use those credentials to log in.

### Timezone Mismatch (Production)

- In production, some date and time values may appear incorrect due to timezone differences.
- This issue does not occur in the local environment.