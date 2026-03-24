Class {
	#name : 'TMFilterBarPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'searchInput',
		'statusFilter',
		'priorityFilter',
		'clearButton',
		'onFilterChangedBlock'
	],
	#category : 'TaskManager-UI',
	#package : 'TaskManager-UI'
}

{ #category : 'layout' }
TMFilterBarPresenter class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		spacing: 6;
		add: 'Search:' asPresenter expand: false;
		add: #searchInput;
		add: 'Status:' asPresenter expand: false;
		add: #statusFilter width: 120;
		add: 'Priority:' asPresenter expand: false;
		add: #priorityFilter width: 100;
		add: #clearButton expand: false;
		yourself
]

{ #category : 'actions' }
TMFilterBarPresenter >> clearFilters [
	searchInput text: ''.
	statusFilter selectIndex: 1.
	priorityFilter selectIndex: 1.
	self notifyFilterChanged
]

{ #category : 'layout' }
TMFilterBarPresenter >> defaultLayout [
    ^ SpBoxLayout newTopToBottom
        add: #taskList;
        yourself
]

{ #category : 'initialization' }
TMFilterBarPresenter >> initializePresenters [
	searchInput := self newTextInput.
	searchInput placeholder: 'Search tasks...'.
	searchInput whenTextChangedDo: [ self notifyFilterChanged ].
	
	statusFilter := self newDropList.
	statusFilter items: #('All' 'todo' 'inProgress' 'done' 'cancelled').
	statusFilter whenSelectedItemChangedDo: [ self notifyFilterChanged ].
	
	priorityFilter := self newDropList.
	priorityFilter items: #('All' 'low' 'medium' 'high' 'critical').
	priorityFilter whenSelectedItemChangedDo: [ self notifyFilterChanged ].
	
	clearButton := self newButton.
	clearButton label: 'Clear'.
	clearButton action: [ self clearFilters ]
]

{ #category : 'private' }
TMFilterBarPresenter >> notifyFilterChanged [
	| f |
	f := TMTaskFilter new.
	f searchText: searchInput text.
	statusFilter selectedItem = 'All' ifFalse: [
		f statusFilter: statusFilter selectedItem asSymbol ].
	priorityFilter selectedItem = 'All' ifFalse: [
		f priorityFilter: priorityFilter selectedItem asSymbol ].
	onFilterChangedBlock ifNotNil: [ onFilterChangedBlock value: f ]
]

{ #category : 'callbacks' }
TMFilterBarPresenter >> onFilterChanged: aBlock [
	onFilterChangedBlock := aBlock
]
