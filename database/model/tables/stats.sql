CREATE TABLE `stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stats_key` varchar(32) NOT NULL,
  `stats_value` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `stats_stats_key_uindex` (`stats_key`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;