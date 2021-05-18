package main

import data.cloudformation as cfn

deny[reason] {
	some id
	rs := input.Resources[id]
	not cfn.resource_has_tag(rs, "Env")
	reason = sprintf("No 'Env' tag: %v", [id])
}

deny[reason] {
	some id
	rs := input.Resources[id]
	not cfn.resource_has_tag(rs, "Name")
	reason = sprintf("No 'Name' tag: %v", [id])
}

deny[reason] {
	some id
	rs := input.Resources[id]
	not cfn.resource_has_tag_and_value(rs, "Name", "vpc")
	reason = sprintf("Invalid tag 'Name'!='vpc': %v", [id])
}
