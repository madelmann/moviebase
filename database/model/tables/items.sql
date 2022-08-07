-- auto-generated definition
create table items
(
    id            int auto_increment
        primary key,
    filename      varchar(4096)                          null,
    title         varchar(4096)                          null,
    text          varchar(4096)                          null,
    md5sum        varchar(32)                            null,
    actors        varchar(1024)                          null,
    tags          mediumtext                             null,
    length        int        default 0                   null,
    owner         varchar(80)                            null,
    is_private    tinyint(1) default 0                   not null,
    last_modified timestamp  default current_timestamp() not null on update current_timestamp(),
    added         datetime                               null,
    rating_count  int        default 0                   not null,
    rating_value  int        default 0                   not null,
    views         int        default 0                   not null,
    deleted       tinyint(1) default 0                   null,
    filesize      int        default 0                   null
);


