// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract CarFax {
    // Vehicle struct
    struct Vehicle {
        string color;
        string brand;
        string model;
        string makeYear;
        Report[] reports; // Reports for the vehicle
        mapping(address => uint) reportCountByEmployee; // Number of reports by each employee
        address[] uniqueReporters; // Unique employees who contributed for the vehicle
    }

    // Report struct
    struct Report {
        uint id;
        uint reportedAt; // Timestamp when the report was made
        uint amount; // Amount of the report
        string comment; // Comment on the report (ex: 'oil change')
        address reporter; // Tracks who created the report
    }

    address private owner; // Owner of the contract
    uint public minimumReportFee = 0.01 ether; // Fee to retrieve vehicle reports by users

    uint private reportIdCounter = 0;
    mapping(string => Vehicle) private vehicles;
    mapping(address => bool) private authorizedEmployees;

    // === Events ===
    event ReportRetrieved(
        uint id,
        address reporter,
        uint reportedAt,
        uint amount,
        string comment,
        string brand,
        string model,
        string color,
        string vin
    );

    event FundTransfered(uint amount, address from, address to);

    constructor() {
        owner = msg.sender;
    }

    // === Modifiers ===
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can do this.");
        _;
    }

    modifier onlyAuthorized() {
        require(
            authorizedEmployees[msg.sender] || msg.sender == owner,
            "Unauthorized"
        );
        _;
    }

    // === Functions ===
    function addVehicle(
        string memory _vin,
        string memory _color,
        string memory _brand,
        string memory _model,
        string memory _makeYear
    ) public onlyAuthorized {
        require(
            bytes(vehicles[_vin].brand).length == 0,
            "Vehicle already exists"
        );

        // Create a new vehicle
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
        Vehicle storage vehicle = vehicles[_vin];

        reportIdCounter++;

        // Record the report
        vehicle.reports.push(
            Report({
                id: reportIdCounter,
                reportedAt: block.timestamp,
                amount: _amount,
                comment: _comment,
                reporter: msg.sender
            })
        );

        // Track unique employees
        if (vehicle.reportCountByEmployee[msg.sender] == 0) {
            vehicle.uniqueReporters.push(msg.sender);
        }

        // Track number of reports for employee
        vehicle.reportCountByEmployee[msg.sender]++;
    }

    function getReports(string memory _vin) public payable {
        // Validations
        require(msg.value >= minimumReportFee, "Insufficient payment");
        require(bytes(vehicles[_vin].brand).length > 0, "Vehicle not found");

        // Find the vehicle
        Vehicle storage vehicle = vehicles[_vin];

        // Total number of reports
        uint totalReports = vehicle.reports.length;
        require(totalReports > 0, "No reports for this vehicle");

        // Transfer proportional fees to each employee
        for (uint i = 0; i < vehicle.uniqueReporters.length; i++) {
            address reporter = vehicle.uniqueReporters[i];

            // Check if employee is still authorized for payment
            if (!authorizedEmployees[reporter]) {
                continue;
            }

            uint reportCountByEmployee = vehicle.reportCountByEmployee[
                reporter
            ];
            uint reporterShare = (reportCountByEmployee * msg.value) /
                totalReports;

            if (reporterShare > 0) {
                emit FundTransfered(reporterShare, owner, reporter);
                payable(reporter).transfer(reporterShare);
            }
        }

        // Retrieve reports
        for (uint i = 0; i < vehicle.reports.length; i++) {
            Report memory report = vehicle.reports[i];
            emit ReportRetrieved(
                report.id,
                report.reporter,
                report.reportedAt,
                report.amount,
                report.comment,
                vehicle.brand,
                vehicle.model,
                vehicle.color,
                _vin
            );
        }
    }

    function authorizeEmployee(address _employee) public onlyOwner {
        authorizedEmployees[_employee] = true;
    }

    function revokeAuthorization(address _employee) public onlyOwner {
        authorizedEmployees[_employee] = false;
    }

    // prevent lock
    receive() external payable {}
}
