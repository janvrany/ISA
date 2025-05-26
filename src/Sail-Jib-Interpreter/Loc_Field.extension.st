Extension { #name : #'Loc_Field' }

{ #category : #'*Sail-Jib-Interpreter' }
Loc_Field >> assign: value in: interpreter [
	| struct |

	struct := loc readIn: interpreter.
	struct := struct set: field to: value.
	loc assign: struct in: interpreter.

]

{ #category : #'*Sail-Jib-Interpreter' }
Loc_Field >> readIn: interpreter [
	| struct |

	struct := loc readIn: interpreter.
	^ struct get: field
]
