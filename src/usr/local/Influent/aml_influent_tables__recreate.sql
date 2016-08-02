-- MySQL dump 10.13  Distrib 5.1.73, for redhat-linux-gnu (x86_64)
--
-- Host: localhost    Database: aml
-- ------------------------------------------------------
-- Server version	5.1.73

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


USE `aml`;


--
-- Table structure for table `clustersummary`
--

DROP TABLE IF EXISTS `clustersummary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clustersummary` (
  `EntityId` varchar(94) NOT NULL DEFAULT '',
  `Property` varchar(47) NOT NULL DEFAULT '',
  `Tag` varchar(47) DEFAULT NULL,
  `Type` varchar(47) DEFAULT NULL,
  `Value` varchar(188) NOT NULL DEFAULT '',
  `Stat` float DEFAULT NULL,
  PRIMARY KEY (`EntityId`,`Property`,`Value`),
  KEY `ix_csum` (`EntityId`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clustersummarymembers`
--

DROP TABLE IF EXISTS `clustersummarymembers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clustersummarymembers` (
  `SummaryId` varchar(94) NOT NULL DEFAULT '',
  `EntityId` varchar(94) NOT NULL DEFAULT '',
  PRIMARY KEY (`SummaryId`,`EntityId`),
  KEY `ix_cmem` (`SummaryId`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `datasummary`
--

DROP TABLE IF EXISTS `datasummary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datasummary` (
  `SummaryOrder` int(11) NOT NULL,
  `SummaryKey` varchar(94) NOT NULL,
  `SummaryLabel` varchar(1000) DEFAULT NULL,
  `SummaryValue` text,
  `UnformattedNumeric` float DEFAULT NULL,
  `UnformattedDatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`SummaryOrder`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finentity`
--

DROP TABLE IF EXISTS `finentity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `finentity` (
  `EntityId` varchar(94) NOT NULL,
  `InboundDegree` int(11) DEFAULT NULL,
  `UniqueInboundDegree` int(11) DEFAULT NULL,
  `OutboundDegree` int(11) DEFAULT NULL,
  `UniqueOutboundDegree` int(11) DEFAULT NULL,
  `NumTransactions` int(11) DEFAULT NULL,
  `MaxTransaction` float DEFAULT NULL,
  `AvgTransaction` float DEFAULT NULL,
  `StartDate` datetime DEFAULT NULL,
  `EndDate` datetime DEFAULT NULL,
  `Label` varchar(256) DEFAULT NULL,
  `AccountType` varchar(256) DEFAULT NULL,
  `AccountClass` varchar(256) DEFAULT NULL,
  `DateOpened` datetime DEFAULT NULL,
  `Status` varchar(256) DEFAULT NULL,
  `PowerOfAttorney` varchar(256) DEFAULT NULL,
  `InitDate` datetime DEFAULT NULL,
  `CustomerType` varchar(256) DEFAULT NULL,
  `CustomerStreet` varchar(256) DEFAULT NULL,
  `CustomerCity` varchar(256) DEFAULT NULL,
  `CustomerState` varchar(256) DEFAULT NULL,
  `CustomerCountry` varchar(256) DEFAULT NULL,
  `CustomerZip` varchar(256) DEFAULT NULL,
  `CustomerPhoneHome` varchar(256) DEFAULT NULL,
  `CustomerPhoneOffice` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`EntityId`),
  KEY `ix_ff_id` (`EntityId`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finentitydaily`
--

DROP TABLE IF EXISTS `finentitydaily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `finentitydaily` (
  `EntityId` varchar(94) NOT NULL DEFAULT '',
  `PeriodDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `InboundAmount` float DEFAULT NULL,
  `InboundDegree` int(11) DEFAULT NULL,
  `OutboundAmount` float DEFAULT NULL,
  `OutboundDegree` int(11) DEFAULT NULL,
  `Balance` float DEFAULT NULL,
  PRIMARY KEY (`EntityId`,`PeriodDate`),
  KEY `ix_fed` (`EntityId`,`PeriodDate`,`InboundAmount`,`OutboundAmount`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finentitymonthly`
--

DROP TABLE IF EXISTS `finentitymonthly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `finentitymonthly` (
  `EntityId` varchar(94) NOT NULL DEFAULT '',
  `PeriodDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `InboundAmount` float DEFAULT NULL,
  `InboundDegree` int(11) DEFAULT NULL,
  `OutboundAmount` float DEFAULT NULL,
  `OutboundDegree` int(11) DEFAULT NULL,
  `Balance` float DEFAULT NULL,
  PRIMARY KEY (`EntityId`,`PeriodDate`),
  KEY `ix_fem` (`EntityId`,`PeriodDate`,`InboundAmount`,`OutboundAmount`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finentityquarterly`
--

DROP TABLE IF EXISTS `finentityquarterly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `finentityquarterly` (
  `EntityId` varchar(94) NOT NULL DEFAULT '',
  `PeriodDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `InboundAmount` float DEFAULT NULL,
  `InboundDegree` int(11) DEFAULT NULL,
  `OutboundAmount` float DEFAULT NULL,
  `OutboundDegree` int(11) DEFAULT NULL,
  `Balance` float DEFAULT NULL,
  PRIMARY KEY (`EntityId`,`PeriodDate`),
  KEY `ix_feq` (`EntityId`,`PeriodDate`,`InboundAmount`,`OutboundAmount`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finentityweekly`
--

DROP TABLE IF EXISTS `finentityweekly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `finentityweekly` (
  `EntityId` varchar(94) NOT NULL DEFAULT '',
  `PeriodDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `InboundAmount` float DEFAULT NULL,
  `InboundDegree` int(11) DEFAULT NULL,
  `OutboundAmount` float DEFAULT NULL,
  `OutboundDegree` int(11) DEFAULT NULL,
  `Balance` float DEFAULT NULL,
  PRIMARY KEY (`EntityId`,`PeriodDate`),
  KEY `ix_few` (`EntityId`,`PeriodDate`,`InboundAmount`,`OutboundAmount`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finentityyearly`
--

DROP TABLE IF EXISTS `finentityyearly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `finentityyearly` (
  `EntityId` varchar(94) NOT NULL DEFAULT '',
  `PeriodDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `InboundAmount` float DEFAULT NULL,
  `InboundDegree` int(11) DEFAULT NULL,
  `OutboundAmount` float DEFAULT NULL,
  `OutboundDegree` int(11) DEFAULT NULL,
  `Balance` float DEFAULT NULL,
  PRIMARY KEY (`EntityId`,`PeriodDate`),
  KEY `ix_fey` (`EntityId`,`PeriodDate`,`InboundAmount`,`OutboundAmount`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finflow`
--

DROP TABLE IF EXISTS `finflow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `finflow` (
  `FromEntityId` varchar(94) NOT NULL DEFAULT '',
  `FromEntityType` varchar(1) DEFAULT NULL,
  `ToEntityId` varchar(94) NOT NULL DEFAULT '',
  `ToEntityType` varchar(1) DEFAULT NULL,
  `FirstTransaction` datetime DEFAULT NULL,
  `LastTransaction` datetime DEFAULT NULL,
  `Amount` float DEFAULT NULL,
  PRIMARY KEY (`FromEntityId`,`ToEntityId`),
  KEY `ix_ff_to_from` (`ToEntityId`,`FromEntityId`),
  KEY `ix_ff_from_to` (`FromEntityId`,`ToEntityId`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finflowdaily`
--

DROP TABLE IF EXISTS `finflowdaily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `finflowdaily` (
  `FromEntityId` varchar(94) NOT NULL DEFAULT '',
  `FromEntityType` varchar(1) DEFAULT NULL,
  `ToEntityId` varchar(94) NOT NULL DEFAULT '',
  `ToEntityType` varchar(1) DEFAULT NULL,
  `Amount` float DEFAULT NULL,
  `PeriodDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`FromEntityId`,`ToEntityId`,`PeriodDate`),
  KEY `ix_ffd_from` (`FromEntityId`,`PeriodDate`,`ToEntityId`,`Amount`),
  KEY `ix_ffd_to` (`ToEntityId`,`PeriodDate`,`FromEntityId`,`Amount`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finflowmonthly`
--

DROP TABLE IF EXISTS `finflowmonthly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `finflowmonthly` (
  `FromEntityId` varchar(94) NOT NULL DEFAULT '',
  `FromEntityType` varchar(1) DEFAULT NULL,
  `ToEntityId` varchar(94) NOT NULL DEFAULT '',
  `ToEntityType` varchar(1) DEFAULT NULL,
  `Amount` float DEFAULT NULL,
  `PeriodDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`FromEntityId`,`ToEntityId`,`PeriodDate`),
  KEY `ix_ffm_from` (`FromEntityId`,`PeriodDate`,`ToEntityId`,`Amount`),
  KEY `ix_ffm_to` (`ToEntityId`,`PeriodDate`,`FromEntityId`,`Amount`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finflowquarterly`
--

DROP TABLE IF EXISTS `finflowquarterly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `finflowquarterly` (
  `FromEntityId` varchar(94) NOT NULL DEFAULT '',
  `FromEntityType` varchar(1) DEFAULT NULL,
  `ToEntityId` varchar(94) NOT NULL DEFAULT '',
  `ToEntityType` varchar(1) DEFAULT NULL,
  `Amount` float DEFAULT NULL,
  `PeriodDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`FromEntityId`,`ToEntityId`,`PeriodDate`),
  KEY `ix_ffq_from` (`FromEntityId`,`PeriodDate`,`ToEntityId`,`Amount`),
  KEY `ix_ffq_to` (`ToEntityId`,`PeriodDate`,`FromEntityId`,`Amount`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finflowweekly`
--

DROP TABLE IF EXISTS `finflowweekly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `finflowweekly` (
  `FromEntityId` varchar(94) NOT NULL DEFAULT '',
  `FromEntityType` varchar(1) DEFAULT NULL,
  `ToEntityId` varchar(94) NOT NULL DEFAULT '',
  `ToEntityType` varchar(1) DEFAULT NULL,
  `Amount` float DEFAULT NULL,
  `PeriodDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`FromEntityId`,`ToEntityId`,`PeriodDate`),
  KEY `ix_ffw_from` (`FromEntityId`,`PeriodDate`,`ToEntityId`,`Amount`),
  KEY `ix_ffw_to` (`ToEntityId`,`PeriodDate`,`FromEntityId`,`Amount`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finflowyearly`
--

DROP TABLE IF EXISTS `finflowyearly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `finflowyearly` (
  `FromEntityId` varchar(94) NOT NULL DEFAULT '',
  `FromEntityType` varchar(1) DEFAULT NULL,
  `ToEntityId` varchar(94) NOT NULL DEFAULT '',
  `ToEntityType` varchar(1) DEFAULT NULL,
  `Amount` float DEFAULT NULL,
  `PeriodDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`FromEntityId`,`ToEntityId`,`PeriodDate`),
  KEY `ix_ffy_from` (`FromEntityId`,`PeriodDate`,`ToEntityId`,`Amount`),
  KEY `ix_ffy_to` (`ToEntityId`,`PeriodDate`,`FromEntityId`,`Amount`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

