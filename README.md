# CarFax Smart Contract

CarFax is a Solidity-based smart contract for managing vehicle records and reports on the blockchain. This contract allows authorized users to add vehicle information, record reports, and retrieve these reports for a fee.

## Features

- **Add Vehicles**: Authorized users can add new vehicle records.
- **Add Reports**: Record maintenance, repair, or any other reports for vehicles.
- **Retrieve Reports**: Retrieve all reports for a specific vehicle with payment.
- **Authorization Management**: Owners can authorize or revoke access for employees.

## Table of Contents

- [Contract Details](#contract-details)
- [Setup](#setup)
- [Usage](#usage)
  - [Adding a Vehicle](#adding-a-vehicle)
  - [Adding a Report](#adding-a-report)
  - [Retrieving Reports](#retrieving-reports)
  - [Managing Authorization](#managing-authorization)
- [Events](#events)
- [License](#license)

---

## Contract Details

- **License**: GPL-3.0
- **Pragma**: `>=0.7.0 <0.9.0`
- **Contract Name**: `CarFax`
- **Compiler Version**: `0.8.19` (evm: `paris`)

## Usage

### Adding a Vehicle

Authorized users can add vehicles using the `addVehicle` function.

#### Parameters:

- `_vin` (string): Vehicle Identification Number.
- `_color` (string): Vehicle color.
- `_brand` (string): Vehicle brand.
- `_model` (string): Vehicle model.
- `_makeYear` (string): Vehicle manufacturing year.

#### Example:

```solidity
addVehicle("1HGCM82633A123456", "Red", "Honda", "Accord", "2003");
```

### Adding a Report

Authorized users can add reports for a specific vehicle using the `addReport` function.

#### Parameters:

- `_vin` (string): Vehicle Identification Number.
- `_amount` (uint): Amount for the report (Eg. cost of maintenance).
- `_comment` (string): Comment about the report.

#### Example:

```solidity
addReport("1HGCM82633A123456", 10000000000000000, "Oil change");
```

### Retrieving Reports

Any user can retrieve reports by paying the required `reportFee`.

#### Parameters:

- `_vin` (string): Vehicle Identification Number.

#### Example:

```solidity
getReports("1HGCM82633A123456");
```

#### Notes:

- Payment must be at least `reportFee` (0.01 ether).
- Emits `ReportRetrieved` events for each report.

### Managing Authorization

#### Authorizing Employees

Only the contract owner can authorize employees using the `authorizeEmployee` function.

#### Parameters:

- `_employee` (address): Address of the employee to authorize.

#### Example:

```solidity
authorizeEmployee(0x123...456);
```

#### Revoking Authorization

Only the contract owner can revoke employee authorization using the `revokeAuthorization` function.

#### Parameters:

- `_employee` (address): Address of the employee to revoke.

#### Example:

```solidity
revokeAuthorization(0x123...456);
```

## Events

- `ReportRetrieved`: Emitted when a report is retrieved.
  - `reportedAt`: Timestamp of the report.
  - `amount`: Amount associated with the report.
  - `comment`: Comment about the report.
  - `brand`: Vehicle brand.
  - `model`: Vehicle model.
  - `color`: Vehicle color.

## License

This project is licensed under the [GPL-3.0 License](https://www.gnu.org/licenses/gpl-3.0.en.html).

---
