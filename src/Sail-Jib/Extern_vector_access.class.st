Class {
	#name : #'Extern_vector_access',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_vector_access class >> id [
	^ 'vector_access'
]

{ #category : #evaluating }
Extern_vector_access >> evaluateWithArguments: args [
	^ args first arraySelect: args second
]
