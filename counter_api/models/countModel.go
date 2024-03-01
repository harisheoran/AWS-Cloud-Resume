package models

import "gorm.io/gorm"

type Count struct {
	gorm.Model
	Count int
	Id    int
}
