Extension { #name : #'Exp_Struct' }

{ #category : #'*Sail-Jib-Interpreter' }
Exp_Struct >> interpretIn: interpreter [
	^ interpreter interpretStruct: self
]
