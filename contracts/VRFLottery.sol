// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./../openzeppelin/contracts/access/Ownable.sol";
import "./../chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract VRFLottery is Ownable, VRFConsumerBase {
    string public name = "My Hardhat Token";

    uint256 public start = 0;
    uint256 public duration = 0;
    uint256 constant public amount = 0.1 ether;

    bool public isInitialized = false;
    mapping(address => bool) public isParticipated;
    mapping(uint256 => address) public participants;
    uint256 public partCount = 0;
    bool public isResultOut;
    bool private isDrawn;
    uint256 private winnerIndex;

    bytes32 internal keyHash;
    uint256 internal fee;
    
    constructor () VRFConsumerBase (
            0x8C7382F9D8f56b33781fE506E897a4F1e2d17255, // VRF Coordinator
            0x326C977E6efc84E512bB9C30f76E30c160eD06FB  // LINK Token
        )
    {
        keyHash = 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4;
        fee = 0.0001 * 10 ** 18; // 0.0001 LINK
    }

    receive() external payable {}

    function initialize(uint256 _start, uint256 _duration) external onlyOwner {
        require(!isInitialized, "Already initialized");
        isInitialized = true;
        require(_start > block.timestamp, "Event can't be in past");
        start = _start;
        duration = _duration;

        emit Initialized(start, duration);
    }

    function isLive() public view returns(bool) {
        if(block.timestamp >= start && block.timestamp < start + duration){
            return true;
        }
        return false;
    }

    function participate() external payable {
        require(isLive(), "Event is not live");
        require(!isParticipated[msg.sender], "Taken part already");
        require(msg.value == amount, "Invalid Amount");
        participants[partCount++] = msg.sender;
        isParticipated[msg.sender] = true;

        emit Participate(msg.sender, block.timestamp);
    }

    function draw() external onlyOwner {
        require(!isDrawn);
        require(isInitialized, "Event was not initialized");
        require(!isLive(), "Event is still live");
        isDrawn = true;

        getRandomNumber();
    }

    function winnerWho() external view returns(address) {
        require(isResultOut, "Result not out yet");
        return participants[winnerIndex];
    }

    function _sendEth(address _addr, uint256 _amt) private {
        bool sent = payable(_addr).send(_amt);
        require(sent, "Failed to send Ether");
    }

    /** 
     * Requests randomness 
     */
    function getRandomNumber() private returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK");
        return requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        isResultOut = true;
        uint256 _rd = randomness;
        winnerIndex = _rd % partCount;
        address _addr = participants[winnerIndex];
        _sendEth(_addr, address(this).balance);

        emit Winner(_addr);
    }


    event Initialized(uint256 start, uint256 duration);
    event Participate(address indexed addr, uint256 time);
    event Winner(address winner);

}