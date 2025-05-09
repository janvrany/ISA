Class {
	#name : #'Extern_i64_to_i',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_i64_to_i class >> id [
	^ '%i64->%i'
]

{ #category : #evaluating }
Extern_i64_to_i >> evaluateWithArguments: args [
	^ args first
]
