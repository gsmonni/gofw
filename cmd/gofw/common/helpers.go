package common

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/xeipuuv/gojsonschema"
	"io"
	"os"
)

func ReadJson(dn string, sn string, data interface{}, useschema bool) error {
	var r *gojsonschema.Result
	var err error
	if useschema {
		schemaLoader := gojsonschema.NewReferenceLoader("file://" + sn)
		documentLoader := gojsonschema.NewReferenceLoader("file://" + dn)
		if r, err = gojsonschema.Validate(schemaLoader, documentLoader); err != nil {
			return err
		}
	}

	if !useschema || r.Valid() {
		// defer the closing of our jsonFile so that we can parse it later on
		jsonFile, err := os.Open(dn)
		defer func() {
			if err := jsonFile.Close(); err != nil {
				panic(err)
			}
		}()

		if err != nil {
			return err
		}
		if byteValue, err := io.ReadAll(jsonFile); err != nil {
			return err
		} else {
			return json.Unmarshal(byteValue, &data)
		}
	} else {
		errMsg := ""
		for _, desc := range r.Errors() {
			errMsg += fmt.Sprintf("%s\n", desc)
		}
		return errors.New(errMsg)
	}
}
