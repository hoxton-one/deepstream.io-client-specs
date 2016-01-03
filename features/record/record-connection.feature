@records
Feature: Record Connectivity

Scenario: The client is connected
	Given the test server is ready
		And the client is initialised
		And the client logs in with username XXX and password YYY
		And the server sends the message A|A+

Scenario: The client creates a record
	Given the client creates a record named "connectionRecord"
	Then the last message the server recieved is R|CR|connectionRecord+

Scenario: The server sends a read ACK and read message for connectionRecord
	Given the server sends the message R|A|S|connectionRecord+
		And the server sends the message R|R|connectionRecord|100|{"name":"John", "pets": [{"name":"Ruffles", "type":"dog","age":2}]}+

Scenario: The client listens to recordPrefix
	When the client listens to a record matching "recordPrefix/.*"
	Then the last message the server recieved is R|L|recordPrefix/.*+

Scenario: The server responds with an ACK
	Given the server sends the message R|A|L|recordPrefix/.*+

Scenario: The client loses it connection to the server
	When the connection to the server is lost
	Given some time passes
	Then the clients connection state is RECONNECTING

Scenario: The client sends an partial update
	When the client sets the record "connectionRecord" "pets.0.name" to "Max"
	
Scenario: The client reconnects to the server
	When the connection to the server is reestablished
	Then the clients connection state is AUTHENTICATING

Scenario: The client is connected
	Given the client logs in with username XXX and password YYY
		And the server sends the message A|A+
	Then the clients connection state is OPEN

Scenario: The client resends the record subscription
	Then the server received the message R|CR|connectionRecord+

Scenario: The client resends the listen record
	Then the server received the message R|L|recordPrefix/.*+

Scenario: The client sends offline changes
	Then the server received the message R|P|connectionRecord|101|pets.0.name|SMax+
