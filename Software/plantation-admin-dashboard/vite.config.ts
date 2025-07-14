// vite.config.ts
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      "/predict": {
        target: "https://tree-health-901340579460.us-central1.run.app",
        changeOrigin: true,
        secure: false,
        rewrite: (path) => path.replace(/^\/predict/, "/predict"),
      },
    },
  },
});



// // https://vite.dev/config/
// export default defineConfig({
//   plugins: [react()],
// })


// import { defineConfig } from "vite";

// export default defineConfig({
//   server: {
//     proxy: {
//       "/predict": {
//         target: "https://tree-health-901340579460.us-central1.run.app",
//         changeOrigin: true,
//         secure: false,
//         rewrite: (path) => path.replace(/^\/predict/, "/predict"),
//       },
//     },
//   },
// });
