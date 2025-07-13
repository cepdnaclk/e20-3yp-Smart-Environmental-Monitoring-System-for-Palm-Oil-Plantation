// src/utils/firebase.ts

import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
// If you want analytics, you can import it — but analytics is not supported in localhost without https

const firebaseConfig = {
  apiKey: "AIzaSyAJsr2x9fVSTZLjk_h-yjLjJEY5YlRgJFs",
  authDomain: "environment-monitoring-s-d169b.firebaseapp.com",
  databaseURL: "https://environment-monitoring-s-d169b-default-rtdb.firebaseio.com",
  projectId: "environment-monitoring-s-d169b",
  storageBucket: "environment-monitoring-s-d169b.appspot.com",
  messagingSenderId: "901340579460",
  appId: "1:901340579460:web:27818e24bbf13986df64d1",
  measurementId: "G-N1HWF3YQ8B"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);

export { auth, db };
