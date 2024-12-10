// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract CarFax {
    address public owner;
    uint public reportFee = 0.01 ether;

    struct Vehicle {
        string color;
        string brand;
        string model;
        string makeYear;
        Report[] reports;
    }

    struct Report {
        uint createdOn;
        uint amount;
        string comment;
    }

    mapping(string => Vehicle) public vehicles;
    mapping(address => bool) private authorizedEmployees;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can do this.");
        _;
    }

    modifier onlyAuthorized() {
        require(authorizedEmployees[msg.sender] || msg.sender == owner, "Unauthorized");
        _;
    }

    function addVehicle(
        string memory _vin,
        string memory _color,
        string memory _brand,
        string memory _model,
        string memory _makeYear
    ) public onlyAuthorized {
        require(bytes(vehicles[_vin].brand).length == 0, "Vehicle exists");
        
        vehicles[_vin].color = _color;
        vehicles[_vin].brand = _brand;
        vehicles[_vin].model = _model;
        vehicles[_vin].makeYear = _makeYear;
    }

    function addReport(
        string memory _vin, 
        uint _amount, 
        string memory _comment
    ) public onlyAuthorized {
        require(bytes(vehicles[_vin].brand).length > 0, "Vehicle not found");
        vehicles[_vin].reports.push(Report({
            createdOn: block.timestamp,
            amount: _amount,
            comment: _comment
        }));
    }

    function getReports(string memory _vin)
        public
        payable
        returns (
            uint[] memory createdOn,
            uint[] memory amounts,
            string[] memory comments,
            string memory brand,
            string memory model,
            string memory color
        )
    {
        require(msg.value >= reportFee, "Insufficient payment");

        Vehicle storage vehicle = vehicles[_vin];
        require(bytes(vehicle.brand).length > 0, "Vehicle not found");

        payable(owner).transfer(msg.value);

        uint reportCount = vehicle.reports.length;

        createdOn = new uint[](reportCount);
        amounts = new uint[](reportCount);
        comments = new string[](reportCount);

        for (uint i = 0; i < reportCount; i++) {
            createdOn[i] = vehicle.reports[i].createdOn;
            amounts[i] = vehicle.reports[i].amount;
            comments[i] = vehicle.reports[i].comment;
        }

        return (
            createdOn,
            amounts,
            comments,
            vehicle.brand,
            vehicle.model,
            vehicle.color
        );
    }

    function authorizeEmployee(address _employee) public onlyOwner {
        authorizedEmployees[_employee] = true;
    }

    function revokeAuthorization(address _employee) public onlyOwner {
        authorizedEmployees[_employee] = false;
    }
}