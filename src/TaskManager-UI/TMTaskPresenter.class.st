Class {
	#name : 'TMTaskPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'manager',
		'taskListPresenter',
		'detailPanel',
		'toolbar',
		'filterBar',
		'statusBar',
		'selectedTask',
		'filter'
	],
	#category : 'TaskManager-UI',
	#package : 'TaskManager-UI'
}

{ #category : 'layout' }
TMTaskPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #toolbar expand: false;
		add: #filterBar expand: false;
		add: (SpBoxLayout newHorizontal
			add: #taskListPresenter;
			add: #detailPanel width: 320;
			yourself);
		add: #statusBar expand: false;
		yourself
]

{ #category : 'instance creation' }
TMTaskPresenter class >> open [
	| app |
	app := self new.
	app manager: TMTaskManager instance.
	app openWithSpec.
	^ app
]

{ #category : 'instance creation' }
TMTaskPresenter class >> openWithSampleData [
	| mgr app |
	TMTaskManager reset.
	mgr := TMTaskManager instance.
	TMSampleData populateManager: mgr.
	app := self new.
	app manager: mgr.
	app open.
	^ app
]

{ #category : 'layout' }
TMTaskPresenter >> defaultLayout [
    ^ SpBoxLayout newTopToBottom
        add: #taskListPresenter;
        yourself
]

{ #category : 'actions' }
TMTaskPresenter >> deleteSelectedTask [
	selectedTask isNil ifTrue: [ ^ self ].
	(self confirm: 'Delete task "', selectedTask title, '"?')
		ifTrue: [
			manager removeTask: selectedTask.
			selectedTask := nil.
			detailPanel showTask: nil ]
]

{ #category : 'actions' }
TMTaskPresenter >> editTask: aTask [
	| dialog |
	dialog := TMTaskEditPresenter new.
	dialog manager: manager.
	dialog task: aTask.
	dialog openDialogWithSpec
]

{ #category : 'window configuration' }
TMTaskPresenter >> initialExtent [
	^ 900 @ 600
]

{ #category : 'initialization' }
TMTaskPresenter >> initialize [
	super initialize.
	filter := TMTaskFilter new.
	selectedTask := nil
]

{ #category : 'initialization' }
TMTaskPresenter >> initializePresenters [
	toolbar := self newToolbar.
	filterBar := self instantiate: TMFilterBarPresenter.
	taskListPresenter := self instantiate: TMTaskListPresenter.
	detailPanel := self instantiate: TMTaskDetailPresenter.
	statusBar := self newLabel.
	
	self setupToolbar.
	self setupFilterBar.
	self setupTaskList
]

{ #category : 'accessing' }
TMTaskPresenter >> manager: aManager [
	manager := aManager.
	self subscribeToAnnouncements.
	self refreshList
]

{ #category : 'actions' }
TMTaskPresenter >> markSelectedDone [
	selectedTask isNil ifTrue: [ ^ self ].
	selectedTask markDone.
	manager updateTask: selectedTask
]

{ #category : 'actions' }
TMTaskPresenter >> newTask [
	| dialog |
	dialog := TMTaskEditPresenter new.
	dialog manager: manager.
	dialog openDialogWithSpec
]

{ #category : 'refreshing' }
TMTaskPresenter >> refreshList [
	| filtered |
	filtered := filter applyTo: manager allTasks.
	taskListPresenter tasks: filtered.
	self updateStatusBar
]

{ #category : 'initialization' }
TMTaskPresenter >> setupFilterBar [
	filterBar onFilterChanged: [ :f |
		filter := f.
		self refreshList ]
]

{ #category : 'initialization' }
TMTaskPresenter >> setupTaskList [
	taskListPresenter onTaskSelected: [ :task |
		selectedTask := task.
		detailPanel showTask: task ].
	taskListPresenter onTaskDoubleClicked: [ :task |
		self editTask: task ]
]

{ #category : 'initialization' }
TMTaskPresenter >> setupToolbar [
    toolbar
        addItem: (SpToolbarButtonPresenter new
            label: 'New Task';
            icon: (self iconNamed: #add);
            action: [ self newTask ];
            yourself);
        addItem: (SpToolbarButtonPresenter new
            label: 'Delete';
            icon: (self iconNamed: #remove);
            action: [ self deleteSelectedTask ];
            yourself)
]

{ #category : 'subscriptions' }
TMTaskPresenter >> subscribeToAnnouncements [
    manager announcer
        when: TMTaskAdded do: [ :ann | self refreshList ] for: self;
        when: TMTaskRemoved do: [ :ann | self refreshList ] for: self;
        when: TMTaskUpdated do: [ :ann | self refreshList ] for: self
]

{ #category : 'title' }
TMTaskPresenter >> title [
	^ 'Task Manager'
]

{ #category : 'updating' }
TMTaskPresenter >> updateStatusBar [
	| stats |
	stats := manager statistics.
	statusBar label: ('Total: {1} | Todo: {2} | In Progress: {3} | Done: {4} | Overdue: {5}'
		format: { stats at: #total. stats at: #todo.
		          stats at: #inProgress. stats at: #done.
		          stats at: #overdue })
]
