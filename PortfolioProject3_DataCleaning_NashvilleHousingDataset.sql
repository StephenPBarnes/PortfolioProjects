-- Data Cleaning Housing Dataset: Remove Nulls, Duplicates, Add/Alter Columns

Select * 
From PortfolioProject3.dbo.NashvilleHousing 
----------------------------------------------------------

-- Convert Date
UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)
Select saleDateConverted, CONVERT(Date, SaleDate) 
From PortfolioProject3.dbo.NashvilleHousing  

-------------------------------------------------------

Select PropertyAddress, ParcelID From PortfolioProject3.dbo.NashvilleHousing
Order by ParcelID

-- Remove Nulls via Inner Join
Select * 
From PortfolioProject3.dbo.NashvilleHousing a
Join PortfolioProject3.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

Update a 
Set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject3.dbo.NashvilleHousing a
Join PortfolioProject3.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

-- (to double-check for nulls, run Join script again)


-------------------------------------------------------

Select PropertyAddress, ParcelID From PortfolioProject3.dbo.NashvilleHousing

-- Break apart "PropertyAddress" by Delimiters into separate columns (Address, City, State) 
Select 
Substring(PropertyAddress, 1, Charindex(',', PropertyAddress ) -1) as Address
, Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, Len(propertyAddress)) as Address
From PortfolioProject3.dbo.NashvilleHousing


-- Create 2 new columns to add in values
ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = Substring(PropertyAddress, 1, Charindex(',', PropertyAddress ) -1)


ALTER TABLE NashvilleHousing
Add PropertySplictCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplictCity = Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, Len(propertyAddress))


Select * From PortfolioProject3.dbo.NashvilleHousing


-- another method == PARSENAME(Replace(Column, ',', '.'), location)
Select OwnerAddress From PortfolioProject3.dbo.NashvilleHousing

Select 
parsename(Replace(OwnerAddress, ',', '.'), 3) 
, parsename(Replace(OwnerAddress, ',', '.'), 2) 
, parsename(Replace(OwnerAddress, ',', '.'), 1) 
From PortfolioProject3.dbo.NashvilleHousing

-- rename/update columns
ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = parsename(Replace(OwnerAddress, ',', '.'), 3) 


ALTER TABLE NashvilleHousing
Add OwnerSplictCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplictCity = parsename(Replace(OwnerAddress, ',', '.'), 2) 


ALTER TABLE NashvilleHousing
Add OwnerSplictState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplictState = parsename(Replace(OwnerAddress, ',', '.'), 1) 


--------------------------------------------------------

-- Change "Y and N" to "yes and no" in (SoldAsVacant)
Select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject3.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
     Else SoldAsVacant
     End
from PortfolioProject3.dbo.NashvilleHousing

-- rename/update 
Update NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
     Else SoldAsVacant
     End

---------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE as(
Select *,
    Row_number() Over (
        Partition by ParcelID,
                     PropertyAddress,
                     SalePrice,
                     SaleDate,
                     LegalReference
                     Order BY
                        UniqueID
                        ) row_num

From PortfolioProject3.dbo.NashvilleHousing
--Order by ParcelID
)

Delete
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


---------------------------------------------------------------

-- Delete unused Columns
Select* From PortfolioProject3.dbo.NashvilleHousing

Alter Table PortfolioProject3.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select* From PortfolioProject3.dbo.NashvilleHousing