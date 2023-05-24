import express from "express";
import ejs from "ejs";
import path from "node:path";
import dotenv from "dotenv"

dotenv.config()

console.log(process.env.PORT, process.env.HOST)

const PORT = (process.env.PORT ?? 8080) as number;
const HOST = process.env.HOST ?? "0.0.0.0"

const main = async () => {
  const app = express();

  app.set("views", path.join(__dirname, "../views"));
  app.set("view engine", ejs);
  app.use(express.static(path.join(__dirname, "../public")));

  app.get("/", (_req, res) => {
    return res.render("pages/index.ejs");
  });

  app.listen(PORT, HOST, () => {
    console.log(`Server Running at https://${HOST}:${PORT}`);
  });
};

main();
