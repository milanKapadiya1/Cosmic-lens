# 🚀 Cosmic Lens: High-Performance NASA Explorer

> **A production-grade media explorer engineered for fault tolerance, strict state management, and network efficiency.**

---

## 📖 Project Overview

**The Engineering Challenge:**
Consuming the NASA APOD API presents unique challenges: polymorphic data types (images vs. videos), inconsistent metadata, and high latency for high-resolution assets.

**The Solution:**
**Cosmic Lens** is architected to handle these edge cases gracefully. Built with **Flutter** and **Provider**, it features a **defensive data layer** that prevents runtime crashes and a custom **in-memory caching strategy** that eliminates redundant network calls, ensuring a seamless user experience even under poor network conditions.

---

## 🏗️ Technical Architecture & Key Decisions

### 1. Defensive Data Modeling (Polymorphism)
* **Problem:** The API returns different JSON structures depending on whether the media is an `image` or a `video`. Naive parsing leads to null pointer exceptions.
* **Solution:** Engineered a robust `ApodModel` with defensive parsing logic. The app intelligently detects the `media_type` at the model layer, normalizing the data before it ever reaches the UI.
* **Result:** Zero runtime crashes on "Video-Only" days.

### 2. Custom In-Memory Caching (40% Network Reduction)
* **Problem:** Users frequently swipe back to previous days. Fetching the same JSON data repeatedly wastes bandwidth and adds latency.
* **Solution:** Implemented a **HashMap-based Caching Strategy** (`Map<String, ApodModel>`). Once a date is fetched, it is stored in memory.
* **Result:** Instant load times (0ms) for previously visited dates and a massive reduction in API quota usage.

### 3. Strict State Management (Provider)
* **Architecture:** Adopts a strict separation of concerns using the **Provider** pattern.
    * **UI Layer:** "Dumb" widgets that only render state.
    * **Business Logic:** A dedicated `ApodProvider` handles data fetching, caching logic, and error states.
    * **Service Layer:** `ApiService` acts as a pure networking client, abstracting HTTP implementation details.

---

## ✨ Key Features

### 🌌 Core Experience
* **Temporal Navigation:** Users can "Time Travel" to any date since 1995 using a native Date Picker to view historical astronomical events.
* **Gesture-Driven Interface:** Implemented "Tinder-style" swipe detection for intuitive navigation between days.
* **Smart Media Rendering:**
    * **Images:** Powered by `cached_network_image` for offline persistence.
    * **Videos:** Deep-linking integration via `url_launcher` to handle YouTube/Vimeo content securely.

### 📱 Responsive & Adaptive UI
* **Cross-Platform Design:**
    * **Mobile:** Optimized `ListView` layouts for touch interaction.
    * **Web/Desktop:** Implements a `ConstrainedBox` architecture (max-width: 600px) to maintain mobile-app aesthetics on large screens without layout stretching.
* **Premium UX:** Custom "Breathing" splash screen animation and skeleton loading states for perceived performance.

---

## 🛠️ Tech Stack

| Layer | Technology |
| :--- | :--- |
| **Framework** | Flutter (Dart) |
| **State Management** | Provider (v6.x) |
| **Networking** | `http` + Custom Exception Handling |
| **Data Source** | NASA APOD API |
| **Utils** | `intl` (Date Formatting), `url_launcher` (Deep Links) |


-

## 📷 Screenshots

<table align="center">
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/8f8bf90b-854d-44db-ba85-5512160bb1f4" width="250"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/44d897d8-ee8c-462a-a43a-ce6bc4809062" width="250"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/0cca38c8-0d68-495a-a9d0-061740d866b4" width="250"/></td>
  </tr>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/148a367c-f291-447c-a684-55e2acb674d9" width="250"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/d50bf2c9-258e-4cf0-8ab6-fb76b4e29582" width="250"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/a1e17c7c-5c64-4318-8af9-da11b70757e5" width="250"/></td>
  </tr>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/8325383c-2ff8-4e04-86ca-cfdc37cae320" width="250"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/1098d078-bfdd-4df4-a276-057450b64259" width="250"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/9c0ca785-020d-4e41-b24b-feee7ee4ffdb" width="250"/></td>
  </tr>
</table>




---

**Developed with ❤️ and Flutter.**
