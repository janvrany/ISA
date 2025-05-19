Class {
	#name : #'Extern_add_bits',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_add_bits class >> id [
	^ 'add_bits'
]

{ #category : #evaluating }
Extern_add_bits >> evaluateWithArguments: args [
	^ args first + args second
]
