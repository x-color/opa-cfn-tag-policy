# Example

## Files

- policy/deny.rego: It defines tagging policy
- templates/vpc-template.yaml: Sample CloudFormation template. It includes untagged resources.

## Evaluate a template with the tagging policy

Using OPA CLI

```bash
$ curl -L -o policy/cfn_tag.rego https://raw.githubusercontent.com/x-color/opa-cfn-tag-policy/main/policy/cfn_tag.rego
$ opa eval -d policy -i templates/vpc-template.yaml data.main
{
  "result": [
    {
      "expressions": [
        {
          "value": {
            "deny": [
              "No 'Env' tag: VPC",
              "No 'Env' tag: InternetGateway",
              "No 'Name' tag: InternetGateway",
              "Invalid tag 'Name'!='vpc': InternetGateway"
            ]
          },
          "text": "data.main",
          "location": {
            "row": 1,
            "col": 1
          }
        }
      ]
    }
  ]
}
```

Using Conftest

```sh
$ conftest pull --update https://raw.githubusercontent.com/x-color/opa-cfn-tag-policy/main/policy/cfn_tag.rego
$ conftest test templates
FAIL - templates/vpc-template.yaml - main - No 'Env' tag: VPC
FAIL - templates/vpc-template.yaml - main - No 'Env' tag: InternetGateway
FAIL - templates/vpc-template.yaml - main - No 'Name' tag: InternetGateway
FAIL - templates/vpc-template.yaml - main - Invalid tag 'Name'!='vpc': InternetGateway

4 tests, 0 passed, 0 warnings, 4 failures, 0 exceptions
```
