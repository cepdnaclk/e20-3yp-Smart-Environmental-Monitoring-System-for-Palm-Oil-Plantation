// import * as admin from 'firebase-admin';
// import * as fs from 'fs';

// // Load service account key
// const serviceAccount = JSON.parse(fs.readFileSync('serviceAccountKey.json', 'utf8'));

// // Initialize Firebase Admin SDK
// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount)
// });


import * as admin from "firebase-admin";
import path from "path";

const serviceAccount = require(path.join(
  "C://Users//ASUS//Desktop//Com_Sem_6//e20-3yp-Smart-Environmental-Monitoring-System-for-Palm-Oil-Plantation//Software//flutter_application_1//functions//environment-monitoring-s-d169b-ccb9a5fc95d3.json"
));

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: "environment-monitoring-s-d169b",
});

// The UID of the user to assign admin role
const uid = 'Vzlybo8JxPMUfT2VWEN9hvbsUu93'; // Replace with actual UID

// Set custom claim
admin.auth().setCustomUserClaims(uid, { admin: true })
  .then(() => {
    console.log(`✅ Admin role set for UID: ${uid}`);
  })
  .catch((error) => {
    console.error('❌ Error setting custom claims:', error);
  });