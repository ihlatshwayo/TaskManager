Class {
	#name : #TMTask,
	#superclass : #Object,
	#instVars : [
		'id',
		'title',
		'description',
		'status',
		'priority',
		'dueDate',
		'createdAt',
		'tags',
		'assignee'
	],
	#category : #'TaskManager-Core'
}

{ #category : #'instance creation' }
TMTask class >> new [
	^ super new initialize
]

{ #category : #'instance creation' }
TMTask class >> withTitle: aTitle [
	^ self new
		title: aTitle;
		yourself
]

{ #category : #'instance creation' }
TMTask class >> withTitle: aTitle description: aDescription [
	^ self new
		title: aTitle;
		description: aDescription;
		yourself
]

{ #category : #initialization }
TMTask >> initialize [
	id := UUID new asString.
	status := #todo.
	priority := #medium.
	createdAt := DateAndTime now.
	tags := OrderedCollection new.
	description := ''.
	assignee := ''
]

{ #category : #accessing }
TMTask >> id [
	^ id
]

{ #category : #accessing }
TMTask >> title [
	^ title
]

{ #category : #accessing }
TMTask >> title: aString [
	title := aString
]

{ #category : #accessing }
TMTask >> description [
	^ description
]

{ #category : #accessing }
TMTask >> description: aString [
	description := aString
]

{ #category : #accessing }
TMTask >> status [
	^ status
]

{ #category : #accessing }
TMTask >> status: aSymbol [
	"Valid statuses: #todo, #inProgress, #done, #cancelled"
	self assert: (#(#todo #inProgress #done #cancelled) includes: aSymbol)
		description: 'Invalid status: ', aSymbol.
	status := aSymbol
]

{ #category : #accessing }
TMTask >> priority [
	^ priority
]

{ #category : #accessing }
TMTask >> priority: aSymbol [
	"Valid priorities: #low, #medium, #high, #critical"
	self assert: (#(#low #medium #high #critical) includes: aSymbol)
		description: 'Invalid priority: ', aSymbol.
	priority := aSymbol
]

{ #category : #accessing }
TMTask >> dueDate [
	^ dueDate
]

{ #category : #accessing }
TMTask >> dueDate: aDateAndTime [
	dueDate := aDateAndTime
]

{ #category : #accessing }
TMTask >> createdAt [
	^ createdAt
]

{ #category : #accessing }
TMTask >> tags [
	^ tags
]

{ #category : #accessing }
TMTask >> assignee [
	^ assignee
]

{ #category : #accessing }
TMTask >> assignee: aString [
	assignee := aString
]

{ #category : #'tags management' }
TMTask >> addTag: aTag [
	(tags includes: aTag) ifFalse: [ tags add: aTag ]
]

{ #category : #'tags management' }
TMTask >> removeTag: aTag [
	tags remove: aTag ifAbsent: []
]

{ #category : #'tags management' }
TMTask >> hasTag: aTag [
	^ tags includes: aTag
]

{ #category : #'status transitions' }
TMTask >> markInProgress [
	self status: #inProgress
]

{ #category : #'status transitions' }
TMTask >> markDone [
	self status: #done
]

{ #category : #'status transitions' }
TMTask >> markCancelled [
	self status: #cancelled
]

{ #category : #'status transitions' }
TMTask >> reopen [
	self status: #todo
]

{ #category : #testing }
TMTask >> isDone [
	^ status = #done
]

{ #category : #testing }
TMTask >> isOverdue [
	dueDate isNil ifTrue: [ ^ false ].
	^ dueDate < DateAndTime now and: [ self isDone not ]
]

{ #category : #testing }
TMTask >> isPending [
	^ status = #todo or: [ status = #inProgress ]
]

{ #category : #'priority helpers' }
TMTask >> priorityValue [
	^ #(#low #medium #high #critical) indexOf: priority
]

{ #category : #printing }
TMTask >> printOn: aStream [
	aStream
		nextPutAll: 'TMTask(';
		nextPutAll: title printString;
		nextPutAll: ' [';
		nextPutAll: status;
		nextPutAll: '] p:';
		nextPutAll: priority;
		nextPut: $)
]

{ #category : #comparing }
TMTask >> = other [
	^ other isKindOf: TMTask and: [ id = other id ]
]

{ #category : #comparing }
TMTask >> hash [
	^ id hash
]
