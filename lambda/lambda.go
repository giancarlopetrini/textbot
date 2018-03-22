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
// may remove gatewayproxyrequest, in favor of a body mapping setup
func Handler(request events.APIGatewayProxyRequest) error {

	// maybe add .WithCredentials if needed
	svc := lexruntimeservice.New(session.New(), aws.NewConfig().WithRegion("us-east-1"))
	botAlias := "dev"
	botName := "BookTrip"
	inputText := "TEST INPUT"
	sessionAttr := make(map[string]*string)
	userID := "testuserID"
	input := lexruntimeservice.PostTextInput{
		BotAlias:          &botAlias,
		BotName:           &botName,
		InputText:         &inputText,
		SessionAttributes: sessionAttr,
		UserId:            &userID,
	}
	svc.PostText(&input)
	return nil
}

func main() {
	lambda.Start(Handler)
}
