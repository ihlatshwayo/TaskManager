Class {
	#name : #TMTaskTest,
	#superclass : #TestCase,
	#category : #'TaskManager-Tests'
}

{ #category : #tests }
TMTaskTest >> testDefaultValues [
	| task |
	task := TMTask new.
	self assert: task status equals: #todo.
	self assert: task priority equals: #medium.
	self assert: task tags isEmpty.
	self assert: task description equals: ''.
	self assert: task assignee equals: ''.
	self deny: task isDone.
	self deny: task isOverdue
]

{ #category : #tests }
TMTaskTest >> testTitleCreation [
	| task |
	task := TMTask withTitle: 'My Task'.
	self assert: task title equals: 'My Task'
]

{ #category : #tests }
TMTaskTest >> testStatusTransitions [
	| task |
	task := TMTask withTitle: 'Test'.
	self assert: task status equals: #todo.
	task markInProgress.
	self assert: task status equals: #inProgress.
	task markDone.
	self assert: task status equals: #done.
	self assert: task isDone.
	task reopen.
	self assert: task status equals: #todo.
	task markCancelled.
	self assert: task status equals: #cancelled
]

{ #category : #tests }
TMTaskTest >> testInvalidStatusRaisesError [
	| task |
	task := TMTask new.
	self should: [ task status: #invalidStatus ] raise: AssertionFailure
]

{ #category : #tests }
TMTaskTest >> testPriorityValues [
	| task |
	task := TMTask new.
	task priority: #low.
	self assert: task priorityValue equals: 1.
	task priority: #critical.
	self assert: task priorityValue equals: 4
]

{ #category : #tests }
TMTaskTest >> testTagManagement [
	| task |
	task := TMTask new.
	task addTag: 'backend'.
	task addTag: 'urgent'.
	self assert: (task hasTag: 'backend').
	self assert: task tags size equals: 2.
	task addTag: 'backend'. "duplicate"
	self assert: task tags size equals: 2.
	task removeTag: 'backend'.
	self deny: (task hasTag: 'backend').
	self assert: task tags size equals: 1
]

{ #category : #tests }
TMTaskTest >> testIsOverdue [
	| task |
	task := TMTask new.
	task dueDate: DateAndTime now - 1 day.
	self assert: task isOverdue.
	task markDone.
	self deny: task isOverdue "done tasks are not overdue"
]

{ #category : #tests }
TMTaskTest >> testEquality [
	| t1 t2 |
	t1 := TMTask withTitle: 'Task A'.
	t2 := TMTask withTitle: 'Task A'.
	self deny: t1 = t2. "Different instances = different ids"
	self assert: t1 = t1
]

{ #category : #tests }
TMTaskTest >> testIsPending [
	| task |
	task := TMTask new.
	self assert: task isPending.
	task markInProgress.
	self assert: task isPending.
	task markDone.
	self deny: task isPending.
	task reopen.
	task markCancelled.
	self deny: task isPending
]

"=== TMTaskManagerTest ==="

Class {
	#name : #TMTaskManagerTest,
	#superclass : #TestCase,
	#instVars : [
		'manager'
	],
	#category : #'TaskManager-Tests'
}

{ #category : #running }
TMTaskManagerTest >> setUp [
	manager := TMTaskManager new
]

{ #category : #tests }
TMTaskManagerTest >> testAddAndRetrieveTasks [
	| t1 t2 |
	t1 := manager createTaskWithTitle: 'Task 1'.
	t2 := manager createTaskWithTitle: 'Task 2'.
	self assert: manager size equals: 2.
	self assert: (manager allTasks includes: t1).
	self assert: (manager allTasks includes: t2)
]

{ #category : #tests }
TMTaskManagerTest >> testRemoveTask [
	| task |
	task := manager createTaskWithTitle: 'To Remove'.
	manager removeTask: task.
	self assert: manager size equals: 0
]

{ #category : #tests }
TMTaskManagerTest >> testFindById [
	| task found |
	task := manager createTaskWithTitle: 'Findable'.
	found := manager findById: task id.
	self assert: found equals: task.
	self assert: (manager findById: 'nonexistent') isNil
]

{ #category : #tests }
TMTaskManagerTest >> testTasksByStatus [
	| t1 t2 t3 |
	t1 := manager createTaskWithTitle: 'Todo'.
	t2 := manager createTaskWithTitle: 'In Progress'.
	t3 := manager createTaskWithTitle: 'Done'.
	t2 markInProgress.
	t3 markDone.
	self assert: (manager todoTasks includes: t1).
	self assert: (manager inProgressTasks includes: t2).
	self assert: (manager doneTasks includes: t3).
	self assert: manager todoTasks size equals: 1
]

{ #category : #tests }
TMTaskManagerTest >> testSearchByTitle [
	manager createTaskWithTitle: 'Fix login bug'.
	manager createTaskWithTitle: 'Write docs'.
	manager createTaskWithTitle: 'Login page redesign'.
	
	| results |
	results := manager searchByTitle: 'login'.
	self assert: results size equals: 2
]

{ #category : #tests }
TMTaskManagerTest >> testStatistics [
	| stats t1 t2 |
	t1 := manager createTaskWithTitle: 'A'.
	t2 := manager createTaskWithTitle: 'B'.
	t2 markDone.
	stats := manager statistics.
	self assert: (stats at: #total) equals: 2.
	self assert: (stats at: #done) equals: 1.
	self assert: (stats at: #todo) equals: 1
]

{ #category : #tests }
TMTaskManagerTest >> testAnnouncementsOnAdd [
	| announced |
	announced := false.
	manager announcer when: TMTaskAdded do: [ announced := true ].
	manager createTaskWithTitle: 'Test'.
	self assert: announced
]

{ #category : #tests }
TMTaskManagerTest >> testAnnouncementsOnRemove [
	| announced task |
	task := manager createTaskWithTitle: 'Test'.
	announced := false.
	manager announcer when: TMTaskRemoved do: [ announced := true ].
	manager removeTask: task.
	self assert: announced
]

"=== TMTaskFilterTest ==="

Class {
	#name : #TMTaskFilterTest,
	#superclass : #TestCase,
	#instVars : [
		'tasks'
	],
	#category : #'TaskManager-Tests'
}

{ #category : #running }
TMTaskFilterTest >> setUp [
	| t1 t2 t3 |
	t1 := TMTask withTitle: 'Frontend task'.
	t1 priority: #high.
	t1 addTag: 'frontend'.
	t1 assignee: 'Alice'.

	t2 := TMTask withTitle: 'Backend task'.
	t2 priority: #low.
	t2 markInProgress.
	t2 addTag: 'backend'.
	t2 assignee: 'Bob'.

	t3 := TMTask withTitle: 'Done task'.
	t3 markDone.
	t3 assignee: 'Alice'.

	tasks := OrderedCollection with: t1 with: t2 with: t3
]

{ #category : #tests }
TMTaskFilterTest >> testFilterByStatus [
	| filter result |
	filter := TMTaskFilter new.
	filter statusFilter: #inProgress.
	result := filter applyTo: tasks.
	self assert: result size equals: 1.
	self assert: result first title equals: 'Backend task'
]

{ #category : #tests }
TMTaskFilterTest >> testFilterByPriority [
	| filter result |
	filter := TMTaskFilter new.
	filter priorityFilter: #high.
	result := filter applyTo: tasks.
	self assert: result size equals: 1.
	self assert: result first title equals: 'Frontend task'
]

{ #category : #tests }
TMTaskFilterTest >> testFilterByTag [
	| filter result |
	filter := TMTaskFilter new.
	filter tagFilter: 'backend'.
	result := filter applyTo: tasks.
	self assert: result size equals: 1
]

{ #category : #tests }
TMTaskFilterTest >> testFilterBySearch [
	| filter result |
	filter := TMTaskFilter new.
	filter searchText: 'front'.
	result := filter applyTo: tasks.
	self assert: result size equals: 1
]

{ #category : #tests }
TMTaskFilterTest >> testCombinedFilter [
	| filter result |
	filter := TMTaskFilter new.
	filter assigneeFilter: 'Alice'.
	result := filter applyTo: tasks.
	self assert: result size equals: 2
]

{ #category : #tests }
TMTaskFilterTest >> testEmptyFilterReturnsAll [
	| filter result |
	filter := TMTaskFilter new.
	result := filter applyTo: tasks.
	self assert: result size equals: tasks size
]
