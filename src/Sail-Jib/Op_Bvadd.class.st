Class {
	#name : #'Op_Bvadd',
	#superclass : #JibOp,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Op_Bvadd class >> id [
	^ '@bvadd'
]

{ #category : #evaluating }
Op_Bvadd >> evaluateWithArguments: args [
	^ args first + args second
]
