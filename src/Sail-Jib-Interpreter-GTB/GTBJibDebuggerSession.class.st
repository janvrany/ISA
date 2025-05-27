Class {
	#name : #GTBJibDebuggerSession,
	#superclass : #JibDebuggerSession,
	#instVars : [
		'gdb',
		'isa'
	],
	#category : #'Sail-Jib-Interpreter-GTB'
}

{ #category : #'instance creation' }
GTBJibDebuggerSession class >> for: aJibInterpreter [
	^self shouldNotImplement. "Use forDebugger: instead"
]

{ #category : #'instance creation' }
GTBJibDebuggerSession class >> forDebugger: aGDBDebugger [
	^self basicNew initializeWithDebugger: aGDBDebugger
]

{ #category : #'debugging actions' }
GTBJibDebuggerSession >> clear [
	self shouldBeImplemented
]

{ #category : #private }
GTBJibDebuggerSession >> copyRegistersFromDebuggerToInterpreter [
	| frame |

	frame := gdb selectedThread stack first.

	self copyRegistersSpec tripletsDo:[:gdbName :jibName :regbankIndex |
		| value |

		value := frame getRegister: gdbName.

		value := value toBitVector: 64.

		regbankIndex notNil ifTrue:[
			interpreter setRegister: regbankIndex bank: jibName zencode to: value.
		] ifFalse:[
			interpreter setRegister: jibName zencode to: value.
		]
	]

]

{ #category : #private }
GTBJibDebuggerSession >> copyRegistersFromInterpreterToDebugger [
	| frame pc |

	frame := gdb selectedThread stack first.

	self copyRegistersSpec tripletsDo:[:gdbName :jibName :regbankIndex |
		| value |

		regbankIndex notNil ifTrue:[
			value := interpreter getRegister: regbankIndex bank: jibName zencode.
		] ifFalse:[
			value := interpreter getRegister: jibName zencode
		].

		value := value unsignedValue.

		frame setRegister: gdbName to: value.
	].

	"We have changed PC so force-set the frame PC tp
	 the new values. Saves us a round-trip to GDB (and
	 potential deadlock :-("
	pc := interpreter getRegister: 'zPC'.
	pc := pc unsignedValue.
	frame setAddr: pc.

]

{ #category : #private }
GTBJibDebuggerSession >> copyRegistersSpec [
	"   GDB name   Jib name  Reg bank index (if any) "
	^#(
	   'ra'       'Xs'       1
	   'sp'       'Xs'       2
	   'gp'       'Xs'       3
	   'tp'       'Xs'       4
	   't0'       'Xs'       5
	   't1'       'Xs'       6
	   't2'       'Xs'       7
	   'fp'       'Xs'       8
	   's1'       'Xs'       9
	   'a0'       'Xs'       10
	   'a1'       'Xs'       11
	   'a2'       'Xs'       12
	   'a3'       'Xs'       13
	   'a4'       'Xs'       14
	   'a5'       'Xs'       15

		'pc'       'PC'       nil
	)
]

{ #category : #accessing }
GTBJibDebuggerSession >> gdb [
	^gdb
]

{ #category : #initialization }
GTBJibDebuggerSession >> initializeWithDebugger: aGDBDebugger [
	| frame insn main  |

	gdb := aGDBDebugger.

	"TODO: BOGUS, needs to be properly factored, no hardcoding values!"
	isa := JibParser parse:   (JibExamples / 'Jib' / 'riscv_quattropod.ir') asFileReference contents.
	isa sourceSearchPath add: (JibExamples / 'Sail') pathName.

	frame := gdb selectedThread stack first.
	insn := frame disassemble detect:[:each | each address = frame pc].

	"TODO: BOGUS, needs to be properly factored, do not assume 32bit little-endian!"
	self assert: insn opcodes size == 4.
	insn := (insn opcodes unsignedLongAt: 1 bigEndian: false) toBitVector: 32.

	main := isa lookupFunction: 'decode_and_execute' zencode.

	interpreter := JibInterpreter for: main arguments: { insn }.

	self copyRegistersFromDebuggerToInterpreter.


]

{ #category : #initialization }
GTBJibDebuggerSession >> initializeWithInterpreter: aJibInterpreter [
	self shouldNotImplement
]

{ #category : #'debugging actions' }
GTBJibDebuggerSession >> terminate [
	self copyRegistersFromInterpreterToDebugger
]
