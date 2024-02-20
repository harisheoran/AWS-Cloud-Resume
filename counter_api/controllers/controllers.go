package controllers

import (
	"fmt"

	"github.com/gin-gonic/gin"
)

// Handler functions
func RootHandler(context *gin.Context) {
	count = append(count, 1)
	fmt.Println(count)

	context.JSON(
		200,
		gin.H{
			"response": count[len(count)-1],
		},
	)

}

var count = []int{0}
