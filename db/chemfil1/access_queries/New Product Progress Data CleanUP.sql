SELECT
  [New Product Progress Data].[Product Code]
FROM [New Product Progress Data]
WHERE ((([New Product Progress Data].Comments) LIKE "*’*"))
OR ((([New Product Progress Data].Cust_Req_Com) LIKE "*’*"))
OR ((([New Product Progress Data].[Lab Batch Com]) LIKE "*’*"))
OR ((([New Product Progress Data].[Product Name]) LIKE "*™*"))
OR ((([New Product Progress Data].[Product Name]) LIKE "*®*"))
OR ((([New Product Progress Data].Comments) LIKE "*°*"))
OR ((([New Product Progress Data].Comments) LIKE "*½*"))
OR ((([New Product Progress Data].[MSDS Init Com]) LIKE "*°*"));
