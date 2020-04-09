pragma solidity >=0.4.0 <0.7.0;

contract Vote {
    /*
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Personal {
        bytes32 name;
        uint vote_Count;
    }

    address chairperson;

    mapping (address => Voter) public voters;

    Personal [] public persons;

    constructor (bytes32[] memory personalnames) public{
        chairperson == msg.sender;
        voters[chairperson].weight = 1 ;
        for (uint i = 0 ; i< personalnames.length; i++){
            persons.push(Personal({
                name:personalnames[i],
                vote_Count : 0
            }));
        }

    }

    function giverighttovote(address _Voter) public {
        require(msg.sender == chairperson,'only chairperson can allow person to vote');
        require(!voters[_Voter].voted,'you allready voted');

        require(voters[_Voter].weight == 0);
        voters[_Voter].weight = 1;

    }

    */

    address chairperson;
    bool voting = false;
    uint voting_count = 1;
    uint candidate_count = 0;
    uint voter_count =0;
    bool _selected_candidate_status;
    bool _candidate_status = false;


    // voter detial
    struct Persons {
        string voter_name;
        uint voted;
        bool elegiable;
    }
    // candidate detial
    struct candidates{
        string candidate_name;
        uint Vote_Count;
    }

    constructor () public {
        chairperson = msg.sender;

    }

    // making list of candidate nad voter
    mapping(uint => address)public candidate_list;
    mapping(address => candidates) standing_candidates;
    mapping(uint => address)public voter_list;
    mapping(address => Persons) Voters;
    // adding voters in the list
    function Add_voter (address _voter ,string memory _name,bool _elegiable) public{
        bool new_voter = true;
        require( msg.sender == chairperson, ' you are not authorized Persons' );
        require(voting == false ,'during voting no new voter can be added' );

        for (uint j = 1;j<=voter_count;j++){
           if (voter_list[j] == _voter){
               new_voter = false;
           }
        }
        // adding voter is allowed once
        require(new_voter == true,'voter allready added to the list');

        voter_count += 1;
        voter_list[voter_count] = _voter;

        Voters[_voter].voter_name = _name;
        Voters[_voter].voted = 0;
        Voters[_voter].elegiable = _elegiable;
    }
    // add candidate
    function Add_candidate (address _candidate,string memory _candidate_name) public {
        bool new_candidate = true;
        require( msg.sender == chairperson, ' you are not authorized Persons' );
        require(msg.sender != _candidate,'self adding is not allowed');
        require(voting == false ,'during voting no new candidate can be added' );

        for (uint j = 1;j<=candidate_count;j++){
           if (candidate_list[j] == _candidate){
               new_candidate = false;
           }
        }
        // candidate can't be added twice
        require(new_candidate == true,'candidate allready added to the list');

        candidate_count += 1;
        candidate_list[candidate_count] = _candidate;
        standing_candidates[_candidate].candidate_name = _candidate_name;
        standing_candidates[_candidate].Vote_Count = 0;

    }
    //only the deployer can only allowed to start and stop voting
    function start_voting (bool _status) public{
        require( msg.sender == chairperson, ' you are not authorized Persons' );
        require(voting != _status,'status change not possible');
        require(voting_count == 1,'voting process canbe started only one time');
        if (voting == false && _status == true && voting_count == 1){
            voting = true ;
            voting_count = 0;
        }
        // voting can be started or stoped once
        if (voting == true && _status == false){
            voting = false;
        }
    }
    // pest the address of the selected address and vote count of that candidate is increased by one
    function Voting (address _selected_candiadate) public{
        // only selected voter all allowed to Vote
        require(Voters[msg.sender].elegiable == true,'you are not allowed to vote');
        // no candidate can vote twice
        require(Voters[msg.sender].voted == 0,'you had alread voted');
        require(voting == true ,'voting is not started yet');

        for (uint i = 0; i <= candidate_count;i++){
            if(candidate_list[i] == _selected_candiadate){
                _candidate_status = true;
                standing_candidates[_selected_candiadate].Vote_Count += 1;
                Voters[msg.sender].voted = 1;
            }
        }
        require(_candidate_status == true, 'selected candidate is not standing for election');

    }
    // result can be called only if the voting process is stoped and it could only be done by the chairperson
    function Result() public view returns(string memory, uint){
        require( msg.sender == chairperson, ' you are not authorized Persons' );
        require(voting == false && voting_count == 0,"either voting is in process or voting has not stred yet");

        uint winner_vote_count = 0;
        address winner_address;
        uint _tied_between = 0 ;
        uint _vote_count;
        // finding the winner
        for (uint i = 1 ; i <= candidate_count ;i++){

             _vote_count = standing_candidates[candidate_list[i]].Vote_Count;

            if (winner_vote_count < _vote_count){
                winner_vote_count = _vote_count;
                winner_address = candidate_list[i];
            }

        }
        //finding if there are more then one winner
        for (uint i = 1 ; i <= candidate_count ;i++){

            _vote_count = standing_candidates[candidate_list[i]].Vote_Count;

            if (winner_address != candidate_list[i] && winner_vote_count == _vote_count){
                _tied_between += 1;
            }


        }
        //displaying Result
        if (_tied_between == 0){
            // when only one candidate win
            return(standing_candidates[winner_address].candidate_name,standing_candidates[winner_address].Vote_Count);
        }
        else {
            //displaying the number of candidate who have same no of vote
            return ("Elction is tied between",_tied_between);
        }

    }

}
