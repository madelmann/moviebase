CREATE TABLE `downloads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source` varchar(1024) NOT NULL,
  `target` varchar(1024) NOT NULL,
  `created` timestamp NULL DEFAULT sysdate(),
  `started` timestamp NULL DEFAULT NULL,
  `done` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;