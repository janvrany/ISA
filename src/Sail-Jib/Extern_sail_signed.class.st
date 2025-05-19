Class {
	#name : #'Extern_sail_signed',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_sail_signed class >> id [
	^ 'sail_signed'
]

{ #category : #evaluating }
Extern_sail_signed >> evaluateWithArguments: args [
	^ args first signedValue
]
