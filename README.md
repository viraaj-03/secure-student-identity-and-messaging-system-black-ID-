SecureID Vault

A privacy-preserving digital identity wallet built for mobile, designed around self-sovereign identity principles and zero-knowledge proofs.

Overview

Most verification systems ask for full scans or copies of physical ID cards, tax documents, and contact details just to confirm basic facts. This leads to massive identity theft risks and needless data collection.

SecureID Vault replaces that model entirely. Instead of showing the actual ID, the app uses salted cryptographic hashes to create a permanent Decentralized Identifier. When a service needs proof of something—like whether someone is an adult or lives in a particular state—the app generates a client-side zero-knowledge proof. The third party gets mathematical certainty without ever seeing the underlying identity records.

Core Highlights

Decentralized Identifiers
Identity attributes are bound into a tamper-proof DID using Veramo, keeping users in control of their credential records across services.

Selective Disclosure
Proofs run directly on the phone using Circom and Groth16 zk-SNARKs. Verification happens in under two seconds without exposing raw details.

Biometric and Hardware Storage
Cryptographic keys and salt values never leave the device. They are locked behind fingerprint or facial authentication inside the phone's secure keystore.

Authorized Verifier Network
Relying services must register on a central management portal and obtain an API key before they can issue verification requests.

Simple QR Verification
Users scan a code presented by the verifier, approve the prompt with biometrics, and return the proof instantly. Firebase Cloud Messaging handles back-and-forth session challenges.

Zero Data Residue
Verifiers store no personal records, documents, or photos. They receive only a true-or-false validation token and can immediately grant access.

How the Verification Flow Works

1. The relying party generates a dynamic QR code containing a unique challenge nonce.
2. The user scans the code using the SecureID Vault mobile app.
3. The app prompts for biometric authentication (face or fingerprint).
4. Upon approval, the app reads the salted credentials from the phone's hardware keystore.
5. The local zero-knowledge engine computes the witness and builds the cryptographic proof.
6. The app transmits the proof and public verification parameters back to the verifier.
7. The verifier checks the proof mathematically and grants access immediately.

Technology Stack

* Mobile App: React Native, Expo, and Flutter options for cross-platform delivery
* Identity Protocols: Veramo SSI framework
* Zero-Knowledge Architecture: Circom circuits with snarkjs running Groth16 proofs
* Local Device Security: Platform-native Keystore and Keychain APIs with local biometric hooks
* Verifier Services: Node.js, Express, and Firebase Cloud Messaging

Getting the Project Running

Circuits and Cryptographic Setup

First, make sure the Circom compiler and snarkjs are installed. Compile the circuit and run the Groth16 setup sequence:

circom circuits/age_verification.circom --r1cs --wasm --sym -o circuits/build

cd circuits/build

snarkjs groth16 setup age_verification.r1cs pot12_final.ptau age_0000.zkey

snarkjs zkey contribute age_0000.zkey age_final.zkey --name="Local Contributor" -v

snarkjs zkey export verification_key age_final.zkey verification_key.json

Running the Verifier Service

Navigate to the verifier directory, install dependencies, and start the node server:

cd verifier-portal
npm install
npm run dev

Running the Mobile Wallet

Navigate to the mobile application directory and start the Expo development environment:

cd mobile
npm install
npx expo start

Security Notes

* The verifier only receives a cryptographic boolean result alongside the public parameters specified by the circuit.
* Dynamic challenge nonces expire quickly to defend against network replay attacks.
* Attribute salts make it impossible for separate verifiers to track or correlate the same person across unrelated platforms.
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
