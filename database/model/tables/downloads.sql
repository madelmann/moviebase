-- auto-generated definition
create table downloads
(
    id      int auto_increment
        primary key,
    source  varchar(1024)               not null,
    target  varchar(1024)               not null,
    created timestamp default sysdate() null,
    started timestamp                   null,
    done    timestamp                   null
);


