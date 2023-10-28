create database UserProject
go
use UserProject

create table users (
    id          int         not null    identity (0, 1),
    name        varchar(45) not null ,
    username    varchar(45) not null    unique ,
    password    varchar(45) not null    default ('123mudar'),
    email       varchar(45) not null ,
    primary key (id)
)
go
create table projects (
    id          int         not null    identity (10000, 1),
    name        varchar(45) not null ,
    description varchar(45) null ,
    date        DATE        not null    check (date >= '01-09-2014'),
    primary key (id)
)
go
create table users_has_projects (
    users_id    int         not null ,
    projects_id int         not null ,
    primary key (users_id, projects_id),
    foreign key (users_id) references users (id),
    foreign key (projects_id) references projects(id)
)

alter table users
drop constraint UQ__users__F3DBC572E67D6552

alter table users
alter column username       varchar(10)     not null

alter table users
add constraint UQ_username unique (username)

alter table users
alter column password   varchar(8)  not null

insert into users
values
    ('Maria', 'Rh_maria', default, 'maria@empresa.com' ),
    ('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
    ('Ana', 'Rh_ana', default, 'ana@empresa.com' ),
    ('Clara', 'Ti_clara', default, 'clara@empresa.com'),
    ('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

insert into projects
values
    ('Re-folha', 'Refatoração das Folhas', '05-09-2014'),
    ('Manutenção PC´s', 'Manutenção PC´s', '06-09-2014'),
    ('Auditoria', null, '07-09-2014')

insert into users_has_projects
values
    (1, 10001),
    (5, 10001),
    (3, 10003),
    (4, 10002),
    (2, 10002)

update projects
set date = '12-09-2014'
where id = 10002

update users
set username = 'Rh_cido'
where name = 'Aparecido'

update users
set password = '888@'
where username = 'Rh_maria' and password = '123mudar'

delete from users_has_projects
where users_id = 2



