import type {Request, Response} from "express";
import { homeController } from "../src/controllers/index"

type TestResponse = {
    viewName: string;
    data: unknown;
} & Response

const request = {} as Request;
const response = {
    viewName: "",
    data: {},
    render: (view: string, viewData: unknown) => {
        response.viewName = view,
        response.data = viewData
    }
} as TestResponse;

describe('GET /', () => {
    test("should render the index view", () => {
        homeController(request, response);
        expect(response.viewName).toBe("pages/index.ejs")
    })
})