CREATE TABLE `images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(80) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `is_processing` tinyint(4) NOT NULL DEFAULT 0,
  `is_processed` tinyint(4) NOT NULL DEFAULT 0,
  `is_deleted` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;