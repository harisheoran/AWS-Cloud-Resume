# Build Stage
FROM golang:1.22 as build

WORKDIR /app

COPY go.* ./

RUN go mod download

COPY . .

RUN mkdir build

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o build/main .

# Second Stage

#FROM scratch

#COPY --from=build /app/main .

EXPOSE 4000

ENTRYPOINT [ "./build/main" ]