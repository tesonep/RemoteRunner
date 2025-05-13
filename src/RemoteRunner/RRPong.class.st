Class {
	#name : 'RRPong',
	#superclass : 'Object',
	#instVars : [
		'requestTime',
		'responseTime'
	],
	#category : 'RemoteRunner',
	#package : 'RemoteRunner'
}

{ #category : 'as yet unclassified' }
RRPong >> executeOn: aRemoteRunner [

	aRemoteRunner pongReceived: self. 

	
]

{ #category : 'accessing' }
RRPong >> requestTime [

	^ requestTime
]

{ #category : 'accessing' }
RRPong >> requestTime: aValue [

	requestTime := aValue
]

{ #category : 'accessing' }
RRPong >> responseTime [

	^ responseTime
]

{ #category : 'accessing' }
RRPong >> responseTime: aValue [

	responseTime := aValue
]
