FROM golang:1.14

WORKDIR ./techtask

COPY . . 

RUN go build -o ./out/devops-techtask .

EXPOSE 443

CMD ["./out/devops-techtask"]
