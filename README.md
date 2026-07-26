<div align="center">
  <img src="https://images.unsplash.com/photo-1555529733-0e67056058e1?auto=format&fit=crop&w=1200&q=80" alt="Zentro Banner" width="100%" />

  <h1>Zentro E-Commerce</h1>
  <p><strong>A Premium, High-Performance Flutter Shopping Experience</strong></p>
  
  <p>
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
    <img src="https://img.shields.io/badge/Material_3-702283?style=for-the-badge&logo=material-design&logoColor=white" alt="Material 3" />
  </p>
</div>

---

## 🌟 Overview

**Zentro** is a modern, premium e-commerce application built with Flutter. Designed with a focus on stunning aesthetics, smooth animations, and high performance, Zentro offers a seamless shopping experience. It features a complete user journey—from browsing dynamic product catalogs to a full checkout and order tracking experience.

## ✨ Key Features

*   🛍️ **Dynamic Product Catalog**: Beautiful grid layouts for exploring Men's, Women's, Accessories, and Footwear collections.
*   🛒 **Robust Cart System**: Add to cart, adjust quantities, and instantly view real-time subtotal/tax calculations.
*   ❤️ **Wishlist Management**: Save your favorite items with a single tap and access them later in a dedicated screen.
*   📦 **Order History**: Track past purchases and view detailed order summaries.
*   💳 **Mock Checkout Flow**: A complete, responsive checkout interface simulating real-world delivery and payment options.
*   ⚡ **High Performance**: Highly optimized image rendering using `cached_network_image` to ensure buttery-smooth scrolling, even on entry-level Android devices.
*   🎨 **Premium UI/UX**: Built strictly using **Material 3** guidelines, featuring glassmorphism, subtle shadow elevations, and high-contrast styling.

## 📱 Screenshots (Mockups)

*(Add screenshots of your application here once uploaded to GitHub)*
*   `Home Screen`
*   `Shop Categories`
*   `Product Details`
*   `Cart & Checkout`

## 🛠️ Tech Stack & Architecture

Zentro is built using modern Flutter architecture to ensure scalability and maintainability:

*   **State Management**: `Provider` (Centralized `CartProvider`, `WishlistProvider`, and `OrderProvider`).
*   **Routing**: `go_router` (Deep-link ready, shell-based navigation).
*   **Image Optimization**: `cached_network_image` (Memory-managed local caching).
*   **Design System**: Custom `ZentroTheme` enforcing strict color palettes and Google Fonts (Montserrat & Inter).

### Directory Structure

```text
lib/
├── components/     # Reusable UI elements (Product Cards, Buttons)
├── data/           # Mock databases and models
├── layouts/        # Shell layouts (Bottom Navigation wrapper)
├── providers/      # Global State Management
├── screens/        # Full-page views (Home, Shop, Checkout, etc.)
├── styles/         # ZentroTheme and color tokens
├── routes.dart     # GoRouter configuration
└── main.dart       # App initialization
```

## 🚀 Getting Started

### Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.0.0 or higher)
*   Dart SDK

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/YourUsername/Zentro.git
    cd Zentro
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run the application**
    ```bash
    flutter run
    ```
    *(Note: For the best performance experience, it is highly recommended to run the app in `--profile` or `--release` mode on a physical device).*

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/YourUsername/Zentro/issues).

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---
<div align="center">
  <sub>Built with ❤️ using Flutter</sub>
</div>
