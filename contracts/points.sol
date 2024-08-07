// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract DegenToken {
    string public constant name = "Degen";
    string public constant symbol = "DGN";
    uint8 public constant decimals = 6;
    address public owner;
    uint public totalSupply;
    mapping (address => uint) public balanceOf;

    struct Item {
        uint itemId;
        string itemName;
        uint itemPrice;
    }

    event Transfer(address indexed from, address indexed to, uint amount);
    event ItemRedeemed(address indexed player, uint itemId, string itemName);

    mapping(uint => Item) public items;
    uint public itemCount;
    mapping(address => mapping(uint => bool)) public redeemedItems;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can execute this function");
        _;
    }

    function transfer(address recipient, uint amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "The balance is insufficient");

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function mint(address receiver,uint amount) external onlyOwner {
        balanceOf[receiver] += amount;
        totalSupply += amount;
        emit Transfer(address(0), receiver, amount);
    }

    function burn(uint amount) external {
        require(amount > 0, "Amount should not be zero");
        require(balanceOf[msg.sender] >= amount, "The balance is insufficient");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }

    function addItem(string memory itemName, uint256 itemPrice) external onlyOwner {
        itemCount++;
        Item memory newItem = Item(itemCount, itemName, itemPrice);
        items[itemCount] = newItem;
    }

    function getItems() external view returns (Item[] memory) {
        Item[] memory allItems = new Item[](itemCount);

        for (uint i = 1; i <= itemCount; i++) {
            allItems[i - 1] = items[i];
        }

        return allItems;
    }

    function redeem(uint itemId) external {
        require(itemId > 0 && itemId <= itemCount, "Invalid item ID");
        Item memory redeemedItem = items[itemId];

        require(balanceOf[msg.sender] >= redeemedItem.itemPrice, "Insufficient balance to redeem");
        require(!redeemedItems[msg.sender][itemId], "Item already redeemed");

        balanceOf[msg.sender] -= redeemedItem.itemPrice;
        balanceOf[owner] += redeemedItem.itemPrice;
        redeemedItems[msg.sender][itemId] = true;

        emit Transfer(msg.sender, owner, redeemedItem.itemPrice);
        emit ItemRedeemed(msg.sender, itemId, redeemedItem.itemName);
    }

    function hasRedeemed(address player, uint itemId) external view returns (bool) {
        return redeemedItems[player][itemId];
    }
}
