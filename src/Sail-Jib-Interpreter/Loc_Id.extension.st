Extension { #name : #'Loc_Id' }

{ #category : #'*Sail-Jib-Interpreter' }
Loc_Id >> assign: value in: interpreter [
	interpreter set: id to: value
]

{ #category : #'*Sail-Jib-Interpreter' }
Loc_Id >> readIn: interpreter [
	^ interpreter get: id 
]
