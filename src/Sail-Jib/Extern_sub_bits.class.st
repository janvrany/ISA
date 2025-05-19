Class {
	#name : #'Extern_sub_bits',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_sub_bits class >> id [
	^ 'sub_bits'
]

{ #category : #evaluating }
Extern_sub_bits >> evaluateWithArguments: args [
	^ args first - args second
]
