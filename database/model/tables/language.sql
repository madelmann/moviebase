CREATE TABLE `language` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(80) NOT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `name` varchar(80) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `language_token_uindex` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;