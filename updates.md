# 🔄 Updates Log

This file tracks all update versions for both the **Mobile App**.

---

## ✅ Latest Versions:
- `mobileVersion = '9.10.6'`
---

## 📱 Mobile App Updates
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