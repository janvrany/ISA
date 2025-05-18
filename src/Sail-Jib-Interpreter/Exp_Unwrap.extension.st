Extension { #name : #'Exp_Unwrap' }

{ #category : #'*Sail-Jib-Interpreter' }
Exp_Unwrap >> interpretIn: interpreter [
	^ interpreter interpretUnwrap: self.
]
