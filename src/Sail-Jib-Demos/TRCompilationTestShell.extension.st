Extension { #name : #TRCompilationTestShell }

{ #category : #'*Sail-Jib-Demos' }
TRCompilationTestShell >> debug: symbol with: arguments types: argumentTypes [
	| linkage |

	linkage := symbol linkageClass basicNew.

	self assert: arguments size == argumentTypes size description: 'Number of formal paramerers does not match actual'.
	1 to: arguments size do: [:i |
		| typ arg |

		typ := argumentTypes at: i.
		arg := arguments at: i.

		typ validateConstant: arg.

		typ isIntegerType ifTrue: [
			| argReg |

			argReg := (linkage parameterRegisters: GPR) at: i.
			debugger setRegister: argReg nameInGDB to: arg.
		] ifFalse: [
			self error: 'Parameter type not supported yet: ' , typ name
		].
	].
	self debugger setRegister: 'pc' to: (nzone1 exports at: symbol).

	"Call injected function"
	GTBSourceDebugger openFor: debugger.
	
	self halt.
	debugger c.

	"Retrieve return value"
	symbol type isIntegerType ifTrue: [
		| retReg |

		retReg := (linkage returnRegisters: GPR) at: 1.
		^ debugger getRegister: retReg nameInGDB
	] ifFalse: [
		self error: 'Return type not supported yet: ' , symbol type name
	].
]
