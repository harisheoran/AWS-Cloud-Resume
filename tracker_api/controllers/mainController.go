package controllers

import (
	"context"
	"fmt"
	"log"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/gin-gonic/gin"
	"github.com/harisheoran/tracker_api/models"
)

func MainHandler(context *gin.Context) {
	client := CreateProductionClient()

	myTable := models.MyTable{
		DynamoDbClient:        client,
		TableName:             "mytrackerssssss",
		PkName:                "PK",
		SkName:                "SK",
		GsiName:               "GSI",
		LsiName:               "LSI",
		GsiIndexName:          "GlobalSecondaryIndex",
		LsiIndexName:          "LocalSecondaryIndex",
		GlobalWriteReadCap:    10,
		PartitionWriteReadCap: 10,
		Location:              "us-east-1",
	}

	fmt.Println(myTable)

	isexist, tableExistERR := myTable.TableExists()
	fmt.Println(isexist)
	if tableExistERR != nil {
		log.Fatal(tableExistERR)
	}
	if isexist {
		mycount, _ := myTable.GetItem("1")

		//fmt.Println("COUNT", mycount.Count)
		if mycount.Count == 0 {
			myCount := models.MyCount{
				Count: 1,
				PK:    "Pk#1",
				SK:    "Sk#1",
			}
			// Put an Item
			err := myTable.PutItem(myCount)

			if err != nil {
				fmt.Print("PUT ITEM ERROR")
				log.Fatal(err)
			} else {
				fmt.Println("Put item success FIRST TIME")
			}
		} else {
			mycount, getErr := myTable.GetItem("1")
			newCount := mycount.Count + 1
			myTable.PutItem(models.MyCount{newCount, "Pk#1", "Sk#1"})

			if getErr != nil {
				context.JSON(
					500,
					gin.H{
						"error": "Database Error",
					},
				)

			}

			fmt.Print("VIEWS: ", mycount.Count)
			context.JSON(
				200,
				gin.H{
					"response": newCount,
				},
			)
		}

	} else {
		myTable.CreateTable()
		context.JSON(
			200,
			gin.H{
				"response": 1,
			},
		)
	}

}

func CreateProductionClient() *dynamodb.Client {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		panic(err)
	}

	return dynamodb.NewFromConfig(cfg)
}

func CreateLocalClient() *dynamodb.Client {
	cfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithRegion("us-east-1"),
		config.WithEndpointResolver(aws.EndpointResolverFunc(
			func(service, region string) (aws.Endpoint, error) {
				return aws.Endpoint{URL: "http://localhost:8000"}, nil
			})),
		config.WithCredentialsProvider(credentials.StaticCredentialsProvider{
			Value: aws.Credentials{
				AccessKeyID: "dummy", SecretAccessKey: "dummy", SessionToken: "dummy",
				Source: "Hard-coded credentials; values are irrelevant for local DynamoDB",
			},
		}),
	)
	if err != nil {
		panic(err)
	}

	return dynamodb.NewFromConfig(cfg)
}
