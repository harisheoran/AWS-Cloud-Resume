package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/harisheoran/tracker_api/models"
)

func main() {
	client := CreateProductionClient()

	myTable := models.MyTable{
		DynamoDbClient:        client,
		TableName:             "view_tracker",
		PkName:                "PK",
		SkName:                "SK",
		GsiName:               "GSI",
		LsiName:               "LSI",
		GsiIndexName:          "GlobalSecondaryIndex",
		LsiIndexName:          "LocalSecondaryIndex",
		GlobalWriteReadCap:    10,
		PartitionWriteReadCap: 10,
		Location:              "ap-south-1",
	}
	myTable.CreateTable()
	isexist, tableExistERR := myTable.TableExists()
	if tableExistERR != nil {
		log.Fatal(tableExistERR)
	}
	if isexist {
		myCount := models.MyCount{
			Count: 1,
			PK:    "Pk#1",
			SK:    "Sk#1",
		}
		delay := 5 * time.Second
		time.Sleep(delay)
		// Put an Item
		err := myTable.PutItem(myCount)

		if err != nil {
			fmt.Print("PUT ITEM ERROR")
			log.Fatal(err)
		} else {
			fmt.Println("Put item success FIRST TIME")
		}
	}
}

func CreateProductionClient() *dynamodb.Client {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		panic(err)
	}

	return dynamodb.NewFromConfig(cfg)
}
