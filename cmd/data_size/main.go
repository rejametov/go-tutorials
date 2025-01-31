package main

import (
	"encoding/json"
	"fmt"

	"github.com/brianvoe/gofakeit"
	desc "github.com/rejametov/go-tutorials/grpc/pkg/note/v1"
	"google.golang.org/protobuf/proto"
)

func main() {
	session := &desc.NoteInfo{
		Title:    gofakeit.BeerName(),
		Content:  gofakeit.IPv4Address(),
		Author:   gofakeit.Name(),
		IsPublic: gofakeit.Bool(),
	}

	dataJson, _ := json.Marshal(session)
	fmt.Printf("\n\ndataJson len %d byte\n%v\n", len(dataJson), dataJson)

	dataPb, _ := proto.Marshal(session)
	fmt.Printf("\n\ndataPb len %d byte\n%v\n", len(dataPb), dataPb)
}
