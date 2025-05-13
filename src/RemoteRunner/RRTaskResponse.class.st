Class {
	#name : 'RRTaskResponse',
	#superclass : 'Object',
	#instVars : [
		'id',
		'response',
		'error'
	],
	#category : 'RemoteRunner',
	#package : 'RemoteRunner'
}

{ #category : 'accessing' }
RRTaskResponse >> executeOn: aRemoteRunner [

	aRemoteRunner handleTaskResponse: self
]

{ #category : 'accessing' }
RRTaskResponse >> getError [

	^ error
]

{ #category : 'accessing' }
RRTaskResponse >> id [
	^ id
]

{ #category : 'accessing' }
RRTaskResponse >> id: aValue [

	id := aValue
]

{ #category : 'accessing' }
RRTaskResponse >> response: aResponse [

	response := aResponse 
]

{ #category : 'accessing' }
RRTaskResponse >> setError: anError [

	error := anError 
]
