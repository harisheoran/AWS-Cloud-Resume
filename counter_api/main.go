package main

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/harisheoran/counter_api/controllers"
	"github.com/harisheoran/counter_api/inits"
)

// The init function will be called automatically and cannot have any parameters.
func init() {
	inits.LoadEnv()
	inits.DBinits()
}

var mainRouter = gin.Default()

func main() {

	// Apply CORS middleware
	mainRouter.Use(cors.Default())

	mainRouter.GET("/", controllers.CountHandler)

	mainRouter.Run(":4000")

}
