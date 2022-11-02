CREATE TABLE `collections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `is_public` tinyint(1) NOT NULL DEFAULT 0,
  `tags` varchar(1024) DEFAULT NULL,
  `description` varchar(4096) DEFAULT NULL,
  `rating_count` int(11) NOT NULL DEFAULT 0,
  `rating_value` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `collections_id_index` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4;