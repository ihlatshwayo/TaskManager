Class {
	#name : #BaselineOfTaskManager,
	#superclass : #BaselineOf,
	#category : #'BaselineOfTaskManager'
}

{ #category : #baselines }
BaselineOfTaskManager >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec
			package: 'TaskManager-Core';
			package: 'TaskManager-UI' with: [ spec requires: #('TaskManager-Core') ];
			package: 'TaskManager-Tests' with: [ spec requires: #('TaskManager-Core') ].

		spec
			group: 'core' with: #('TaskManager-Core');
			group: 'ui' with: #('TaskManager-UI');
			group: 'tests' with: #('TaskManager-Tests');
			group: 'default' with: #('TaskManager-Core' 'TaskManager-UI' 'TaskManager-Tests')
	]
]
