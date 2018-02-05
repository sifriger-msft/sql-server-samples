CREATE VIEW Website.PurchaseOrderLines
AS
SELECT        ol.PurchaseOrderLineID, ol.PurchaseOrderID, ol.Description, ol.IsOrderLineFinalized, si.StockItemName AS ProductName, si.Brand, si.Size, c.ColorName, pt.PackageTypeName, ol.OrderedOuters, ol.ReceivedOuters, 
                         ol.ExpectedUnitPricePerOuter
FROM            Purchasing.PurchaseOrderLines AS ol INNER JOIN
                         Warehouse.StockItems AS si ON ol.StockItemID = si.StockItemID INNER JOIN
                         Warehouse.Colors AS c ON c.ColorID = si.ColorID INNER JOIN
                         Warehouse.PackageTypes AS pt ON ol.PackageTypeID = pt.PackageTypeID
