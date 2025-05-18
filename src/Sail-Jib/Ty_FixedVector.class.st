Class {
	#name : #'Ty_FixedVector',
	#superclass : #Ty,
	#instVars : [
		'length',
		'ty'
	],
	#category : #'Sail-Jib'
}

{ #category : #syntax }
Ty_FixedVector class >> inducedParser [
	^ '%fvec' asParser trim
	, (
	    PPParser decimalNat,
	    $, asParser trim,
	    Ty asParser
	    construct: #(length - ty)
	  ) parens
	==> #second
]

{ #category : #enumerating }
Ty_FixedVector >> childrenDo: aBlock [
	aBlock value: ty
	
]

{ #category : #'as yet unclassified' }
Ty_FixedVector >> newUndefined [
	^ self newZero
]

{ #category : #'as yet unclassified' }
Ty_FixedVector >> newZero [
	| zero |

	zero := ty newZero.
	^ (0 to: length - 1)
			inject: (self sort mkFreshConst: 'undefined')
			into: [ :array :index | array arrayStore: index toInt put: zero ]

]

{ #category : #accessing }
Ty_FixedVector >> sort [
	^ Int sort --> ty sort.
]

{ #category : #printing }
Ty_FixedVector >> unparseOn: aStream [
	aStream nextPutAll: '%fvec ('.
	length printOn: aStream.
	aStream nextPutAll: ', '.
	ty unparseOn: aStream.
	aStream nextPut: $)
	
]
