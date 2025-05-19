Extension { #name : #'Exp_Kind' }

{ #category : #'*Sail-Jib-Interpreter' }
Exp_Kind >> interpretIn: interpreter [
	^ interpreter interpretKind: self.
]
