Class {
	#name : #JibProgramEnvironment,
	#superclass : #JibEnvironment,
	#instVars : [
		'context',
		'typename2SortMap',
		'unitSort'
	],
	#category : #'Sail-Jib-Environment'
}

{ #category : #accessing }
JibProgramEnvironment >> context [
	^context
]

{ #category : #initialization }
JibProgramEnvironment >> initializeWithNode: aJibProgramNode [
	node := aJibProgramNode.
	context := Z3Context current.
	unitSort := context mkEnumerationSort: '%unit' 
	                             elements: { '()' }
	                               consts: Cell new
	                              testers: Cell new.	
	typename2SortMap := Dictionary new.
]

{ #category : #lookup }
JibProgramEnvironment >> lookupCtorForName: name numArgs: numArgs ifNone: noneBlock [
	"Lookup and return datatype constructor with given `name` 
	taking `numArgs`. If no such constructor is found, evaluate
	`noneBlock` and return resulting value."
	
	typename2SortMap do:[:sort |
		sort constructors do:[:ctor|
			(ctor name = name and:[ctor arity = numArgs]) ifTrue:[
				^ ctor
			]
		]
	].
	^noneBlock value.
]

{ #category : #lookup }
JibProgramEnvironment >> lookupSortForTypename: id [
	^ typename2SortMap at: id ifAbsent:[ JibProgramNotWellFormedError signal: 'No such type: ',id  ]
]

{ #category : #lookup }
JibProgramEnvironment >> lookupSortForUnit [
	^ unitSort 
]

{ #category : #accessing }
JibProgramEnvironment >> parent [
	^ nil
]

{ #category : #registering }
JibProgramEnvironment >> registerSort: sort forTypename: id [
	self assert:(sort isKindOf: Z3Sort).

	(typename2SortMap includesKey: id) ifTrue:[
		JibProgramNotWellFormedError signal: 'Typename ', id ,' already defined!'
	].
	typename2SortMap at: id put: sort.



]
