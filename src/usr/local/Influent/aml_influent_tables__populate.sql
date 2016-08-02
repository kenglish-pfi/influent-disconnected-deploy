USE aml;

-- FinFlowDaily is the primary source data table of the application 
-- (not FinFlow).  FinFlow is derived from FinFlowDaily and is
-- an over-all summary of FinFlowDaily
insert into FinFlowDaily
 SELECT `debit_account`, 'A', `beneficiary_account`, 'A', SUM(`amount_usd`), DATE(`dt`)
	FROM transactions
	group by `debit_account`, `beneficiary_account`, DATE(`dt`);

insert into FinEntity (
    EntityId, 
    InboundDegree, 
    UniqueInboundDegree, 
    OutboundDegree, 
    UniqueOutboundDegree, 
    NumTransactions, 
    MaxTransaction, 
    AvgTransaction, 
    StartDate, 
    EndDate,
    -- From accounts:
    Label,
    AccountType,
    AccountClass,
    DateOpened,
    Status,
    PowerOfAttorney,
    InitDate,
    CustomerType,
    CustomerStreet,
    CustomerCity,
    CustomerState,
    CustomerCountry,
    CustomerZip,
    CustomerPhoneHome,
    CustomerPhoneOffice    )
Select
    EntityId, 
    sum(InboundDegree) as InboundDegree, 
    sum(UniqueInboundDegree) as UniqueInboundDegree, 
    sum(OutboundDegree) as OutboundDegree, 
    sum(UniqueOutboundDegree) as UniqueOutboundDegree, 
    sum(numTransactions) as NumTransactions, 
    max(MaxTransaction) as MaxTransactions, 
    sum(TotalTransactions) / sum(numTransactions) as AvgTransactions, 
    min(StartDate) as StartDate, 
    max(EndDate) as EndDate,
    max(A.customer_name) as Label,                                   
    max(A.account_type) as AccountType,
    max(A.account_class) as AccountClass,
    max(A.date_opened) as DateOpened,
    max(A.status) as Status,
    max(A.power_of_attorney) as PowerOfAttorney,           
    max(A.init_date) as InitDate,
    max(A.customer_type) as CustomerType,
    max(A.customer_street) as CustomerStreet,
    max(A.customer_city) as CustomerCity,
    max(A.customer_state) as CustomerState,
    max(A.customer_country) as CustomerCountry,
    max(A.customer_zip) as CustomerZip,            
    max(A.customer_phone_home) as CustomerPhoneHome,
    max(A.customer_phone_office) as CustomerPhoneOffice
From (
    select  `beneficiary_account` as EntityId,
            count(`debit_account`) as InboundDegree,
            count( distinct `debit_account` ) as UniqueInboundDegree,
            0 as OutboundDegree,
            0 as UniqueOutboundDegree,
            count(`beneficiary_account`) as numTransactions,
            max(`amount_usd`) as MaxTransaction,
            sum(`amount_usd`) as TotalTransactions,
            min(`dt`) as StartDate,
            max(`dt`) as EndDate
    from transactions 
    group by `beneficiary_account`
    UNION ALL
    select `debit_account` as EntityId,
            0 as InboundDegree,
            0 as UniqueInboundDegree,
            count(`beneficiary_account`) as OutboundDegree,
            count( distinct `beneficiary_account` ) as UniqueOutboundDegree,
            sum( case when `debit_account` <> `beneficiary_account` then 1 else 0 end ) as numTransactions,
            max(`amount_usd`) as MaxTransaction,
            sum(`amount_usd`) as TotalTransactions,
            min(`dt`) as StartDate,
            max(`dt`) as EndDate
    from transactions
    group by `debit_account`
)q
inner join accounts A 
    on q.`EntityId` = A.`id`
group by EntityId;

insert into FinFlowWeekly
 select FromEntityId, FromEntityType, ToEntityId, ToEntityType, sum(Amount), DATE_ADD(DATE(PeriodDate), INTERVAL ((1) - DAYOFWEEK(DATE(PeriodDate)) - 6 ) DAY)
  from FinFlowDaily
  group by FromEntityId, FromEntityType, ToEntityId, ToEntityType, DATE_ADD(DATE(PeriodDate), INTERVAL ((1) - DAYOFWEEK(DATE(PeriodDate)) - 6 ) DAY);

insert into FinFlowMonthly
 select FromEntityId, FromEntityType, ToEntityId, ToEntityType, sum(Amount), CONCAT(CONCAT(CONCAT(convert(YEAR(DATE(PeriodDate)),char(4)),'/'),convert(MONTH(DATE(PeriodDate)),char(2))),'/01')
  from FinFlowDaily
  group by FromEntityId, FromEntityType, ToEntityId, ToEntityType, CONCAT(CONCAT(CONCAT(convert(YEAR(DATE(PeriodDate)),char(4)),'/'),convert(MONTH(DATE(PeriodDate)),char(2))),'/01');

insert into FinFlowQuarterly
 select FromEntityId, FromEntityType, ToEntityId, ToEntityType, sum(Amount), CONCAT(CONCAT(CONCAT(convert(YEAR(DATE(PeriodDate)),char(4)),'/'),case when QUARTER(DATE(PeriodDate))=1 then '01' when QUARTER(DATE(PeriodDate))=2 then '04' when QUARTER(DATE(PeriodDate))=3 then '07' when QUARTER(DATE(PeriodDate))=4 then '010' end),'/01')
  from FinFlowMonthly
  group by FromEntityId, FromEntityType, ToEntityId, ToEntityType, CONCAT(CONCAT(CONCAT(convert(YEAR(DATE(PeriodDate)),char(4)),'/'),case when QUARTER(DATE(PeriodDate))=1 then '01' when QUARTER(DATE(PeriodDate))=2 then '04' when QUARTER(DATE(PeriodDate))=3 then '07' when QUARTER(DATE(PeriodDate))=4 then '010' end),'/01');

insert into FinFlowYearly
 select FromEntityId, FromEntityType, ToEntityId, ToEntityType, sum(Amount), CONCAT(convert(YEAR( DATE(PeriodDate)),char(4)),'/01/01')
  from FinFlowMonthly
  group by FromEntityId, FromEntityType, ToEntityId, ToEntityType, CONCAT(convert(YEAR( DATE(PeriodDate)),char(4)),'/01/01');

insert into FinFlow
 select FromEntityId, FromEntityType, ToEntityId, ToEntityType, min(DATE(PeriodDate)), max(DATE(PeriodDate)), sum(Amount)
  from FinFlowDaily
  group by FromEntityId, FromEntityType, ToEntityId, ToEntityType;

create table temp_ids (Entity varchar(100));
create index tids on temp_ids (Entity);

insert into temp_ids
 select distinct FromEntityId
  from FinFlowYearly
 union
 select distinct ToEntityId
  from FinFlowYearly;

insert into FinEntityDaily select Entity, DATE(PeriodDate),
       sum(case when ToEntityId = Entity and FromEntityType = 'A' then Amount else 0 end),
       sum(case when ToEntityId = Entity and FromEntityType = 'A' then 1 else 0 end), -- calculate inbound degree
       sum(case when FromEntityId = Entity and ToEntityType = 'A' then Amount else 0 end),
       sum(case when FromEntityId = Entity and ToEntityType = 'A' then 1 else 0 end), -- calculate outbound degree
       0 -- TODO calculate balance
 from temp_ids
 join FinFlowDaily on FromEntityId = Entity or ToEntityId = Entity
 group by Entity, DATE(PeriodDate);

-- cleanup
drop table temp_ids;

insert into FinEntityWeekly
 select EntityId, DATE_ADD(DATE(PeriodDate), INTERVAL ((1) - DAYOFWEEK(DATE(PeriodDate)) - 6 ) DAY), sum(InboundAmount), sum(InboundDegree), sum(OutboundAmount), sum(OutboundDegree), 0
  from FinEntityDaily
  group by EntityId, DATE_ADD(DATE(PeriodDate), INTERVAL ((1) - DAYOFWEEK(DATE(PeriodDate)) - 6 ) DAY);

insert into FinEntityMonthly
 select EntityId,  CONCAT(CONCAT(CONCAT(convert(YEAR( DATE(PeriodDate)),char(4)),'/'),convert(MONTH(DATE(PeriodDate)),char(2))),'/01'), sum(InboundAmount), sum(InboundDegree), sum(OutboundAmount), sum(OutboundDegree), 0
  from FinEntityDaily
  group by EntityId, CONCAT(CONCAT(CONCAT(convert(YEAR( DATE(PeriodDate)),char(4)),'/'),convert(MONTH(DATE(PeriodDate)),char(2))),'/01');

insert into FinEntityQuarterly
 select EntityId, CONCAT(CONCAT(CONCAT(convert(YEAR( DATE(PeriodDate)),char(4)),'/'),case when QUARTER(DATE(PeriodDate))=1 then '01' when QUARTER(DATE(PeriodDate))=2 then '04' when QUARTER(DATE(PeriodDate))=3 then '07' when QUARTER(DATE(PeriodDate))=4 then '010' end),'/01'), sum(InboundAmount), sum(InboundDegree), sum(OutboundAmount), sum(OutboundDegree), 0
  from FinEntityMonthly
  group by EntityId, CONCAT(CONCAT(CONCAT(convert(YEAR( DATE(PeriodDate)),char(4)),'/'),case when QUARTER(DATE(PeriodDate))=1 then '01' when QUARTER(DATE(PeriodDate))=2 then '04' when QUARTER(DATE(PeriodDate))=3 then '07' when QUARTER(DATE(PeriodDate))=4 then '010' end),'/01');

insert into FinEntityYearly
 select EntityId, CONCAT(convert(YEAR( DATE(PeriodDate)),char(4)),'/01/01'), sum(InboundAmount), sum(InboundDegree), sum(OutboundAmount), sum(OutboundDegree), 0
  from FinEntityQuarterly
  group by EntityId, CONCAT(convert(YEAR( DATE(PeriodDate)),char(4)),'/01/01');

insert into DataSummary (SummaryOrder, SummaryKey, SummaryLabel, SummaryValue, UnformattedNumeric, UnformattedDatetime)
values (
	1,
	'InfoSummary',
	'About',
	'Some interesting description of your dataset can be written here.',
    NULL,
    NULL
);

-- The following calculates the number of accounts in the data
insert into DataSummary (SummaryOrder, SummaryKey, SummaryLabel, SummaryValue, UnformattedNumeric, UnformattedDatetime)
select 
	2,
	'NumAccounts',
	'Accounts',
	CAST(count(*) AS char(9)),
	count(*),
	NULL
from FinEntity;

-- The following calculates the number of transactions in the data
insert into DataSummary (SummaryOrder, SummaryKey, SummaryLabel, SummaryValue, UnformattedNumeric, UnformattedDatetime)
select
	3,
	'NumTransactions',
	'Transactions',
	CAST(count(*) AS char(9)),
	count(*),
	NULL
from transactions;

-- The following calculates the earliest transaction in the data
insert into DataSummary (SummaryOrder, SummaryKey, SummaryLabel, SummaryValue, UnformattedNumeric, UnformattedDatetime)
select
	4,
	'StartDate',
	'Earliest Transaction',
	CAST(MIN(firstTransaction) AS char(9)),
	NULL,
	MIN(firstTransaction)
from FinFlow;

-- The following calculates the latest transaction in the data
insert into DataSummary (SummaryOrder, SummaryKey, SummaryLabel, SummaryValue, UnformattedNumeric, UnformattedDatetime)
select
	5,
	'EndDate',
	'Latest Transaction',
	CAST(MAX(lastTransaction) AS char(9)),
	NULL,
	MAX(lastTransaction)
from FinFlow;




