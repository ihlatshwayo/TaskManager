Class {
	#name : #TMTaskManager,
	#superclass : #Object,
	#instVars : [
		'tasks',
		'announcer'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'TaskManager-Core'
}

{ #category : #'instance creation' }
TMTaskManager class >> new [
	^ super new initialize
]

{ #category : #'singleton' }
TMTaskManager class >> instance [
	instance isNil ifTrue: [ instance := self new ].
	^ instance
]

{ #category : #'singleton' }
TMTaskManager class >> reset [
	instance := nil
]

{ #category : #initialization }
TMTaskManager >> initialize [
	tasks := OrderedCollection new.
	announcer := Announcer new
]

{ #category : #accessing }
TMTaskManager >> announcer [
	^ announcer
]

{ #category : #'task operations' }
TMTaskManager >> addTask: aTask [
	tasks add: aTask.
	announcer announce: (TMTaskAdded new task: aTask).
	^ aTask
]

{ #category : #'task operations' }
TMTaskManager >> createTaskWithTitle: aTitle [
	^ self addTask: (TMTask withTitle: aTitle)
]

{ #category : #'task operations' }
TMTaskManager >> createTaskWithTitle: aTitle description: aDescription [
	^ self addTask: (TMTask withTitle: aTitle description: aDescription)
]

{ #category : #'task operations' }
TMTaskManager >> removeTask: aTask [
	tasks remove: aTask ifAbsent: [].
	announcer announce: (TMTaskRemoved new task: aTask).
]

{ #category : #'task operations' }
TMTaskManager >> updateTask: aTask [
	announcer announce: (TMTaskUpdated new task: aTask).
]

{ #category : #'task operations' }
TMTaskManager >> findById: anId [
	^ tasks detect: [ :t | t id = anId ] ifNone: [ nil ]
]

{ #category : #querying }
TMTaskManager >> allTasks [
	^ tasks copy
]

{ #category : #querying }
TMTaskManager >> tasksByStatus: aStatus [
	^ tasks select: [ :t | t status = aStatus ]
]

{ #category : #querying }
TMTaskManager >> todoTasks [
	^ self tasksByStatus: #todo
]

{ #category : #querying }
TMTaskManager >> inProgressTasks [
	^ self tasksByStatus: #inProgress
]

{ #category : #querying }
TMTaskManager >> doneTasks [
	^ self tasksByStatus: #done
]

{ #category : #querying }
TMTaskManager >> cancelledTasks [
	^ self tasksByStatus: #cancelled
]

{ #category : #querying }
TMTaskManager >> tasksByPriority: aPriority [
	^ tasks select: [ :t | t priority = aPriority ]
]

{ #category : #querying }
TMTaskManager >> overdueTasks [
	^ tasks select: [ :t | t isOverdue ]
]

{ #category : #querying }
TMTaskManager >> pendingTasks [
	^ tasks select: [ :t | t isPending ]
]

{ #category : #querying }
TMTaskManager >> tasksWithTag: aTag [
	^ tasks select: [ :t | t hasTag: aTag ]
]

{ #category : #querying }
TMTaskManager >> tasksAssignedTo: aPerson [
	^ tasks select: [ :t | t assignee = aPerson ]
]

{ #category : #querying }
TMTaskManager >> searchByTitle: aString [
	| lower |
	lower := aString asLowercase.
	^ tasks select: [ :t | t title asLowercase includesSubstring: lower ]
]

{ #category : #querying }
TMTaskManager >> tasksSortedByPriority [
	^ tasks asSortedCollection: [ :a :b | a priorityValue > b priorityValue ]
]

{ #category : #querying }
TMTaskManager >> tasksSortedByDueDate [
	^ (tasks select: [ :t | t dueDate notNil ])
		asSortedCollection: [ :a :b | a dueDate < b dueDate ]
]

{ #category : #statistics }
TMTaskManager >> statistics [
	^ Dictionary new
		at: #total put: tasks size;
		at: #todo put: self todoTasks size;
		at: #inProgress put: self inProgressTasks size;
		at: #done put: self doneTasks size;
		at: #cancelled put: self cancelledTasks size;
		at: #overdue put: self overdueTasks size;
		yourself
]

{ #category : #'bulk operations' }
TMTaskManager >> markAllDone: aCollection [
	aCollection do: [ :t |
		t markDone.
		self updateTask: t ]
]

{ #category : #accessing }
TMTaskManager >> size [
	^ tasks size
]

{ #category : #printing }
TMTaskManager >> printOn: aStream [
	aStream
		nextPutAll: 'TMTaskManager(';
		print: tasks size;
		nextPutAll: ' tasks)'
]
