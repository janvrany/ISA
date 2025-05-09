Class {
	#name : #'Extern_i_to_i64',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_i_to_i64 class >> id [
	^ '%i->%i64'
]

{ #category : #evaluating }
Extern_i_to_i64 >> evaluateWithArguments: args [
	^ args first
]
