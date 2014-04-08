changes_since
=============
A Changelog tool that helps you display a neat changelog of all pull requests merged since a certain tag.
This works well if you use a pull request based process, i.e. every commit made to master is via a pull request.

Example:

From https://github.com/resque/resque

`ChangesSince.fetch('v1.25.2')`
```
Unclassified:

* won't be needing rack-test as well (Dan Buch)
* Extracted a new WorkerQueueList class out of Rescue::Worker (Einar Jonsson)
* implementation of Backend connection with Hash (Ryan Biesemeyer)
* update readme.md with hooks link (Ryan Biesemeyer)
* speed up test suite (Ryan Biesemeyer)
* Added worker_registry_tests (Ryan Biesemeyer)
* add info about queue priority to readme (Ryan Biesemeyer)
* Fix line and file endings. (Ryan Biesemeyer)
* increase coverage for process coordinator (Ryan Biesemeyer)
* Add Resque.configure documentation to README (Ryan Biesemeyer)
...
```
If you want to use enhanced functionality, you can tag pull requests with #bug, #internal, or #public
The 'Unclassified' would then change to Bug, Internal or Public respectively.

There are some additional options you can use

Author filter:

`ChangesSince.fetch('v1.25.2', { :author_filter => ["Dan Buch", "Steve Klabnik"] })`
```
Unclassified:

* won't be needing rack-test as well (Dan Buch)
* Fixed typos (Steve Klabnik)
* Make sure the filicide is justified (Steve Klabnik)
* Spelling mistake correction. (Steve Klabnik)
* Fix spelling of "languages" in readme (Steve Klabnik)
* Fix daemonize option (Steve Klabnik)
* Add wrapper for JSON encoding exceptions because yay consistency (Steve Klabnik)
* The resque-2.0 tests are so noisy! (Steve Klabnik)
...
```

`ChangesSince.fetch('v1.25.2', { :all => true })` - Tries to extract additional interesting commits

You can also pass in some team logic.

Example:

`TEAMS = {
  "Team 1" => ["Dan Buch", "Einar Jonsson"],
  "Team 2" => ["Ryan Biesemeyer", "Steve Klabnik"]
}`

`ChangesSince.fetch('v1.25.2', {}, TEAMS)`
```
*Team 1*

Unclassified:

* won't be needing rack-test as well (Dan Buch)
* Extracted a new WorkerQueueList class out of Rescue::Worker (Einar Jonsson)

*Team 2*

Unclassified:

* update readme.md with hooks link (Ryan Biesemeyer)
* speed up test suite (Ryan Biesemeyer)
* add info about queue priority to readme (Ryan Biesemeyer)
* Added worker_registry_tests (Ryan Biesemeyer)
* Add Resque.configure documentation to README (Ryan Biesemeyer)
* Typo in comment (Ryan Biesemeyer)
* Attempt to infer queue from worker class (Ryan Biesemeyer)
* increase coverage for process coordinator (Ryan Biesemeyer)
* Fix line and file endings. (Ryan Biesemeyer)
* implementation of Backend connection with Hash (Ryan Biesemeyer)
* Feature/exits for real (Steve Klabnik)
* Make sure the filicide is justified (Steve Klabnik)
```
