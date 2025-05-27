Extension { #name : #GDBThread }

{ #category : #'*Sail-Jib-Interpreter-GTB' }
GDBThread >> onThreadSelectedEvent: aGDBThreadSelectedEvent [
	|  frame |

	frame := aGDBThreadSelectedEvent frame.
	frame notNil ifTrue:[ frame setDebugger: debugger; setThread: self ].
	aGDBThreadSelectedEvent setThread: self.

	"
	The below is prone to deadlock on Pharo so for now...
	"
	Smalltalk isPharo ifTrue:[ ^ self ].


	"  Be carefull, thread may be running!"
	(self isStopped and:[frame notNil]) ifTrue:[
		"  Beware, `self stack` may execute another command"
		"  and this is called from within event dispatch loop."
		"  "
		"  This was not possible before, but now it should"
		"  (see commit bf5cfa214dd4)"
		aGDBThreadSelectedEvent setFrame: (self stack at: (frame level + 1))
	]

	"Created: / 29-07-2018 / 22:21:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
	"Modified: / 20-11-2019 / 22:09:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
	"Modified: / 25-01-2022 / 15:23:24 / Jan Vrany <jan.vrany@labware.com>"

]
