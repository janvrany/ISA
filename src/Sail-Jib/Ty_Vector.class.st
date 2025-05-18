Class {
	#name : #'Ty_Vector',
	#superclass : #Ty,
	#instVars : [
		'ty'
	],
	#category : #'Sail-Jib'
}

{ #category : #syntax }
Ty_Vector class >> inducedParser [
	^ '%vec' asParser
	, Ty asParser parens
	construct: #(- ty)
]

{ #category : #enumerating }
Ty_Vector >> childrenDo: aBlock [
	aBlock value: ty
	
]

{ #category : #accessing }
Ty_Vector >> sort [
	^ Int sort --> ty sort.
]

{ #category : #printing }
Ty_Vector >> unparseOn: aStream [
	aStream nextPutAll:'%vec('.
	ty unparseOn: aStream.
	aStream 	nextPutAll:')'.

]
