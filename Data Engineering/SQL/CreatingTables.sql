create table electricityPrices (
	DateAvg varchar(100),
	PriceAvg varchar(100),
	DateMin varchar(100),
	PriceMin varchar(100),
);

create table stagedContact (
	id int,
	firstname varchar(45),
	lastname varchar(45),
	address varchar(100),
	zipcode varchar(45),
	city varchar(45),
	email varchar(45),
	customer_id int,
	country_id int,

);

create table stagedContract(
	id int,
	startdate date,
	enddate	date,
	interval int,
	customer_id int,
	contracttype_id int,
	fixedprice decimal(6,3)
);

create table stagedContractType(
	id int,
	name varchar(45)
);

create table stagedCountry(
	id int,
	countryname varchar(45)
);

create table stagedCustomer(
	id int,
	customername varchar(200),
	country_id int
);

create table stagedFixedPrices(
	idPrices int,
	startdate date,
	enddate date,
	price decimal(6,3)
);