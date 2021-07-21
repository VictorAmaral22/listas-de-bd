-- 1) Escreva comandos select, utilizando as tabelas para uma rede social criadas nas listas de exercícios anteriores, para responder as perguntas:
--  a) Quais os nomes dos usuários em comum entre os grupos SQLite e Banco de Dados-IFRS-2021?
    select usuario.nome from membro
        join usuario on membro.usuario = usuario.email
        join grupo on membro.grupo = grupo.codigo
    where grupo.nome = 'SQLite'
intersect
    select usuario.nome from membro
        join usuario on membro.usuario = usuario.email
        join grupo on membro.grupo = grupo.codigo
    where grupo.nome = 'Banco de Dados-IFRS-2021';

--  b) Qual o nome do usuário do Brasil que mais recebeu curtidas em suas postagens nos últimos 30 dias?
--levando em conta que são os últimos 30 dias de reações e não de posts, porque podemos ter uma reação agora de um post de 2017.

select usuario.nome, count(*) as qtd from usuario
    join cidade on usuario.cidade = cidade.codigo
    join estado on cidade.estado = estado.codigodaUF
    join pais on estado.pais = pais.codigoISO
    join post on usuario.email = post.usuario
    join postreacao on post.codigo = postreacao.post
    join reacao on postreacao.reacao = reacao.codigo
where
    pais.nome = 'Brasil' and 
    reacao.nome = 'curtir' and
    date(postreacao.datapostreacao, 'localtime') between date('now', '-30 days', 'localtime') and date('now', 'localtime')
group by usuario.nome
having count(*) = (
    select count(*) as qtd from usuario
        join cidade on usuario.cidade = cidade.codigo
        join estado on cidade.estado = estado.codigodaUF
        join pais on estado.pais = pais.codigoISO
        join post on usuario.email = post.usuario
        join postreacao on post.codigo = postreacao.post
        join reacao on postreacao.reacao = reacao.codigo
    where 
        pais.nome = 'Brasil' and
        reacao.nome = 'curtir' and
        date(postreacao.datapostreacao, 'localtime') between date('now', '-30 days', 'localtime') and date('now', 'localtime')
    group by usuario.nome
    order by qtd desc
    limit 1
);

--  c) Quais os 5 assuntos mais comentados no Brasil nos últimos 30 dias? - em desenvolvimento ainda
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

select post.codigo, pais.nome, assunto.nome from post
    join cidade on post.cidade = cidade.codigo
    join estado on cidade.estado = estado.codigodaUF
    join pais on estado.pais = pais.codigoISO
    join assuntopost on post.codigo = assuntopost.post
    join assunto on assuntopost.assunto = assunto.codigo
where 
    date(post.datadopost, 'localtime') between date('now', '-30 days', 'localtime') and date('now', 'localtime')
order by post.codigo;

--  d) Quais os 5 assuntos mais comentados por país nos últimos 30 dias?
--  e) Quais os assuntos da postagem que mais recebeu a reação amei na última semana?
--  f) Qual o nome do usuário que postou a postagem que teve mais curtidas no Brasil nos últimos 60 dias?
--  g) Qual faixa etária mais reagiu às postagens do grupo SQLite nos últimos 60 dias? Considere as faixas etárias: -18, 18-21, 21-25, 25-30, 30-36, 36-43, 43-51, 51-60 e 60-.
--  h) Dos 5 assuntos mais comentados no Brasil no mês passado, quais também estavam entre os 5 assuntos mais comentados no Brasil no mês retrasado?
--  i) Quais os nomes dos usuários que participam do grupo SQLite que tiveram a 1ª, 2ª e 3ª maior quantidade de comentários em uma postagem sobre o assunto select?
--  j) Quais os nomes dos usuários dos grupos SQLite ou Banco de Dados-IFRS-2021 que possuem a maior quantidade de amigos?
--  k) Quais os nomes dos usuários dos grupos SQLite ou Banco de Dados-IFRS-2021 que possuem a maior quantidade de amigos em comum?
--  l) Quais os nomes dos usuários que devem ser sugeridos como amigos para um dado usuário? Considere que, se A e B não são amigos mas possuem no mínimo 5 assuntos em comum entre os 10 assuntos mais comentados por cada um nos últimos 3 meses, B deve ser sugerido como amigo de A.


-- 2) Descreva e justifique as adequações/alterações que foram realizadas nas tabelas criadas para uma rede social nas listas de exercícios anteriores para que o exercício 1 acima pudesse ser resolvido.

--trocamos o nome do grupo 'Banco de Dados-IFRS2021' para 'Banco de Dados-IFRS-2021'