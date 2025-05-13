Class {
	#name : 'RRTaskExecution',
	#superclass : 'TKTTaskExecution',
	#instVars : [
		'id'
	],
	#category : 'RemoteRunner',
	#package : 'RemoteRunner'
}

{ #category : 'accessing' }
RRTaskExecution >> id [
	^ id
]

{ #category : 'initialization' }
RRTaskExecution >> initialize [ 

	super initialize.
	id := UUID new.
]
