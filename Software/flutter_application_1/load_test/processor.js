// processor.js
module.exports = {
  generateData: function (req, ctx, ee, next) {
    const latitude = Math.random() * (7.245 - 7.243) + 7.243;
    const longitude = Math.random() * (80.170 - 80.168) + 80.168;
    const nitrogen = Math.floor(Math.random() * (30 - 10 + 1)) + 10;
    const phosphorus = Math.floor(Math.random() * (10 - 3 + 1)) + 3;
    const potassium = Math.floor(Math.random() * (12 - 4 + 1)) + 4;
    const soilMoisture = Math.floor(Math.random() * (50 - 10 + 1)) + 10;
    const timestamp = new Date().toISOString();

    req.json = {
      geoPoint: {
        latitude,
        longitude,
      },
      nitrogen,
      phosphorus,
      potassium,
      soilMoisture,
      timestamp,
    };

    return next();
  }
};
