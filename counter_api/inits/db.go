package inits

import (
	"os"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB *gorm.DB

func DBinits() {
	db_url := os.Getenv("DB_URL")
	db, err := gorm.Open(mysql.Open(db_url), &gorm.Config{})
	if err != nil {
		panic("failed to connect to database")
	}
	DB = db
}
