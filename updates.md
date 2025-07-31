# 🔄 Updates Log

This file contains a complete changelog for both the **Mobile App** and the **Backend**.

---

## ✅ Latest Versions:
- `mobileVersion = '9.10.2'`
- `backendVersion = '9.8.1'` <!-- Replace with your current backend version -->

---

## 📱 Mobile App Updates

### AV 9.10.3
- Added a confirmation dialog when changing the default address if **sellerWiseShipping** is enabled, warning users that the cart will be cleared.
- Integrated `ShippingInfo` screen dynamically based on business setting instead of always using `SelectAddress`.
- Enhanced safety by switching from `double.parse()` to `double.tryParse()` in the `ShippingCostResponse` model to prevent crashes.
- Added new localization key: `change_default_address_make_cart_empty` (Arabic + English).

### AV 9.10.2
- Implemented a new layout and functionality for the **wholesale** system across the entire app.
- Improved user experience on the product details screen.

### AV 9.10.1
- Fixed a login issue that occurred under poor network conditions.
- Improved automatic language loading from the server.

---

## 🛠 Backend Updates

### BV 2.5.0
- Added support for the new **wholesale** package system in product data.
- Updated `getProductDetails` API to include the revised wholesale logic.

### BV 2.4.9
- Fixed filtering issue with categories and brands in product listings.
- Optimized database queries to reduce server load and improve performance.

---
