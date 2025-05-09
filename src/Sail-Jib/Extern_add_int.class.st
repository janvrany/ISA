Class {
	#name : #'Extern_add_int',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_add_int class >> id [
	^ 'add_int'
]

{ #category : #evaluating }
Extern_add_int >> evaluateWithArguments: args [
	^ self 	shouldBeImplemented
]
