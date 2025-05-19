Class {
	#name : #JibProgramNaiveAnalyzer,
	#superclass : #Object,
	#category : #'Sail-Jib-Environment'
}

{ #category : #analysis }
JibProgramNaiveAnalyzer >> analyze: program [
	program analyzeUsing: self.
]

{ #category : #analysis }
JibProgramNaiveAnalyzer >> analyzeChildrenOf: node [
	node childrenDo:[:child | child analyzeUsing: self ].
]

{ #category : #'analysis - defs' }
JibProgramNaiveAnalyzer >> analyzeEnum: enum [
	| enumSort |
	
	enumSort := Z3DatatypeSort mkEnumerationSort: enum id 
	                                    elements: enum ids
	                                      consts: Cell new
	                                     testers: Cell new.
	
	enum program environment 
		registerSort: enumSort forTypename: enum id.

]

{ #category : #'analysis - defs' }
JibProgramNaiveAnalyzer >> analyzeFn: fn [
	fn setEnvironment: (JibEnvironment of: fn)
]

{ #category : #'analysis - defs' }
JibProgramNaiveAnalyzer >> analyzeLet: let [
	let setEnvironment: (JibEnvironment of: let)
]

{ #category : #'analysis - defs' }
JibProgramNaiveAnalyzer >> analyzeProgram: program [
	program setEnvironment: (JibProgramEnvironment of: program).
	Z3ContextQuery answer: program environment context do:[
		self analyzeChildrenOf: program.
	] 
	
]

{ #category : #'analysis - defs' }
JibProgramNaiveAnalyzer >> analyzeRegister: register [
	register setEnvironment: (JibEnvironment of: register)
]

{ #category : #'analysis - defs' }
JibProgramNaiveAnalyzer >> analyzeStruct: struct [
	| fields ctor sort |

	fields := struct fields collect: [ :nameAndType | nameAndType key -> (nameAndType value sort)].

	ctor := Z3Constructor name: struct id
	                recognizer: 'is-' , struct id
	                    fields: fields
	               referencing:((1 to: fields size) collect: [ :_ | 0 ]).
	sort := Z3DatatypeSort name: struct id constructors: { ctor }.

	struct program environment
		registerSort: sort forTypename: struct id.

]

{ #category : #'analysis - defs' }
JibProgramNaiveAnalyzer >> analyzeUnion: union [
	| unionCtors unionSort |

	unionCtors := union members collect:[:nameAndType|
		| name type ctor |

		name := nameAndType key.
		type := nameAndType value.

		ctor := Z3Constructor name: name
		                recognizer: 'is-' , name
		                    fields: { 'v' -> type sort }
		               referencing: { 0 }.

		ctor.
	].

	unionSort := Z3DatatypeSort name: union id constructors: unionCtors.

	union program environment
		registerSort: unionSort forTypename: union id.

]
