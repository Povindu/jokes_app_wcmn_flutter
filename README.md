# Flutter Jokes App

This Flutter application fetches jokes from an API and caches them using the `shared_preferences` package. The app is designed to display five jokes in both online and offline modes, ensuring a seamless user experience regardless of internet connectivity.

---

## Features

- **Fetch Jokes Online**: Retrieves 5 jokes from the jokes API using a `GET` request.
- **Offline Support**: Displays cached jokes when the app is launched without an internet connection.
- **Caching**: Stores jokes using the `shared_preferences` package for offline use.
- **Error Handling**: Handles scenarios such as no internet connection or API errors gracefully.

---

## Requirements

1. **Flutter Framework**: The app is built entirely using Flutter.
2. **Caching**: Utilizes `shared_preferences` for caching jokes.
3. **Offline Mode**: Ensures jokes are displayed when no internet connection is available.
4. **UI**: Displays exactly 5 jokes at all times.
5. **JSON Handling**: Proper serialization and deserialization of API responses.

---

## Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone <repository_url>
   cd <repository_folder>
