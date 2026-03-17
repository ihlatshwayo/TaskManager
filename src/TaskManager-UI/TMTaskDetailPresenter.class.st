Class {
	#name : #TMTaskDetailPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'titleLabel',
		'statusLabel',
		'priorityLabel',
		'descriptionText',
		'dueDateLabel',
		'assigneeLabel',
		'tagsLabel',
		'createdAtLabel',
		'task'
	],
	#category : #'TaskManager-UI'
}

{ #category : #layout }
TMTaskDetailPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		spacing: 8;
		add: (SpBoxLayout newVertical
			add: 'Task Details' asPresenter expand: false;
			yourself) expand: false;
		add: #titleLabel expand: false;
		add: #statusLabel expand: false;
		add: #priorityLabel expand: false;
		add: #assigneeLabel expand: false;
		add: #dueDateLabel expand: false;
		add: #tagsLabel expand: false;
		add: #createdAtLabel expand: false;
		add: 'Description:' asPresenter expand: false;
		add: #descriptionText;
		yourself
]

{ #category : #initialization }
TMTaskDetailPresenter >> initializePresenters [
	titleLabel := self newLabel label: '(No task selected)'.
	statusLabel := self newLabel label: ''.
	priorityLabel := self newLabel label: ''.
	assigneeLabel := self newLabel label: ''.
	dueDateLabel := self newLabel label: ''.
	tagsLabel := self newLabel label: ''.
	createdAtLabel := self newLabel label: ''.
	descriptionText := self newText.
	descriptionText editable: false
]

{ #category : #actions }
TMTaskDetailPresenter >> showTask: aTask [
	task := aTask.
	aTask isNil
		ifTrue: [ self clearDetail ]
		ifFalse: [ self populateDetail: aTask ]
]

{ #category : #private }
TMTaskDetailPresenter >> clearDetail [
	titleLabel label: '(No task selected)'.
	statusLabel label: ''.
	priorityLabel label: ''.
	assigneeLabel label: ''.
	dueDateLabel label: ''.
	tagsLabel label: ''.
	createdAtLabel label: ''.
	descriptionText text: ''
]

{ #category : #private }
TMTaskDetailPresenter >> populateDetail: aTask [
	titleLabel label: aTask title.
	statusLabel label: 'Status: ', aTask status.
	priorityLabel label: 'Priority: ', aTask priority.
	assigneeLabel label: 'Assignee: ', (aTask assignee ifEmpty: [ 'Unassigned' ]).
	dueDateLabel label: 'Due: ', (aTask dueDate
		ifNil: [ 'No due date' ]
		ifNotNil: [ :d | d printString copyFrom: 1 to: 10 ]).
	tagsLabel label: 'Tags: ', (aTask tags isEmpty
		ifTrue: [ 'None' ]
		ifFalse: [ aTask tags joinWith: ', ' ]).
	createdAtLabel label: 'Created: ', (aTask createdAt printString copyFrom: 1 to: 16).
	descriptionText text: aTask description
]
