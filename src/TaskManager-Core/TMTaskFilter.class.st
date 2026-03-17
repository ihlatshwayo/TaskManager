Class {
	#name : #TMTaskFilter,
	#superclass : #Object,
	#instVars : [
		'statusFilter',
		'priorityFilter',
		'tagFilter',
		'assigneeFilter',
		'searchText',
		'showOverdueOnly'
	],
	#category : #'TaskManager-Core'
}

{ #category : #'instance creation' }
TMTaskFilter class >> new [
	^ super new initialize
]

{ #category : #initialization }
TMTaskFilter >> initialize [
	statusFilter := nil.
	priorityFilter := nil.
	tagFilter := nil.
	assigneeFilter := nil.
	searchText := ''.
	showOverdueOnly := false
]

{ #category : #accessing }
TMTaskFilter >> statusFilter: aSymbolOrNil [
	statusFilter := aSymbolOrNil
]

{ #category : #accessing }
TMTaskFilter >> priorityFilter: aSymbolOrNil [
	priorityFilter := aSymbolOrNil
]

{ #category : #accessing }
TMTaskFilter >> tagFilter: aStringOrNil [
	tagFilter := aStringOrNil
]

{ #category : #accessing }
TMTaskFilter >> assigneeFilter: aStringOrNil [
	assigneeFilter := aStringOrNil
]

{ #category : #accessing }
TMTaskFilter >> searchText: aString [
	searchText := aString
]

{ #category : #accessing }
TMTaskFilter >> showOverdueOnly: aBoolean [
	showOverdueOnly := aBoolean
]

{ #category : #filtering }
TMTaskFilter >> applyTo: aCollection [
	| result |
	result := aCollection.
	statusFilter notNil ifTrue: [
		result := result select: [ :t | t status = statusFilter ] ].
	priorityFilter notNil ifTrue: [
		result := result select: [ :t | t priority = priorityFilter ] ].
	tagFilter notNil ifTrue: [
		result := result select: [ :t | t hasTag: tagFilter ] ].
	assigneeFilter notNil ifTrue: [
		result := result select: [ :t | t assignee = assigneeFilter ] ].
	(searchText notNil and: [ searchText notEmpty ]) ifTrue: [
		| lower |
		lower := searchText asLowercase.
		result := result select: [ :t | t title asLowercase includesSubstring: lower ] ].
	showOverdueOnly ifTrue: [
		result := result select: [ :t | t isOverdue ] ].
	^ result
]

{ #category : #testing }
TMTaskFilter >> isActive [
	^ statusFilter notNil
		or: [ priorityFilter notNil
		or: [ tagFilter notNil
		or: [ assigneeFilter notNil
		or: [ searchText notEmpty
		or: [ showOverdueOnly ] ] ] ] ]
]

{ #category : #resetting }
TMTaskFilter >> reset [
	self initialize
]
