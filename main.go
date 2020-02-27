package main

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()

	e.GET("/", hello)
	e.GET("/teste/:param", getTeste)

	e.Logger.Fatal(e.Start(":80"))
}

func hello(c echo.Context) error {
	return c.String(http.StatusOK, "pipeline de deploy feita")
}

func getTeste(c echo.Context) error {
	param := c.Param("param")
	return c.String(http.StatusOK, param)
}
