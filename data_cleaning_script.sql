/*
Data Cleaning in SQL
*/

-- Selecting database
use ProjectsDB;

-- Overview of data
select *
from nashville_housing;

------------------------------------------------------------------------------------------------------------------------------------


-- Standardize Date Format
alter table nashville_housing
add SaleDateConverted Date;

update nashville_housing
set SaleDateConverted = convert(date, SaleDate);

select SaleDateConverted
from nashville_housing;

update nashville_housing
set SaleDate = convert(date, SaleDate);

------------------------------------------------------------------------------------------------------------------------------------


-- Populate Property address data
select *
from nashville_housing
where PropertyAddress is null;

select *
from nashville_housing
order by ParcelID;

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from nashville_housing a
join nashville_housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from nashville_housing a
join nashville_housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

------------------------------------------------------------------------------------------------------------------------------------


-- Breaking out Address into Individual Columns (Address, City, State)
select PropertyAddress
from nashville_housing;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
from nashville_housing;

ALTER TABLE nashville_housing
Add PropertySplitAddress Nvarchar(255);

Update nashville_housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 );

ALTER TABLE nashville_housing
Add PropertySplitCity Nvarchar(255);

Update nashville_housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress));

select *
from nashville_housing;


-- Spliting Owner Address
select OwnerAddress
from nashville_housing;

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from nashville_housing;


ALTER TABLE nashville_housing
Add OwnerSplitAddress Nvarchar(255);

Update nashville_housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);


ALTER TABLE nashville_housing
Add OwnerSplitCity Nvarchar(255);

Update nashville_housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);


ALTER TABLE nashville_housing
Add OwnerSplitState Nvarchar(255);

Update nashville_housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);


Select *
from nashville_housing;

------------------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from nashville_housing
Group by SoldAsVacant
order by 2;

Select SoldAsVacant, 
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
from nashville_housing;

Update nashville_housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;

------------------------------------------------------------------------------------------------------------------------------------


-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
					) row_num
					
from nashville_housing
)
Delete
From RowNumCTE
Where row_num > 1;

-- Checking if any row_num twice exist, as they are removed
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
					) row_num
					
from nashville_housing;

------------------------------------------------------------------------------------------------------------------------------------


-- Delete Unused Columns
Alter Table nashville_housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;


-- Final data in table
select *
from nashville_housing
order by ParcelID;