Class {
	#name : 'TMTaskEditPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'titleInput',
		'descriptionInput',
		'statusDropdown',
		'priorityDropdown',
		'assigneeInput',
		'tagsInput',
		'saveButton',
		'cancelButton',
		'task',
		'manager'
	],
	#category : 'TaskManager-UI',
	#package : 'TaskManager-UI'
}

{ #category : 'layout' }
TMTaskEditPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		spacing: 8;
		add: (SpBoxLayout newHorizontal
			add: 'Title:' asPresenter expand: false width: 80;
			add: #titleInput;
			yourself) expand: false;
		add: (SpBoxLayout newHorizontal
			add: 'Status:' asPresenter expand: false width: 80;
			add: #statusDropdown;
			yourself) expand: false;
		add: (SpBoxLayout newHorizontal
			add: 'Priority:' asPresenter expand: false width: 80;
			add: #priorityDropdown;
			yourself) expand: false;
		add: (SpBoxLayout newHorizontal
			add: 'Assignee:' asPresenter expand: false width: 80;
			add: #assigneeInput;
			yourself) expand: false;
		add: (SpBoxLayout newHorizontal
			add: 'Tags:' asPresenter expand: false width: 80;
			add: #tagsInput;
			yourself) expand: false;
		add: 'Description:' asPresenter expand: false;
		add: #descriptionInput;
		add: (SpBoxLayout newHorizontal
			addLast: #saveButton expand: false;
			addLast: #cancelButton expand: false;
			yourself) expand: false;
		yourself
]

{ #category : 'actions' }
TMTaskEditPresenter >> closeDialog [
	self window ifNotNil: [ :w | w close ]
]

{ #category : 'window configuration' }
TMTaskEditPresenter >> initialExtent [
	^ 480 @ 380
]

{ #category : 'initialization' }
TMTaskEditPresenter >> initializePresenters [
	titleInput := self newTextInput.
	descriptionInput := self newText.
	
	statusDropdown := self newDropList.
	statusDropdown items: #(#todo #inProgress #done #cancelled).
	statusDropdown display: [ :s | s ].
	
	priorityDropdown := self newDropList.
	priorityDropdown items: #(#low #medium #high #critical).
	priorityDropdown display: [ :p | p ].
	
	assigneeInput := self newTextInput.
	tagsInput := self newTextInput.
	tagsInput placeholder: 'tag1, tag2, tag3'.
	
	saveButton := self newButton.
	saveButton label: 'Save'.
	saveButton action: [ self saveTask ].
	
	cancelButton := self newButton.
	cancelButton label: 'Cancel'.
	cancelButton action: [ self closeDialog ]
]

{ #category : 'accessing' }
TMTaskEditPresenter >> manager: aManager [
	manager := aManager
]

{ #category : 'private' }
TMTaskEditPresenter >> populateFrom: aTask [
	titleInput text: aTask title.
	descriptionInput text: aTask description.
	statusDropdown selectItem: aTask status.
	priorityDropdown selectItem: aTask priority.
	assigneeInput text: aTask assignee.
	tagsInput text: (aTask tags joinWith: ', ')
]

{ #category : 'actions' }
TMTaskEditPresenter >> saveTask [
	| title |
	title := titleInput text trimSeparators.
	title isEmpty ifTrue: [
		self inform: 'Title cannot be empty.'.
		^ self ].
	
	task isNil
		ifTrue: [ task := manager createTaskWithTitle: title ]
		ifFalse: [ task title: title ].
	
	task
		description: descriptionInput text;
		status: statusDropdown selectedItem;
		priority: priorityDropdown selectedItem;
		assignee: assigneeInput text trimSeparators.
	
	"Parse tags"
	task tags removeAllSuchThat: [ :t | true ].
	(tagsInput text substrings: ',') do: [ :tag |
		| trimmed |
		trimmed := tag trimSeparators.
		trimmed isEmpty ifFalse: [ task addTag: trimmed ] ].
	
	manager updateTask: task.
	self closeDialog
]

{ #category : 'accessing' }
TMTaskEditPresenter >> task: aTask [
	task := aTask.
	self populateFrom: aTask
]

{ #category : 'title' }
TMTaskEditPresenter >> title [
	^ task isNil ifTrue: [ 'New Task' ] ifFalse: [ 'Edit Task' ]
]
