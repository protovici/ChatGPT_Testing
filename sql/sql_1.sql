

DELCARE @userCurrencyID INT = 1;

SELECT SUM(CASE @userCurrencyID
                WHEN 1/*USD*/ THEN Fees.Total_amount
                WHEN Invoices.inv_currencyType THEN Fees.total_amount_native
                ELSE Fees.total_amount * fe.conversionRate
            END)
                / NULLIF(SUM(Fees.unit),0) AS avgRate
FROM [SkyProduction].[dbo].[Invoices]
INNER JOIN Fees ON Invoices.Invoice_ID = Fees.Invoice_IDINNER JOIN dbo.timekeeperFirms tf ON tf.firmListID = fees.firmListID
LEFT JOIN [ SkyProduction].[dbo].[lu_foreignExchange] fe ON fe.conversionDate = Invoices.inv_date AND fe.currencyTypeID
        WHERE Fees.flatFee = 0
            AND Invoices.inv_audited = 1
            AND Invoices.inv_type = 1
            AND Client_ID = ''