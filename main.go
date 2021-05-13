package main

import (
	_ "embed"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"sort"
	"text/template"
)

type ResourceSpecification struct {
	Documentation string                 `json:"Documentation,omitempty"`
	Properties    map[string]interface{} `json:"Properties,omitempty"`
}

func (r *ResourceSpecification) hasTagsProperty() bool {
	for k := range r.Properties {
		if k == "Tags" {
			return true
		}
	}
	return false
}

type CloudFormationResourceSpecification struct {
	ResourceTypes                map[string]ResourceSpecification  `json:"ResourceTypes,omitempty"`
	PropertyTypes                map[string]map[string]interface{} `json:"PropertyTypes,omitempty"`
	ResourceSpecificationVersion string                            `json:"ResourceSpecificationVersion,omitempty"`
}

type templateValue struct {
	Types []string
}

//go:embed cfn_tag.rego.template
var tempFile string

func downloadFile(url string) ([]byte, error) {
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	return ioutil.ReadAll(resp.Body)
}

func main() {
	// This JSON file defines the specification of the CloudFormation Template for Tokyo region (ap-northeast-1).
	// See https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-resource-specification.html
	url := "https://d33vqc0rt9ld30.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json"
	body, err := downloadFile(url)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	cfnSpec := new(CloudFormationResourceSpecification)
	if err := json.Unmarshal(body, cfnSpec); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	tplValue := templateValue{
		Types: make([]string, 0),
	}

	for typ, spec := range cfnSpec.ResourceTypes {
		if spec.hasTagsProperty() {
			tplValue.Types = append(tplValue.Types, typ)
		}
	}
	sort.Strings(tplValue.Types)

	tpl, err := template.New("").Parse(tempFile)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	if err := tpl.Execute(os.Stdout, tplValue); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
