Class {
	#name : #'Extern_vector_update',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_vector_update class >> id [
	^ 'vector_update'
]

{ #category : #evaluating }
Extern_vector_update >> evaluateWithArguments: args [
	^ args first copy
		at: args second put: args third;
		yourself
]
