# 🚀 Cosmic Lens Lite
**A Production-Grade NASA APOD Explorer built with Flutter & Provider**

---

## 📖 Project Overview

**Cosmic Lens Lite** is a robust mobile application designed to explore the cosmos using the **NASA Astronomy Picture of the Day (APOD) API**.

Unlike simple tutorial apps, this project was architected to demonstrate **production-grade engineering principles**. It features robust state management, defensive handling of complex API data (polymorphic media types), intelligent local caching for network efficiency, and a cross-platform responsive design that works seamlessly on both Mobile and Web.

---

## ✨ Key Features

### 1. **Core Functionality**
* **Daily Astronomy Feed:** Fetches and displays high-resolution images and detailed scientific explanations from NASA's live API.
* **Time Travel Mode:** Users can query specific historical dates using a native Date Picker to view past astronomical events (e.g., birthdays, historic launches).
* **Swipe Navigation:** "Tinder-style" gesture navigation allows users to intuitively swipe left/right to browse through previous and next days seamlessly.

### 2. **Advanced Media Handling**
* **Polymorphic Data Support:** The app intelligently detects the `media_type` returned by the API.
    * **Images:** Rendered with `CachedNetworkImage` for performance and offline capability.
    * **Videos:** Handled via a custom "Watch Video" interface that deep-links to YouTube/Vimeo using `url_launcher`, preventing crashes on video-only days.

### 3. **Performance & Optimization**
* **Smart In-Memory Caching:** Implements a HashMap-based caching strategy (`Map<String, ApodModel>`). Once a date is fetched, it is stored locally, ensuring **instant load times (0ms)** and zero network cost when swiping back to previously viewed days.
* **Pull-to-Refresh:** Users can pull down to instantly reset the application state to "Today," clearing temporary navigation history.

### 4. **UI/UX & Responsiveness**
* **Cross-Platform Responsive Design:**
    * **Mobile:** Uses native `ListView` and flexible widgets for a perfect fit on all screen sizes.
    * **Web:** Implements a `ConstrainedBox` architecture (`maxWidth: 600px`) to maintain a clean, mobile-app-like experience on desktop browsers without awkward stretching.
* **Defensive UI:** Graceful handling of missing API data (null safety) ensures users never see technical error messages.
* **Premium Splash Screen:** Features a custom "Breathing" animation (Fade + Scale) for a polished app launch experience.

---

## 🛠 Technical Architecture

The project follows a strict **Layered Architecture** to ensure maintainability and scalability.

### **1. Data Layer (`lib/models`, `lib/services`)**
* **Robust Models:** `ApodModel` includes defensive `fromJson` parsing logic to handle null values gracefully (e.g., missing copyright info) and normalize data types.
* **Service Isolation:** `ApiService` abstracts all HTTP logic, endpoint construction, and exception handling from the rest of the app.

### **2. State Management (`lib/providers`)**
* **Provider Pattern:** Uses `ChangeNotifier` to manage global application state.
* **Logic Flow:** The Provider handles the business logic for:
    * Fetching data.
    * Managing the cache.
    * Updating `isLoading` and `errorMessage` states.
    * Notifying the UI only when necessary to minimize rebuilds.

### **3. UI Layer (`lib/screens`)**
* **Passive Views:** Screens are "dumb" widgets that simply consume data from the Provider.
* **Gesture Logic:** Complex interaction logic (Swipe detection) is handled directly in the UI layer to control navigation intent before passing requests to the Provider.

---

## 🧰 Tech Stack & Dependencies

* **Framework:** Flutter (Dart)
* **State Management:** `provider` (v6.x)
* **Networking:** `http`
* **APIs:** [NASA APOD API](https://api.nasa.gov/)
* **Key Packages:**
    * `cached_network_image`: For efficient image rendering and caching.
    * `url_launcher`: For handling external video links securely.
    * `intl`: For precise date formatting (`YYYY-MM-DD`).
    * `google_fonts`: For themed typography (Orbitron).

---

##  📷  Screenshort ![two](https://github.com/user-attachments/assets/22d88ca9-14b7-495d-b252-30a6a6863cad)
![three](https://github.com/user-attachments/assets/d2ffc0cd-c3e4-4fb1-a640-772cc7337ff0)
![six](https://github.com/user-attachments/assets/76e942a9-99e2-4f47-a44b-f7f02f9b0fc5)
![seven](https://github.com/user-attachments/assets/6ac24ef3-9b57-4939-b755-96f7cc651036)
![one](https://github.com/user-attachments/assets/5d1c7670-8745-450d-82bd-e7815fa830bb)
![four](https://github.com/user-attachments/assets/571f2b84-8ed1-4a83-bff4-b1598f032379)
![five](https://github.com/user-attachments/assets/94814e96-e0ce-4410-81d1-3f61a70a79b4)


## 🚀 How to Run

1.  **Clone the project**
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Setup Assets:**
    * Ensure `assets/logo.png` exists in the project directory.
    * Create a `.env` file in the root and add your key: `NASA_API_KEY=YOUR_KEY`
4.  **Run on Mobile:**
    ```bash
    flutter run
    ```
5.  **Run on Web (Production Build):**
    ```bash
    flutter run -d chrome --web-renderer html
    ```

---

**Developed with ❤️ and Flutter.**
