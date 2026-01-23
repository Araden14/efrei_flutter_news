import express from "express";
import cors from "cors";

const app = express();
app.use(cors());

app.get("/", (req, res) => {
  res.send("Proxy RSS Le Monde opérationnel. Utilisez /rss?url=...");
});

app.get("/rss", async (req, res) => {
  const url = req.query.url;
  if (!url) return res.status(400).send("URL manquante");

  try {
    const response = await fetch(url, {
      headers: {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
        "Accept": "application/rss+xml, text/xml"
      }
    });
    const data = await response.text();
    res.set("Content-Type", "application/rss+xml");
    res.send(data);
  } catch (error) {
    res.status(500).send("Erreur proxy: " + error.message);
  }
});

app.listen(3000, () => {
  console.log("Serveur proxy sur http://localhost:3000");
});