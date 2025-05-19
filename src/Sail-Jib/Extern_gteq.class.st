Class {
	#name : #'Extern_gteq',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_gteq class >> id [
	^ 'gteq'
]

{ #category : #evaluating }
Extern_gteq >> evaluateWithArguments: args [
	^ args first >= args second
]
