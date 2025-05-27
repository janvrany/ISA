Extension { #name : #BitVector }

{ #category : #'*Sail-Jib-Demos' }
BitVector >> signExtendTo: nbits [
	"Sign-extend receiver to exactly nbits"

	^self signExtend: nbits - self length

]

{ #category : #'*Sail-Jib-Demos' }
BitVector >> zeroExtendTo: nbits [
	"Zero-extend receiver to exactly nbits"

	^self zeroExtend: nbits - self length

]
