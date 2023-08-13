package common

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestReadJson(t *testing.T) {
	//p0 := gomonkey.ApplyFuncReturn(gojsonschema.Validate, nil, errors.New("validate err"))
	assert.Error(t, ReadJson("", "", nil, true))
	//p0.Reset()
}
