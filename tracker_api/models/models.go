package models

import (
	"context"
	"errors"
	"fmt"
	"log"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

type MyTable struct {
	DynamoDbClient *dynamodb.Client
	TableName      string
	PkName         string
	SkName         string
	GsiName        string
	LsiName        string
	GsiIndexName   string
	LsiIndexName   string

	// GlobalWriteReadCap should be equal or higher than PartitionWriteReadCap
	GlobalWriteReadCap    int
	PartitionWriteReadCap int

	Location string
}

type MyCount struct {
	Count int    `dynamodbav:"Count"`
	PK    string `dynamodbav:"PK"`
	SK    string `dynamodbav:"SK"`
}

const (
	PKFormat = "Pk#%s"
	SKFormat = "Sk#%s"
)

// Get Item
func (myTable MyTable) GetItem(id string) (MyCount, error) {
	item := MyCount{}
	selectedKeys := map[string]string{
		"PK": fmt.Sprintf(PKFormat, id),
		"SK": fmt.Sprintf(SKFormat, id),
	}
	key, err := attributevalue.MarshalMap(selectedKeys)

	data, err := myTable.DynamoDbClient.GetItem(context.TODO(), &dynamodb.GetItemInput{
		TableName: aws.String(myTable.TableName),
		Key:       key,
	},
	)

	if err != nil {
		return item, fmt.Errorf("GetItem: %v\n", err)
	}

	if data.Item == nil {
		return item, fmt.Errorf("GetItem: Data not found.\n")
	}

	err = attributevalue.UnmarshalMap(data.Item, &item)
	if err != nil {
		return item, fmt.Errorf("UnmarshalMap: %v\n", err)
	}

	return item, nil
}

// Put a item
func (myTable MyTable) PutItem(mycount MyCount) error {
	data, err := attributevalue.MarshalMap(mycount)

	if err != nil {
		return fmt.Errorf("MarshalMap: %v\n", err)
	}

	_, err = myTable.DynamoDbClient.PutItem(context.TODO(), &dynamodb.PutItemInput{
		TableName: aws.String(myTable.TableName),
		Item:      data,
	})

	if err == nil {
		return fmt.Errorf("PUTITEM: %v\n", err)
	}

	return nil

}

// Create a table
func (myTable MyTable) CreateTable() {
	out, err := myTable.DynamoDbClient.CreateTable(context.TODO(), &dynamodb.CreateTableInput{
		TableName: aws.String(myTable.TableName),
		AttributeDefinitions: []types.AttributeDefinition{
			{
				AttributeName: aws.String(myTable.PkName),
				AttributeType: types.ScalarAttributeTypeS,
			},
			{
				AttributeName: aws.String(myTable.SkName),
				AttributeType: types.ScalarAttributeTypeS,
			},
		},
		KeySchema: []types.KeySchemaElement{
			{
				AttributeName: aws.String(myTable.PkName),
				KeyType:       types.KeyTypeHash,
			},
			{
				AttributeName: aws.String(myTable.SkName),
				KeyType:       types.KeyTypeRange,
			},
		},
		ProvisionedThroughput: &types.ProvisionedThroughput{
			ReadCapacityUnits:  aws.Int64(int64(myTable.PartitionWriteReadCap)),
			WriteCapacityUnits: aws.Int64(int64(myTable.PartitionWriteReadCap)),
		},
	})
	if err != nil {
		panic(err)
	}

	fmt.Println(out)
}

func (basics MyTable) TableExists() (bool, error) {
	exists := true
	_, err := basics.DynamoDbClient.DescribeTable(
		context.TODO(), &dynamodb.DescribeTableInput{TableName: aws.String(basics.TableName)},
	)
	if err != nil {
		var notFoundEx *types.ResourceNotFoundException
		if errors.As(err, &notFoundEx) {
			log.Printf("Table %v does not exist.\n", basics.TableName)
			err = nil
		} else {
			log.Printf("Couldn't determine existence of table %v. Here's why: %v\n", basics.TableName, err)
		}
		exists = false
	}
	return exists, err
}
