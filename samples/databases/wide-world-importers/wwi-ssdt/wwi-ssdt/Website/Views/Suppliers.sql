
CREATE VIEW [Website].[Suppliers]
AS
SELECT s.SupplierID,
       s.SupplierName,
	   s.SupplierReference,
       sc.SupplierCategoryName,
       pp.FullName AS PrimaryContact,
       ap.FullName AS AlternateContact,
       s.PhoneNumber,
       s.FaxNumber,
       s.WebsiteURL,
		s.PostalAddressLine1,
		s.PostalAddressLine2,
		s.PostalPostalCode,
		pc.CityName,
		psp.StateProvinceName,
	   DeliveryLocation = JSON_QUERY((SELECT 
				[type] = 'Feature',
				[geometry.type] = 'Point',
				[geometry.coordinates] = JSON_QUERY(CONCAT('[',s.DeliveryLocation.Long,',',s.DeliveryLocation.Lat ,']')),
				[properties.DeliveryMethod] = dm.DeliveryMethodName,
				[properties.City] = c.CityName,
				[properties.Province] = sp.StateProvinceName,
				[properties.Territory] = sp.SalesTerritory
			FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)),
		s.BankAccountName,
		s.BankAccountNumber,
		s.BankAccountCode,
		s.BankAccountBranch,
		s.BankInternationalCode,
		s.PaymentDays
FROM Purchasing.Suppliers AS s
	LEFT OUTER JOIN Purchasing.SupplierCategories AS sc
		ON s.SupplierCategoryID = sc.SupplierCategoryID
	LEFT OUTER JOIN [Application].People AS pp
		ON s.PrimaryContactPersonID = pp.PersonID
	LEFT OUTER JOIN [Application].People AS ap
		ON s.AlternateContactPersonID = ap.PersonID
	LEFT OUTER JOIN [Application].DeliveryMethods AS dm
		ON s.DeliveryMethodID = dm.DeliveryMethodID
	LEFT OUTER JOIN [Application].Cities AS c
		ON s.DeliveryCityID = c.CityID
		LEFT OUTER JOIN [Application].StateProvinces AS sp
			ON sp.StateProvinceID = c.StateProvinceID
	LEFT OUTER JOIN [Application].Cities AS pc
		ON s.DeliveryCityID = pc.CityID
		LEFT OUTER JOIN [Application].StateProvinces AS psp
			ON psp.StateProvinceID = pc.StateProvinceID
