package cfn.tag.env

import data.cfn.tag

untagged_resources[resources] {
	rs = tag.taggable_resources - tagged_resources
	resources = rs[_]
}

tagged_resources[resources] {
	input.Resources[r].Properties.Tags[_].Key == "Env"
	resources = r
}

deny[msg] {
	msg = sprintf("'%v' does not have 'Env' tag", [untagged_resources[_]])
}
