// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract CarFax {
    address private owner;
    uint public reportFee = 0.01 ether;

    struct Vehicle {
        string color;
        string brand;
        string model;
        string makeYear;
        Report[] reports;
    }

    struct Report {
        uint reportedAt;
        uint amount;
        string comment;
    }

    mapping(string => Vehicle) public vehicles;
    mapping(address => bool) private authorizedEmployees;

    event ReportRetrieved(
        uint reportedAt,
        uint amount,
        string comment,
        string brand,
        string model,
        string color
    );

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

        vehicles[_vin].reports.push(
            Report({
                reportedAt: block.timestamp,
                amount: _amount,
                comment: _comment
            })
        );
    }

    function getReports(string memory _vin) public payable {
        require(msg.value >= reportFee, "Insufficient payment");
        require(bytes(vehicles[_vin].model).length > 0, "Vehicle not found");

        Vehicle storage vehicle = vehicles[_vin];

        payable(owner).transfer(msg.value);

        for (uint i = 0; i < vehicle.reports.length; i++) {
            Report memory report = vehicle.reports[i];
            emit ReportRetrieved(
                report.reportedAt,
                report.amount,
                report.comment,
                vehicle.brand,
                vehicle.model,
                vehicle.color
            );
        }
    }

    function authorizeEmployee(address _employee) public onlyOwner {
        authorizedEmployees[_employee] = true;
    }

    function revokeAuthorization(address _employee) public onlyOwner {
        authorizedEmployees[_employee] = false;
    }
}
