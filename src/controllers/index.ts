import type { Response, Request } from "express";

export const homeController = (_req: Request, res: Response) => {
  return res.render("pages/index.ejs");
};
