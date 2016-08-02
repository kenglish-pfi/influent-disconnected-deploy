
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

--
-- Current Database: `aml`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `aml` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `aml`;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `id` varchar(94) NOT NULL,
  `account_class` varchar(256) DEFAULT NULL,
  `account_type` varchar(256) DEFAULT NULL,
  `customer_id` varchar(256) DEFAULT NULL,
  `date_opened` datetime DEFAULT NULL,
  `status` varchar(256) DEFAULT NULL,
  `power_of_attorney` varchar(256) DEFAULT NULL,
  `customer_name` varchar(256) DEFAULT '<?>',
  `customer_type` varchar(256) DEFAULT '<?>',
  `init_date` datetime DEFAULT NULL,
  `customer_street` varchar(256) DEFAULT '<?>',
  `customer_city` varchar(256) DEFAULT '<?>',
  `customer_state` varchar(256) DEFAULT '<?>',
  `customer_country` varchar(256) DEFAULT '<?>',
  `customer_zip` varchar(256) DEFAULT '<?>',
  `customer_phone_home` varchar(256) DEFAULT NULL,
  `customer_phone_office` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_id` (`id`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transactions` (
  `id` varchar(94) NOT NULL,
  `type` varchar(16) NOT NULL,
  `dt` datetime DEFAULT '2013-01-01 00:00:00',
  `amount_usd` float NOT NULL,
  `transaction_city` varchar(256) DEFAULT NULL,
  `transaction_state` varchar(256) DEFAULT NULL,
  `transaction_country` varchar(256) DEFAULT NULL,
  `debit_party_name` varchar(256) DEFAULT NULL,
  `debit_party_city` varchar(256) DEFAULT NULL,
  `debit_party_state` varchar(256) DEFAULT NULL,
  `debit_party_country` varchar(256) DEFAULT NULL,
  `debit_bank_name` varchar(256) DEFAULT NULL,
  `debit_bank_city` varchar(256) DEFAULT NULL,
  `debit_bank_state` varchar(256) DEFAULT NULL,
  `debit_bank_country` varchar(256) DEFAULT NULL,
  `debit_account` varchar(94) NOT NULL,
  `beneficiary_name` varchar(256) DEFAULT NULL,
  `beneficiary_city` varchar(256) DEFAULT NULL,
  `beneficiary_state` varchar(256) DEFAULT NULL,
  `beneficiary_country` varchar(256) DEFAULT NULL,
  `beneficiary_account` varchar(94) NOT NULL,
  `beneficiary_bank_name` varchar(256) DEFAULT NULL,
  `beneficiary_bank_city` varchar(256) DEFAULT NULL,
  `beneficiary_bank_state` varchar(256) DEFAULT NULL,
  `beneficiary_bank_country` varchar(256) DEFAULT NULL,
  `comment` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `trans_source` (`debit_account`),
  KEY `trans_dest` (`beneficiary_account`),
  KEY `trans_ids` (`debit_account`,`beneficiary_account`)
)  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

