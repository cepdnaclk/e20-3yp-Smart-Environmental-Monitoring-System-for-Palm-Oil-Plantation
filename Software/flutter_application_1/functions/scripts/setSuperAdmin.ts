import * as admin from "firebase-admin";
import * as path from "path";

// Load service account key
const serviceAccount = require(path.join("C://Users//ASUS//Desktop//Com_Sem_6//e20-3yp-Smart-Environmental-Monitoring-System-for-Palm-Oil-Plantation//Software//flutter_application_1//functions//environment-monitoring-s-d169b-firebase-adminsdk-fbsvc-a732b6dc9d.json"));

// Initialize admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: "environment-monitoring-s-d169b" // Replace with your Firebase project ID
});

const uid = "xOb97QyQFBTFBGV7n7br9qt95683"; // Replace with actual UID of the user

async function setAdminRole() {
  try {
    await admin.auth().setCustomUserClaims(uid, { admin: true });
    console.log(`Super admin privileges set for user: ${uid}`);
  } catch (error) {
    console.error("Error setting admin claim:", error);
  }
}

setAdminRole();
