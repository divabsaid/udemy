SHELL=cmd
STRIPE_SECRET=sk_test_51JririKpk5bRqqMwDB68RATeVLIY1fZTSDMhRm5NWAYq5vqmxTgaq44wEyNG6fMlebvvALI5oHcd93PktapE4CT000zcDLppIg
STRIPE_KEY=pk_test_51JririKpk5bRqqMw33ofvogkoAJjTlUtnbREKvhOnWFO3uoiq3IPyGMAc9DXvxrSB9OFx2XUnyHTfwyrVowVCLcs008ipV3NlT
GOSTRIPE_PORT=4000
API_PORT=4001
DSN="root:@(localhost:3306)/widgets?parseTime=true&tls=false"

## build: builds all binaries
build: clean build_front build_back
	@echo All binaries built!

## clean: cleans all binaries and runs go clean
clean:
	@echo Cleaning...
	@echo y | DEL /S dist
	@go clean
	@echo Cleaned and deleted binaries

## build_front: builds the front end
build_front:
	@echo Building front end...
	@go build -o dist/gostripe.exe ./cmd/web
	@echo Front end built!

## build_invoice: builds the invoice microservice
build_invoice:
	@echo Building invoice microservice...
	@go build -o dist/invoice.exe ./cmd/micro/invoice
	@echo Invoice microservice built!

## build_back: builds the back end
build_back:
	@echo Building back end...
	@go build -o dist/gostripe_api.exe ./cmd/api
	@echo Back end built!

## start: starts front and back end
start: start_front start_back start_invoice

## start_invoice: starts the invoice microservice
start_invoice: build_invoice
	@echo Starting the invoice microservice...
	start /B .\dist\invoice.exe -dsn=${DSN}
	@echo Invoice microservice running!

## start_front: starts the front end
start_front: build_front
	@echo Starting the front end...
	set STRIPE_KEY=${STRIPE_KEY}&& set STRIPE_SECRET=${STRIPE_SECRET}&& start /B .\dist\gostripe.exe -dsn=${DSN}
	@echo Front end running!

## start_back: starts the back end
start_back: build_back
	@echo Starting the back end...
	set STRIPE_KEY=${STRIPE_KEY}&& set STRIPE_SECRET=${STRIPE_SECRET}&& start /B .\dist\gostripe_api.exe -dsn=${DSN}
	@echo Back end running!

## stop: stops the front and back end
stop: stop_front stop_back stop_invoice
	@echo All applications stopped

## stop_invoice: stops the invoice microservice
stop_invoice:
	@echo Stopping the invoice microservice...
	@taskkill /IM invoice.exe /F
	@echo Stopped invoice microservice

## stop_front: stops the front end
stop_front:
	@echo Stopping the front end...
	@taskkill /IM gostripe.exe /F
	@echo Stopped front end

## stop_back: stops the back end
stop_back:
	@echo Stopping the back end...
	@taskkill /IM gostripe_api.exe /F
	@echo Stopped back end


run:
	set STRIPE_KEY=${STRIPE_KEY}&& set STRIPE_SECRET=${STRIPE_SECRET}&& go run ./cmd/web -dsn=${DSN}

run-api:
	set STRIPE_KEY=${STRIPE_KEY}&& set STRIPE_SECRET=${STRIPE_SECRET}&& go run ./cmd/api -dsn=${DSN}

run-invoice:
	go run ./cmd/micro/invoice