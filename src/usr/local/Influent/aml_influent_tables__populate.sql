use aml;

-- finflowdaily is the primary source data table of the application 
-- (not finflow).  finflow is derived from finflowdaily and is
-- an over-all summary of finflowdaily
insert into finflowdaily
 select `debit_account`, 'a', `beneficiary_account`, 'a', sum(`amount_usd`), date(`dt`)
	from transactions
	group by `debit_account`, `beneficiary_account`, date(`dt`);

insert into finentity (
    entityid, 
    inbounddegree, 
    uniqueinbounddegree, 
    outbounddegree, 
    uniqueoutbounddegree, 
    numtransactions, 
    maxtransaction, 
    avgtransaction, 
    startdate, 
    enddate,
    -- from accounts:
    label,
    accounttype,
    accountclass,
    dateopened,
    status,
    powerofattorney,
    initdate,
    customertype,
    customerstreet,
    customercity,
    customerstate,
    customercountry,
    customerzip,
    customerphonehome,
    customerphoneoffice    )
select
    entityid, 
    sum(inbounddegree) as inbounddegree, 
    sum(uniqueinbounddegree) as uniqueinbounddegree, 
    sum(outbounddegree) as outbounddegree, 
    sum(uniqueoutbounddegree) as uniqueoutbounddegree, 
    sum(numtransactions) as numtransactions, 
    max(maxtransaction) as maxtransactions, 
    sum(totaltransactions) / sum(numtransactions) as avgtransactions, 
    min(startdate) as startdate, 
    max(enddate) as enddate,
    max(a.customer_name) as label,                                   
    max(a.account_type) as accounttype,
    max(a.account_class) as accountclass,
    max(a.date_opened) as dateopened,
    max(a.status) as status,
    max(a.power_of_attorney) as powerofattorney,           
    max(a.init_date) as initdate,
    max(a.customer_type) as customertype,
    max(a.customer_street) as customerstreet,
    max(a.customer_city) as customercity,
    max(a.customer_state) as customerstate,
    max(a.customer_country) as customercountry,
    max(a.customer_zip) as customerzip,            
    max(a.customer_phone_home) as customerphonehome,
    max(a.customer_phone_office) as customerphoneoffice
from (
    select  `beneficiary_account` as entityid,
            count(`debit_account`) as inbounddegree,
            count( distinct `debit_account` ) as uniqueinbounddegree,
            0 as outbounddegree,
            0 as uniqueoutbounddegree,
            count(`beneficiary_account`) as numtransactions,
            max(`amount_usd`) as maxtransaction,
            sum(`amount_usd`) as totaltransactions,
            min(`dt`) as startdate,
            max(`dt`) as enddate
    from transactions 
    group by `beneficiary_account`
    union all
    select `debit_account` as entityid,
            0 as inbounddegree,
            0 as uniqueinbounddegree,
            count(`beneficiary_account`) as outbounddegree,
            count( distinct `beneficiary_account` ) as uniqueoutbounddegree,
            sum( case when `debit_account` <> `beneficiary_account` then 1 else 0 end ) as numtransactions,
            max(`amount_usd`) as maxtransaction,
            sum(`amount_usd`) as totaltransactions,
            min(`dt`) as startdate,
            max(`dt`) as enddate
    from transactions
    group by `debit_account`
)q
inner join accounts a 
    on q.`entityid` = a.`id`
group by entityid;

insert into finflowweekly
 select fromentityid, fromentitytype, toentityid, toentitytype, sum(amount), date_add(date(perioddate), interval ((1) - dayofweek(date(perioddate)) - 6 ) day)
  from finflowdaily
  group by fromentityid, fromentitytype, toentityid, toentitytype, date_add(date(perioddate), interval ((1) - dayofweek(date(perioddate)) - 6 ) day);

insert into finflowmonthly
 select fromentityid, fromentitytype, toentityid, toentitytype, sum(amount), concat(concat(concat(convert(year(date(perioddate)),char(4)),'/'),convert(month(date(perioddate)),char(2))),'/01')
  from finflowdaily
  group by fromentityid, fromentitytype, toentityid, toentitytype, concat(concat(concat(convert(year(date(perioddate)),char(4)),'/'),convert(month(date(perioddate)),char(2))),'/01');

insert into finflowquarterly
 select fromentityid, fromentitytype, toentityid, toentitytype, sum(amount), concat(concat(concat(convert(year(date(perioddate)),char(4)),'/'),case when quarter(date(perioddate))=1 then '01' when quarter(date(perioddate))=2 then '04' when quarter(date(perioddate))=3 then '07' when quarter(date(perioddate))=4 then '010' end),'/01')
  from finflowmonthly
  group by fromentityid, fromentitytype, toentityid, toentitytype, concat(concat(concat(convert(year(date(perioddate)),char(4)),'/'),case when quarter(date(perioddate))=1 then '01' when quarter(date(perioddate))=2 then '04' when quarter(date(perioddate))=3 then '07' when quarter(date(perioddate))=4 then '010' end),'/01');

insert into finflowyearly
 select fromentityid, fromentitytype, toentityid, toentitytype, sum(amount), concat(convert(year( date(perioddate)),char(4)),'/01/01')
  from finflowmonthly
  group by fromentityid, fromentitytype, toentityid, toentitytype, concat(convert(year( date(perioddate)),char(4)),'/01/01');

insert into finflow
 select fromentityid, fromentitytype, toentityid, toentitytype, min(date(perioddate)), max(date(perioddate)), sum(amount)
  from finflowdaily
  group by fromentityid, fromentitytype, toentityid, toentitytype;

create table temp_ids (entity varchar(100));
create index tids on temp_ids (entity);

insert into temp_ids
 select distinct fromentityid
  from finflowyearly
 union
 select distinct toentityid
  from finflowyearly;

insert into finentitydaily select entity, date(perioddate),
       sum(case when toentityid = entity and fromentitytype = 'a' then amount else 0 end),
       sum(case when toentityid = entity and fromentitytype = 'a' then 1 else 0 end), -- calculate inbound degree
       sum(case when fromentityid = entity and toentitytype = 'a' then amount else 0 end),
       sum(case when fromentityid = entity and toentitytype = 'a' then 1 else 0 end), -- calculate outbound degree
       0 -- todo calculate balance
 from temp_ids
 join finflowdaily on fromentityid = entity or toentityid = entity
 group by entity, date(perioddate);

-- cleanup
drop table temp_ids;

insert into finentityweekly
 select entityid, date_add(date(perioddate), interval ((1) - dayofweek(date(perioddate)) - 6 ) day), sum(inboundamount), sum(inbounddegree), sum(outboundamount), sum(outbounddegree), 0
  from finentitydaily
  group by entityid, date_add(date(perioddate), interval ((1) - dayofweek(date(perioddate)) - 6 ) day);

insert into finentitymonthly
 select entityid,  concat(concat(concat(convert(year( date(perioddate)),char(4)),'/'),convert(month(date(perioddate)),char(2))),'/01'), sum(inboundamount), sum(inbounddegree), sum(outboundamount), sum(outbounddegree), 0
  from finentitydaily
  group by entityid, concat(concat(concat(convert(year( date(perioddate)),char(4)),'/'),convert(month(date(perioddate)),char(2))),'/01');

insert into finentityquarterly
 select entityid, concat(concat(concat(convert(year( date(perioddate)),char(4)),'/'),case when quarter(date(perioddate))=1 then '01' when quarter(date(perioddate))=2 then '04' when quarter(date(perioddate))=3 then '07' when quarter(date(perioddate))=4 then '010' end),'/01'), sum(inboundamount), sum(inbounddegree), sum(outboundamount), sum(outbounddegree), 0
  from finentitymonthly
  group by entityid, concat(concat(concat(convert(year( date(perioddate)),char(4)),'/'),case when quarter(date(perioddate))=1 then '01' when quarter(date(perioddate))=2 then '04' when quarter(date(perioddate))=3 then '07' when quarter(date(perioddate))=4 then '010' end),'/01');

insert into finentityyearly
 select entityid, concat(convert(year( date(perioddate)),char(4)),'/01/01'), sum(inboundamount), sum(inbounddegree), sum(outboundamount), sum(outbounddegree), 0
  from finentityquarterly
  group by entityid, concat(convert(year( date(perioddate)),char(4)),'/01/01');

insert into datasummary (summaryorder, summarykey, summarylabel, summaryvalue, unformattednumeric, unformatteddatetime)
values (
	1,
	'infosummary',
	'about',
	'some interesting description of your dataset can be written here.',
    null,
    null
);

-- the following calculates the number of accounts in the data
insert into datasummary (summaryorder, summarykey, summarylabel, summaryvalue, unformattednumeric, unformatteddatetime)
select 
	2,
	'numaccounts',
	'accounts',
	cast(count(*) as char(9)),
	count(*),
	null
from finentity;

-- the following calculates the number of transactions in the data
insert into datasummary (summaryorder, summarykey, summarylabel, summaryvalue, unformattednumeric, unformatteddatetime)
select
	3,
	'numtransactions',
	'transactions',
	cast(count(*) as char(9)),
	count(*),
	null
from transactions;

-- the following calculates the earliest transaction in the data
insert into datasummary (summaryorder, summarykey, summarylabel, summaryvalue, unformattednumeric, unformatteddatetime)
select
	4,
	'startdate',
	'earliest transaction',
	cast(min(firsttransaction) as char(9)),
	null,
	min(firsttransaction)
from finflow;

-- the following calculates the latest transaction in the data
insert into datasummary (summaryorder, summarykey, summarylabel, summaryvalue, unformattednumeric, unformatteddatetime)
select
	5,
	'enddate',
	'latest transaction',
	cast(max(lasttransaction) as char(9)),
	null,
	max(lasttransaction)
from finflow;




