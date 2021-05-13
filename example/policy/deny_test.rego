package main

test_deny_no_env_tag {
	deny["No 'Env' tag: NoEnvVpc"] with input as data.mock.invalid
}

test_deny_no_name_tag {
	deny["No 'Name' tag: NoNameVpc"] with input as data.mock.invalid
}

test_deny_invalid_tag {
	deny["Invalid tag 'Name'!='vpc': NoEnvVpc"] with input as data.mock.invalid
}

test_deny_env_tag_exists {
	not deny["No 'Env' tag: VPC"] with input as data.mock.valid
}

test_deny_name_tag_exists {
	not deny["No 'Name' tag: VPC"] with input as data.mock.valid
}

test_deny_valid_tag {
	not deny["Invalid tag 'Name'!='vpc': %v"] with input as data.mock.invalid
}
