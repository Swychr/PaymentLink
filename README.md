# Payment Link WebView (Flutter)

This project demonstrates how to open payment links generated through an API inside a WebView in a Flutter application. It supports both **iOS** and **Android**, providing a smooth and secure in-app payment experience without redirecting users to an external browser.

---

## 🚀 Overview

Many payment providers return a hosted payment URL that the user must visit to complete their transaction. This project shows how to:

- Request a payment link from your backend API  
- Display it inside an in-app WebView  
- Track WebView navigation to detect successful or failed payment redirects  
- Provide a consistent checkout flow across both Android and iOS  
- Improve conversion by keeping users inside the app rather than switching browsers

---

## 🔗 Flow Summary

1. The Flutter app sends a request to the backend to generate a payment link.  
2. The backend returns a short-lived `paymentUrl`.  
3. The app loads this URL in an embedded WebView.  
4. The WebView navigates through the payment provider’s pages.  
5. When the payment provider redirects to the configured success or failure URL, the app detects it.  
6. The app closes the WebView and optionally verifies the payment status via the backend.

---

## 📱 Platform Support

- **Android**  
  - Uses the Android system WebView  
  - Supports JavaScript, redirects, UPI deep links, and external app handoff  
  - Requires internet permission

- **iOS**  
  - Uses WKWebView  
  - Supports JavaScript, navigation delegate, and native redirections  
  - Requires ATS configuration for non-HTTPS URLs

---

## 🧭 Features

- In-app payment flow with WebView  
- Custom callback URL detection (success/error)  
- Server-side verification recommended after redirect  
- Loading indicators and graceful error handling  
- Handles both HTTPS and custom URL scheme redirects  
- Prevents users from leaving the app during payment  
- Simple implementation, flexible for any payment gateway

---

## 🔐 Security Recommendations

- Always use **HTTPS** payment URLs.  
- Never trust client-side success URLs — always perform **server-side verification**.  
- Use short-lived or tokenized payment URLs.  
- Avoid enabling unrestricted network access unless required.  
- Do not expose API keys or payment provider secrets in the client app.

---

## 🧩 Use Cases

- Payment gateway checkout (Razorpay, Stripe, PayPal, Paystack, Flutterwave, Swychr, etc.)  
- Custom hosted checkout pages  
- Subscription billing confirmation  
- Wallet top-ups  
- Invoice payment links  
- Secure redirection flows

---

## 🧪 Testing Checklist

- Payment link loads correctly on both Android and iOS  
- Success and failure URLs are intercepted properly  
- Payment states are validated on the backend  
- External app redirects (UPI, bank apps) behave as expected  
- Proper handling of network errors and page failures  
- App resumes gracefully if user returns from external payment apps

---

## 📂 Project Structure

- **/lib** — Flutter UI and WebView integration  
- **/android** — Android configuration (manifest, network settings)  
- **/ios** — iOS configuration (Info.plist, ATS settings)  

---

## 🤝 Contributions

Issues and pull requests are welcome!  
Feel free to contribute improvements such as:
- Payment provider-specific guides  
- Better error handling  
- Examples with deep linking  
- Custom UI checkout screens

---

## 📄 License

This project is distributed under the MIT License.

---

## ✨ Author

**Harshit Kumar**

---

If you find this project useful, please consider giving it a ⭐ on GitHub!
