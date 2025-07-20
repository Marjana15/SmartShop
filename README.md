## Smart Shop

A feature‑rich, Flutter‑based mini e‑commerce app showcasing state management, persistent settings, theming, and a clean UI.

---

### 🚀 Features

* **Splash Screen** with animated logo
* **Login & Registration**

  * Email/password validation
  * “Demo” fill buttons for rapid testing
  * Persistent auth state via `SharedPreferences`
* **Dark & Light Themes**

  * Toggle in drawer
  * Preference saved across launches
* **Product Catalog**

  * Fetches real data from [FakeStore API](https://fakestoreapi.com)
  * Skeleton loaders (Shimmer) while fetching
  * Search bar, category filters, and a custom sort menu
* **Favorites**

  * Mark/unmark products
  * View favorite list separately
* **Shopping Cart**

  * Add/remove products with quantity controls
  * Live badge counts in AppBar & drawer
  * Checkout screen with “slide to pay” (using `slide_to_act`)
* **Profile Management**

  * View & edit first/last name, phone, address
  * Change password

---

### 🏗 Architecture & State Management

* **Provider** for state management across:

  * `ThemeProvider` (theme toggling)
  * `AuthProvider` (login/register/profile)
  * `ProductProvider` (fetch/filter/sort products + favorites)
  * `CartProvider` (cart items, quantities, totals)
* **SharedPreferences** for persisting:

  * Login state & user profile
  * Theme choice
  * Favorites
* **HTTP** via `http` package to FakeStore endpoints

---

### 🖼 Screenshots

<details>
<summary>Splash & Auth</summary>

| ![Splash](https://i.postimg.cc/mDNrHdKN/Screenshot-1753036056.png) | ![Login](https://i.postimg.cc/J75yDnLV/Screenshot-1753035993.png) | ![Register](https://i.postimg.cc/TY2Kr6dy/Screenshot-1753035999.png) |
| :--------------------------------------------: | :-------------------------------------------: | :----------------------------------------------: |
|                  Splash Screen                 |                  Login Screen                 |                  Register Screen                 |

</details>

<details>
<summary>Catalog & Filtering</summary>

| ![Home](https://i.postimg.cc/7PFB6KwQ/Screenshot-1753035849.png) | ![Category Chips](https://i.postimg.cc/Y0HWcLB8/Screenshot-1753035932.png) |
| :------------------------------------------: | :----------------------------------------------------: |
|             Product Grid & Search            |               Category Chips & Sort Menu               |

</details>

<details>
<summary>Cart & Checkout</summary>

| ![Cart](https://i.postimg.cc/sXJ65wGc/9.png) | ![Checkout](https://i.postimg.cc/Jn8Yy900/10.png) | ![Slide to Pay](https://i.postimg.cc/L56yDLzM/11.png) |
| :------------------------------------------: | :----------------------------------------------------: | :---------------------------------------------------------: |
|                  Cart Screen                 |                    Checkout Summary                    |                     Slide-to-Pay Control                    |

</details>

---

### 🛠 Tech Stack

* **Flutter & Dart**
* **Provider** (state management)
* **SharedPreferences** (local storage)
* **http** (network calls)
* **shimmer** (loading placeholders)
* **badges** (count badges)
* **slide\_to\_act** (checkout slider)

---

### ⚙️ Installation & Setup

1. **Clone repo**

   ```bash
   git clone https://github.com/marjana15/smart_shop.git
   cd smart_shop
   ```
2. **Install dependencies**

   ```bash
   flutter pub get
   ```
3. **Run**

   ```bash
   flutter run
   ```

---

### 📄 License

This project is licensed under the MIT License. Feel free to use and adapt!

---

> Built with ❤️ by *Marjana15*

