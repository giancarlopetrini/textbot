package main

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/lexruntimeservice"

	// "github.com/sfreiberg/gotwilio"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// Handler - lambda handler for processing inbound twiML
func Handler(request events.APIGatewayProxyRequest) error {

	// create lexruntime client, maybe add .WithCredentials if needed
	svc := lexruntimeservice.New(session.New(), aws.NewConfig().WithRegion("us-east-1"))
	input := &lexruntimeservice.PostTextInput{
		BotAlias:          `location:"uri" locationName:"botAlias" type:"string" required:"true"`,
		BotName:           `location:"uri" locationName:"botName" type:"string" required:"true"`,
		InputText:         `locationName:"inputText" min:"1" type:"string" required:"true"`,
		SessionAttributes: `locationName:"sessionAttributes" type:"map"`,
		UserId:            `location:"uri" locationName:"userId" min:"2" type:"string" required:"true"`,
	}
	svc.PostText(input)
	return nil
}

func main() {
	lambda.Start(Handler)
}
