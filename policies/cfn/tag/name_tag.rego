package cfn.tag.name

import data.cfn.tag

untagged_resources[resources] {
	rs = tag.taggable_resources - tagged_resources
	resources = rs[_]
}

tagged_resources[resources] {
	input.Resources[r].Properties.Tags[_].Key == "Name"
	resources = r
}

deny[msg] {
	msg = sprintf("'%v' does not have 'Name' tag", [untagged_resources[_]])
}
