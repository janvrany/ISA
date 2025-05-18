Class {
	#name : #JibExtern,
	#superclass : #JibPrim,
	#category : #'Sail-Jib'
}

{ #category : #testing }
JibExtern class >> isAbstract [
	^self == JibExtern 
]

{ #category : #utilities }
JibExtern class >> make: id [
	| externClassName |

	externClassName := ('Extern_' , id) asSymbol .
	(Smalltalk includesKey: externClassName) ifFalse:[
		| externClass idSource evaluateSource|

		externClass := JibExtern subclass: externClassName instanceVariableNames: '' classVariableNames: '' package: JibExtern package name.

		idSource :=
'id
	^ ''<1s>''' expandMacrosWith: id.
		evaluateSource :=
'evaluateWithArguments: args
	^ self 	shouldBeImplemented'.

		externClass class compile: idSource classified: #accessing.
		externClass compile: evaluateSource classified: #evaluating.

	]

]

{ #category : #accessing }
JibExtern class >> named: id [
	self allSubclassesDo: [ :cls |
		(cls isAbstract not and:[ cls id = id ]) ifTrue:[
			^cls new
		]
	].
	"TEMPORARY CODE"
	JibExtern make: id.
	self allSubclassesDo: [ :cls |
		(cls isAbstract not and:[ cls id = id ]) ifTrue:[
			^cls new
		]
	].
	"END OF TEMPORARY CODE"
	self error: 'No extern named ''' , id , ''''.
	
	"
	JibExtern named: 'sign_extend'
	JibExtern make: 'append'
	"
]

{ #category : #testing }
JibExtern >> isExtern [
	^ true
]
