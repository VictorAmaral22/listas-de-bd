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
   primary key(codigodaUF),
   foreign key(pais) references pais(codigoISO)
   );

create table cidade(
   codigo integer not null,
   nome varchar(100) not null,
   estado char(2) not null,
   primary key (codigo),
   foreign key (estado) references estado(codigodaUF)
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
   foreign key(usuario2) references usuario(email)
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
    foreign key(pagina) references pagina(codigo)
);

create table grupo(
    codigo integer not null,
    nome varchar(300) not null,
    primary key(codigo)
);

create table membro(
    usuario varchar(200) not null,
    grupo integer not null,
    foreign key(usuario) references usuario(email)
    foreign key(grupo) references grupo(codigo)
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
    primary key(codigo),
    foreign key(usuario) references usuario(email)
);

create table citacao(
    post integer not null,
    usuario varchar(200) not null,
    foreign key(post) references post(codigo),
    foreign key(usuario) references usuario(email)
);


create table compartilhar(
    post integer not null,
    usuario varchar(200) not null,
    datadecompartilhamento date not null, --default current_date
    horariodecompartilhamento time not null, --default current_timestamp
  foreign key(post) references post(codigo),
    foreign key(usuario) references usuario(email)
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
    foreign key(usuario) references usuario(email)
);

create table comentario(
    codigo integer not null,
    conteudo varchar(100000),
    datacomentario date not null, --default current_date
    horacomentario time not null, --default current_timestamp
    usuario varchar(200) not null,
    post integer not null,
    primary key(codigo),
    foreign key (usuario) references usuario(email),
    foreign key (post) references post(codigo)
);

create table resposta(
    comentario1 integer not null,
    comentario2 integer not null,
    foreign key(comentario1) references comentario(codigo),
    foreign key(comentario2) references comentario(codigo)
);

create table comentarioreacao(
   comentario integer not null,
   reacao integer not null,
   usuario varchar(200) not null,
   datacomentarioreacao date not null, --default current_date
   horacomentarioreacao time not null, --default current_timestamp
   foreign key(comentario) references comentario(codigo),
   foreign key(reacao) references reacao(codigo),
    foreign key(usuario) references usuario(email)
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
   foreign key(post) references post(codigo)
);

create table assuntocomentario(
  assunto integer not null,
  comentario integer not null,
  foreign key(assunto) references assunto(codigo),
   foreign key(comentario) references comentario(codigo)
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

insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(2, 'professordebd@gmail.com', 
'2021-06-02', '15:35:00', 'Atendimento de BD no GMeet amanhã para quem tiver dúvidas de INSERT', 1);
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

insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(5,1,'pedroalencar@gmail.com','2021-06-02', '15:00:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(6,1,'pedroalencar@gmail.com','2021-06-02', '15:05:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(6,1,'aninha@gmail.com','2021-06-02', '15:05:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(7,1,'aninha@gmail.com','2021-06-02', '15:10:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(8,1,'aninha@gmail.com','2021-06-02', '15:15:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(9,1,'aninha@gmail.com','2021-06-02', '15:20:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(10,1,'aninha@gmail.com','2021-06-02', '15:25:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(11,1,'aninha@gmail.com','2021-06-02', '15:30:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(12,1,'aninha@gmail.com','2021-06-02', '15:35:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(13,1,'aninha@gmail.com','2021-06-02', '15:40:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(14,1,'aninha@gmail.com','2021-06-02', '15:45:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(15,1,'aninha@gmail.com','2021-06-02', '15:50:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(16,1,'aninha@gmail.com','2021-06-02', '15:55:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(17,1,'aninha@gmail.com','2021-06-02', '16:00:00');
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(18,1,'aninha@gmail.com','2021-06-02', '16:05:00');

--1) Escreva comandos select, utilizando as tabelas para uma rede social criadas nas listas de exercícios anteriores, para responder as perguntas:
--  a) Quais os nomes dos usuários que são amigos de Maria Cruz Albuquerque, e-mail mcalbuq@mymail.com?
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('mcalbuq@mymail.com','joaosbras@mymail.com', '2021-05-17', '10:00:00');

select usuario.nome from amigo
    join usuario on amigo.usuario1 = usuario.email or amigo.usuario2 = usuario.email
where 
    lower(usuario1) like '%mcalbuq@mymail.com%' or
    lower(usuario2) like '%mcalbuq@mymail.com%'
group by usuario.nome
having usuario.email!='mcalbuq@mymail.com';

--  b) Quais os nomes dos usuários que são amigos de Paulo Xavier Ramos, e-mail pxramos@mymail.com, e também de Joana Rosa Medeiros, e-mail jorosamed@mymail.com?
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('pxramos@mymail.com','joaosbras@mymail.com', '2021-05-17', '10:00:00');
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('pxramos@mymail.com','pedroalencar@gmail.com', '2021-05-17', '10:00:00');
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('mariaclara1@gmail.com','pxramos@mymail.com', '2021-05-17', '10:00:00');
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('jorosamed@mymail.com','joaosbras@mymail.com', '2021-05-17', '10:00:00');
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('jorosamed@mymail.com','pedroalencar@gmail.com', '2021-05-17', '10:00:00');
insert into amigo(usuario1, usuario2, datadeamizade, horadeamizade) values('mariaclara1@gmail.com','jorosamed@mymail.com', '2021-05-17', '10:00:00');

select usuario.nome from amigo
    join usuario on amigo.usuario1 = usuario.email or amigo.usuario2 = usuario.email
where 
    (lower(usuario1) like '%pxramos@mymail.com%' or
        lower(usuario2) like '%pxramos@mymail.com%') or
    (lower(usuario1) like '%jorosamed@mymail.com%' or
        lower(usuario2) like '%jorosamed@mymail.com%')
group by usuario.nome
having (usuario.email != 'pxramos@mymail.com' and usuario.email != 'jorosamed@mymail.com');

--  c) Qual a média de curtidas nas postagens que contém o assunto banco de dados? -REVISAR
select assunto.nome, count(*)/count(distinct post.codigo) as media from post
    join assuntopost on post.codigo = assuntopost.post
    join assunto on assuntopost.assunto = assunto.codigo
    left join postreacao on post.codigo = postreacao.post
    left join reacao on postreacao.reacao = reacao.codigo
where assunto.nome = 'BD' and reacao.nome = 'curtir' or assunto.nome = 'BD' and reacao.nome is null;

--  d) Qual a média de comentários das postagens que contém o assunto banco de dados?
select assunto.nome, cast(count(distinct comentario.codigo) as real)/cast(count(distinct post.codigo) as real) as media from post
    join assuntopost on post.codigo = assuntopost.post
    join assunto on assuntopost.assunto = assunto.codigo
    left join comentario on post.codigo = comentario.post
where assunto.nome = 'BD';

--  e) Quantas postagens sobre o assunto banco de dados receberam a reação amei nos últimos 3 meses?
insert into reacao(codigo, nome) values (3, 'amei');
insert into assuntopost(assunto, post) values(1,3); --post 3  com amei
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(3,3,'aninha@gmail.com','2021-06-02', '16:05:00');

insert into assuntopost(assunto, post) values(1,4); --post 4 com amei
insert into postreacao(post, reacao, usuario, datapostreacao, horapostreacao) values(4,3,'aninha@gmail.com','2021-06-02', '16:05:00');

select assunto.nome, count(distinct post.codigo) as numero from post
    join assuntopost on post.codigo = assuntopost.post
    join assunto on assuntopost.assunto = assunto.codigo
    left join postreacao on post.codigo = postreacao.post
    left join reacao on postreacao.reacao = reacao.codigo
where assunto.nome like '%BD%' and reacao.nome='amei';

--  f) Qual o ranking dos assuntos mais postados na última semana?
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

select assunto.nome, count(*) as qtdPosts from post 
    join assuntopost on post.codigo = assuntopost.post
    join assunto on assuntopost.assunto = assunto.codigo
where
    date(post.datadopost, 'localtime') between date('now', '-7 days', 'localtime') and date('now', 'localtime')
group by assunto.nome order by qtdPosts desc;


--  g) Qual o ranking da quantidade de postagens por estado no Brasil nos últimos 3 meses?
insert into estado(codigodaUF, nome, pais) values('RN', 'Rio Grande do Norte', 'BRA');
insert into cidade(codigo, nome, estado) values(4, 'Natal', 'RN');

-- insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(23,'mariaclara1@gmail.com', '2021-06-27', '16:00:00', 'Olá mundo9', 4);

insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(29,'mariaclara1@gmail.com', '2021-06-27', '16:00:00', 'Olá mundo9', 4);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(30,'mariaclara1@gmail.com', '2021-06-27', '16:05:00', 'Olá mundo9', 4);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(31,'mariaclara1@gmail.com', '2021-06-27', '16:10:00', 'Olá mundo9', 4);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(32,'mariaclara1@gmail.com', '2021-06-27', '16:15:00', 'Olá mundo9', 4);

select count(post.codigo), estado.nome as estado from post join cidade on post.cidade = cidade.codigo join estado on cidade.estado = estado.codigodaUF
where
    date(post.datadopost, 'localtime') between date('now', '-3 months', 'localtime') and date('now', 'localtime')
group by estado.nome
order by count(post.codigo) desc ;

--  h) Qual o ranking da quantidade de postagens contendo o assunto banco de dados por estado no Brasil nos últimos 3 meses?
insert into assuntopost(assunto, post) values(1, 29);
insert into assuntopost(assunto, post) values(1, 32);

select count(post.codigo), estado.nome as estado from post 
    join cidade on post.cidade = cidade.codigo 
    join estado on cidade.estado = estado.codigodaUF
    join assuntopost on post.codigo = assuntopost.post
    join assunto on assuntopost.assunto = assunto.codigo
where date(post.datadopost, 'localtime') between date('now', '-3 month', 'localtime') and date('now', 'localtime')
group by estado.nome
order by count(post.codigo) desc;

--  i) Qual o ranking dos usuários do Brasil que mais receberam curtidas em suas postagens nos últimos 30 dias?


--  j) Qual o ranking da quantidade de reações às postagens do grupo SQLite por faixa etária por gênero nos últimos 60 dias? 
-- Considere as faixas etárias: -18, 18-21, 21-25, 25-30, 30-36, 36-43, 43-51, 51-60 e 60-.
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

select case
    when cast((julianday('now', 'localtime')-julianday(usuario.datanasc, 'localtime'))/365.2422 as integer) < 18 then 'Menor de 18'
    when cast((julianday('now', 'localtime')-julianday(usuario.datanasc, 'localtime'))/365.2422 as integer) between 18 and 21 then 'De 18 a 21'
    when cast((julianday('now', 'localtime')-julianday(usuario.datanasc, 'localtime'))/365.2422 as integer) between 21 and 25 then 'De 21 a 25'
    when cast((julianday('now', 'localtime')-julianday(usuario.datanasc, 'localtime'))/365.2422 as integer) between 25 and 30 then 'De 25 a 30'
    when cast((julianday('now', 'localtime')-julianday(usuario.datanasc, 'localtime'))/365.2422 as integer) between 30 and 36 then 'De 30 a 36'
    when cast((julianday('now', 'localtime')-julianday(usuario.datanasc, 'localtime'))/365.2422 as integer) between 36 and 43 then 'De 36 a 43'
    when cast((julianday('now', 'localtime')-julianday(usuario.datanasc, 'localtime'))/365.2422 as integer) between 43 and 51 then 'De 43 a 51'
    when cast((julianday('now', 'localtime')-julianday(usuario.datanasc, 'localtime'))/365.2422 as integer) between 51 and 60 then 'De 51 a 60'
    when cast((julianday('now', 'localtime')-julianday(usuario.datanasc, 'localtime'))/365.2422 as integer) > 60 then 'Maior de 60'
end as faixaEtaria, usuario.genero, count(*) as qtdReacoes
from post
    join postreacao on post.codigo = postreacao.post
    join reacao on postreacao.reacao = reacao.codigo
    join usuario on postreacao.usuario = usuario.email
where post.grupo = 1
group by faixaEtaria, usuario.genero;

--  k) Quais os nomes dos usuários que tiveram alguma postagem comentada pelo usuário Edson Arantes do Nascimento, e-mail pele@cbf.com.br, no último mês?

--  l) Quais os nomes dos usuários que são amigos dos membros do grupo Banco de Dados-IFRS2021?

--  m) Quais os nomes dos usuários que receberam mais de 1000 curtidas em uma postagem, em menos de 24 horas após a postagem, nos últimos 7 dias?

--  n) Quais os assuntos das postagens do usuário Paulo Martins Silva, e-mail pmartinssilva90@mymail.com, compartilhadas pelo usuário João Silva Brasil, e-mail joaosbras@mymail.com, nos últimos 3 meses?



--2) Descreva e justifique as adequações/alterações que foram realizadas nas tabelas criadas para uma rede social nas listas de exercícios anteriores para que o exercício 1 acima pudesse ser resolvido.

--Ligamos as tabelas página e grupo ao post.
--Adicionamos a data de nascimento dos usuários e o gênero deles.