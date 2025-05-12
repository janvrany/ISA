Extension { #name : #'Exp_Field' }

{ #category : #'*Sail-Jib-Interpreter' }
Exp_Field >> interpretIn: interpreter [
	^ interpreter interpretField: self.
]
