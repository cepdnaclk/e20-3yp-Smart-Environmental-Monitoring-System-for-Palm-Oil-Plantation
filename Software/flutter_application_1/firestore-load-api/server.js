const express = require("express");
const admin = require("firebase-admin");
const bodyParser = require("body-parser");

const serviceAccount = require("C://Users//ASUS//Desktop//Com_Sem_6//e20-3yp-Smart-Environmental-Monitoring-System-for-Palm-Oil-Plantation//Software//flutter_application_1//functions//environment-monitoring-s-d169b-firebase-adminsdk-fbsvc-a732b6dc9d.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const app = express();

app.use((req, res, next) => {
  console.log(`Received ${req.method} request for ${req.url}`);
  next();
});


// ✅ Parse incoming JSON
app.use(express.json());
app.use(bodyParser.json());

app.post('/write-raw', async (req, res) => {
  let data = req.body;

  // Convert string timestamp to Firestore Timestamp
  if (data.timestamp && typeof data.timestamp === 'string') {
    try {
      data.timestamp = admin.firestore.Timestamp.fromDate(new Date(data.timestamp));
    } catch (err) {
      console.error("Invalid timestamp format:", data.timestamp);
      return res.status(400).send({ error: "Invalid timestamp format" });
    }
  }

  try {
    await db.collection('raw_readings').add(data);
    console.log('✅ Data written:', data);
    res.status(200).send({ message: 'Data written successfully' });
  } catch (error) {
    console.error('❌ Firestore write error:', error);
    res.status(500).send({ error: 'Failed to write data', details: error.message });
  }
});


const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Listening on http://localhost:${PORT}`);
});