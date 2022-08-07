-- auto-generated definition
create table actors
(
    id          int auto_increment
        primary key,
    name        varchar(256)  not null,
    tags        varchar(1024) null,
    description varchar(4096) null
);


