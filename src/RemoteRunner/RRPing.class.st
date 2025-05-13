Class {
	#name : 'RRPing',
	#superclass : 'Object',
	#instVars : [
		'requestTime'
	],
	#category : 'RemoteRunner',
	#package : 'RemoteRunner'
}

{ #category : 'executing' }
RRPing >> executeOn: aRRWorker [

	| response |

	response := RRPong new
		requestTime: requestTime;
		responseTime: DateAndTime now;
		yourself.
		
	aRRWorker sendResponse: response
			
]

{ #category : 'initialization' }
RRPing >> initialize [ 

	super initialize.
	requestTime := DateAndTime now.
]
