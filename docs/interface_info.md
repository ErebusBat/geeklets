
Joins to eat the rest of the line, and start the next:
	.*$\s+

Interface:
	^(\w+\d+):

Mac Addr, ether or fw:
	(?:ether|lladdr)\s+((?:[a-z0-9]{2}:?)+)

IPv4 Addr:
	(?:inet)\s+([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})
	
Link Status:
	(?:status):\s+(\w+)
	
Return just interfaces:
	^(\w+\d+):.*\s(?:^\s+.*\s)+
	
