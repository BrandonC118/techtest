FROM golang:1.14

WORKDIR .

COPY . . 

RUN go install .

EXPOSE 443

CMD ["techtest"]
