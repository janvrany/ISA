Class {
	#name : #'Ty_Union',
	#superclass : #Ty,
	#instVars : [
		'id'
	],
	#category : #'Sail-Jib'
}

{ #category : #syntax }
Ty_Union class >> inducedParser [
	^ '%union' asParser trim
	, JibParser id
	construct: #(- id)
]

{ #category : #accessing }
Ty_Union >> sort [
	^ self environment lookupSortForTypename: id
]

{ #category : #printing }
Ty_Union >> unparseOn: aStream [
	aStream nextPutAll: '%union '.
	aStream nextPutAll: id
]
