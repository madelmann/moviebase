CREATE TABLE `collection_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `collection_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `collection_items_collection_id_index` (`collection_id`)
) ENGINE=InnoDB AUTO_INCREMENT=801 DEFAULT CHARSET=latin1;