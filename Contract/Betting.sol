        pragma solidity ^0.4.0;
        import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
        import "safemath.sol";
        
        /*
         * @title Testing Oraclize
         * Test contract to understand the basics of leveraging the Oraclize service.
         */
        
        contract Betting is usingOraclize {
            
            address public owner = msg.sender;
            address internal player;
            string  internal betquestion;
            uint    internal oraclizeresult; 
            uint    internal playerbet;
            uint    internal reward;

        
        /*Events*/
            event Log(string);
            event CorrectAnswer(uint);
            event BetQuestion(string);
            
        
        /*Modifier*/
                modifier onlyOwner {
                    require(msg.sender == owner);
                    _;
                }

        
        /*Put Bet*/  
                function putBet (uint _playerbet) public payable {
                    
                    /* Ensure that contract creator cannot put bet */
                    require (msg.sender != owner);
                    
                    /* Ensure that msg.value is greater than zero */
                    require(msg.value > 0);
                         
                    /* Ensure that player has sufficient balance to put his bet */
                    require ((msg.sender.balance) >= msg.value);
                        
                    /* Ensure that game contract has sufficient balance to give reward twice the bet amount */
                    reward = SafeMath.mul(1,msg.value);  
                    require (this.balance >= reward);
                    
                    /* If above two conditions are met transfer bet amount to work variable*/
                    playerbet = _playerbet;
                        
                    }
                    

        /*Set Bet Question - can be invoked only by contract owner */  
                function setBetQuestion (string _question) public {
                    
                    require (msg.sender == owner);
                    betquestion = _question;
                    
                    }
                    
                    
        /*Play Bet*/            
                function playBet() public  payable {
                    
                    require(msg.value == 0);
                    require(playerbet != 0);
                    
                    if (oraclize_getPrice("WolframAlpha") > this.balance) {
                    Log("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
                    }else{
                    Log("Oraclize query was sent, standing by for the answer..");    
                    oraclize_query("WolframAlpha", betquestion);
                    }    
                    
                }       

            
        /* Oraclize callback.
        * @param _myid The query id.
        * @param _result The result of the query.
        * @param _proof Oraclie generated proof. Stored in ipfs in this case.
        * Therefore is the ipfs multihash.
        */
                function __callback(
                    bytes32 _myid,
                    string _result,
                    bytes _proof
                  ) public
                  {
                    require(msg.sender == oraclize_cbAddress());
                    oraclizeresult = parseInt(_result); 
                    
                    BetQuestion(betquestion);
                    CorrectAnswer(oraclizeresult);
                    
                    if (playerbet == oraclizeresult) {
                        player.transfer(reward);
                        Log('Your answer is correct. You have Won');
                    } else {
                        Log('Your answer is incorrect. You have Lost');
                    }
                   
                  }
        
        /*Get Balance*/
                function getBalance () constant returns(address, uint256){
                        return (msg.sender, msg.sender.balance);
                }
                
        /*Get Balance by Address*/
                function getbalbyAddress (address _address) constant returns(uint256){
                        return (_address.balance);
                }
                    
        /*Destroy the function - only by contract creator*/    
                function destroy() {
                    require (msg.sender == owner);
                    selfdestruct(owner);
                }
                
                
        /*Transfer function to transfer amount to contract or to a player - can be invoked only by contract creator*/    
                function transferbetamount(address _address, uint _amount) payable returns (address, uint) {
                    require (msg.sender == owner);
                    _address.transfer(_amount);
                    return(_address, _amount);
                }
                
                
        /*Payable Fallback function*/
                function()  payable{    
                    
                    }
                    
        }
                    
                    
