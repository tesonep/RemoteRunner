Class {
	#name : 'RemoteRunner',
	#superclass : 'Object',
	#traits : 'TTaskScheduler',
	#classTraits : 'TTaskScheduler classTrait',
	#instVars : [
		'remoteWorker',
		'socketServer',
		'requestedTasks'
	],
	#category : 'RemoteRunner',
	#package : 'RemoteRunner'
}

{ #category : 'as yet unclassified' }
RemoteRunner >> handleTaskResponse: aRRTaskResponse [

	| task |
	
	task := requestedTasks removeKey: aRRTaskResponse id.
	task setFinishedState.
	
	aRRTaskResponse getError ifNotNil: [ :anError | anError debug ].
	
]

{ #category : 'initialization' }
RemoteRunner >> initialize [

	super initialize.
	
	socketServer := RRSocketServer new.
	socketServer 
		whenMessageReceivedDo: [ :aClient :aStream | 
			self 
				rawProcessMessageFrom: aStream 
				ofClient: aClient ];
		whenNewClientDo: [ :aClient | 
			remoteWorker := aClient.
			self pingWorker ].
		
	requestedTasks := Dictionary new.
	
]

{ #category : 'accessing' }
RemoteRunner >> localAddress [

	^ socketServer localAddress 
]

{ #category : 'accessing' }
RemoteRunner >> localPort [

	^ socketServer localPort
]

{ #category : 'as yet unclassified' }
RemoteRunner >> pingWorker [
	
	socketServer forClient: remoteWorker sendData: [ :aStream | FLSerializer serialize: RRPing new on: aStream ]
]

{ #category : 'as yet unclassified' }
RemoteRunner >> pongReceived: aRRPong [
	
	self inform: 'Pong ' , aRRPong responseTime printString
]

{ #category : 'schedulling' }
RemoteRunner >> privateSchedule: aTask [

	| execution |

	execution := aTask asTask configureTaskExecution: RRTaskExecution new with: self.

	self scheduleTaskExecution: execution
]

{ #category : 'initialization' }
RemoteRunner >> processMessage: message ofClient: aClient [

	message executeOn: self
]

{ #category : 'initialization' }
RemoteRunner >> rawProcessMessageFrom: aStream ofClient: aClient [

	| message |
	message := FLMaterializer materializeFrom: aStream.
	self processMessage: message ofClient: aClient	
]

{ #category : 'schedulling' }
RemoteRunner >> scheduleTaskExecution: aTaskExecution [

	| taskRequest |
	
	requestedTasks at: aTaskExecution id put: aTaskExecution.
	taskRequest := aTaskExecution taskRequest.
	
	aTaskExecution setRunningState.
	
	socketServer 
		forClient: remoteWorker 
		sendData: [ :aStream | FLSerializer serialize: taskRequest on: aStream ]
]

{ #category : 'accessing' }
RemoteRunner >> start [ 

	socketServer start.
	
]

{ #category : 'accessing' }
RemoteRunner >> stop [ 

	remoteWorker ifNotNil: [ remoteWorker stop ].
	socketServer stop.

]
