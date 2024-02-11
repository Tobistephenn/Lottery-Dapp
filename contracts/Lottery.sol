// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

contract lottery {
    address public manager;
    address payable [] public candidates;
    address payable public winner;

    constructor () {
        manager = msg.sender;
    }

    receive () external payable {
        require(msg.value == 1 ether);
        candidates.push(payable(msg.sender));
    }

    function getBalance () public view returns (uint) {
        require(msg.sender == manager);
        return address(this).balance;
    }

    function getRandom () public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, candidates.length)));
    }

    function pickWinner () public {
        require(msg.sender == manager);
        require(candidates.length >= 2);
        uint r = getRandom ();
        uint index = r % candidates.length;
        winner = candidates[index];
        winner.transfer(getBalance());
        candidates = new address payable [](0);
    }
}