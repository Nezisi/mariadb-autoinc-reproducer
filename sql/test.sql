-- MySQL dump 10.13  Distrib 5.7.22, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: XY
-- ------------------------------------------------------
-- Server version	5.7.25

SET foreign_key_checks=0;
SET time_zone='+00:00';
SET unique_checks=0;
SET sql_mode='NO_AUTO_VALUE_ON_ZERO';

--
-- Table structure for table `pcfeature`
--
DROP TABLE IF EXISTS `pcfeature`;
CREATE TABLE `pcfeature` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62;
--
-- Dumping data for table `pcfeature`
--
LOCK TABLES `pcfeature` WRITE;
INSERT INTO `pcfeature` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),(41),(42),(43),(44),(45),(46),(47),(48),(49),(50),(51),(52),(53),(54),(55),(56),(57),(58),(59),(60),(61);
UNLOCK TABLES;

SET foreign_key_checks=1;
SET unique_checks=1;
-- Dump completed on 2020-10-20 11:38:49
