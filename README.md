# 📱 SmartPay – A Voice-Enabled Digital Payment Application

SmartPay is a multilingual, voice-controlled digital payment mobile application developed under the **ISEA Phase III Internship at NIT Warangal**. It provides an intuitive and accessible interface similar to GPay or PhonePe, enabling users to interact through voice commands in multiple Indian languages.

---

## 🚀 Features

- 🎙️ **Multilingual Voice Assistant**
  - Recognizes voice commands in English, Hindi, and Telugu.
  - Translates commands into English using Google Translator.
  - Performs in-app navigation or responds via AI (ChatGPT).
S
- 💳 **Digital Payment Simulation**
  - Initiate transactions using voice or taps.
  - Scan QR, pay contacts, pay mobile numbers.
  - Profile view and transaction history.

- 📲 **Clean UI & Navigation**
  - Home grid with intuitive icons.
  - Voice interaction with feedback.

---

## 🖼️ Home Screen Icons & Functionalities

| Icon                | Functionality Description |
|---------------------|---------------------------|
| 🧑‍🤝‍🧑 Pay to Contacts     | Opens a screen to simulate sending money to saved contacts. |
| 📱 Pay to Mobile Number | Allows entry of a mobile number to send money (UPI-like). |
| 📷 Scan QR             | Opens a mock QR scanner page (to be extended for real scan). |
| 🔁 Self Account        | Simulates transferring money to your own account. |
| 📃 Transaction History | Shows mock data of past transactions for reference. |
| 🙍 Profile             | Displays user's profile information. |

---


## 📁 Folder Structure

```
smartpay/
├── lib/
│   ├── main.dart
│   ├── home_screen.dart
│   ├── widgets/
│   │   └── voice_assistant.dart
│   ├── screens/
│   │   ├── pay_contacts.dart
│   │   ├── pay_mobile_number.dart
│   │   ├── scan_qr_screen.dart
│   │   ├── self_account_screen.dart
│   │   ├── profile_screen.dart
│   │   └── transaction_history.dart
│   ├── services/
│   │   └── openai_service.dart
├── pubspec.yaml
└── README.md
```

---

## 📦 Dependencies Used

```yaml
dependencies:
  flutter:
    sdk: flutter
  speech_to_text: ^6.3.0
  flutter_tts: ^3.6.3
  translator: ^0.1.7
  http: ^0.13.5
  google_fonts: ^6.0.0
```

---

## 🔮 Future Enhancements

- Integration with Paytm Payment Aggregator API.
- Live UPI transactions.
- Eye movement-based guidance for accessibility.
- Admin portal for transactions.
- Backend integration with Nodejs.

---

## 👩‍💻 Developer Info

- **Name**: Archana, Gaurav  
- **Internship**: ISEA Phase III, NIT Warangal  
- **Project**: Voice-Based Digital Payment App  
- **Contact**: archanaittaboina4@gmail.com , ghs2ndacc@gmail.com

link:  https://drive.google.com/drive/folders/14jXwN_-_aKO4hHxUQ86f3eZkLUryxmIF?usp=drive_link

---

## 📜 License

This project was developed under the ISEA Phase III program for educational and research purposes only.
