Class {
	#name : #'Extern_zero_extend',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_zero_extend class >> id [
	^ 'zero_extend'
]

{ #category : #evaluating }
Extern_zero_extend >> evaluateWithArguments: args [
	^ args first zeroExtend: args second value - args first length
]
