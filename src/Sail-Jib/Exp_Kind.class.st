Class {
	#name : #'Exp_Kind',
	#superclass : #JibExp,
	#instVars : [
		'exp',
		'id'
	],
	#category : #'Sail-Jib'
}

{ #category : #enumerating }
Exp_Kind >> childrenDo: aBlock [
	aBlock value: exp
	
]

{ #category : #accessing }
Exp_Kind >> expr [
	^exp
]

{ #category : #accessing }
Exp_Kind >> id [
	^id
]

{ #category : #printing }
Exp_Kind >> unparseOn: aStream [
	exp unparseOn: aStream.
	aStream 
		nextPutAll: ' is ';
		nextPutAll: id.
]
