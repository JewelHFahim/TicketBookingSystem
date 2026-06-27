import express, { Request, Response } from "express";
const app = express();
const port = 5000;

app.get("/", (req: Request, res: Response) => {
  res.send("Welcome, Football Ticket Booking System !");
});

app.listen(port, () => {
  console.log(`Server running on port: ${port}`);
});
