# 🔄 Updates Log

This file tracks all update versions for both the **Mobile App**.

---

## ✅ Latest Versions:
- `mobileVersion = '9.10.14'`
---

## 📱 Mobile App Updates
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