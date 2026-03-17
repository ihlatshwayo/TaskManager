Class {
	#name : #TMTaskAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'task'
	],
	#category : #'TaskManager-Core'
}

{ #category : #accessing }
TMTaskAnnouncement >> task [
	^ task
]

{ #category : #accessing }
TMTaskAnnouncement >> task: aTask [
	task := aTask
]

"=== TMTaskAdded ==="

Class {
	#name : #TMTaskAdded,
	#superclass : #TMTaskAnnouncement,
	#category : #'TaskManager-Core'
}

"=== TMTaskRemoved ==="

Class {
	#name : #TMTaskRemoved,
	#superclass : #TMTaskAnnouncement,
	#category : #'TaskManager-Core'
}

"=== TMTaskUpdated ==="

Class {
	#name : #TMTaskUpdated,
	#superclass : #TMTaskAnnouncement,
	#category : #'TaskManager-Core'
}
