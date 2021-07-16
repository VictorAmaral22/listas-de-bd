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
where usuario1= 'pxramos@mymail.com' or usuario2='pxramos@mymail.com' or usuario1='jorosamed@mymail.com' or usuario2='jorosamed@mymail.com'
group by usuario.nome
having count(usuario.nome) = 2;

--  c) Qual a média de curtidas nas postagens que contém o assunto banco de dados?
select cast(count(case when reacao.nome = 'curtir' then 1 else null end ) as real)/cast(count(distinct post.codigo) as real) as media from post
    join assuntopost on post.codigo = assuntopost.post
    join assunto on assuntopost.assunto = assunto.codigo
    left join postreacao on post.codigo = postreacao.post
    left join reacao on postreacao.reacao = reacao.codigo
where 
    (assunto.nome = 'BD' and reacao.nome = 'curtir') or 
    (assunto.nome = 'BD' and reacao.nome != 'curtir') or 
    (assunto.nome = 'BD' and reacao.nome is null);


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
where 
    date(post.datadopost, 'localtime') between date('now', '-3 month', 'localtime') and date('now', 'localtime')
group by estado.nome
order by count(post.codigo) desc;

--  i) Qual o ranking dos usuários do Brasil que mais receberam curtidas em suas postagens nos últimos 30 dias?

--Estamos considerando que mais curtidas em suas postagens se trata de independente de quantas postagens, ter mais curtidas.primary

select post.usuario from post 
    join postreacao on post.codigo = postreacao.post 
    join usuario on post.usuario = usuario.email 
    join cidade on usuario.cidade = cidade.codigo 
    join estado on cidade.estado = estado.codigodaUF 
    join pais on estado.pais = pais.codigoISO 
    join reacao on postreacao.reacao = reacao.codigo
where 
    reacao.nome = 'curtir' and 
    pais.nome = "Brasil" and
    (date(post.datadopost, 'localtime') between date('now', '-30 days', 'localtime') and date('now', 'localtime'))
group by post.usuario
order by count(post.codigo) desc;

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
where 
    post.grupo = 1 and
    (date(post.datadopost, 'localtime') between date('now', '-60 days', 'localtime') and date('now', 'localtime'))
group by faixaEtaria, usuario.genero
order by qtdReacoes desc;

--  k) Quais os nomes dos usuários que tiveram alguma postagem comentada pelo usuário Edson Arantes do Nascimento, e-mail pele@cbf.com.br, no último mês?

insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('pele@cbf.com.br','Edson Arantes do Nascimento', 'm', '1950-01-22', '2010-01-01', '09:00:00', 1); 
insert into comentario(codigo, conteudo, datacomentario, horacomentario, usuario, post) values(4, 'Blablabla', '2021-06-02', '15:15:00', 'pele@cbf.com.br', 1);
insert into comentario(codigo, conteudo, datacomentario, horacomentario, usuario, post) values(5, 'Blablabla1', '2021-06-02', '15:20:00', 'pele@cbf.com.br', 2);

select post.codigo, usuario.nome from post 
    join usuario on post.usuario = usuario.email
    join comentario on post.codigo = comentario.post
where 
    comentario.usuario = 'pele@cbf.com.br' and
    (date(comentario.datacomentario, 'localtime') between date('now', '-1 month', 'localtime') and date('now', 'localtime'));

--  l) Quais os nomes dos usuários que são amigos dos membros do grupo Banco de Dados-IFRS2021?
insert into grupo (nome) values ('Banco de Dados-IFRS2021');
insert into membro (usuario, grupo) values 
    ('mariaclara2@gmail.com', 2),
    ('professordebd@gmail.com', 2),
    ('jorosamed@mymail.com', 2),
    ('joaosbras@mymail.com', 2);

select
    case
        when usuario.email = membro.usuario then null
        when usuario.email != membro.usuario then usuario.nome
    end as amigoNome
from grupo
    join membro on grupo.codigo = membro.grupo
    join amigo on membro.usuario = amigo.usuario1 or membro.usuario = amigo.usuario2
    join usuario on amigo.usuario1 = usuario.email or amigo.usuario2 = usuario.email
where
    grupo.nome = 'Banco de Dados-IFRS2021' and
    amigoNome is not null
group by amigoNome
order by grupo.nome, membro.usuario;

--  m) Quais os nomes dos usuários que receberam mais de 1000 curtidas em uma postagem, em menos de 24 horas após a postagem, nos últimos 7 dias?
select usuario.nome from postreacao 
    join post on postreacao.post=post.codigo 
    join reacao on postreacao.reacao=reacao.codigo 
    join usuario on post.usuario = usuario.email
where 
    reacao.nome = 'curtir' and
    (datetime(postreacao.datapostreacao, 'localtime') between datetime(post.datadopost, 'localtime') and datetime(post.datadopost, '+1 day', 'localtime')) and
    (datetime(post.datadopost, 'localtime') between datetime('now', '-7 days', 'localtime') and datetime('now', 'localtime'))
group by post.codigo
having count(postreacao.reacao) > 1000;

--  n) Quais os assuntos das postagens do usuário Paulo Martins Silva, e-mail pmartinssilva90@mymail.com, compartilhadas pelo usuário João Silva Brasil, e-mail joaosbras@mymail.com, nos últimos 3 meses?
insert into usuario(email, nome, genero, datanasc, datadecadastro, horadecadastro, cidade) values('pmartinssilva90@mymail.com','Paulo Martins Silva', 'm', '2001-09-11', '2010-01-01', '09:00:00', 2); 
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(36,'pmartinssilva90@mymail.com', '2021-06-25', '15:40:00', 'Olá mundo', 1);
insert into post(codigo, usuario, datadopost, horadopost, conteudo, cidade) values(37,'pmartinssilva90@mymail.com', '2021-06-26', '15:40:00', 'Olá mundo', 1);
insert into assuntopost(assunto, post) values(1, 36);
insert into assuntopost(assunto, post) values(2, 36);
insert into assuntopost(assunto, post) values(2, 37);
insert into assuntopost(assunto, post) values(3, 37);
insert into compartilhar(post, usuario, datadecompartilhamento, horariodecompartilhamento) values(36, 'joaosbras@mymail.com', '2021-06-25', '15:40:00');
insert into compartilhar(post, usuario, datadecompartilhamento, horariodecompartilhamento) values(37, 'joaosbras@mymail.com', '2021-06-26', '15:40:00');

select assunto.nome from post
    join assuntopost on post.codigo = assuntopost.post
    join assunto on assuntopost.assunto = assunto.codigo
    join compartilhar on post.codigo = compartilhar.post
where 
    (post.usuario = 'pmartinssilva90@mymail.com') and
    (compartilhar.usuario = 'joaosbras@mymail.com') and
    (date(datadopost, 'localtime') between date('now', '-3 month', 'localtime') and date('now', 'localtime'))
group by assunto.nome;

--2) Descreva e justifique as adequações/alterações que foram realizadas nas tabelas criadas para uma rede social nas listas de exercícios anteriores para que o exercício 1 acima pudesse ser resolvido.

--Ligamos as tabelas página e grupo ao post.
--Adicionamos a data de nascimento dos usuários e o gênero deles.