# CarFax Smart Contract Documentation

## Overview

The `CarFax` contract is a vehicle history tracking system that allows authorized employees to manage vehicle data and add reports for specific vehicles. Users can query these reports by paying a fee. The contract is designed to ensure secure management of data with role-based access control.

---

## Table of Contents

- [Contract Information](#contract-information)
- [State Variables](#state-variables)
- [Structs](#structs)
- [Modifiers](#modifiers)
- [Functions](#functions)
  - [Constructor](#constructor)
  - [Add Vehicle](#add-vehicle)
  - [Add Report](#add-report)
  - [Get Reports](#get-reports)
  - [Authorize Employee](#authorize-employee)
  - [Revoke Authorization](#revoke-authorization)
- [Access Control](#access-control)
- [Payment Handling](#payment-handling)
- [Security Considerations](#security-considerations)

---

## Contract Information

- **License**: GPL-3.0
- **Solidity Version**: ^0.7.0 to <0.9.0

---

## State Variables

### `owner`

- **Type**: `address`
- **Description**: Address of the contract owner with administrative privileges.

### `reportFee`

- **Type**: `uint`
- **Initial Value**: `0.01 ether`
- **Description**: Fee required to retrieve vehicle reports.

### `vehicles`

- **Type**: `mapping(string => Vehicle)`
- **Description**: Stores vehicle data indexed by their VIN.

### `authorizedEmployees`

- **Type**: `mapping(address => bool)`
- **Description**: Tracks employees authorized to manage vehicle and report data.

---

## Structs

### `Vehicle`

- **Fields**:
  - `color`: `string` - Color of the vehicle.
  - `brand`: `string` - Brand of the vehicle.
  - `model`: `string` - Model of the vehicle.
  - `makeYear`: `string` - Manufacture year of the vehicle.
  - `reports`: `Report[]` - Array of reports associated with the vehicle.

### `Report`

- **Fields**:
  - `createdOn`: `uint` - Timestamp of when the report was created.
  - `amount`: `uint` - Monetary value related to the report (e.g., damages).
  - `comment`: `string` - Description or details of the report.

---

## Modifiers

### `onlyOwner`

- **Description**: Restricts access to the contract owner.
- **Reverts**: If `msg.sender` is not the owner.

### `onlyAuthorized`

- **Description**: Restricts access to authorized employees and the owner.
- **Reverts**: If `msg.sender` is not authorized.

---

## Functions

### Constructor

```solidity
constructor() {
    owner = msg.sender;
    reportFee = 0.01 ether;
}
```

- **Description**: Initializes the contract with the owner's address and the report fee.

### Add Vehicle

```solidity
function addVehicle(string memory _vin, string memory _color, string memory _brand, string memory _model, string memory _makeYear) public onlyAuthorized {
    // Implementation details
}
```

- **Description**: Adds a new vehicle to the system.
- **Parameters**:
  - `_vin`: VIN (Vehicle Identification Number) of the vehicle.
  - `_color`: Color of the vehicle.
  - `_brand`: Brand of the vehicle.
  - `_model`: Model of the vehicle.
  - `_makeYear`: Manufacture year of the vehicle.

### Add Report

```solidity
function addReport(string memory _vin, uint _amount, string memory _comment) public onlyAuthorized {
    // Implementation details
}
```

- **Description**: Adds a new report for a specific vehicle.
- **Parameters**:
  - `_vin`: VIN of the vehicle.
  - `_amount`: Monetary value related to the report.
  - `_comment`: Description or details of the report.

### Get Reports

```solidity
function getReports(string memory _vin) public payable returns (Report[] memory) {
    // Implementation details
}
```

- **Description**: Retrieves all reports associated with a vehicle.
- **Parameters**:
  - `_vin`: VIN of the vehicle.
- **Returns**: Array of `Report` structs.

### Authorize Employee

```solidity
function authorizeEmployee(address _employee) public onlyOwner {
    // Implementation details
}
```

- **Description**: Grants an address permission to manage vehicle and report data.
- **Parameters**:
  - `_employee`: Address of the employee to authorize.

### Revoke Authorization

```solidity
function revokeAuthorization(address _employee) public onlyOwner {
    // Implementation details
}
```

- **Description**: Revokes an employee's authorization to manage vehicle and report data.
- **Parameters**:
  - `_employee`: Address of the employee to deauthorize.

---

## Access Control

- The contract owner has full administrative privileges.
- Authorized employees can manage vehicle data and add reports.

---

## Payment Handling

- A fee is required to retrieve vehicle reports.
- The fee is set to `0.01 ether` by default.

---

## Security Considerations

- Access control is enforced through modifiers to restrict unauthorized access.

---

## Disclaimer

This document is for informational purposes only and does not constitute financial advice. Readers are encouraged to do their research and due diligence before interacting with the smart contract.
