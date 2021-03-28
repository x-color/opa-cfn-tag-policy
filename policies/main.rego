package policy

import data.cfn.tag

default allow = false

allow {
	count(tag[_].deny[_]) == 0
}

messages[msg] {
	msg = tag[_].deny[_]
}
