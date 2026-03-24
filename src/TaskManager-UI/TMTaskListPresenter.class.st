Class {
	#name : 'TMTaskListPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'taskTable',
		'onTaskSelectedBlock',
		'onTaskDoubleClickedBlock',
		'tasks'
	],
	#category : 'TaskManager-UI',
	#package : 'TaskManager-UI'
}

{ #category : 'layout' }
TMTaskListPresenter class >> defaultLayout [
    ^ SpBoxLayout newTopToBottom
        add: '#taskTable';
        yourself
]

{ #category : 'initialization' }
TMTaskListPresenter >> initializePresenters [
	taskTable := self newTable.
	tasks := OrderedCollection new.
	
	taskTable
		addColumn: (SpStringTableColumn
			title: 'Priority'
			evaluated: [ :t | self priorityIcon: t priority ]);
		addColumn: (SpStringTableColumn
			title: 'Title'
			evaluated: [ :t | t title ]);
		addColumn: (SpStringTableColumn
			title: 'Status'
			evaluated: [ :t | self statusLabel: t status ]);
		addColumn: (SpStringTableColumn
			title: 'Assignee'
			evaluated: [ :t | t assignee ifEmpty: [ '-' ] ]);
		addColumn: (SpStringTableColumn
			title: 'Due Date'
			evaluated: [ :t |
				t dueDate
					ifNil: [ '-' ]
					ifNotNil: [ :d | d printString copyFrom: 1 to: 10 ] ]);
		addColumn: (SpStringTableColumn
			title: 'Tags'
			evaluated: [ :t | t tags joinWith: ', ' ]).
	
	taskTable whenSelectionChangedDo: [ :sel |
		onTaskSelectedBlock ifNotNil: [
			sel isEmpty
				ifFalse: [ onTaskSelectedBlock value: sel selectedItem ]
				ifTrue: [ onTaskSelectedBlock value: nil ] ] ].
	
	taskTable whenActivatedDo: [ :sel |
		onTaskDoubleClickedBlock ifNotNil: [
			sel isEmpty ifFalse: [
				onTaskDoubleClickedBlock value: sel selectedItem ] ] ]
]

{ #category : 'callbacks' }
TMTaskListPresenter >> onTaskDoubleClicked: aBlock [
	onTaskDoubleClickedBlock := aBlock
]

{ #category : 'callbacks' }
TMTaskListPresenter >> onTaskSelected: aBlock [
	onTaskSelectedBlock := aBlock
]

{ #category : 'helpers' }
TMTaskListPresenter >> priorityIcon: aPriority [
	^ Dictionary new
		at: #low put: '↓ Low';
		at: #medium put: '→ Med';
		at: #high put: '↑ High';
		at: #critical put: '!! Crit';
		at: aPriority ifAbsent: [ aPriority ]
]

{ #category : 'helpers' }
TMTaskListPresenter >> statusLabel: aStatus [
	^ Dictionary new
		at: #todo put: '○ Todo';
		at: #inProgress put: '◐ In Progress';
		at: #done put: '● Done';
		at: #cancelled put: '✕ Cancelled';
		at: aStatus ifAbsent: [ aStatus ]
]

{ #category : 'accessing' }
TMTaskListPresenter >> tasks: aCollection [
	tasks := aCollection asOrderedCollection.
	taskTable items: tasks
]
