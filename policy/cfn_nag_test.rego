package cloudformation

mock := {
	"Type": "AWS::EC2::VPC",
	"Properties": {"Tags": [{
		"Key": "Env",
		"Value": "dev",
	}]},
}

test_has_tag_target_tag_exists {
	has_tag(input, "Env") with input as mock
}

test_has_tag_target_tag_doesnt_exist {
	not has_tag(input, "Name") with input as mock
}

test_has_tag_valid_tag_and_value {
	has_tag_and_value(input, "Env", "dev") with input as mock
}

test_has_tag_valid_tag_and_value {
	not has_tag_and_value(input, "Env", "prd") with input as mock
}
