# Music iOS application example

Swift 5.1 | Xcode 11.3 | Cocoapods 1.8.4

## Project is under development

### Before the start:
In Music/4.Services/Environment.swift change APIConfiguration.baseURL to yours.




## Architecture

#### Conceptualy:
 ------------------------------------------------
| Adapters (Controllers, Clients, Managers, etc) |
|------------------------------------------------|
| Use Cases		  	||							 |
|-------------------|| 						 	 |
| Services			||			Plugins			 |
|-------------------||							 |
| Domain			||							 |
 ------------------------------------------------

#### Swift Modularization:
 -----------------------------------------------------
|	iOS App		|	watchOS App	|	[iOS App 2]	| ... |
|-----------------------------------------------------|
|	Feature1	|	Feature2	|	Feature2	| ... |
|-----------------------------------------------------|
|	Core 											  |
 -----------------------------------------------------

#### Project structure
Core:
	- UI
	- Rx
	- Remote API
	- DB Access
	- BLE Manager
	- ...
	- Services
	- Domain

Feature:
	- Navigation
	- Stories
		- View
		- Logic (State, Command, reduce + highly specialized Domain models and Services)

App:
	- AppDelegate
	- Info.plist

#### Design patterns
RxFeedback




