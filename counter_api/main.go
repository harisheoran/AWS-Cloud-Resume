package main

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/harisheoran/counter_api/controllers"
)

var mainRouter = gin.Default()

func main() {

	// Apply CORS middleware
	mainRouter.Use(cors.Default())

	mainRouter.GET("/", controllers.RootHandler)

	mainRouter.Run(":4000")

}
