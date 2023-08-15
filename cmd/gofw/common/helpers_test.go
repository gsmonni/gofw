package common

import (
	"errors"
	"github.com/agiledragon/gomonkey/v2"
	"github.com/stretchr/testify/assert"
	"github.com/xeipuuv/gojsonschema"
	"testing"
)

func TestReadJson(t *testing.T) {
	p0 := gomonkey.ApplyFuncReturn(gojsonschema.Validate, nil, errors.New("validate err"))
	assert.Error(t, ReadJson("", "", nil, true))
	p0.Reset()
}
