drop table assuntocomentario;
drop table assuntopost;
drop table assunto;
drop table comentarioreacao;
drop table resposta;
drop table comentario;
drop table postreacao;
drop table reacao;
drop table compartilhar;
drop table citacao;
drop table post;
drop table membro;
drop table grupo;
drop table seguidor;
drop table pagina;
drop table amigo;
drop table usuario;
drop table cidade;
drop table estado;
drop table pais;

create table pais(
   codigoISO char(3) not null,
   nome varchar(100) not null,
   primary key(codigoISO)
);

create table estado(
   codigodaUF char(2) not null,
   nome varchar(100),
   pais char(3) not null,
   foreign key(pais) references pais(codigoISO),
   primary key(codigodaUF)
);

create table cidade(
   codigo integer not null,
   nome varchar(100) not null,
   estado char(2) not null,
   foreign key (estado) references estado(codigodaUF),
   primary key (codigo)
);

create table usuario(
   email varchar(200) not null,
   nome varchar(200) not null,
   genero char(1) not null,
   datanasc date not null,
   datadecadastro date not null, --default current_date
   horadecadastro time not null, --default current_timestamp
   cidade integer not null, 
   foreign key(cidade) references cidade(codigo),
   primary key(email),
   check(genero = 'm' or genero = 'f')
);
 
create table amigo(
   usuario1 varchar(200) not null,
   usuario2 varchar(200) not null,
   datadeamizade date not null, --default current_date
   horadeamizade time not null, --default current_timestamp
   foreign key(usuario1) references usuario(email),
   foreign key(usuario2) references usuario(email),
   primary key(usuario1, usuario2)
);

create table pagina(
    codigo integer not null, 
    nome varchar(300) not null,
    primary key(codigo)
);

create table seguidor(
    usuario varchar(200) not null,
    pagina integer not null,
    foreign key(usuario) references usuario(email),
    foreign key(pagina) references pagina(codigo),
    primary key(usuario, pagina)
);

create table grupo(
    codigo integer not null,
    nome varchar(300) not null,
    primary key(codigo)
);

create table membro(
    usuario varchar(200) not null,
    grupo integer not null,
    foreign key(usuario) references usuario(email),
    foreign key(grupo) references grupo(codigo),
    primary key(usuario, grupo)
);


create table post(
    codigo integer not null,
    usuario varchar(200) not null,
    datadopost date not null, --default current_date
    horadopost time not null, --default current_timestamp
    conteudo varchar(300),
    cidade integer not null,
    grupo integer, 
    pagina integer, 
    foreign key(cidade) references cidade(codigo),
    foreign key(grupo) references grupo(codigo),
    foreign key(pagina) references pagina(codigo),
    foreign key(usuario) references usuario(email),
    primary key(codigo)
);

create table citacao(
    post integer not null,
    usuario varchar(200) not null,
    foreign key(post) references post(codigo),
    foreign key(usuario) references usuario(email),
    primary key(post, usuario)
);


create table compartilhar(
    post integer not null,
    usuario varchar(200) not null,
    datadecompartilhamento date not null, --default current_date
    horariodecompartilhamento time not null, --default current_timestamp
    foreign key(post) references post(codigo),
    foreign key(usuario) references usuario(email),
    primary key(post, usuario)
);

create table reacao(
    codigo integer not null,
    nome varchar(30) not null,
    primary key(codigo)
);

create table postreacao(
    post integer not null,
    reacao integer not null,
    usuario varchar(200) not null,
    datapostreacao date not null, --default current_date
    horapostreacao time not null, --default current_timestamp
    foreign key(post) references post(codigo),
    foreign key(reacao) references reacao(codigo),
    foreign key(usuario) references usuario(email),
    primary key(post, usuario)
);

create table comentario(
    codigo integer not null,
    conteudo varchar(100000),
    datacomentario date not null, --default current_date
    horacomentario time not null, --default current_timestamp
    usuario varchar(200) not null,
    post integer not null,
    foreign key (usuario) references usuario(email),
    foreign key (post) references post(codigo),
    primary key(codigo)
);

create table resposta(
    comentario1 integer not null,
    comentario2 integer not null,
    foreign key(comentario1) references comentario(codigo),
    foreign key(comentario2) references comentario(codigo),
    primary key(comentario1, comentario2)
);

create table comentarioreacao(
   comentario integer not null,
   reacao integer not null,
   usuario varchar(200) not null,
   datacomentarioreacao date not null, --default current_date
   horacomentarioreacao time not null, --default current_timestamp
   foreign key(comentario) references comentario(codigo),
   foreign key(reacao) references reacao(codigo),
   foreign key(usuario) references usuario(email),
   primary key(comentario, usuario)
);

create table assunto(
    codigo integer not null,
    nome varchar(200) not null,
    primary key(codigo)
);

create table assuntopost(
   assunto integer not null,
   post integer not null,
   foreign key(assunto) references assunto(codigo),
   foreign key(post) references post(codigo),
   primary key(assunto,post)
);

create table assuntocomentario(
  assunto integer not null,
  comentario integer not null,
  foreign key(assunto) references assunto(codigo),
  foreign key(comentario) references comentario(codigo),
  primary key(assunto,comentario)
);

insert into pais(codigoISO, nome) values('BRA', 'Brasil');
insert into estado(codigodaUF, nome, pais) values('RS', 'Rio Grande do Sul', 'BRA');
insert into cidade(codigo, nome, estado) values(1, 'Rio Grande', 'RS');

insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('professordebd@gmail.com','Professor de BD', 'm', '1950-01-22', '2010-01-01', '09:00:00', 1); 
insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('joaosbras@mymail.com','João Silva Brasil', 'm', '1966-01-22', '2020-01-01', '13:00:00', 1);
insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('pedroalencar@gmail.com','Pedro Alencar Pereira', 'm', '1974-03-23', '2020-01-01', '13:05:00', 1); 
insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('mcalbuq@mymail.com','Maria Cruz Albuquerque', 'f', '1983-12-02', '2020-01-01', '13:10:00', 1); 
insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('jorosamed@mymail.com','Joana Rosa Medeiros', 'f', '1986-11-20', '2020-01-01', '13:15:00', 1); 
insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('pxramos@mymail.com','Paulo Xavier Ramos', 'm', '1995-10-30', '2020-01-01', '13:20:00', 1); 

insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('professordebd@gmail.com','joaosbras@mymail.com', '2021-05-17', '10:00:00');
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('professordebd@gmail.com','pedroalencar@gmail.com', '2021-05-17', '10:05:00');
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('professordebd@gmail.com','mcalbuq@mymail.com', '2021-05-17', '10:10:00');
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('professordebd@gmail.com','jorosamed@mymail.com', '2021-05-17', '10:15:00');
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('professordebd@gmail.com','pxramos@mymail.com', '2021-05-17', '10:20:00');


insert into assunto(codigo, nome) values(1, 'BD');
insert into assunto(codigo, nome) values(2, 'SQLite');
insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('ifrsrg@gmail.com','IFRS campus Rio Grande', 'm', '1999-01-01', '2020-01-01', '13:20:00', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(1, 'joaosbras@mymail.com', '2021-06-02', '15:00:00', 'Hoje eu aprendi como inserir dados no SQLite no IFRS', 1);
insert into assuntopost(assunto, post) values(1, 1);
insert into assuntopost(assunto, post) values(2, 1);
insert into citacao(post, usuario) values(1, 'ifrsrg@gmail.com');

insert into reacao(codigo,nome) values(1, 'curtir');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(1,1,'pedroalencar@gmail.com','2021-06-02', '15:05:00');

insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(1,1,'mcalbuq@mymail.com','2021-06-02', '15:10:00');

insert into assunto(codigo, nome) values(3, 'INSERT');
insert into comentario(codigo, conteudo, datacomentario, horacomentario, usuario, post) values(1, 'Alguém mais ficou com dúvida no comando INSERT?', '2021-06-02', '15:15:00', 'jorosamed@mymail.com', 1);
insert into assuntocomentario(assunto, comentario) values(1,1);
insert into assuntocomentario(assunto, comentario) values(2,1);
insert into assuntocomentario(assunto, comentario) values(3,1);

insert into comentario(codigo, conteudo, datacomentario, horacomentario, usuario, post) values(2, 'Eu também', '2021-06-02', '15:20:00', 'pxramos@mymail.com', 1);
insert into resposta(comentario1, comentario2) values(1,2); --o 2 é resposta do 1 mas os dois são comentarios do post 1

insert into reacao(codigo, nome) values (2, 'triste');
insert into comentarioreacao(comentario, reacao, usuario, datacomentarioreacao, horacomentarioreacao) values(1, 2, 'pxramos@mymail.com', '2021-06-02', '15:20:00');

insert into comentario(codigo, conteudo, datacomentario, horacomentario, usuario, post) values(3, 'Já agendaste horário de atendimento com o professor?', '2021-06-02', '15:30:00', 'joaosbras@mymail.com', 1);
insert into resposta(comentario1, comentario2) values(2,3);

insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(2, 'professordebd@gmail.com','2021-06-02', '15:35:00', 'Atendimento de BD no GMeet amanhã para quem tiver dúvidas de INSERT', 1);
insert into assunto(codigo, nome) values(4, 'atendimento');
insert into assuntopost(assunto, post) values(1,2);
insert into assuntopost(assunto, post) values(2,2);
insert into assuntopost(assunto, post) values(3,2);
insert into assuntopost(assunto, post) values(4,2);
insert into citacao(post, usuario) values(2, 'jorosamed@mymail.com');
insert into citacao(post, usuario) values(2, 'pxramos@mymail.com');
insert into compartilhar(post, usuario, datadecompartilhamento, horariodecompartilhamento) values(2, 'joaosbras@mymail.com', '2021-06-02', '15:40:00');

insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(3, 'mcalbuq@mymail.com','2021-06-02', '15:40:00', 'Olá mundo', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(4, 'mcalbuq@mymail.com','2021-06-02', '15:45:00', 'Olá mundo 2', 1);

insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(5,'pxramos@mymail.com', '2021-06-25', '15:40:00', 'Olá mundo', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(6,'pxramos@mymail.com', '2021-06-25', '15:45:00', 'Olá mundo2', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(7,'pxramos@mymail.com', '2021-06-25', '15:50:00', 'Olá mundo3', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(8,'pxramos@mymail.com', '2021-06-25', '15:55:00', 'Olá mundo4', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(9,'pxramos@mymail.com', '2021-06-26', '15:45:00', 'Olá mundo5', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(10,'pxramos@mymail.com', '2021-06-26', '15:50:00', 'Olá mundo6', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(11,'pxramos@mymail.com', '2021-06-26', '15:55:00', 'Olá mundo7', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(12,'pxramos@mymail.com', '2021-06-27', '15:45:00', 'Olá mundo8', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(13,'pxramos@mymail.com', '2021-06-27', '15:50:00', 'Olá mundo9', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(14,'pxramos@mymail.com', '2021-06-28', '15:45:00', 'Olá mundo10', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(15,'pxramos@mymail.com', '2021-06-29', '15:45:00', 'Olá mundo11', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(16,'pxramos@mymail.com', '2021-06-30', '15:45:00', 'Olá mundo12', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(17,'pxramos@mymail.com', '2021-07-01', '15:45:00', 'Olá mundo13', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(18,'pxramos@mymail.com', '2021-07-01', '15:50:00', 'Olá mundo14', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(19,'pxramos@mymail.com', '2021-07-01', '15:55:00', 'Olá mundo15', 1);

insert into cidade(codigo, nome, estado) values(2, 'São José do Norte', 'RS');
insert into cidade(codigo, nome, estado) values(3, 'Santa Maria', 'RS');

insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('aninha@gmail.com','Aninha', 'f', '2001-09-11', '2010-01-01', '09:00:00', 2); 
insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('mariaclara1@gmail.com','Maria Clara 1', 'f', '2002-04-22', '2010-01-01', '09:00:00', 3); 
insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('mariaclara2@gmail.com','Maria Clara 2', 'f', '2005-11-05', '2010-01-01', '09:00:00', 3); 
insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('giovanna@gmail.com','Giovanna', 'f', '2006-01-22', '2021-07-01', '09:00:00', 1); 

insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(5,1,'pedroalencar@gmail.com','2021-06-25', '18:00:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(6,1,'pedroalencar@gmail.com','2021-06-25', '18:05:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(6,1,'aninha@gmail.com','2021-06-25', '18:05:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(7,1,'aninha@gmail.com','2021-06-25', '18:10:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(8,1,'aninha@gmail.com','2021-06-25', '18:15:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(9,1,'aninha@gmail.com','2021-06-26', '18:20:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(10,1,'aninha@gmail.com','2021-06-26', '18:25:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(11,1,'aninha@gmail.com','2021-06-26', '18:30:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(12,1,'aninha@gmail.com','2021-06-27', '19:35:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(13,1,'aninha@gmail.com','2021-06-27', '19:40:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(14,1,'aninha@gmail.com','2021-06-28', '19:45:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(15,1,'aninha@gmail.com','2021-07-02', '15:50:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(16,1,'aninha@gmail.com','2021-07-02', '15:55:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(17,1,'aninha@gmail.com','2021-07-02', '16:00:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(18,1,'aninha@gmail.com','2021-07-02', '16:05:00');

--inserts da lista 4
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('mcalbuq@mymail.com','joaosbras@mymail.com', '2021-05-17', '10:00:00');

insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('pxramos@mymail.com','joaosbras@mymail.com', '2021-05-17', '10:00:00');
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('pxramos@mymail.com','pedroalencar@gmail.com', '2021-05-17', '10:00:00');
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('mariaclara1@gmail.com','pxramos@mymail.com', '2021-05-17', '10:00:00');
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('jorosamed@mymail.com','joaosbras@mymail.com', '2021-05-17', '10:00:00');
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('jorosamed@mymail.com','pedroalencar@gmail.com', '2021-05-17', '10:00:00');
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('mariaclara1@gmail.com','jorosamed@mymail.com', '2021-05-17', '10:00:00');

insert into reacao(codigo, nome) values (3, 'amei');
insert into assuntopost(assunto, post) values(1,3); --post 3  com amei
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(3,3,'aninha@gmail.com','2021-06-02', '16:05:00');

insert into assuntopost(assunto, post) values(1,4); --post 4 com amei
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(4,3,'aninha@gmail.com','2021-06-02', '16:05:00');

insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(23,'pxramos@mymail.com', '2021-07-14', '10:00:00', 'Sqlite god', 1);
insert into assuntopost(assunto, post) values(2, 23);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(24,'pxramos@mymail.com', '2021-07-14', '10:00:00', 'Sqlite, o que é? Onde vive, o que come...', 1);
insert into assuntopost(assunto, post) values(2, 24);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(25,'mariaclara1@gmail.com', '2021-07-13', '10:00:00', 'Ai ai esse Sqlite', 1);
insert into assuntopost(assunto, post) values(2, 25);

insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(26,'mariaclara1@gmail.com', '2021-07-12', '10:00:00', 'Inserindo dados aleatórios', 1);
insert into assuntopost(assunto, post) values(3, 26);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(27,'mariaclara1@gmail.com', '2021-07-12', '10:00:00', 'Inserindo dados mais aleatórios', 1);
insert into assuntopost(assunto, post) values(3, 27);

insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(28,'mariaclara1@gmail.com', '2021-07-12', '10:00:00', 'Cidade 4', 1);
insert into assuntopost(assunto, post) values(1, 28);

insert into estado(codigodaUF, nome, pais) values('RN', 'Rio Grande do Norte', 'BRA');
insert into cidade(codigo, nome, estado) values(4, 'Natal', 'RN');

insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(29,'mariaclara1@gmail.com', '2021-06-27', '16:00:00', 'Olá mundo9', 4);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(30,'mariaclara1@gmail.com', '2021-06-27', '16:05:00', 'Olá mundo9', 4);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(31,'mariaclara1@gmail.com', '2021-06-27', '16:10:00', 'Olá mundo9', 4);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(32,'mariaclara1@gmail.com', '2021-06-27', '16:15:00', 'Olá mundo9', 4);

insert into assuntopost(assunto, post) values(1, 29);
insert into assuntopost(assunto, post) values(1, 32);

insert into grupo (nome) values ('SQLite');
insert into membro (usuario, grupo) values ('professordebd@gmail.com', 1); --71
insert into membro (usuario, grupo) values ('joaosbras@mymail.com', 1); --55
insert into membro (usuario, grupo) values ('pedroalencar@gmail.com', 1); --47
insert into membro (usuario, grupo) values ('pxramos@mymail.com', 1); --25
insert into membro (usuario, grupo) values ('aninha@gmail.com', 1); --19

insert into post(codigo, grupo, usuario, datadopost, horadopost, conteudo, cidade) values(33, 1, 'professordebd@gmail.com', '2021-06-27', '16:00:00', 'Post aleatório no grupo guys...', 4);
insert into post(codigo, grupo, usuario, datadopost, horadopost, conteudo, cidade) values(34, 1, 'pxramos@mymail.com', '2021-07-02', '16:00:00', 'Post aleatório 2 no grupo guys...', 4);
insert into post(codigo, grupo, usuario, datadopost, horadopost, conteudo, cidade) values(35, 1, 'aninha@gmail.com', '2021-07-13', '16:00:00', 'Post aleatório 3 no grupo guys...', 4);

insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(33, 1, 'aninha@gmail.com', '2021-06-27', '16:05:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(33, 2, 'pxramos@mymail.com', '2021-06-27', '16:05:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(33, 3, 'joaosbras@mymail.com', '2021-06-27', '16:55:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(34, 3, 'joaosbras@mymail.com', '2021-07-02', '16:15:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(34, 3, 'pxramos@mymail.com', '2021-07-02', '16:15:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(35, 3, 'professordebd@gmail.com', '2021-07-13', '16:01:00');

insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('pele@cbf.com.br','Edson Arantes do Nascimento', 'm', '1950-01-22', '2010-01-01', '09:00:00', 1); 
insert into comentario(codigo, conteudo, datacomentario, horacomentario, usuario, post) values(4, 'Blablabla', '2021-06-02', '15:15:00', 'pele@cbf.com.br', 1);
insert into comentario(codigo, conteudo, datacomentario, horacomentario, usuario, post) values(5, 'Blablabla1', '2021-06-02', '15:20:00', 'pele@cbf.com.br', 2);

insert into grupo (nome) values ('Banco de Dados-IFRS-2021');
insert into membro (usuario, grupo) values 
    ('mariaclara2@gmail.com', 2),
    ('professordebd@gmail.com', 2),
    ('jorosamed@mymail.com', 2),
    ('joaosbras@mymail.com', 2);

insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('pmartinssilva90@mymail.com','Paulo Martins Silva', 'm', '2001-09-11', '2010-01-01', '09:00:00', 2); 
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(36,'pmartinssilva90@mymail.com', '2021-06-25', '15:40:00', 'Olá mundo', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(37,'pmartinssilva90@mymail.com', '2021-06-26', '15:40:00', 'Olá mundo', 1);
insert into assuntopost(assunto, post) values(1, 36);
insert into assuntopost(assunto, post) values(2, 36);
insert into assuntopost(assunto, post) values(2, 37);
insert into assuntopost(assunto, post) values(3, 37);
insert into compartilhar(post, usuario, datadecompartilhamento, horariodecompartilhamento) values(36, 'joaosbras@mymail.com', '2021-06-25', '15:40:00');
insert into compartilhar(post, usuario, datadecompartilhamento, horariodecompartilhamento) values(37, 'joaosbras@mymail.com', '2021-06-26', '15:40:00');


--inserts da Lista 5

--c)
insert into assunto(nome) values ('Subselect');

insert into assuntopost(assunto, post) values(4, 23);
insert into assuntopost(assunto, post) values(5, 23);
insert into assuntopost(assunto, post) values(5, 27);
insert into assuntopost(assunto, post) values(1, 26);
insert into assuntopost(assunto, post) values(5, 28);
insert into assuntopost(assunto, post) values(5, 29);
insert into assuntopost(assunto, post) values(2, 32);
insert into assuntopost(assunto, post) values(4, 24);
insert into assuntopost(assunto, post) values(4, 25);
insert into assuntopost(assunto, post) values(5, 25);

insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-15', '00:00:00', 'aninha@gmail.com', 23);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-15', '00:05:00', 'aninha@gmail.com', 23);

insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:00:00', 'aninha@gmail.com', 25);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:05:00', 'aninha@gmail.com', 25);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:10:00', 'aninha@gmail.com', 25);

insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:00:00', 'aninha@gmail.com', 26);

insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:00:00', 'aninha@gmail.com', 27);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:05:00', 'aninha@gmail.com', 27);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:10:00', 'aninha@gmail.com', 27);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:15:00', 'aninha@gmail.com', 27);

insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:00:00', 'aninha@gmail.com', 34);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:05:00', 'aninha@gmail.com', 34);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:10:00', 'aninha@gmail.com', 34);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:15:00', 'aninha@gmail.com', 34);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:20:00', 'aninha@gmail.com', 34);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:25:00', 'aninha@gmail.com', 34);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values ('Blablabla', '2021-07-14', '00:30:00', 'aninha@gmail.com', 34);

--e)
insert into assuntopost(assunto, post) values(1, 34);
insert into assuntopost(assunto, post) values(2, 34);
insert into assuntopost(assunto, post) values(4, 34);

--i)
insert into assunto(nome) values('select');
insert into assuntopost(assunto, post) values(6, 1);
insert into assuntopost(assunto, post) values(6, 2);
insert into assuntopost(assunto, post) values(6, 23);
insert into assuntopost(assunto, post) values(6, 24);
insert into assuntopost(assunto, post) values(6, 34);

insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values('Putzzz', '2021-07-20', '10:00:00', 'jorosamed@mymail.com', 35);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values('Hummmm', '2021-07-30', '10:00:00', 'jorosamed@mymail.com', 35);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values('Doisss', '2021-07-30', '10:05:00', 'jorosamed@mymail.com', 35);
insert into comentario(conteudo, datacomentario, horacomentario, usuario, post) values('Trêssss', '2021-07-30', '10:10:00', 'jorosamed@mymail.com', 35);

insert into assuntocomentario(assunto, comentario) values(6, 23);
insert into assuntocomentario(assunto, comentario) values(6, 24);
insert into assuntocomentario(assunto, comentario) values(6, 25);
insert into assuntocomentario(assunto, comentario) values(6, 26);