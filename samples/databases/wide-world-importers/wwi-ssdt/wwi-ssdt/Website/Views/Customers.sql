

CREATE VIEW [Website].[Customers]
AS
SELECT s.CustomerID,
       s.CustomerName,
       sc.CustomerCategoryName,
       pp.FullName AS PrimaryContact,
       ap.FullName AS AlternateContact,
       s.PhoneNumber,
       s.FaxNumber,
       s.WebsiteURL,
	   s.PostalAddressLine1,
	   s.PostalAddressLine2,
	   pc.CityName AS PostalCity,
	   s.PostalPostalCode,
	   s.AccountOpenedDate,
	   s.PaymentDays,
	   s.StandardDiscountPercentage,
	   s.CreditLimit,
	   s.IsOnCreditHold,
	   s.IsStatementSent,
	   s.RunPosition,
	   bg.BuyingGroupName,
       DeliveryLocation = JSON_QUERY((SELECT
				type = 'Feature',
				[geometry.type] = 'Point',
				[geometry.coordinates] = JSON_QUERY(CONCAT('[',s.DeliveryLocation.Long,',',s.DeliveryLocation.Lat ,']')),
				[properties.Method] = DeliveryMethodName,
				[properties.AddressLine1] = s.DeliveryAddressLine1,
				[properties.AddressLine2] = s.DeliveryAddressLine2,
				[properties.CityID] = s.DeliveryCityID,
				[properties.CityName] = c.CityName,
				[properties.Province] = sp.StateProvinceName,
				[properties.Territory] = sp.SalesTerritory,
				[properties.DeliveryMethodID] = s.DeliveryMethodID,
				[properties.DeliveryCityID] = s.DeliveryCityID
		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)),
		s.BillToCustomerID,
		s.BuyingGroupID,
		s.CustomerCategoryID,
		s.PrimaryContactPersonID,
		s.AlternateContactPersonID,
		s.PostalCityID
FROM Sales.Customers AS s
LEFT OUTER JOIN Sales.CustomerCategories AS sc
ON s.CustomerCategoryID = sc.CustomerCategoryID
LEFT OUTER JOIN [Application].People AS pp
ON s.PrimaryContactPersonID = pp.PersonID
LEFT OUTER JOIN [Application].People AS ap
ON s.AlternateContactPersonID = ap.PersonID
LEFT OUTER JOIN Sales.BuyingGroups AS bg
ON s.BuyingGroupID = bg.BuyingGroupID
LEFT OUTER JOIN [Application].DeliveryMethods AS dm
ON s.DeliveryMethodID = dm.DeliveryMethodID
LEFT OUTER JOIN [Application].Cities AS c
ON s.DeliveryCityID = c.CityID
LEFT OUTER JOIN [Application].StateProvinces AS sp
ON sp.StateProvinceID = c.StateProvinceID
LEFT OUTER JOIN [Application].Cities AS pc
ON s.PostalCityID = pc.CityID