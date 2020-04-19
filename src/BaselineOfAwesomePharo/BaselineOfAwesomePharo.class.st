Class {
	#name : #BaselineOfAwesomePharo,
	#superclass : #Object,
	#category : #BaselineOfAwesomePharo
}

{ #category : #baselines }
BaselineOfAwesomePharo >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec package: 'AwesomePharo'.
			spec group: 'default' with: #( 'AwesomePharo' ) ]
]
