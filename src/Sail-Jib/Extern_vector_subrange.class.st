Class {
	#name : #'Extern_vector_subrange',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_vector_subrange class >> id [
	^ 'vector_subrange'
]

{ #category : #evaluating }
Extern_vector_subrange >> evaluateWithArguments: args [
	^ args first copyFrom: args second value to: args third value
]
