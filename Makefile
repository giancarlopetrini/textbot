go:
	env GOOS=linux ARCH=amd64 go build -o lambda-file lambda/lambda.go
	zip lambda-file lambda-file
clean:
	rm lambda-file lambda-file.zip