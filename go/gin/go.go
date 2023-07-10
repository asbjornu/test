package main

import (
	"github.com/gin-gonic/gin"
)

func home(c *gin.Context) {
	router := gin.Default()
	url := gin.template_func.URLFor("home")
	c.String(200, url)
}

func main() {
	router := gin.Default()
	router.GET("/", home)
	router.Run(":9000")
}
