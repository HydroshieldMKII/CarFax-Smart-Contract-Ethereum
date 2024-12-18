# CarFax Smart Contract

The **CarFax** smart contract is designed to maintain a decentralized registry of vehicle reports. It enables the creation, tracking, and retrieval of maintenance reports for vehicles while ensuring fair compensation for authorized employees.

## Table of Contents

- [Problem Statement](#problem-statement)
- [Solution](#solution)
- [Features](#features)
- [Contract Details](#contract-details)
  - [SPDX License](#spdx-license)
  - [Solidity Version](#solidity-version)
  - [Key Variables](#key-variables)
- [Structs](#structs)
  - [Vehicle](#vehicle)
  - [Report](#report)
- [Events](#events)
- [Modifiers](#modifiers)
- [Key Functions](#key-functions)
  - [addVehicle](#addvehicle)
  - [addReport](#addreport)
  - [retrieveReport](#retrievereport)
  - [authorizeEmployee](#authorizeemployee)
  - [revokeEmployee](#revokeemployee)
- [Deployment](#deployment)
- [Security Features](#security-features)
- [Additional Notes](#additional-notes)
- [Example Use Case](#example-use-case)

## Problem Statement

Traditional vehicle maintenance records are often centralized and prone to manipulation or loss. Employees who contribute to these records may not receive fair compensation for their efforts. A decentralized solution is needed to ensure transparency, data integrity, and equitable payment distribution.

## Solution

The **CarFax** smart contract provides a secure and transparent platform for managing vehicle maintenance reports. It allows authorized employees to add reports for vehicles, which can be retrieved by users for a fee. The fees are distributed among the employees who contributed to the reports, ensuring fair compensation. The contract also includes features for adding and managing vehicle details, authorizing employees, and revoking access when needed.

## Features

- **Vehicle Management**: Add and manage vehicle details.
- **Report Management**: Create detailed reports for vehicles, including timestamps, costs, and comments.
- **Payment Distribution**: Distribute report retrieval fees proportionally among contributing employees.
- **Employee Authorization**: Add or revoke employee access to manage vehicles and reports.

## Contract Details

### SPDX License

- License: `GPL-3.0`

### Solidity Version

- Pragma: `^0.7.0`

### Key Variables

- `owner`: Contract owner (creator) with administrative privileges.
- `minimumReportFee`: Minimum fee required for users to retrieve vehicle reports (default: 0.01 Ether).
- `vehicles`: A mapping of VIN (Vehicle Identification Number) to `Vehicle` structs.
- `authorizedEmployees`: Tracks employee addresses with permission to manage vehicles and reports.

## Structs

### Vehicle

Stores detailed information about a vehicle:

- **color**: Color of the vehicle.
- **brand**: Manufacturer brand.
- **model**: Model name.
- **makeYear**: Year of manufacture.
- **reports**: Array of maintenance reports.
- **reportCountByEmployee**: Mapping of employee addresses to the count of reports they’ve contributed.
- **uniqueReporters**: List of unique employee addresses who have reported for the vehicle.

### Report

Details of a maintenance report:

- **id**: Unique report identifier.
- **reportedAt**: Timestamp of the report creation.
- **amount**: Cost of the maintenance activity.
- **comment**: Description of the maintenance activity (e.g., "Oil Change").
- **reporter**: Address of the employee who created the report.

## Events

- `ReportRetrieved`: Triggered when reports are retrieved by users, including detailed report and vehicle information.
- `FundTransfered`: Emitted when report retrieval fees are distributed among employees.

## Modifiers

- `onlyOwner`: Restricts functions to the contract owner.
- `onlyAuthorized`: Restricts functions to authorized employees or the owner.

## Key Functions

### addVehicle

Adds a new vehicle to the registry. The VIN is used as a unique identifier and must be provided.

```solidity
function addVehicle(
    string memory _vin,
    string memory _color,
    string memory _brand,
    string memory _model,
    string memory _makeYear
) public onlyAuthorized
```

### addReport

Adds a maintenance report for a vehicle. The `minimumFee` is required to create a report. The person who adds the report is considered the reporter and must be an authorized employee.

```solidity
function addReport(
    string memory _vin,
    uint256 _amount,
    string memory _comment
) public onlyAuthorized
```

### retrieveReport

Retrieves a vehicle report and distributes fees among employees.

```solidity
function retrieveReport(string memory _vin) public payable
```

### authorizeEmployee

Authorizes an employee to manage vehicles and reports.

```solidity
function authorizeEmployee(address _employee) public onlyOwner
```

### revokeEmployee

Revokes an employee's authorization to manage vehicles and reports.

```solidity
function revokeEmployee(address _employee) public onlyOwner
```

## Deployment

The contract can be deployed on the Ethereum blockchain using Remix or other Solidity development environments.

## Security Features

- **Ownership Control**: Only the owner can authorize or revoke employee access.
- **Fee Validation**: Ensures users pay the minimum fee before accessing reports.
- **Payment Distribution**: Fairly distributes report fees among contributing employees.

## Additional Notes

- Contract includes a `receive()` function to prevent Ether from being locked.
- Reports are tied to a unique VIN, ensuring data consistency and integrity.

## Example Use Case

1. **Vehicle Addition**: Authorized employee adds a vehicle.
2. **Report Creation**: Employee submits a maintenance report for the vehicle.
3. **Report Retrieval**: User pays the fee to retrieve the report. The fee is distributed among contributing employees.
