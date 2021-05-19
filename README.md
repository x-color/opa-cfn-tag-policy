# CloudFormation tagging policy

This repository has a [policy file](https://github.com/x-color/cfn-opa-tag-policy/blob/main/policy/cfn_tag.rego) of the [Open Policy Agent](https://www.openpolicyagent.org/) to check that resources defined in CloudFormation templates are tagged.

The repository updates the policy file to follow the latest specification of CloudFormation everyday.

## How to use

Get the policy file.

```bash
# Download the policy
$ curl -L -o policy/cfn_tag.rego https://raw.githubusercontent.com/x-color/opa-cfn-tag-policy/main/policy/cfn_tag.rego

# Pull the policy if you use Conftest (https://github.com/open-policy-agent/conftest)
$ conftest pull https://raw.githubusercontent.com/x-color/opa-cfn-tag-policy/main/policy/cfn_tag.rego
```

Import the policy and use functions in your policy files.

```rego
package <your package name>

import data.cloudformation as cfn

# Check that resources have 'TAG NAME' tag
deny[msg] {
	some id
	rs := input.Resources[id]
	not cfn.resource_has_tag(rs, "<TAG NAME>")
	msg = sprintf("No '<TAG NAME>' tag: %v", [id])
}

# Check that resources have 'TAG NAME' tag and the tag's value is 'TAG VALUE'
deny[msg] {
	some id
	rs := input.Resources[id]
	not cfn.resource_has_tag_and_value(rs, "<TAG NAME>", "<TAG VALUE>")
	msg = sprintf("Invalid tag '<TAG NAME>' != '<TAG VALUE>': %v", [id])
}
```

Using OPA CLI

```bash
$ opa eval -d policy -i <cfn template file> data.<package name>
```

Using Conftest

```bash
$ conftest test --policy <package name> <cfn template file>
```

## Sample

Sample policy file and CloudFormation template is in [example](https://github.com/x-color/opa-cfn-tag-policy/tree/main/example).
See the directory if you want to try it.

## LICENCE

MIT
