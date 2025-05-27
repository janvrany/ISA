Class {
	#name : #GTBActionStepInJib,
	#superclass : #GTBDebuggerAction,
	#category : #'Sail-Jib-Interpreter-GTB'
}

{ #category : #accessing }
GTBActionStepInJib class >> actionFor: aGTBDebugger [
	<gtInstructionDebuggingAction>
	<gtContextInstructionDebuggingAction>

	^self forDebugger: aGTBDebugger
]

{ #category : #accessing }
GTBActionStepInJib >> defaultIcon [

	^ GLMUIThemeExtraIcons glamorousInto
]

{ #category : #accessing }
GTBActionStepInJib >> defaultLabel [

	^ 'Into Jib'
]

{ #category : #actions }
GTBActionStepInJib >> defaultOrder [

	^ 40
]

{ #category : #actions }
GTBActionStepInJib >> executeAction [
	| ctx |

	ctx := Z3Context fromDefault.
	Z3ContextQuery answer: ctx do: [
		self debugger debug: self interruptedContext using: JibSourceDebugger
	].

]
