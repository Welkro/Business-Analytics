--create
alter
procedure createInvoiceDataForMonth
	@year_value int,
	@month_value int
as
set nocount on;
begin
	-- exec createInvoiceDataForMonth @year_value = 2021, @month_value = 2;

	-- Auxiliary variables for months
	declare @startdate date;
	declare @enddate date;
	declare @loopdate date;

	select @startdate = DATEFROMPARTS(@year_value, @month_value, 1);
	select @enddate = DATEADD(day, -1, DATEADD(month, 1, @startdate))

	-- Contract related auxiliary variables
	declare @contractId int;
	declare @contractType int;
	declare @contractPrice decimal(6,3);
	declare @actualPrice decimal(6,3);
	declare @cost decimal(6,3);

	-- Invoice related auxiliary variables
	declare @invoiceNumber int;
	declare @invoiceRowNumber int;

	-- Variables that relates to the customers
	declare @customerId int;
	declare @customerName varchar(200);
	declare @CustomerCursorStatus int;

	declare CustomerCursor cursor for 
		select c.id, c.customername
		from dbo.stagedCustomer c
		--where c.id in (10, 50, 80);

	open CustomerCursor;
	fetch next from CustomerCursor into @customerId, @customerName;
	set @CustomerCursorStatus = @@FETCH_STATUS;

	-- 1) Go through each customer one at a time
	while (@CustomerCursorStatus = 0)
	begin
		-- print @customerName;

		select @loopdate = @startdate, @invoiceNumber = 0, @invoiceRowNumber = 1;

	-- 2) Go through each day of the 12 months (details from parameters)
		while (@loopdate <= @enddate)
		begin

			-- 3) Which is the active contract
			-- 4) What is the active contract type
			select @contractId = c.id, @contractType = c.contracttype_id, @contractPrice = c.fixedprice
			from dbo.stagedContract c
			where c.customer_id = @customerId and @loopdate between c.startdate and c.enddate;

			select @cost = CONVERT(decimal(6,3), REPLACE(p.PriceAvg, ',', '.'))
			from dbo.electricityPrices p
			where @startdate = CONVERT(date, p.DateAvg, 104);

			-- If contract found, then write invoice row
			if (@contractId is not null)
			begin
				-- 1.1) Create a new Fact-table row to the header fact invoice
				if (@invoiceNumber = 0)
				begin
					insert into Repository.dbo.FactInvoiceHeader (customer_id, invoicedate, duedate) values (@customerId, @enddate, DATEADD(day, 14, @enddate));

					select @invoiceNumber = MAX(invoicenumber) from Repository.dbo.FactInvoiceHeader where customer_id = @customerId and invoicedate > @startdate; 
				end

				/*
				Contract types:
					1	Daily based price + FixedPrice
					2	FixedPrice for contract period
					3	Periodical prices from FixedPrices table
				*/

				if (@contractType = 1)
					begin
						select @actualPrice = @contractPrice + @cost;
					end
				else if (@contractType = 2)
					begin
						select @actualPrice = @contractPrice;
					end
				else
					begin
						select @actualPrice = fp.price
						from dbo.stagedFixedPrices fp
						where @loopdate between fp.startdate and fp.enddate;
					end

				-- 5) Add row information into Fact-table
				insert into Repository.dbo.FactInvoicesRow (invoicenumber, rownumber, contract_id, contracttype_id, amount, cost)
					values (@invoiceNumber, @invoiceRowNumber, @contractId, @contractType, @actualPrice, @cost);

				select @invoiceRowNumber = @invoiceRowNumber+1;


			end

			select @loopdate = DATEADD(day, 1, @loopdate);

		end

		fetch next from CustomerCursor into @customerId, @customerName;
		set @CustomerCursorStatus = @@FETCH_STATUS;
	end

	close CustomerCursor;
	deallocate CustomerCursor;
end