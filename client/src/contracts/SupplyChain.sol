// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SupplyChain {
    event Added(uint256 index);

    struct State {
        string description;
        address person;
    }

    struct Product {
        address creator;
        string productName;
        uint256 productId;
        string date;
        uint256 totalStates;
        mapping(uint256 => State) positions;
    }

    mapping(uint256 => Product) allProducts;
    uint256 numOfItems;
    uint256 items = 0;

    function concat(string memory _a, string memory _b)
        public
        pure
        returns (string memory)
    {
        bytes memory bytes_a = bytes(_a);
        bytes memory bytes_b = bytes(_b);
        string memory length_ab = new string(bytes_a.length + bytes_b.length);
        bytes memory bytes_c = bytes(length_ab);
        uint256 k = 0;
        for (uint256 i = 0; i < bytes_a.length; i++) bytes_c[k++] = bytes_a[i];
        for (uint256 i = 0; i < bytes_b.length; i++) bytes_c[k++] = bytes_b[i];
        return string(bytes_c);
    }

    function newItem(string memory _text, string memory _date)
        public
        returns (bool)
    {
        Product storage p = allProducts[numOfItems++];
        p.creator = msg.sender;
        p.totalStates = 0;
        p.productName = _text;
        p.productId = items;
        p.date = _date;
        items = items + 1;
        emit Added(items - 1);
        return true;
    }

    function addState(uint256 _productId, string memory info)
        public
        returns (string memory)
    {
        require(_productId <= items);
        State memory newState = State({person: msg.sender, description: info});
        allProducts[_productId].positions[
            allProducts[_productId].totalStates
        ] = newState;
        allProducts[_productId].totalStates =
            allProducts[_productId].totalStates +
            1;
        return info;
    }

    function searchProduct(uint256 _productId)
        public
        view
        returns (string memory)
    {
        require(_productId <= items);
        string memory output = "Product Name: ";
        output = concat(output, allProducts[_productId].productName);
        output = concat(output, "<br>Manufacture Date: ");
        output = concat(output, allProducts[_productId].date);

        for (uint256 j = 0; j < allProducts[_productId].totalStates; j++) {
            output = concat(output, "<br>Warehouse Location: ");
            output = concat(
                output,
                allProducts[_productId].positions[j].description
            );
        }
        return output;
    }

    function sayHello() public pure returns (string memory) {
        // dummy function for checking blockcahin.
        return "Hello World!";
    }

    function getProductId() public view returns (uint256) {
        return items + 1;
    }

    constructor() public {}
}
