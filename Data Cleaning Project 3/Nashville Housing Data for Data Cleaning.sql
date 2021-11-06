/*
Cleaning Data in SQL Queries
*/


Select *
From NashvillePortfolioProject..NashvilleHousing

-- Standardize Date Format

Select SaleDate, Convert(Date,SaleDate)
From NashvillePortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add Sale_Date Date;

Update NashvilleHousing
Set Sale_Date = Convert(Date,SaleDate)

select sale_date
from NashvilleHousing

-- Populate Property Address data

Select propertyaddress
From NashvilleHousing
where propertyaddress is null

Select *
From NashvillePortfolioProject.dbo.NashvilleHousing
Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
From NashvillePortfolioProject.dbo.NashvilleHousing a
Join NashvillePortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET propertyaddress = ISNULL(a.propertyaddress, b.PropertyAddress)
From NashvillePortfolioProject.dbo.NashvilleHousing a
Join NashvillePortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From NashvillePortfolioProject..NashvilleHousing

Select
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
From NashvillePortfolioProject..NashvilleHousing

Alter Table nashvillehousing
ADD Address nvarchar(255);

Alter Table nashvillehousing
Add New_PropertyAddress nvarchar(255);

Update NashvilleHousing
Set New_PropertyAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1)

Alter Table nashvillehousing
ADD City nvarchar(255);

Update NashvilleHousing
Set City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select OwnerAddress
From NashvilleHousing

SELECT
parsename(Replace(owneraddress, ',', '.'), 3) as Address
,parsename(Replace(owneraddress, ',', '.'), 2) as City
,parsename(Replace(owneraddress, ',', '.'), 1) as State
From NashvilleHousing

Alter Table nashvillehousing
Add Owner_address nvarchar(255);

Update NashvilleHousing
Set Owner_Address = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

Alter Table nashvillehousing
Add Owner_City nvarchar(255);

Update NashvilleHousing
Set Owner_City = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

Alter Table nashvillehousing
Add Owner_State nvarchar(255);

Update NashvilleHousing
Set Owner_State = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)

Select *
From NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), COUNT(Soldasvacant)
From NashvilleHousing
Group By SoldAsVacant
Order By 2;

Select SoldAsVacant
,Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	END
From NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	END

Select *
from NashvilleHousing

-- Remove Duplicates
-- Using CTE
With RowNumCTE
As
(
Select *
,ROW_NUMBER() Over(Partition By ParcelID, PropertyAddress, SalePrice, LegalReference, Sale_date Order by uniqueid) row_num
from NashvilleHousing
)
Select *
from RowNumCTE
where row_num>1;

Alter Table nashvillehousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table nashvillehousing
Drop Column Saledate

Select *
from NashvilleHousing
