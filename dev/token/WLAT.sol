// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WLAT {
    
    event  Deposit(address indexed src, uint amount);
    event  Transfer(address indexed to, uint amount);

    function deposit(address src, uint amount) internal {
        emit Deposit(src, amount);
    }

    function transfer(address to, uint amount) internal returns (bool) {
        require(totalSupply() >= amount);
        payable(to).transfer(amount);
        emit Transfer(to, amount);
        return true;
    }

    function totalSupply() public view returns (uint) {
        return address(this).balance;
    }
}
