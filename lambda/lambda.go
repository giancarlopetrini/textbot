package main

import (
	"fmt"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
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
	fmt.Println(request.Body)
	return Response{Res: "Nailed It"}, nil
}

func main() {
	lambda.Start(Handler)
}

// maybe add .WithCredentials if needed
/*svc := lexruntimeservice.New(session.New(), aws.NewConfig().WithRegion("us-east-1"))
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
outputText, err := svc.PostText(&input)
if err != nil {
	log.Printf("Error getting PostTextOuput from Lex: %s", err)
}
_, except, err = twilio.SendSMS(os.Getenv("twilio_num"), smsResponse.From, *outputText.Message, "", "")
if except != nil {
	log.Printf("Exception thrown by Twilio while sending response from Lex: %v", except)
}
if err != nil {
	log.Printf("Error calling twilio.SendSMS method: %s", err)
}
return nil*/
