-- Facebook

--DROP
drop table reagePost;
drop table assuntoPost;
drop table perfilCitado;
drop table post;
drop table perfilPagina;
drop table pagina;
drop table perfilGrupo;
drop table grupo;
drop table amigo;
drop table perfil;
drop table cidade;
drop table estado;
drop table reacao;
drop table assunto;
drop table pais;

--TABLES

create table pais(
    codigo integer not null,
    nome varchar(50) not null,
    primary key(codigo)
);
insert into pais (codigo, nome) values (1,'Brasil');

create table assunto(
    codigo integer not null,
    nome varchar(30) not null,
    primary key(codigo)
);
insert into assunto (codigo, nome) values 
    (1, 'BD'),
    (2, 'SQLite'),
    (3, 'INSERT'),
    (4, 'Atendimento');

create table reacao(
    codigo integer not null,
    nome varchar(20),
    primary key(codigo)
);
insert into reacao (nome) values 
    ('Like'),
    ('Haha'),
    ('Amei'),
    ('Wow'),
    ('Grr'),
    ('Triste');

--  localização
create table estado(
    uf char(2) not null,
    pais integer not null,
    sigla char(2) not null,
    nome varchar(50) not null,
    foreign key(pais) references pais(codigo),
    primary key(uf, pais)
);
insert into estado (uf, pais, sigla, nome) values (10, 1, 'RS', 'Rio Grande do Sul');

create table cidade(
    municipio char(7) not null,
    estado char(2) not null,
    pais integer not null,
    nome varchar(50) not null,
    foreign key(estado, pais) references estado(uf, pais),
    primary key(municipio, estado, pais)
);
insert into cidade (municipio, estado, pais, nome) values (1234567, 10, 1, 'Rio Grande');

--  perfil
create table perfil(
    email varchar(40) not null,
    cidade char(7) not null,
    estado char(2) not null,
    pais integer not null,
    nome varchar(100) not null,
    dataHora datetime not null default current_timestamp, 
    foreign key(cidade, estado, pais) references cidade(municipio, estado, pais),
    primary key(email)
);
insert into perfil (email, cidade, estado, pais, nome, dataHora) values 
    ('professordebd@gmail.com', 1234567, 10, 1, 'Professor de BD', '2010-01-01 09:00:00'),
    ('joaosbras@mymail.com', 1234567, 10, 1, 'João Silva Brasil', '2020-01-01 13:00:00'),
    ('pedroalencarpereira@gmail.com', 1234567, 10, 1, 'Pedro Alencar Pereira', '2020-01-01 13:05:00'),
    ('mcalbuq@mymail.com', 1234567, 10, 1, 'Maria Cruz Albuquerque', '2020-01-01 13:10:00'),
    ('jorosamed@mymail.com', 1234567, 10, 1, 'Joana Rosa Medeiros', '2020-01-01 13:15:00'),
    ('pxramos@mymail.com', 1234567, 10, 1, 'Paulo Xavier Ramos', '2020-01-01 13:20:00');
insert into perfil (email, cidade, estado, pais, nome) values ('ifrscampusriogrande@riogrande.ifrs.edu.br', 1234567, 10, 1, 'IFRS Campus Rio Grande');

create table amigo(
    perfil varchar(40) not null,
    perfil_amigo varchar(40) not null,
    dataHora datetime not null default current_timestamp,
    foreign key(perfil) references perfil(email),
    foreign key(perfil_amigo) references perfil(email),
    primary key(perfil, perfil_amigo)
);
insert into amigo (perfil, perfil_amigo, dataHora) values
    ('professordebd@gmail.com', 'joaosbras@mymail.com', '2021-05-17 10:00:00'),
    ('professordebd@gmail.com', 'pedroalencarpereira@gmail.com', '2021-05-17 10:05:00'),
    ('professordebd@gmail.com', 'mcalbuq@mymail.com', '2021-05-17 10:10:00'),
    ('professordebd@gmail.com', 'jorosamed@mymail.com', '2021-05-17 10:15:00'),
    ('professordebd@gmail.com', 'pxramos@mymail.com', '2021-05-17 10:20:00');

--  grupos/paginas
create table grupo(
    codigo integer not null,
    perfil_criador varchar(40) not null,
    nome varchar(100) not null,
    foreign key(perfil_criador) references perfil(email),
    primary key(codigo)
);
create table perfilGrupo(
    grupo integer not null,
    perfil_participante varchar(40) not null,
    foreign key(grupo) references grupo(codigo),
    foreign key(perfil_participante) references perfil(email),
    primary key(grupo, perfil_participante)
);

create table pagina(
    codigo integer not null,
    perfil_adm varchar(40) not null,
    nome varchar(100) not null,
    foreign key(perfil_adm) references perfil(email),
    primary key(codigo)
);
create table perfilPagina(
    pagina integer not null,
    perfil_participante varchar(40) not null,
    foreign key(pagina) references pagina(codigo),
    foreign key(perfil_participante) references perfil(email),
    primary key(pagina, perfil_participante)
);

--  posts
create table post(
    codigo integer not null,
    perfil varchar(40) not null,
    cidade char(7) not null,
    estado char(2) not null,
    pais integer not null,
    dataHora datetime not null default current_timestamp,
    texto varchar(500) not null,
    postComentado integer,
    postCompart integer,
    foreign key(perfil) references perfil(email),
    foreign key(cidade, estado, pais) references cidade(municipio, estado, pais),
    foreign key(postComentado) references post(codigo),
    foreign key(postCompart) references post(codigo),
    primary key(codigo)
);

create table perfilCitado (
    post integer not null,
    perfil_citado varchar(40) not null,
    foreign key(post) references post(codigo),
    foreign key(perfil_citado) references perfil(email),
    primary key(post, perfil_citado)
);

--  assuntos
create table assuntoPost(
    assunto integer not null,
    post integer not null,
    foreign key(assunto) references assunto(codigo),
    foreign key(post) references post(codigo),
    primary key(assunto, post)
);

--  reações
create table reagePost(
    post integer not null,
    perfil varchar(40) not null,
    reacao integer not null,
    dataHora datetime not null default current_timestamp,
    foreign key(post) references post(codigo),
    foreign key(perfil) references perfil(email),
    foreign key(reacao) references reacao(codigo),
    primary key(post, perfil)
);

--INSERTS
insert into post (perfil, cidade, estado, pais, dataHora, texto) values ('joaosbras@mymail.com', 1234567, 10, 1, '2021-06-02 15:00:00', 'Hoje eu aprendi como inserir dados no SQLite no IFRS');
insert into assuntoPost (assunto, post) values (1, 1),(2, 1);
insert into perfilCitado (post, perfil_citado) values (1, 'ifrscampusriogrande@riogrande.ifrs.edu.br');

insert into reagePost (post, perfil, reacao, dataHora) values (1, 'pedroalencarpereira@gmail.com', 1, '2021-06-02 15:05:00');
insert into reagePost (post, perfil, reacao, dataHora) values (1, 'mcalbuq@mymail.com', 1, '2021-06-02 15:10:00');

insert into post (perfil, cidade, estado, pais, dataHora, texto, postComentado) values ('jorosamed@mymail.com', 1234567, 10, 1, '2021-06-02 15:15:00', 'Alguém mais ficou com dúvida no comando INSERT?', 1);
insert into assuntoPost (assunto, post) values (1, 2),(2, 2),(3, 2);

insert into post (perfil, cidade, estado, pais, dataHora, texto, postComentado) values ('pxramos@mymail.com', 1234567, 10, 1, '2021-06-02 15:20:00', 'Eu também', 2);
insert into reagePost (post, perfil, reacao, dataHora) values (2, 'pxramos@mymail.com', 6, '2021-06-02 15:20:00');

insert into post (perfil, cidade, estado, pais, dataHora, texto, postComentado) values ('joaosbras@mymail.com', 1234567, 10, 1, '2021-06-02 15:30:00', 'Já agendaste horário de atendimento com o professor?', 3);
insert into assuntoPost (assunto, post) values (4, 4),(1, 4);

insert into post (perfil, cidade, estado, pais, dataHora, texto) values ('professordebd@gmail.com', 1234567, 10, 1, '2021-06-02 15:35:00', 'Atendimento de BD no GMeet amanhã para quem tiver dúvidas de INSERT');
insert into assuntoPost (assunto, post) values (4, 5),(1, 5),(2, 5),(3, 5);
insert into perfilCitado (post, perfil_citado) values (5, 'jorosamed@mymail.com'),(5, 'pxramos@mymail.com');

insert into post (perfil, cidade, estado, pais, dataHora, texto, postCompart) values ('joaosbras@mymail.com', 1234567, 10, 1, '2021-06-02 15:40:00', 'Atendimento de BD no GMeet amanhã para quem tiver dúvidas de INSERT', 5);
