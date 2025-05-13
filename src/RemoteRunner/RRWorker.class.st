Class {
	#name : 'RRWorker',
	#superclass : 'Object',
	#instVars : [
		'connection',
		'tktRunner'
	],
	#category : 'RemoteRunner',
	#package : 'RemoteRunner'
}

{ #category : 'connection open/close' }
RRWorker >> connectTo: address port: port [
	
	| clientSocket |
	clientSocket := Socket newTCP.
	clientSocket connectTo: address port: port.
	
	connection := RRSocketClient new
		socket: clientSocket;
		whenMessageReceivedDo: [ :client :stream | self processMessageFrom: stream ];
		whenClosedDo: [ :aClient | self stop ];
		onErrorDo: [ :aClient :anError | anError debug ];
		start;
		yourself.
	
	tktRunner := TKTWorker new
				name: self class name, ' ', self hash printString , ' Worker';
				priority: Processor userSchedulingPriority;
				start
]

{ #category : 'actions' }
RRWorker >> enqueue: aValuable [

	aValuable asTask schedule: tktRunner 
]

{ #category : 'handling messages' }
RRWorker >> processMessageFrom: aStream [

	| message |
	
	message := FLMaterializer materializeFrom: aStream.

	message executeOn: self.
]

{ #category : 'handling messages' }
RRWorker >> sendResponse: aResponse [

	connection binaryOutputStreamDo: [ :outputStream |
		FLSerializer serialize: aResponse on: outputStream ]
]

{ #category : 'initialization' }
RRWorker >> stop [

	connection stop.
	tktRunner ifNotNil: [ tktRunner stop ].
]
