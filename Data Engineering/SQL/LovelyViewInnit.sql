
create view vFactCustomerInvoices
as
select h.invoicenumber, h.customer_id, h.invoicedate, h.duedate, SUM(r.amount) as totalamount, SUM(r.cost) as totalcost
from dbo.FactInvoiceHeader h
join dbo.FactInvoicesRow r on h.invoicenumber = r.invoicenumber
group by h.invoicenumber, h.customer_id, h.invoicedate, h.duedate;

select * from dbo.vFactCustomerInvoices;

create view vFactCustomerInvoiceRows
as
select h.invoicenumber, r.rownumber, h.customer_id, r.amount, r.cost, r.contract_id, r.contracttype_id
from dbo.FactInvoiceHeader h
join dbo.FactInvoicesRow r on h.invoicenumber = r.invoicenumber;