Class {
	#name : #'Extern_sail_unsigned',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_sail_unsigned class >> id [
	^ 'sail_unsigned'
]

{ #category : #evaluating }
Extern_sail_unsigned >> evaluateWithArguments: args [
	^ args first toUnsignedInt
]
