Class {
	#name : 'TMTaskTest',
	#superclass : 'TestCase',
	#category : 'TaskManager-Tests',
	#package : 'TaskManager-Tests'
}

{ #category : 'tests' }
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

{ #category : 'tests' }
TMTaskTest >> testEquality [
	| t1 t2 |
	t1 := TMTask withTitle: 'Task A'.
	t2 := TMTask withTitle: 'Task A'.
	self deny: t1 = t2. "Different instances = different ids"
	self assert: t1 = t1
]

{ #category : 'tests' }
TMTaskTest >> testInvalidStatusRaisesError [
	| task |
	task := TMTask new.
	self should: [ task status: #invalidStatus ] raise: AssertionFailure
]

{ #category : 'tests' }
TMTaskTest >> testIsOverdue [
	| task |
	task := TMTask new.
	task dueDate: DateAndTime now - 1 day.
	self assert: task isOverdue.
	task markDone.
	self deny: task isOverdue "done tasks are not overdue"
]

{ #category : 'tests' }
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

{ #category : 'tests' }
TMTaskTest >> testPriorityValues [
	| task |
	task := TMTask new.
	task priority: #low.
	self assert: task priorityValue equals: 1.
	task priority: #critical.
	self assert: task priorityValue equals: 4
]

{ #category : 'tests' }
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

{ #category : 'tests' }
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

{ #category : 'tests' }
TMTaskTest >> testTitleCreation [
	| task |
	task := TMTask withTitle: 'My Task'.
	self assert: task title equals: 'My Task'
]
