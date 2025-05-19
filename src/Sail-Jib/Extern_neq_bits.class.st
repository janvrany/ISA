Class {
	#name : #'Extern_neq_bits',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_neq_bits class >> id [
	^ 'neq_bits'
]

{ #category : #evaluating }
Extern_neq_bits >> evaluateWithArguments: args [
	^ (args first = args second) not
]
