--standardize date formate

select * from [portfolio project 1].dbo.nashvillehousing

select saledateconverted ,convert(date, saledate)
from nashvillehousing 

update nashvillehousing
set saledate=convert(date, saledate)

alter table nashvillehousing 
add saledateconverted date;


update nashvillehousing
set saledateconverted=convert(date, saledate)


--populate property address data


select *
from nashvillehousing 
--where propertyaddress is null
order by parcelid


select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress, isnull(a.propertyaddress,b.propertyaddress)
from nashvillehousing a
join nashvillehousing b
on a.parcelid=b.parcelid
and a.uniqueid<>b.uniqueid
where a.propertyaddress is null 

update a
set propertyaddress= isnull(a.propertyaddress,b.propertyaddress)
from nashvillehousing a
join nashvillehousing b
on a.parcelid=b.parcelid
and a.uniqueid<>b.uniqueid
where a.propertyaddress is null 


--breaking out address into individual columns (address,city,state)


select propertyaddress
from nashvillehousing 
--where propertyaddress is null
--order by parcelid


select 
substring(propertyaddress,1,charindex(',',propertyaddress)-1) as address,
substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress)) as address
from nashvillehousing 


alter table nashvillehousing
add propertysplitaddress nvarchar(255)

update nashvillehousing
set propertysplitaddress=substring(propertyaddress,1,charindex(',',propertyaddress)-1)

alter table nashvillehousing
add propertysplitcity nvarchar(255);

update nashvillehousing
set propertysplitcity= substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))

select * from nashvillehousing

select owneraddress
from nashvillehousing

select 
parsename(replace(owneraddress,',','.'),3)
,parsename(replace(owneraddress,',','.'),2)
,parsename(replace(owneraddress,',','.'),1)
from nashvillehousing  


alter table nashvillehousing
add ownersplitaddress nvarchar(255)

update nashvillehousing
set ownersplitaddress=parsename(replace(owneraddress,',','.'),3)

alter table nashvillehousing
add ownersplitcity nvarchar(255);

update nashvillehousing
set ownersplitcity= parsename(replace(owneraddress,',','.'),2)


alter table nashvillehousing
add ownersplitstate nvarchar(255);


update nashvillehousing
set ownersplitstate= parsename(replace(owneraddress,',','.'),1) 

select * from nashvillehousing 

--change y and n to yes and no in soldasvacant field


select distinct(soldasvacant),count(soldasvacant)
from nashvillehousing 
group by soldasvacant
order by 2 


select soldasvacant
,case when soldasvacant='y' then 'yes'
when soldasvacant='n' then 'no'
else soldasvacant
end
from nashvillehousing

update nashvillehousing
set soldasvacant=case when soldasvacant='y' then 'yes'
when soldasvacant='n' then 'no'
else soldasvacant
end


--remove duplicates


with rownumcte as(
select * ,
row_number() over (
                 partition by parcelid ,
				 propertyaddress, 
				 saleprice,
				 saledate,
				 legalreference 
                 order by 
				      uniqueid
					  ) row_num

from nashvillehousing 
--order by parcelid

) 
select  * from rownumcte 
where row_num >1
--order by propertyaddress


---- delete unused columns 

select * 
from nashvillehousing 


alter table nashvillehousing
drop column owneraddress,propertyaddress,taxdistrict


alter table nashvillehousing
drop column saledate




