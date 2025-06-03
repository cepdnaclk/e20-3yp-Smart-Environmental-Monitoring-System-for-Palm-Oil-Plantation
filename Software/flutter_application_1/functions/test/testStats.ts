import axios from "axios";

// Use Firestore emulator if needed
process.env.FIRESTORE_EMULATOR_HOST = "localhost:8080";

const projectId = "environment-monitoring-s-d169b";
const functionName = "getSectionParameterStatistics";
const region = "us-central1";

const url = `http://localhost:5001/${projectId}/${region}/${functionName}`;

async function test() {
  try {
    const response = await axios.post(
      url,
      {
        data: {
          sectionPath: "states/y7A23J2QvlC1845hmOYU/sections/Mr6HodnzvBeXr0aMoEhL",
          parameter: "npk.nitrogen",
          // Optional:
          startTime: "2025-03-01T00:00:00Z",
          endTime: "2025-04-27T00:00:00Z",
        },
      },
      {
        headers: { "Content-Type": "application/json" },
      }
    );

    console.log("📊 Statistics Result:", JSON.stringify(response.data, null, 2));
  } catch (err: any) {
    console.error("❌ Error testing function:", err.response?.data || err.message);
  }
}

test();
