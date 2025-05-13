Class {
	#name : 'RRSocketServer',
	#superclass : 'Object',
	#instVars : [
		'clients',
		'portToUse',
		'serverSocket',
		'acceptService',
		'whenMessageReceivedDoBlock',
		'sendWorker',
		'whenNewClientDoBlock',
		'whenClientDisconnectBlock'
	],
	#category : 'RemoteRunner',
	#package : 'RemoteRunner'
}

{ #category : 'visiting' }
RRSocketServer >> acceptLoop [
	
	| clientSocket client |
	clientSocket := serverSocket waitForAcceptFor: 10.
	clientSocket ifNil: [ ^ self ].
	
	client := RRSocketClient new
		socket: clientSocket;
		whenMessageReceivedDo: whenMessageReceivedDoBlock;
		whenClosedDo: [ :aClient | 
			aClient stop. 
			clients remove: aClient.
			whenClientDisconnectBlock ifNotNil: [ whenClientDisconnectBlock value: aClient ] ];
		onErrorDo: [ :aClient :anError | anError debug ];
		start;
		yourself.
	
	clients add: client.
	
	whenNewClientDoBlock ifNotNil: [ whenNewClientDoBlock value: client ]

]

{ #category : 'as yet unclassified' }
RRSocketServer >> forClient: aClient sendData: withOutputStreamBlock [

	([ aClient binaryOutputStreamDo: withOutputStreamBlock ] asTask
		 future: sendWorker) onFailureDo: [ :e | e debug ]
]

{ #category : 'initialization' }
RRSocketServer >> initialize [ 
	
	super initialize.
	
	clients := OrderedCollection new.
	portToUse := 0.
]

{ #category : 'accessing' }
RRSocketServer >> localAddress [
	
	^ serverSocket localAddress
]

{ #category : 'accessing' }
RRSocketServer >> localPort [

	^ serverSocket localPort
]

{ #category : 'accessing' }
RRSocketServer >> portToUse: aValue [

	portToUse := aValue
]

{ #category : 'controlling' }
RRSocketServer >> start [

	serverSocket := Socket newTCP
		listenOn: portToUse backlogSize: 10;
		yourself.

	sendWorker := TKTWorker new
		name: (self class name) , ' send worker ' , self hash printString;
		priority: Processor lowIOPriority;
		start;
		yourself.
		
	self startServerService.
	
	
	
]

{ #category : 'as yet unclassified' }
RRSocketServer >> startServerService [
	
	acceptService ifNotNil: [ acceptService stop ].
	
	acceptService := TKTParameterizableService new
		name: (self class name) , ' server process ' , self hash printString;
		stepDelay: 0 seconds;
		priority: Processor lowIOPriority;
		step: [ self acceptLoop ];
		start;
		yourself.
]

{ #category : 'controlling' }
RRSocketServer >> stop [
	
	acceptService ifNotNil: [ acceptService stop].
	acceptService := nil.
	
	sendWorker ifNotNil: [ sendWorker stop ].
	sendWorker := nil.
	
	clients do: [:e | e stop ].
	serverSocket closeAndDestroy.
]

{ #category : 'accessing' }
RRSocketServer >> whenClientDisconnectDo: aBlock [

	whenClientDisconnectBlock := aBlock
]

{ #category : 'accessing' }
RRSocketServer >> whenMessageReceivedDo: aBlock [

	whenMessageReceivedDoBlock := aBlock
]

{ #category : 'accessing' }
RRSocketServer >> whenNewClientDo: aBlock [

	whenNewClientDoBlock := aBlock
]
