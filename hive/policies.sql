-- MySQL dump 10.13  Distrib 5.1.73, for redhat-linux-gnu (x86_64)
--
-- Host: localhost    Database: navigatormetaserver8165ba83e1e24e015027c98bfd967356
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

--
-- Table structure for table `NAV_POLICIES`
--

DROP TABLE IF EXISTS `NAV_POLICIES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `NAV_POLICIES` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `DESCRIPTION` varchar(1024) DEFAULT NULL,
  `QUERY` varchar(1024) NOT NULL,
  `DRL` text,
  `UI_DATA` text,
  `STATUS` varchar(255) DEFAULT NULL,
  `CREATED_BY` varchar(255) NOT NULL,
  `CREATED_ON` bigint(20) NOT NULL,
  `UPDATED_BY` varchar(255) DEFAULT NULL,
  `UPDATED_ON` bigint(20) DEFAULT NULL,
  `LAST_RUN_ON` bigint(20) DEFAULT NULL,
  `ENABLED` bit(1) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `NAME` (`NAME`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NAV_POLICIES`
--

LOCK TABLES `NAV_POLICIES` WRITE;
/*!40000 ALTER TABLE `NAV_POLICIES` DISABLE KEYS */;
INSERT INTO `NAV_POLICIES` VALUES (1,'Archive files older than 7 years','','(sourceType:hdfs) AND (created:[* TO NOW-7YEAR]) AND -tags:archive',NULL,'\"\"[{\"name\":\"MOVE\",\"args\":{\"targetPath\":\"/archive/\"},\"type\":\"CommandAction\",\"enabled\":true},{\"name\":null,\"description\":null,\"properties\":null,\"tags\":[\"archive\"],\"type\":\"UpdateEntityAction\",\"enabled\":true},{\"message\":{\"value\":\"archive_file\",\"expression\":false},\"queue\":\"hdfs_archive_queue\",\"type\":\"SendMessageAction\",\"enabled\":true}]',NULL,'admin',1435759730688,'admin',1443335824227,1436882880999,''),(2,'Autoclassify incoming sales data','','(sourceType:hive) AND (originalName:salesdata) AND (type:Table)',NULL,'\"\"[{\"name\":null,\"description\":{\"value\":\"This is the real estate sales history from March 2014 in New York. Obtained by monthly MLS feed.\",\"expression\":false},\"properties\":{\"month\":{\"value\":\"March\",\"expression\":false},\"retain_until\":{\"value\":\"Calendar.getInstance().add(Calendar.YEAR, 7).getTime()\",\"expression\":true},\"source\":{\"value\":\"nycmls\",\"expression\":false}},\"tags\":[\"realestate\",\"mls\",\"salesdata\"],\"type\":\"UpdateEntityAction\",\"enabled\":true}]',NULL,'admin',1435759798333,'admin',1443299449232,1444341371768,''),(3,'Encrypt sensitive data','','tags:pii and -tags:encrypted',NULL,'\"\"[{\"name\":null,\"description\":null,\"properties\":null,\"tags\":[\"encrypted\"],\"type\":\"UpdateEntityAction\",\"enabled\":true},{\"message\":null,\"queue\":\"encrypt_queue\",\"type\":\"SendMessageAction\",\"enabled\":true}]',NULL,'admin',1435759831457,'admin',1435759831457,NULL,''),(4,'Notify when permissions are incorrect','','(permissions:\"rwxrwxrwx\") AND (sourceType:hdfs) AND (type:file OR type:directory) AND (deleted:false)',NULL,'\"\"[{\"name\":null,\"description\":null,\"properties\":null,\"tags\":[\"bad_permissions\"],\"type\":\"UpdateEntityAction\",\"enabled\":true},{\"message\":{\"value\":\"bad_permissions:\",\"expression\":false},\"queue\":\"config_q\",\"type\":\"SendMessageAction\",\"enabled\":true}]',NULL,'admin',1435759855445,'admin',1435759887107,NULL,''),(5,'Tag sensitive data','','originalName:\"s_neighbor\" AND sourceType:hive AND type:field',NULL,'\"\"[{\"name\":null,\"description\":null,\"properties\":{},\"tags\":[\"sensitive\"],\"type\":\"UpdateEntityAction\",\"enabled\":true}]',NULL,'admin',1438407611907,'admin',1438407611907,1445442787529,'');
/*!40000 ALTER TABLE `NAV_POLICIES` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-10-22 14:31:16
