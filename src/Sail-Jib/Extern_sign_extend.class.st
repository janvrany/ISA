Class {
	#name : #'Extern_sign_extend',
	#superclass : #JibExtern,
	#category : #'Sail-Jib'
}

{ #category : #accessing }
Extern_sign_extend class >> id [
	^ 'sign_extend'" : %bv , %i -> %bv "
]

{ #category : #accessing }
Extern_sign_extend class >> signature [
	"Return this primt's signature (as fabricated instance of `Def_Val`).
	 This is needed for type unification."

	^ Def_Val
			constructNewFrom: { self id . { Ty_AnyBits new . Ty_I64 new } . Ty_AnyBits new }
			accordingTo: #(id tys ty)



]

{ #category : #evaluating }
Extern_sign_extend >> evaluateWithArguments: args [
	^ args first signExtend: args second value - args first length
]
