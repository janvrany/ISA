Class {
	#name : #'Extern_append',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_append class >> id [
	^ 'append'
]

{ #category : #evaluating }
Extern_append >> evaluateWithArguments: args [
	^ args first , args second
]
