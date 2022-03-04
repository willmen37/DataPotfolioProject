Select *
From PortfolioProject.dbo.NashvilleHousing


--Standarize Format

    --change format--

Select SaleDate, CONVERT(Date,SaleDate) as SaleDateConverted
From PortfolioProject.dbo.NashvilleHousing
     --add in table--
ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;
	--Update table--
Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)
	--check on changes--
Select *
From PortfolioProject.dbo.NashvilleHousing


--Populate Property Address Data

  --Put together Addresses with the same ParcelID but different UniqueID--

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a			          	
Join PortfolioProject.dbo.NashvilleHousing b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 
  --Update the Table--
Update a
SET PropertyAddress= ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
 JOIN PortfolioProject.dbo.NashvilleHousing b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null
  --Check the Changes--
Select *
From PortfolioProject.dbo.NashvilleHousing




--Breaking out address into individual columns (Address, City, State)
							-- PARSENAME ONLY CHANGES PERIODS "." --

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing 
     --Remove comas and add periods and divide values in columns--
Select
PARSENAME (REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME (REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME (REPLACE(OwnerAddress, ',', '.'),1)
From PortfolioProject.dbo.NashvilleHousing

	--Insert new cells into the table--
ALTER TABLE NashvilleHousing 
add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE NashvilleHousing
add OwnerSplitState Nvarchar(255)

Update NashvilleHousing 
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


Select *
From PortfolioProject.dbo.NashvilleHousing


--CHANGE Y AND N TO YES AND NO IN "SoldAsVacant" Field--

    --Check what are the most popular values on these cells--
Select Distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2
    
	--Replace values BUILDING A CASE--
Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


   --Update Table--

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
						When SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END

Select *
From PortfolioProject.dbo.NashvilleHousing

 