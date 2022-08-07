-- auto-generated definition
create table images
(
    id            int auto_increment
        primary key,
    owner         varchar(80)       null,
    title         varchar(255)      not null,
    image         varchar(255)      not null,
    is_processing tinyint default 0 not null,
    is_processed  tinyint default 0 not null,
    is_deleted    tinyint default 0 not null
);


