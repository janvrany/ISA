Class {
	#name : #MoreVMs25,
	#superclass : #TestCaseWithZ3Context,
	#instVars : [
		'jib',
		'compilation',
		'decode_and_execute',
		'debugging'
	],
	#pools : [
		'TRDataTypes'
	],
	#category : #'Sail-Jib-Demos'
}

{ #category : #accessing }
MoreVMs25 class >> compiler [
	Smalltalk isPharo ifTrue:[
		^super compiler options: #(+ optionSkipSemanticWarnings)
	].
	^super compiler
]

{ #category : #running }
MoreVMs25 class >> new [
	^self basicNew initialize
]

{ #category : #accessing }
MoreVMs25 class >> testSelectors [
	^ self selectors select: [ :each | each beginsWith:'example' ]
]

{ #category : #running }
MoreVMs25 >> debug [
	^[
		debugging := true.
		super debug.
	] ensure:[
		debugging := false.
	]
]

{ #category : #examples }
MoreVMs25 >> example_01_addi [
	| insn interpreter |

	insn := 16r00278713 toBitVector: 32. "addi x14, x15, 2"

	interpreter := JibInterpreter for: decode_and_execute arguments: { insn }.

	interpreter setRegister: 14 bank: 'zXs' to: (16rCAFE00000000AFFE toBitVector: 64).
	interpreter setRegister: 15 bank: 'zXs' to: (                 40 toBitVector: 64).

	interpreter interpret.

	self assert: (interpreter getRegister: 14 bank: 'zXs')
	     equals: (42 toBitVector: 64).
]

{ #category : #examples }
MoreVMs25 >> example_02_addi_d [
	| insn interpreter |

	insn := 16r00278713 toBitVector: 32. "addi x14, x15, 2"

	interpreter := JibInterpreter for: decode_and_execute arguments: { insn }.

	interpreter setRegister: 14 bank: 'zXs' to: (16rCAFE00000000AFFE toBitVector: 64).
	interpreter setRegister: 15 bank: 'zXs' to: (                 40 toBitVector: 64).

	"
	JibInstructionDebugger openOn: (JibDebuggerSession for: interpreter)
	"
	debugging ifTrue:[self halt].

	interpreter interpret.

	self assert: (interpreter getRegister: 14 bank: 'zXs')
	     equals: (42 toBitVector: 64).
]

{ #category : #examples }
MoreVMs25 >> example_03_addi_symbolic_d [
	| imm x15 x14 insn interpreter |

	imm := 'imm' toBitVector: 12.
	x15 := 'x15' toBitVector: 64.

	insn := imm , (16r78713 toBitVector: 32-12). "addi x14, x15, <imm>"

	interpreter := JibInterpreter for: decode_and_execute arguments: { insn }.

	interpreter setRegister: 14 bank: 'zXs' to: (16rCAFE00000000AFFE toBitVector: 64).
	interpreter setRegister: 15 bank: 'zXs' to: x15.
	"
	JibInstructionDebugger openOn: (JibDebuggerSession for: interpreter)
	"
	debugging ifTrue:[self halt].

	interpreter interpret.

	x14 := interpreter getRegister: 14 bank: 'zXs'.

	self assert:  x14
	     equals: (x15 + (imm signExtendTo: 64)).
]

{ #category : #initialization }
MoreVMs25 >> initialize [
	debugging := false.
]

{ #category : #running }
MoreVMs25 >> setUp [
	super setUp.

	compilation := TRCompilation forConfig: TRCompilationConfig forRV64GLinux.

	jib := JibParser parse: (JibExamples / 'Jib' / 'riscv_quattropod.ir') asFileReference contents.
	jib sourceSearchPath add: (JibExamples / 'Sail') pathName.

	decode_and_execute := jib lookupFunction: 'decode_and_execute' zencode.
]
