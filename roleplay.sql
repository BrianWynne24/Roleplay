/*
Navicat MySQL Data Transfer

Source Server         : roleplay
Source Server Version : 50612
Source Host           : localhost:3306
Source Database       : hgrp

Target Server Type    : MYSQL
Target Server Version : 50612
File Encoding         : 65001

Date: 2013-07-03 20:26:05
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for jobs
-- ----------------------------
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `JobID` int(11) NOT NULL,
  `Job` varchar(20) DEFAULT NULL,
  `Salary` int(11) DEFAULT NULL,
  `Flags` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`JobID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jobs
-- ----------------------------
INSERT INTO `jobs` VALUES ('1', 'Unemployed', '5', '');
INSERT INTO `jobs` VALUES ('2', 'Admin', '45', 'admin');
INSERT INTO `jobs` VALUES ('3', 'Police Officer', '40', 'pd');

-- ----------------------------
-- Table structure for playerdata
-- ----------------------------
DROP TABLE IF EXISTS `playerdata`;
CREATE TABLE `playerdata` (
  `User` varchar(30) NOT NULL,
  `JobID` int(11) DEFAULT NULL,
  `Money` int(11) DEFAULT NULL,
  `Bank` int(11) DEFAULT NULL,
  `Inventory` text,
  `BankInventory` mediumtext,
  `Hunger` int(11) DEFAULT NULL,
  PRIMARY KEY (`User`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of playerdata
-- ----------------------------
INSERT INTO `playerdata` VALUES ('20920627', '3', '0', '100', null, null, '96');

-- ----------------------------
-- Table structure for property
-- ----------------------------
DROP TABLE IF EXISTS `property`;
CREATE TABLE `property` (
  `Name` varchar(25) DEFAULT NULL,
  `Door` varchar(25) NOT NULL,
  `Price` int(11) DEFAULT NULL,
  `Flags` varchar(25) DEFAULT NULL,
  `Master` varchar(25) DEFAULT NULL,
  `Owner` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`Door`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of property
-- ----------------------------
INSERT INTO `property` VALUES ('Closet', 'closet_01', '500', null, null, null);
INSERT INTO `property` VALUES (null, 'police_child01', null, null, 'police_master', null);
INSERT INTO `property` VALUES (null, 'police_child02', null, null, 'police_master', null);
INSERT INTO `property` VALUES ('Police Station', 'police_master', '0', 'pd', null, null);
