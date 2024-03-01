package controllers

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/harisheoran/counter_api/inits"
	"github.com/harisheoran/counter_api/models"
)

// Handler functions
func CountHandler(context *gin.Context) {

	var count models.Count
	result := inits.DB.First(&count, "545")
	log.Print("Result is ", result)

	if result.Error != nil {
		context.JSON(
			500,
			gin.H{"error": "THis is error"})
		return
	}

	thisCount := count.Count + 1
	inits.DB.Model(&count).Updates(models.Count{Count: thisCount, Id: 545})
	context.JSON(200, gin.H{"response": count.Count})
}
