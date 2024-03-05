package main

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/harisheoran/tracker_api/controllers"
	"github.com/harisheoran/tracker_api/inits"
)

func init() {
	inits.LoadEnv()
}

var mainRouter = gin.Default()

func main() {

	// Apply CORS middleware
	mainRouter.Use(cors.Default())

	mainRouter.GET("/", controllers.MainHandler)

	mainRouter.Run(":4000")
}
