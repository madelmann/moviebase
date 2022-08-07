-- auto-generated definition
create table collections
(
    id           int auto_increment
        primary key,
    identifier   varchar(255)         not null,
    name         varchar(255)         null,
    description  varchar(4069)        null,
    type         int        default 0 not null,
    is_public    tinyint(1) default 0 not null,
    tags         varchar(1024)        null,
    rating_value int        default 0 not null,
    rating_count int        default 0 not null
);


