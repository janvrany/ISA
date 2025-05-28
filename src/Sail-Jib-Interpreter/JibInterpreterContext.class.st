Class {
	#name : #JibInterpreterContext,
	#superclass : #Object,
	#instVars : [
		'values',
		'function',
		'caller',
		'pc',
		'loc'
	],
	#category : #'Sail-Jib-Interpreter-Interpreter'
}

{ #category : #'instance creation' }
JibInterpreterContext class >> for: code [
	self assert: (code isRegister or:[code isLet]).

	^self for: code arguments: #()
]

{ #category : #'instance creation' }
JibInterpreterContext class >> for: code arguments: args [
	^self for: code arguments: args caller: nil
]

{ #category : #'instance creation' }
JibInterpreterContext class >> for: code arguments: args caller: caller [
	^self basicNew initializeWith: code arguments: args caller: caller
]

{ #category : #accessing }
JibInterpreterContext >> caller [
	^ caller
]

{ #category : #'accessing - variables' }
JibInterpreterContext >> def: id to: value [
	"Define new variable and set value to value"
	self assert: (values includesKey: id) not.
	values at: id put: value
]

{ #category : #accessing }
JibInterpreterContext >> function [
	^ function
]

{ #category : #'accessing - variables' }
JibInterpreterContext >> get: id [
	self assert: (values includesKey: id).
	^ values at: id.

]

{ #category : #'accessing - variables' }
JibInterpreterContext >> getRetVal [
	"Return the return value once function returns.
	 Should only be called after function interpretation
	 reaches 'end' instruction."

	^ self get: function retName
]

{ #category : #inspecting }
JibInterpreterContext >> gtLocalsIn: composite [
	<gtInspectorPresentationOrder: 40>

	^ composite fastTable
		title: 'Locals';
		display: [ :ctx | values associations ];
		column: 'Name' evaluated: [ :nameAndValue | nameAndValue key ];
		column: 'Value' evaluated: [ :nameAndValue | nameAndValue value simplify ];
		send: [ :selection | selection value ];
		yourself.


]

{ #category : #initialization }
JibInterpreterContext >> initializeWith: code arguments: args caller: callr [
	self assert: code hasCode.

	values := OrderedDictionary new.
	function := code.
	caller := callr.
	pc := 1.
	loc := (function instrs at: 1) sourceLoc.

	function isFn ifTrue:[
		"Initialize arguments and return value. We do this only
		 for real functions (Def_Fn) since let and register initializers
		 do not take arguments and have no return value"

		| signature |

		signature := function signature.
		values at: function retName put: signature retType newUndefined.
		function argNames with: args do:[:argName :argValue  |
			values at: argName put: argValue.
		].
	].




]

{ #category : #accessing }
JibInterpreterContext >> pc [
	^ pc
]

{ #category : #accessing }
JibInterpreterContext >> pc: anInteger [
	"Set the current PC (index into instrs sequence) in this context."

	"Here we allow to set the PC one beyond the size of an instruction
	 sequence - this is to signal end of initializer execution. See
	 JibInterpreter >> interpret1."
	self assert: (pc between: 1 and: function instrs size + 1).

	pc := anInteger.

	"Update the source location:"
	pc = (function instrs size + 1) ifTrue:[
		"If this is an initializer and finished execution, set
		 the location to unknown."
		loc := SourceLoc_Unknown new.
	] ifFalse:[
		"Otherwise set it to instruction's location unless it is
		 a `goto` or `end` who have no locations. So for those,
		 the location remains the location if previously executed
		 instruction. This avoids 'flickering' in debugger and also
		 deals with 'jump islands' in Jib code (jumps to cluster of
		 other jumps)."
		| instr |

		instr := function instrs at: pc.
		(instr isGoto not and:[instr isEnd not]) ifTrue:[
			loc := instr sourceLoc
		]
	]



]

{ #category : #printing }
JibInterpreterContext >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: '(in '.
	function displayStringOn: aStream.
	aStream nextPutAll: ' at '.
	pc printOn: aStream.
	aStream nextPut: $).
]

{ #category : #'accessing - variables' }
JibInterpreterContext >> set: id to: value [
	self assert: (values includesKey: id).
	
	values at: id put: value
]

{ #category : #accessing }
JibInterpreterContext >> sourceLoc [
	"Return a source location for instruction currently being executed.
	
	 Note that this may not be always the location of instruction at
	 current pc, for details, see `#pc:`.
	 "

	^ loc
]
