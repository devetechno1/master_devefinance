# 🔄 Updates Log

This file tracks all update versions for both the **Mobile App**.

---

## ✅ Latest Versions:
- `mobileVersion = '9.10.22'`
---

## 📱 Mobile App Updates
<details>
<summary><strong>AV 9.10.22 – Router fallback to WebView + domain update</strong></summary>

### Routing
- Added `errorPageBuilder` to `GoRouter` that opens unknown routes in `CommonWebviewScreen` with `backHome=true` and URL `${RAW_BASE_URL}/mobile-page{path}`.
- `CommonWebviewScreen` now intercepts navigation and forwards it to `NavigationService` (deep links use router; external links use `url_launcher`).
- Back behavior: go back within WebView if possible; otherwise navigate to `/`.

### Config
- Updated `DOMAIN_PATH` to `sellerwise.devefinance.com`.

### Tech
- `NavigationService.handleUrls` now supports `useGo` to choose between `context.go` and `context.push`.

### Notes
- No API path changes.
- Store update: **yes** (routing behavior visible to users).
</details>


<details>
<summary><strong>AV 9.10.21 – Positive-only stock handling & simplified stock label</strong></summary>

### Logic
- Added `NumEx.onlyPositive` to normalize negative numbers to zero.
- Product details now use a sanitized stock getter (`_s`) for `maxQuantity`.

### UI/UX
- Simplified stock label to use `_stock_txt` directly from backend, keeping red color when out of stock.

### Notes
- No API changes.
- Store update: **no** (internal helper + UI logic tweak).
</details>

<details>
<summary><strong>AV 9.10.20 – Point API to local dev server</strong></summary>

### Config
- `DOMAIN_PATH` set to `devefinance.com`.
- `RAW_BASE_URL` switched to `http://192.168.100.200:8080/devef` (overrides `PROTOCOL + DOMAIN_PATH`).
- Effective `BASE_URL`: `http://192.168.100.200:8080/devef/api/v2`.

### Notes
- No endpoint path changes; only the base URL changed.
- **Store update: yes** (changing the app’s API base requires shipping a new build).
- On Android 9+, ensure cleartext HTTP is allowed (e.g., `usesCleartextTraffic=true` or network security config).
</details>

<details>
<summary><strong>AV 9.10.19 – Guard product details UI against negative stock</strong></summary>

### UI/UX
- When `_stock < 0`, the product details screen now shows:
  - total price as `0`,
  - quantity field fixed to `0`,
  - left stock text as `0`,
  - “out of stock” label active,
  - add-to-cart button disabled (grey, no shadow).

### Notes
- No API changes.
- Store update: **no** (logic/UI safeguards only).
</details>


<details>
<summary><strong>AV 9.10.18 – Add rating stars to MiniProductCard</strong></summary>

### UI/UX
- Added star rating row to `MiniProductCard` using `RatingBarIndicator`.
- Reduced bottom padding of the name line from 6 to 0 to make room for stars.

### Tech
- Optional `rating` parameter (int) on `MiniProductCard`; internally clamped to 0–5.
- Reuses existing `flutter_rating_bar` dependency already present in the project.

### Notes
- No API changes.
- Store update: **no** (minor UI enhancement).
</details>
<details>
<summary><strong>AV 9.10.17 – Order details spacing & top selling card padding</strong></summary>

### UI/UX
- Added a small left padding for order status labels (“Order placed”, “Confirmed”, “On the way”, “Delivered”) to improve alignment in the timeline row.
- Reduced bottom padding from 14 to 10 in the Top Selling product card content.

### Notes
- No API changes.
- Store update: **no** (minor UI tweaks).
</details>
<details>
<summary><strong>AV 9.10.16 – Arabic copy fix for orders string</strong></summary>

### UI/UX
- Corrected Arabic translation for `your_ordered_all_lower` from "طلبت" to "طلباتك".

### Notes
- No API changes.
- Store update: **no** (copy-only change).
</details>

<details>
<summary><strong>AV 9.10.15 – Order status colors moved to model</strong></summary>

### UI/UX
- Consolidated payment/delivery color logic into the `Order` model (`paymentColor`, `deliveryColor`).
- Order list now uses model-provided colors instead of inline UI conditions.

### Tech
- Added `material.dart` import in the order mini response model.

### Notes
- No API changes.
- Store update: **no** (UI-only refactor).
</details><details>
<summary><strong>AV 9.10.22 – Router fallback to WebView + domain update</strong></summary>

### Routing
- Added `errorPageBuilder` to `GoRouter` that opens unknown routes in `CommonWebviewScreen` with `backHome=true` and URL `${RAW_BASE_URL}/mobile-page{path}`.
- `CommonWebviewScreen` now intercepts navigation and forwards it to `NavigationService` (deep links use router; external links use `url_launcher`).
- Back behavior: go back within WebView if possible; otherwise navigate to `/`.

### Config
- Updated `DOMAIN_PATH` to `sellerwise.devefinance.com`.

### Tech
- `NavigationService.handleUrls` now supports `useGo` to choose between `context.go` and `context.push`.

### Notes
- No API path changes.
- Store update: **yes** (routing behavior visible to users).
</details>



<details>
<summary><strong>AV 9.10.14 – OTP Login, LTR phone row & Auth UI polish</strong></summary>

### APIs (new)
- **POST** `/auth/send-otp` — Sends an OTP to the provided phone.
  - **Request (JSON)**: `{ "phone": string, "country_code": string, "identity_matrix": string, "temp_user_id": string }`
  - **Expected**: `200 OK` with `{ result, message, ... }`
  - **Errors**: `400/422` (validation), `401/429` (auth/rate limit)
- **POST** `/auth/verify-otp` — Verifies the OTP and logs the user in.
  - **Request (JSON)**: `{ "phone": string, "country_code": string, "otp_code": string, "identity_matrix": string, "temp_user_id": string, "device_info"?: object }`
  - **Expected**: `200 OK` with `LoginResponse` payload
  - **Errors**: `400/422` for invalid code

### UI/UX
- New **OTP** login provider (visible when `login_with_otp=1`).
- Phone input row is now **forced LTR** across locales.
- Unified third-party login icons via `LoginWith3rd` widget.
- Auth container uses `AlignmentDirectional` / `PositionedDirectional` and removes the outer `Directionality`.

### Settings
- Added `allowOTPLogin` and aggregated getter `otherLogins` in `BusinessSettingsData`.

### Notes
- No breaking changes to existing endpoints.
- Store update: **no** (feature addition only).
</details>




<details>
<summary><strong>AV 9.10.13 – Auth/Phone LTR & Registration fields refactor</strong></summary>

### UI/UX
- Phone input row now enforced as **LTR** regardless of app locale.
- Registration form fields refactored into a reusable `_SignUpField` to reduce duplication and keep consistent styling.

### Tech
- Reused existing input decorations, theme, and phone input widget.
- No API changes.

### Notes
- Requires Flutter version supporting `Column(spacing:)`; otherwise, replace with `SizedBox` spacing.
</details>


<details>
<summary><strong>AV 9.10.12 – Profile contact display cleanup</strong></summary>

### UI/UX
- **Profile**: prefer showing **Phone** if available; fallback to **Email**.
- **Profile Edit**: hide **Phone** block when empty; hide **Email** block when empty (no more empty fields).

### Infra / Widgets
- Reused existing `CustomInternationalPhoneNumberInput` and current input decorations/shadows.

### Notes
- No API changes.
- No store updates required.
</details>


<details>
<summary><strong>AV 9.10.11 – PagedView modularization</strong></summary>

### Infra / Widgets
- Split monolithic PagedView into separate files:
  - `lib/custom/paged_view/models/page_result.dart`
  - `lib/custom/paged_view/paged_view.dart`
  - `lib/helpers/grid_responsive.dart`
- Updated imports in:
  - `lib/screens/product/top_selling_products.dart`
  - `lib/screens/wholesales_screen.dart`
- UX/Perf: load-more triggers at bottom edge; prefetch when first page doesn't fill viewport.

### Notes
- No API changes.
- No store updates required.
</details>


<details>
<summary><strong>AV 9.10.10</strong></summary>

### Stability & Null-Safety
- **ClassifiedAdsResponse**: resilient JSON parsing (nullable `links`/`meta`, strict `success`, empty list when `data` isn't a List).
- **UserInfoResponse**: same guards; strict boolean `success`.
- **ProfileRepository.getUserInfoResponse()**: return type → `UserInfoResponse` (was `dynamic`).
- **My Classified Ads**: null-safe checks before accessing first element.
- **Guest Checkout / Map**: null-safe `animateCamera` with controller existence check.
- **Profile screen**: show Classifieds entry only if feature enabled **and** user is logged in.

### Notes
- **No API changes** → _no MUST UPDATE_ for server.
- Suggested app version: `9.10.10+91010`.
</details>


<details>
<summary><strong>AV 9.10.9</strong></summary>

### Widgets / Infra
- New generic **`PagedView<T>`** with infinite scroll, pull-to-refresh, and flexible layouts (**list / grid / masonry**).
- Supports `preloadTriggerFraction`, custom `itemBuilder`, `loadingItemBuilder`, `emptyBuilder`, and scroll `physics`.
- Grid tuning via `gridCrossAxisCount`, `gridAspectRatio`, `gridMainAxisExtent`. Sliver-based for performance.

### Product Screens
- **TopSellingProducts** migrated to `PagedView<Product>`; single-shot fetch (`hasMore=false`), masonry 2-col, shimmer placeholders.
- **Wholesale** screen migrated to `PagedView<Product>` with real paging via `getWholesaleProducts(page)`; shimmer while loading more.
- Wholesale badge now shows **only if**: wholesale addon installed **and** `BusinessSettingsData.showWholesaleLabel` is true.

### Models
- `BusinessSettingsData`: add `showWholesaleLabel` (maps backend key `wholesale_lable == "1"`).
- `ProductMiniResponse`: `success` -> **required non-nullable bool**; JSON parsed with `json["success"] == true`.

### UI
- `ShimmerHelper`: add `loadingItemBuilder(int index)` helper.
- `MyTheme`: normalize color fields; prefer `const` where safe.

### Notes
- **No API endpoint changes** → _no MUST UPDATE_ for server.
- Suggested app version: `9.10.9+91009`.
</details>


<details>
<summary><strong>AV 9.10.8</strong></summary>

### Config
- **RAW_BASE_URL** now points to local dev server: `http://192.168.100.200:8080/devef` (dynamic domain commented).  
  ⚠️ Dev-only — revert before production.

### Repository / API
- `getWholesaleProducts` now accepts `int page` and calls `/wholesale/all-products?page={page}`.

### Wholesale Screen
- Implemented **pagination + infinite scroll** (prefetch at ~70%), **pull-to-refresh**, and **shimmer** placeholders while loading more.
- Replaced `FutureBuilder` with state-driven flow (`page`, `_isLoading`, `_isLoadingMore`, `_hasMoreProducts`).
- Fixed item count/index issues; proper controller disposal; extracted `AppBar` builder.

### Product Details
- **pkg price** line: show strikethrough **only if discounted** (`firstPrice != price`) to avoid false strikes.

### Notes
- Suggested app version: `9.10.8+91008`.
</details>


<details>
<summary><strong>AV 9.10.7</strong></summary>

### Android
- AGP → **8.1.1** (settings.gradle).
- Temporarily use **debug signing** for `release` (testing only).
- Ensure **AndroidX** & **Jetifier** enabled.

### iOS
- `firebase_core` → **3.15.2**, `firebase_messaging` → **15.2.10**.
- Added `geolocator_apple`, `sms_autofill`.

### Dependencies
- Added: `geolocator`, `geolocator_android`.
- Updates: `go_router` **16.1.0**, `http` **1.5.0**, `google_maps_flutter*`, `webview_flutter*`, `shared_preferences_android`, etc.

### Location & Maps
- New `HandlePermissions.getCurrentLocation()` (Geolocator) with denied/forever/service-off handling.
- Map: auto-center to GPS if no coords, **myLocationEnabled**, recenter **FAB**, smooth camera, safer placemark try/catch.

### UI/UX
- `Btn.basic`: new `isLoading` (disables press + themed disabled color).
- Loading bar height **36 → 40**.
- Map pin tinted with theme; action bar lifted to avoid FAB overlap.

### Notes
- Suggest `version: 9.10.7+91007` in `pubspec.yaml`.
- **Before production**: restore `release { signingConfig signingConfigs.release }`.
</details>



<details>
<summary><strong>AV 9.10.6</strong></summary>

- Improved shared value loading (`user_id`, `is_logged_in`) in `main.dart`.
- Added conditional headers (`user_id`, `device_info`) to Business Settings API.
- Added error handling to `getProductDetails()` with translated fallback message.
- Handled product detail API failure:
  - Added `errorMessage` state.
  - Displayed `CustomErrorWidget` on failure.
  - Prevented rendering of bottom app bar when product is invalid.
- Handled seller image failure using `imageErrorBuilder`.
- Fixed wishlist logic with proper boolean check.
- Conditionally rendered flash deal in profile screen.
- Marked review submit failures with `isError: true`.

</details>


<details>
<summary><strong>AV 9.10.5</strong></summary>

- Added a `Loading.isLoading` getter to prevent showing duplicate loading dialogs.
- Improved **loading behavior** during:
  - Registration
  - Adding a new address
- Integrated `OneContext` for global context handling in registration and address flows.
- Fixed potential null/empty issues with the email field during sign-up.
- Enhanced `commonHeader` to include `Authorization` header if access token is available.
- Ensured cart data is fetched when returning to home screen via `HomePresenter`.
- Improved UI consistency by calling `reset()` before re-fetching home data.

</details>


<details>
<summary><strong>AV 9.10.4</strong></summary>

- Integrated **sms_autofill** package to support automatic SMS code detection during password reset.
- Updated password reset flow:
  - `getPasswordForgetResponse()` now requires `app_signature`.
  - Auto-fills OTP code using `CodeAutoFill` and `TextFieldPinAutoFill`.
- Extended OTP timer duration from 20 to 90 seconds.
- Fixed minor formatting issues and improved error handling in password reset process.
- Added safety around `device_info` usage with better spacing and conditionals.

</details>


<details>
<summary><strong>AV 9.10.3</strong></summary>

- Added a confirmation dialog when changing the default address if **sellerWiseShipping** is enabled, warning users that the cart will be cleared.
- Integrated `ShippingInfo` screen dynamically based on business setting instead of always using `SelectAddress`.
- Enhanced safety by switching from `double.parse()` to `double.tryParse()` in the `ShippingCostResponse` model to prevent crashes.
- Added new localization key: `change_default_address_make_cart_empty` (Arabic + English).

</details>


<details>
<summary><strong>AV 9.10.2</strong></summary>

- Implemented a new layout and functionality for the **wholesale** system across the entire app.
- Improved user experience on the product details screen.
</details>


<details>
<summary><strong>AV 9.10.1</strong></summary>

- Fixed a login issue that occurred under poor network conditions.
- Improved automatic language loading from the server.
</details>