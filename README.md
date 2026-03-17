# TaskManager — Pharo Smalltalk

A full-featured Task Manager application built in Pharo using idiomatic Smalltalk patterns: Spec2 for the UI, Announcer for events, and Tonel for source control.

---

## Project Structure

```
TaskManager/
└── src/
    ├── BaselineOfTaskManager/     ← Metacello baseline
    │   └── BaselineOfTaskManager.class.st
    ├── TaskManager-Core/          ← Domain model
    │   ├── TMTask.class.st
    │   ├── TMTaskManager.class.st
    │   ├── TMTaskFilter.class.st
    │   ├── TMTaskAnnouncements.class.st
    │   └── TMSampleData.class.st
    ├── TaskManager-UI/            ← Spec2 presenters
    │   ├── TMTaskPresenter.class.st
    │   ├── TMTaskListPresenter.class.st
    │   ├── TMTaskDetailPresenter.class.st
    │   ├── TMTaskEditPresenter.class.st
    │   └── TMFilterBarPresenter.class.st
    └── TaskManager-Tests/         ← SUnit tests
        └── TMTaskTest.class.st    (TMTaskTest, TMTaskManagerTest, TMTaskFilterTest)
```

---

## Installation

### Option A — Load via Metacello (recommended)

Open a Pharo Playground and evaluate:

```smalltalk
Metacello new
    baseline: 'TaskManager';
    repository: 'github://YOUR_USERNAME/TaskManager/src';
    load.
```

### Option B — Manual load (Tonel)

```smalltalk
| repo |
repo := MCFileTreeRepository new directory: '/path/to/TaskManager/src' asFileReference.
MCPackageLoader new
    addPackage: 'TaskManager-Core';
    addPackage: 'TaskManager-UI';
    addPackage: 'TaskManager-Tests';
    repository: repo;
    load.
```

---

## Quick Start

### Open the UI with sample data

```smalltalk
TMTaskPresenter openWithSampleData.
```

### Open with an empty manager

```smalltalk
TMTaskPresenter open.
```

### Use the core API directly

```smalltalk
| mgr task |
mgr := TMTaskManager new.

"Create tasks"
task := mgr createTaskWithTitle: 'Fix login bug'
             description: 'Breadcrumb breaks on mobile'.
task priority: #critical.
task assignee: 'Alice'.
task addTag: 'bug'.
task addTag: 'frontend'.
task dueDate: DateAndTime now + 2 days.

"Query"
mgr todoTasks.                   "All todo tasks"
mgr overdueTasks.                "Past due date"
mgr searchByTitle: 'login'.      "Full-text search"
mgr tasksSortedByPriority.       "Sorted by priority desc"
mgr statistics.                  "Dictionary with counts"

"Status transitions"
task markInProgress.
task markDone.
task reopen.

"Filtering"
| filter |
filter := TMTaskFilter new.
filter statusFilter: #inProgress.
filter priorityFilter: #high.
filter applyTo: mgr allTasks.
```

### Run the tests

```smalltalk
TMTaskTest suite run.
TMTaskManagerTest suite run.
TMTaskFilterTest suite run.

"Or all at once from the Test Runner tool (Pharo IDE > Tools > Test Runner)"
```

---

## Core Classes

### `TMTask`

The domain object. Stores title, description, status, priority, due date, assignee, and tags.

| Method | Description |
|--------|-------------|
| `withTitle:` | Create a task with a title |
| `markInProgress` / `markDone` / `markCancelled` / `reopen` | Status transitions |
| `isDone` / `isOverdue` / `isPending` | Boolean queries |
| `addTag:` / `removeTag:` / `hasTag:` | Tag management |
| `priorityValue` | Returns 1–4 for sorting |

Valid **statuses**: `#todo` `#inProgress` `#done` `#cancelled`  
Valid **priorities**: `#low` `#medium` `#high` `#critical`

---

### `TMTaskManager`

Manages the task collection. Dispatches events via `Announcer`.

| Method | Description |
|--------|-------------|
| `createTaskWithTitle:` | Create and add a task |
| `addTask:` / `removeTask:` | Add/remove an existing task |
| `findById:` | Look up by UUID string |
| `todoTasks` / `inProgressTasks` / `doneTasks` | Filter by status |
| `overdueTasks` | All past-due, not-done tasks |
| `searchByTitle:` | Case-insensitive substring search |
| `tasksSortedByPriority` | Sorted collection, highest first |
| `statistics` | Dictionary with counts per status |
| `announcer` | Subscribe to `TMTaskAdded`, `TMTaskRemoved`, `TMTaskUpdated` |

---

### `TMTaskFilter`

Composable filter object.

```smalltalk
| filter |
filter := TMTaskFilter new.
filter statusFilter: #inProgress.
filter priorityFilter: #high.
filter searchText: 'bug'.
filter showOverdueOnly: true.

filter applyTo: mgr allTasks.
filter reset.
```

---

### Announcements

Subscribe to task events:

```smalltalk
mgr announcer
    when: TMTaskAdded   do: [ :ann | Transcript show: 'Added: ', ann task title ];
    when: TMTaskRemoved do: [ :ann | Transcript show: 'Removed: ', ann task title ];
    when: TMTaskUpdated do: [ :ann | Transcript show: 'Updated: ', ann task title ].
```

---

## UI (Spec2)

| Presenter | Role |
|-----------|------|
| `TMTaskPresenter` | Main window — toolbar, list, detail panel, status bar |
| `TMTaskListPresenter` | Sortable table of tasks |
| `TMTaskDetailPresenter` | Read-only detail view on the right |
| `TMTaskEditPresenter` | Modal dialog to create or edit a task |
| `TMFilterBarPresenter` | Search + status/priority dropdowns |

---

## Requirements

- Pharo 11 or 12
- Spec2 (included in standard Pharo image)

---

## License

MIT
