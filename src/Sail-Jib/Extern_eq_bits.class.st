Class {
	#name : #'Extern_eq_bits',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_eq_bits class >> id [
	^ 'eq_bits'
]

{ #category : #evaluating }
Extern_eq_bits >> evaluateWithArguments: args [
	^ args first === args second
]
