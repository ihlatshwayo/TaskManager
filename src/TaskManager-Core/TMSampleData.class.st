Class {
	#name : #TMSampleData,
	#superclass : #Object,
	#category : #'TaskManager-Core'
}

{ #category : #'sample data' }
TMSampleData class >> populateManager: aManager [
	"Populate a task manager with sample tasks for demonstration."
	| task |

	task := aManager createTaskWithTitle: 'Design database schema'
		description: 'Create ER diagram and write migration scripts for the new product module.'.
	task priority: #high.
	task assignee: 'Alice'.
	task addTag: 'backend'.
	task addTag: 'design'.
	task dueDate: DateAndTime now + 5 days.

	task := aManager createTaskWithTitle: 'Implement login page'
		description: 'Build login and registration forms with validation and OAuth support.'.
	task priority: #high.
	task status: #inProgress.
	task assignee: 'Bob'.
	task addTag: 'frontend'.
	task addTag: 'auth'.
	task dueDate: DateAndTime now + 2 days.

	task := aManager createTaskWithTitle: 'Write unit tests for API'
		description: 'Achieve 80%+ coverage for REST API endpoints.'.
	task priority: #medium.
	task assignee: 'Alice'.
	task addTag: 'testing'.
	task addTag: 'backend'.

	task := aManager createTaskWithTitle: 'Deploy to staging'
		description: 'Set up CI/CD pipeline and deploy the current build to the staging environment.'.
	task priority: #medium.
	task status: #inProgress.
	task assignee: 'Charlie'.
	task addTag: 'devops'.
	task dueDate: DateAndTime now + 1 days.

	task := aManager createTaskWithTitle: 'Fix navigation bug'
		description: 'Breadcrumb does not update correctly on mobile view.'.
	task priority: #critical.
	task assignee: 'Bob'.
	task addTag: 'bug'.
	task addTag: 'frontend'.
	task dueDate: DateAndTime now - 1 days. "Already overdue"

	task := aManager createTaskWithTitle: 'Update user documentation'
		description: 'Revise the user guide to reflect the new UI changes.'.
	task priority: #low.
	task status: #done.
	task assignee: 'Diana'.
	task addTag: 'docs'.

	task := aManager createTaskWithTitle: 'Performance profiling'
		description: 'Profile the application under load and identify bottlenecks.'.
	task priority: #medium.
	task assignee: 'Charlie'.
	task addTag: 'performance'.
	task addTag: 'backend'.

	task := aManager createTaskWithTitle: 'Set up monitoring alerts'
		description: 'Configure PagerDuty alerts for error rate and latency thresholds.'.
	task priority: #high.
	task status: #cancelled.
	task assignee: 'Charlie'.
	task addTag: 'devops'.

	^ aManager
]
