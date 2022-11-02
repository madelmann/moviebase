CREATE TABLE `sessions` (
  `id` varchar(256) NOT NULL,
  `identifier` varchar(80) NOT NULL,
  `is_admin` int(11) NOT NULL DEFAULT 0,
  `created` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `expires` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;