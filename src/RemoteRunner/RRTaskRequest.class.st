Class {
	#name : 'RRTaskRequest',
	#superclass : 'Object',
	#instVars : [
		'id',
		'valuable'
	],
	#category : 'RemoteRunner',
	#package : 'RemoteRunner'
}

{ #category : 'operations' }
RRTaskRequest >> doExecuteOn: aRRWorker [

	| response executingContext |
	response := RRTaskResponse new
		            id: id;
		            yourself.

	executingContext := thisContext.

	[ response response: valuable value ] 
		onErrorDo: [ :anError |
			anError freezeUpTo: executingContext sender.
			response setError: anError ].

	^ response
]

{ #category : 'execution' }
RRTaskRequest >> executeOn: aRRWorker [

	| response |

	aRRWorker enqueue: [ 		
		response := self doExecuteOn: aRRWorker.
		aRRWorker sendResponse: response ]

			
]

{ #category : 'accessing' }
RRTaskRequest >> id [
	^ id
]

{ #category : 'accessing' }
RRTaskRequest >> id: anInteger [ 
	id := anInteger
]

{ #category : 'accessing' }
RRTaskRequest >> valuable [

	^ valuable
]

{ #category : 'accessing' }
RRTaskRequest >> valuable: anObject [

	valuable := anObject
]
