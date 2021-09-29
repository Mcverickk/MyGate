pragma solidity >=0.4.17 < 0.9.0;

contract MyGate
{
    
    address chairPerson;
    
    //constructor to register deployer as msg.sender.
    constructor()
    {
        chairPerson = msg.sender;
    }
    //struct to store details of the approval
    //identity examples are guest,swiggy,zomato,courier etc.
    struct Approval
    {
        string vistingFlat;
        string name;
        string identity;
        
    }
    //struct to store details of guards
    struct Guard
    {
        string name;
        uint phoneNumber;
        address adrs;
    }
    //struct to store details of flat owners
    struct flatOwner
    {
        string flatID;
        string name;
        uint phoneNumber;
        address adrs;
    }
    
    //mapping to map flat no. to the owners details
    mapping(string => flatOwner) flatToOwners;
    //mapping to map address of guards to thier details
    mapping(address => Guard) adrsToGuard;
    
    mapping(address => Approval[]) pendingApprovals;
    
    Guard[] public guards;
    flatOwner[] owners;
    Approval[] approvals;
    
    //modifier to check only chairPerson has the permission
    modifier onlyChairPerson()
    {
        require(msg.sender == chairPerson,"You do not have registering permission.");
        _;
    }
    
    //modifier to check only Guard has the permission
    modifier onlyGuard() 
    {
        require(msg.sender == adrsToGuard[msg.sender].adrs,"You do not have Guard permission.");
        _;
    }
    
    
    // chairPerson can register the guards through this function
    function registerGuard(string memory _name, uint _phoneNum, address _adrsID) public onlyChairPerson
    {
        guards.push(Guard(_name,_phoneNum,_adrsID));
        adrsToGuard[_adrsID] = Guard(_name,_phoneNum,_adrsID);
        
    }
    //chairPerson can register the flat owners through this function
    function registerFlatOwner(string memory _flatNo, string memory _name, uint _phoneNum, address _adrsID) public onlyChairPerson
    {
        owners.push(flatOwner(_flatNo,_name,_phoneNum,_adrsID));
        flatToOwners[_flatNo] = flatOwner(_flatNo,_name,_phoneNum,_adrsID);
    }
    //
    function approvalGenerate(string memory _flatNo,string memory _name,string memory _role) public onlyGuard
    {
        
        pendingApprovals[flatToOwners[_flatNo].adrs].push(Approval(_flatNo,_name,_role));
        
    }
    
    function pendingApprovalCount() public view returns(uint)
    {
        return (pendingApprovals[msg.sender].length);
        
    }
    
    function viewApproval(uint _number) public view returns(string memory,string memory)
    {
        return ((pendingApprovals[msg.sender][_number].name),pendingApprovals[msg.sender][_number].identity);
    }
    
    
    
    
    
    
    
}
