This steps are for contract name vote.
The whole contract work in several steps:
1)	The contract is initialization by the chairperson Account and using the same account voters and candidates are added using add_voter and add_candidate respectively. In add_voter function bool type variable _elegiable is to give permission to any user for voting.
2)	Then the function start_voting is use to start and stop voting process. By using true and false value to start and stop voting respectively.
3)	After voting is started user can vote to any person they want by putting the account number of the person of their choice. After completion of voting chairperson stop voting by putting false in the start_voting function.
4)	At last after completion of all the process result function can be used to show result of the election, if two or more candidates get same no of winning votes then output will show the number of candidate who get same no of vote with an Election is tied between message. 
