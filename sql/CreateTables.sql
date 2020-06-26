
use covid;

-- Create covid.us Table 

CREATE TABLE `us` (
  `date_time` datetime DEFAULT NULL,
  `cases` int(11) DEFAULT NULL,
  `deaths` int(11) DEFAULT NULL,
  UNIQUE KEY `idx_us_date_time` (`date_time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Create covid.us_states

CREATE TABLE `us_states` (
  `date_time` datetime DEFAULT NULL,
  `state` varchar(30) DEFAULT NULL,
  `fips` int(11) DEFAULT NULL,
  `cases` int(11) DEFAULT NULL,
  `deaths` int(11) DEFAULT NULL,
  UNIQUE KEY `idx_us_states_date_time_state` (`date_time`,`state`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Create covid.us_counties

CREATE TABLE `us_counties` (
  `date_time` datetime DEFAULT NULL,
  `county` varchar(40) DEFAULT NULL,
  `state` varchar(30) DEFAULT NULL,
  `fips` varchar(11) DEFAULT NULL,
  `cases` int(11) DEFAULT NULL,
  `deaths` int(11) DEFAULT NULL,
  UNIQUE KEY `idx_us_counties_date_time_county_state` (`date_time`,`county`,`state`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- us case rate view

CREATE  VIEW `covid`.`us_case_rate_vw` AS 
select `t1`.`date_time` AS `date_time`,(`t2`.`cases` - `t1`.`cases`) AS `rate` 
from (`covid`.`us` `t1` join `covid`.`us` `t2` on(((`t1`.`date_time` + interval 1 day) = `t2`.`date_time`)));

-- us death rate view

CREATE VIEW `covid`.`us_death_rate_vw` AS 
select `t1`.`date_time` AS `date_time`,(`t2`.`deaths` - `t1`.`deaths`) AS `rate` 
from (`covid`.`us` `t1` join `covid`.`us` `t2` on(((`t1`.`date_time` + interval 1 day) = `t2`.`date_time`)));

-- us state case rate view

CREATE VIEW `covid`.`us_states_case_rate_vw` AS 
select `t1`.`date_time` AS `date_time`,`t1`.`state` AS `state`,(`t2`.`cases` - `t1`.`cases`) AS `rate` 
from (`covid`.`us_states` `t1` join `covid`.`us_states` `t2` on(((`t1`.`state` = `t2`.`state`) and ((`t1`.`date_time` + interval 1 day) = `t2`.`date_time`))));

-- us state death rate view

CREATE VIEW `covid`.`us_states_death_rate_vw` AS 
select `t1`.`date_time` AS `date_time`,`t1`.`state` AS `state`,(`t2`.`deaths` - `t1`.`deaths`) AS `rate` 
from (`covid`.`us_states` `t1` join `covid`.`us_states` `t2` on(((`t1`.`state` = `t2`.`state`) and ((`t1`.`date_time` + interval 1 day) = `t2`.`date_time`))));

-- us county case rate view

CREATE VIEW `covid`.`us_county_case_rate_vw` AS 
select `t1`.`date_time` AS `date_time`,`t1`.`state` AS `state`,`t1`.`county` AS `county`,(`t2`.`cases` - `t1`.`cases`) AS `rate` 
from (`covid`.`us_counties` `t1` join `covid`.`us_counties` `t2` on(((`t1`.`state` = `t2`.`state`) and (`t1`.`county` = `t2`.`county`) and ((`t1`.`date_time` + interval 1 day) = `t2`.`date_time`))));

-- us county death rate view

CREATE VIEW `covid`.`us_county_death_rate_vw` AS 
select `t1`.`date_time` AS `date_time`,`t1`.`state` AS `state`,`t1`.`county` AS `county`,(`t2`.`deaths` - `t1`.`deaths`) AS `rate` 
from (`covid`.`us_counties` `t1` join `covid`.`us_counties` `t2` on(((`t1`.`state` = `t2`.`state`) and (`t1`.`county` = `t2`.`county`) and ((`t1`.`date_time` + interval 1 day) = `t2`.`date_time`))));






