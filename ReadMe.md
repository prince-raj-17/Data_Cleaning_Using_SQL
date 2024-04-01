# Data Cleaning in SQL

This repository contains SQL scripts for data cleaning tasks performed on the Nashville housing dataset.

## Overview

The dataset used for this cleaning process is `nashville_housing` within the `ProjectsDB` database. The following tasks are executed to clean the data:

1. **Standardize Date Format**: Conversion of the `SaleDate` column to a standard date format.
2. **Populate Property Address Data**: Filling missing values in the `PropertyAddress` column using data from similar records.
3. **Breaking out Address into Individual Columns**: Splitting the `PropertyAddress` column into `Address` and `City`.
4. **Splitting Owner Address**: Separating `OwnerAddress` into `OwnerSplitAddress`, `OwnerSplitCity`, and `OwnerSplitState`.
5. **Change Y and N to Yes and No in "Sold as Vacant" Field**: Updating 'Y' and 'N' values in the `SoldAsVacant` column to 'Yes' and 'No' respectively.
6. **Remove Duplicates**: Removing duplicate records based on certain criteria.
7. **Delete Unused Columns**: Removing unnecessary columns (`OwnerAddress`, `TaxDistrict`, `PropertyAddress`, `SaleDate`).

## File Description

- `data_cleaning_script.sql`: SQL script containing all the queries for data cleaning tasks.
- `Raw_NH_Data`: Excel file containg raw data of Nashville housing.
- `NH_Data_After_Cleaning`: This excel file contains cleaned data of Nashville housing after execting sql qeries.

## Dataset

The dataset used for this cleaning process is stored in the `nashville_housing` table within the `ProjectsDB` database.

## Credits

This data cleaning process was performed by Prince Raj`.