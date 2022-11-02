CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_modified` timestamp NOT NULL DEFAULT current_timestamp(),
  `username` varchar(128) NOT NULL,
  `password` varchar(80) NOT NULL,
  `identifier` varchar(80) NOT NULL,
  `is_admin` int(11) NOT NULL DEFAULT 0,
  `surname` varchar(80) DEFAULT NULL,
  `prename` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4;