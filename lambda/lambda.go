package main

import (
	"log"
	"os"
	"strings"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/lexruntimeservice"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/sfreiberg/gotwilio"
)

// Handler - lambda handler for processing inbound twiML
// may remove gatewayproxyrequest, in favor of a body mapping setup
func Handler(request events.APIGatewayProxyRequest) error {
	twilio := gotwilio.NewTwilioClient(os.Getenv("twilio_sid"), os.Getenv("twilio_auth"))
	smsResponse, except, err := twilio.GetSMS(os.Getenv("twilio_sid"))
	if err != nil {
		log.Printf("Can't get SMSResponse %s", err)
	}
	if except != nil {
		log.Printf("Twilio threw an exception: %v", except)
	}
	log.Printf("Value of smsResponse ->: %v, %T", smsResponse, smsResponse)

	// maybe add .WithCredentials if needed
	svc := lexruntimeservice.New(session.New(), aws.NewConfig().WithRegion("us-east-1"))
	botAlias := "dev"
	botName := "BookTrip"
	inputText := smsResponse.Body
	sessionAttr := make(map[string]*string)
	userID := strings.Replace(smsResponse.From, "+", "", -1)
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
