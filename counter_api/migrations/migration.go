package main

import (
	"github.com/harisheoran/counter_api/inits"
	"github.com/harisheoran/counter_api/models"
)

func init() {
	inits.LoadEnv()
	inits.DBinits()
}

func main() {
	inits.DB.AutoMigrate(&models.Count{})
	count := models.Count{Count: 0, Id: 545}
	inits.DB.Create(&count)
}
