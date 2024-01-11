pragma solidity ^0.8.23;

contract bank {
    mapping (address => uint) public balance;
    address[3] public riches;
    address owner;
    address fund;

    constructor () {
        owner = msg.sender;
        fund = msg.sender;
    }

    receive() external payable { }
    // 存款
    function save() public  payable  virtual {}

    // 提款，只有管理员可以提取
    function withdraw() public      {
        require(msg.sender == owner, "Operation without permission!");
        // ba.transfer(ba.balance);
        uint256 amount = address(this).balance;
        //谁要钱谁发起，发起的会调用实例this，指的是合约
        payable(owner).transfer(amount);
    }
}


contract bigBank is bank {
    modifier moreEth() {
        uint256 requireEth = 0.001 ether;
        require(msg.value > requireEth, "Transfer ether shuld more than 0.001 ETH");
        _;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function save() public payable override moreEth {
        balance[msg.sender] = msg.value;
        uint minBalance = msg.value;
        uint index = 4;
        // 循环判断最小
        for(uint i = 0; i < 3; i++){
            if (riches[i] == msg.sender) {
                balance[msg.sender] = msg.value + balance[msg.sender];
                return;
            }
            //100,300,500.400,替换掉。
            if(minBalance > balance[riches[i]]){
                minBalance = balance[riches[i]];
                index = i;
            }
        }
        if(index < 3){
            riches[index] = msg.sender;
        }
    }

     function changeOwner(address ownableContract) public  {
        owner = ownableContract;
    }

}

contract ownable {
    receive() external payable { }
    function withdrawOwnable(address con) public  {
       IBank(con).withdraw();
    }
}


interface IBank {
    function withdraw() external ;
    
}