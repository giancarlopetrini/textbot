package main

import (
	"fmt"
	"log"
	"net/url"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/lexruntimeservice"
	"github.com/sfreiberg/gotwilio"
)

var (
	twilioSid  = os.Getenv("twilio_sid")
	twilioAuth = os.Getenv("twilio_auth")
	twilio     = gotwilio.NewTwilioClient(twilioSid, twilioAuth)
)

// Request - pulling json from API Gateway, originating from Twilio
type Request struct {
	Body string `json:"body-json"`
}

// Response - will eventually by xml (TwiML) back to twilio, i think...
type Response struct {
	Res string `json:"response"`
}

// Handler - invoked by twilio request to api gateway
func Handler(request Request) (Response, error) {
	if request.Body == "" {
		log.Fatalf("No text received from twilio")
		return Response{}, nil
	}
	log.Printf("Original Body from Twilio: %s", request.Body)

	twilioIn, err := url.ParseQuery(request.Body)
	if err != nil {
		log.Fatalf("Unable to parse inbound info: %s", err)
	}
	log.Printf("Parsed twilio inbound: %s", twilioIn)

	// maybe add .WithCredentials if needed
	svc := lexruntimeservice.New(session.New(), aws.NewConfig().WithRegion("us-east-1"))
	botAlias := "dev"
	botName := "BookTrip"
	inputText := (strings.Join(twilioIn["Body"], " "))
	sessionAttr := make(map[string]*string)
	userID := (strings.Replace(strings.Join(twilioIn["From"], ""), "+", "", -1))
	input := lexruntimeservice.PostTextInput{
		BotAlias:          &botAlias,
		BotName:           &botName,
		InputText:         &inputText,
		SessionAttributes: sessionAttr,
		UserId:            &userID,
	}
	outputText, err := svc.PostText(&input)
	if err != nil {
		log.Printf("Error getting PostTextOuput from Lex: %s", err)
	}
	log.Printf("%v \n", outputText)

	_, exception, err := twilio.SendSMS(os.Getenv("twilio_num"), userID, *outputText.Message, "", "")
	if exception != nil {
		log.Printf("Exception thrown by Twilio while sending response from Lex: %v", exception)
		return Response{Res: fmt.Sprint(exception)}, nil
	}
	if err != nil {
		log.Printf("Error calling twilio.SendSMS method: %s", err)
		return Response{Res: fmt.Sprint(err)}, err
	}
	return Response{}, nil

}

func main() {
	lambda.Start(Handler)
}
