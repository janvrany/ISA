Class {
	#name : #'SourceLoc_Known',
	#superclass : #JibSourceLoc,
	#instVars : [
		'file',
		'line1',
		'char1',
		'line2',
		'char2'
	],
	#category : #'Sail-Jib'
}

{ #category : #syntax }
SourceLoc_Known class >> inducedParser [
	| nat |

	nat := #digit asParser plus flatten trim ==> #asInteger.

	^ $` asParser trim
	, nat
	, nat , $: asParser , nat
	, $- asParser
	, nat , $: asParser , nat
	construct: #(- file line1 - char1 - line2 - char2)

]

{ #category : #comparing }
SourceLoc_Known >> = another [
	^ self class = another class
		and:[line1 = another line1
		and:[char1 = another char1
		and:[line2 = another line2
		and:[char2 = another char2]]]]
]

{ #category : #accessing }
SourceLoc_Known >> char1 [
	^ char1
]

{ #category : #accessing }
SourceLoc_Known >> char1: anObject [
	char1 := anObject
]

{ #category : #accessing }
SourceLoc_Known >> char2 [
	^ char2
]

{ #category : #accessing }
SourceLoc_Known >> char2: anObject [
	char2 := anObject
]

{ #category : #accessing }
SourceLoc_Known >> file [
	^ self program lookupFile: file
]

{ #category : #accessing }
SourceLoc_Known >> fileIndex [
	^ file
]

{ #category : #accessing }
SourceLoc_Known >> fileIndex: anObject [
	file := anObject
]

{ #category : #inspecting }
SourceLoc_Known >> gtInspectorSourceIn: composite [
	<gtInspectorPresentationOrder: 20>
	composite text
			title: 'Source';
			display: [
				| source |

				source := self sourceTextWithHighlights.
				source isNil ifTrue:[
					source := 'Source not available'.
				].
				source.
			];
			initialize: [ :text |
				self source notNil ifTrue:[
					text selectionInterval: self sourceInterval
				]
			];
			withLineNumbers: true;
			wrapped: false;
			format: #asText
]

{ #category : #comparing }
SourceLoc_Known >> hash [
	^ (((((self class hash
		+ file hash) hashMultiply
		+ 	line1 hash) hashMultiply
		+ 	char1 hash) hashMultiply
		+ 	line2 hash) hashMultiply
		+ 	char2 hash) hashMultiply
]

{ #category : #testing }
SourceLoc_Known >> isKnown [
	^ true

]

{ #category : #accessing }
SourceLoc_Known >> line1 [
	^ line1
]

{ #category : #accessing }
SourceLoc_Known >> line1: anObject [
	line1 := anObject
]

{ #category : #accessing }
SourceLoc_Known >> line2 [
	^ line2
]

{ #category : #accessing }
SourceLoc_Known >> line2: anObject [
	line2 := anObject
]

{ #category : #accessing }
SourceLoc_Known >> source [
	"Return the (Sail) source as String or nil if source file is not available."

	| f |

	f := self file.
	f exists ifTrue:[
		^f contents.
	].
	^ nil
]

{ #category : #accessing }
SourceLoc_Known >> sourceInterval [
	"Return interval in source string represening this location.
	 If source string cannot be retrieved or source is truncated,
	 return interval (1 to: 0)."

	| source start end line |

	source := self source.
	source notNil ifTrue: [
		line := 1.
		source string lineIndicesDo: [:lineStart :lineEnd :lineEndIncludingNl |
			line == line1 ifTrue:[
				start := lineStart + char1.
			].
			line == line2 ifTrue:[
				end := lineStart + char2 - 1.
				^ start to: end
			].
			line := line + 1.
		].
	].
	^ 1 to: 0

]

{ #category : #accessing }
SourceLoc_Known >> sourceText [
	| source |

	source := self source.
	source notNil ifTrue:[
		^source asText.
	].
	^ nil
]

{ #category : #accessing }
SourceLoc_Known >> sourceTextWithHighlights [
	| source interval |

	source := self source.
	source notNil ifTrue:[
		source := source asText.
		interval := self sourceInterval.
		source addAttribute: TextBackgroundColor yellow from: interval first to: interval last.
		source addAttribute: TextColor black from: interval first to: interval last.
		^ source.
	].
	^ source.
]

{ #category : #printing }
SourceLoc_Known >> unparseOn: aStream [	
	aStream space; space.
	aStream nextPut:$`.
	file printOn: aStream.
	aStream space.
	line1 printOn: aStream. aStream nextPut: $:. char1 printOn: aStream.
	aStream nextPut:$-.	
	line2 printOn: aStream. aStream nextPut: $:. char2 printOn: aStream


]
