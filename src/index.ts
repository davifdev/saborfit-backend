import express from "express";
import { authRouter } from "./routes/auth";

const app = express();

app.use("/api/auth", authRouter);

app.get("/", (req, res) => {
  res.send("Hello, World!");
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
