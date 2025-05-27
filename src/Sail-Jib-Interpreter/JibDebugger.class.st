Class {
	#name : #JibDebugger,
	#superclass : #GTGenericStackDebugger,
	#category : #'Sail-Jib-Interpreter-Debugger'
}

{ #category : #accessing }
JibDebugger class >> defaultTitle [
	^ self class name
]

{ #category : #testing }
JibDebugger class >> isAbstract [
	^ self == JibDebugger 
]

{ #category : #openning }
JibDebugger class >> openOn: anObject [
	self == JibDebugger ifTrue:[
		^ JibSourceDebugger openOn: anObject 
	] ifFalse:[
		^ super openOn: anObject.
	]
]

{ #category : #accessing }
JibDebugger class >> sessionClass [
	^JibDebuggerSession 
]

{ #category : #private }
JibDebugger class >> spanNewSessionForContext: aContext fromProcess: aProcess [
	self shouldNotImplement 
]

{ #category : #accessing }
JibDebugger class >> spanNewSessionFrom: anotherSession [
	(anotherSession isKindOf: self sessionClass) ifTrue:[
		^ anotherSession copy.
	].

	(anotherSession isKindOf: GTBDebuggerSession) ifTrue:[
		^ GTBJibDebuggerSession forDebugger: anotherSession debugger
	].
	
	^ self error: 'Unssuported session type!'
]

{ #category : #private }
JibDebugger class >> spanNewSessionLabeled: aString forContext: aContext fromProcess: aProcess [
	self shouldNotImplement 
]

{ #category : #'building presentations' }
JibDebugger >> codeIn: composite forContext: frame [
	self subclassResponsibility 
]

{ #category : #building }
JibDebugger >> debuggerStructureIn: browser [
	
	browser
		row: #stack;
		row: #code span: 2;
		row: #inspector.
]

{ #category : #formatting }
JibDebugger >> formatInstruction: insn forContext: context [
	(context function instrs indexOf: insn) == context pc ifTrue:[
		^ '>> ' , insn unparsedString
	] ifFalse:[
		^ '   ' , insn unparsedString
	]

]

{ #category : #formatting }
JibDebugger >> formatStackForContext: context [
	^context function unparsedString
]

{ #category : #'building presentations' }
JibDebugger >> installBindingsForDoItIn: aPresentation from: aContext [
	"TODO"


]

{ #category : #'building presentations' }
JibDebugger >> instructionsIn: composite forContext: context [
	^ composite fastList
		title: 'Instructions';
		with: [ :list | self installActionsForRootPragmas: #( instructionDebuggingAction ) in: list ];
		initialize: [ :list | list showLine: context pc ];
		display: [ context function instrs ];
		format: [ :insn | self formatInstruction: insn forContext: context ];
		selectionAct: [ :list | list selection inspect ]
			iconName: #smallInspectIt
			entitled: 'Inspect'.
]

{ #category : #opening }
JibDebugger >> setDebuggerToFirstNonFilteredContext [
	"Nothing to do"
]

{ #category : #'building presentations' }
JibDebugger >> sourceIn: composite forContext: context [
	composite text
			title: 'Source';
			with: [ :text | self installActionsForRootPragmas: #( sourceDebuggingAction ) in: text ];
			display: [ context sourceLoc sourceTextWithHighlights ifNil:[ 'Source not available' ] ];
			format: #asText;
			initialize: [ :text | text showLine: context sourceLoc sourceLine ];
			withLineNumbers: true;
			wrapped: false

]

{ #category : #'building presentations' }
JibDebugger >> stackWidgetIn: composite [
	^ composite fastList
		title: 'Stack';
		useCache;
		display: [:aSession | self retrieveStackFrom: aSession];
		format: [ :aContext | self formatStackForContext: aContext];
		selectionAct: [ :list | list selection inspect ]
			iconName: #smallInspectIt
			entitled: 'Inspect'.
]

{ #category : #building }
JibDebugger >> transmitFromStackToCodeIn: browser [
	browser transmit
		from: #stack port: #selection;
		to: #code;
		andShow: [ :composite :context | context notNil ifTrue:[ self codeIn: composite forContext: context ]].
]

{ #category : #updating }
JibDebugger >> updateBrowser [
	| browserPane session |

	session := self session.
	((session interruptedContext isNil) and:[session gdb notNil]) ifTrue: [
		"Following code is copy-paste-n-hacked version of #debug:using:"

		| newSession newDebugger |

		session terminate.
		self detachSession.
		self browser close.
		"session updateContextTo: aContext."
		newSession := GTBDebugger sessionClass on: session gdb.
		newDebugger := GTBNativeDebugger on: newSession.
		^ self openAndInitialize: newDebugger
	] ifFalse: [
		browserPane := self browser pane.
		(browserPane port: #entity) silentValue: nil.
		(browserPane port: #entity) value: session.
	]
]
