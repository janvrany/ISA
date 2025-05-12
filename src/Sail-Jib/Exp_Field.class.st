Class {
	#name : #'Exp_Field',
	#superclass : #JibExp,
	#instVars : [
		'exp',
		'id'
	],
	#category : #'Sail-Jib'
}

{ #category : #enumerating }
Exp_Field >> childrenDo: aBlock [
	aBlock value: exp
]

{ #category : #accessing }
Exp_Field >> expr [
	^ exp
]

{ #category : #accessing }
Exp_Field >> id [
	^ id
]

{ #category : #printing }
Exp_Field >> unparseOn: aStream [
	exp unparseOn: aStream.
	aStream 
		nextPut: $.;
		nextPutAll: id.

]
