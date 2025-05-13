Class {
	#name : 'RRSocketClient',
	#superclass : 'Object',
	#instVars : [
		'socket',
		'receiveService',
		'whenMessageReceivedDoBlock',
		'socketStream',
		'onErrorDoBlock',
		'whenClosedDoBlock'
	],
	#category : 'RemoteRunner',
	#package : 'RemoteRunner'
}

{ #category : 'enumerating' }
RRSocketClient >> binaryOutputStreamDo: aBlock [

	| stream |
	
	stream := SocketStream on: socket.
	stream binary.
	
	[ aBlock value: stream ]
		ensure: [ stream flush ]
]

{ #category : 'accessing' }
RRSocketClient >> connectTo: hostAddress port: port [

	socket := Socket newTCP.
	socket connectTo: hostAddress port: port.
]

{ #category : 'enumerating' }
RRSocketClient >> onErrorDo: aBlock [

	onErrorDoBlock := aBlock
]

{ #category : 'accessing' }
RRSocketClient >> socket: aSocket [ 
	socket := aSocket
]

{ #category : 'controlling' }
RRSocketClient >> start [

	socketStream := SocketStream on: socket.
	socketStream binary.

	receiveService := TKTParameterizableService new
		priority: Processor lowIOPriority;
		name: self class name , ' receive service ' , self hash printString;
		stepDelay: 0 seconds;
		step: [ [ | closed | 
				closed := false.  
				socket waitForDataIfClosed: [ closed := true ].
				closed 
					ifTrue: [ whenClosedDoBlock value: self ]
					ifFalse: [ whenMessageReceivedDoBlock value: self value: socketStream] ] 
				onErrorDo: [ :e | onErrorDoBlock value: self value: e ] ];
		start;
		yourself.
	
]

{ #category : 'controlling' }
RRSocketClient >> stop [

	socketStream ifNotNil: [ socketStream flush ].
	socket closeAndDestroy.

	receiveService ifNotNil: [ receiveService stop ].	
]

{ #category : 'enumerating' }
RRSocketClient >> whenClosedDo: aBlock [

	whenClosedDoBlock := aBlock
]

{ #category : 'enumerating' }
RRSocketClient >> whenMessageReceivedDo: aBlock [

	whenMessageReceivedDoBlock := aBlock
]
