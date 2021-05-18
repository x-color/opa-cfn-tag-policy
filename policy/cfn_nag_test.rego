package cloudformation

mock := {
	"Type": "AWS::EC2::VPC",
	"Properties": {"Tags": [{
		"Key": "Env",
		"Value": "dev",
	}]},
}

test_resource_has_tag_target_tag_exists {
	resource_has_tag(input, "Env") with input as mock
}

test_resource_has_tag_target_tag_doesnt_exist {
	not resource_has_tag(input, "Name") with input as mock
}

test_resource_has_tag_valid_tag_and_value {
	resource_has_tag_and_value(input, "Env", "dev") with input as mock
}

test_resource_has_tag_valid_tag_and_value {
	not resource_has_tag_and_value(input, "Env", "prd") with input as mock
}
