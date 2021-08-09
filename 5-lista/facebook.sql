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

--  c) Quais os 5 assuntos mais comentados no Brasil nos últimos 30 dias?
--levamos em conta que comentados, seria no sentido de que foi mencionado em comentários e posts.
select assunto, 
    case
        when qtd2 is null then qtd1
        when qtd2 is not null then qtd1+qtd2
    end as total 
from (
    select assunto.nome as assunto, qtdnoPost.qtd as qtd1, qtdnoComentario.qtd as qtd2 from assunto
        join (
            select assunto.nome, count(*) as qtd from post
                join assuntopost on post.codigo = assuntopost.post
                join assunto on assuntopost.assunto = assunto.codigo
            where 
                date(post.datadopost, 'localtime') between date('now', '-30 days', 'localtime') and date('now', 'localtime') and
                post.usuario in (
                    select usuario.email from usuario
                        join cidade on usuario.cidade = cidade.codigo
                        join estado on cidade.estado = estado.codigodaUF
                        join pais on estado.pais = pais.codigoISO
                    where pais.nome = 'Brasil'
                )
            group by assunto.nome
            order by qtd desc
        ) as qtdnoPost on assunto.nome = qtdnoPost.nome
        left join (
            select assunto.nome, count(*) as qtd from comentario
                join assuntocomentario on comentario.codigo = assuntocomentario.comentario
                join assunto on assuntocomentario.assunto = assunto.codigo
            where 
                date(comentario.datacomentario, 'localtime') between date('now', '-30 days', 'localtime') and date('now', 'localtime') and
                comentario.usuario in (
                    select usuario.email from usuario
                        join cidade on usuario.cidade = cidade.codigo
                        join estado on cidade.estado = estado.codigodaUF
                        join pais on estado.pais = pais.codigoISO
                    where pais.nome = 'Brasil'
                )
            group by assunto.nome
            order by qtd desc
        ) as qtdnoComentario on assunto.nome = qtdnoComentario.nome
) as tmp1
where total in (
    select distinct* from (
        select  
            case
                when qtd2 is null then qtd1
                when qtd2 is not null then qtd1+qtd2
            end as total from (
            select assunto.nome as assunto, qtdnoPost.qtd as qtd1, qtdnoComentario.qtd as qtd2 from assunto
                join (
                    select assunto.nome, count(*) as qtd from post
                        join assuntopost on post.codigo = assuntopost.post
                        join assunto on assuntopost.assunto = assunto.codigo
                    where 
                        date(post.datadopost, 'localtime') between date('now', '-30 days', 'localtime') and date('now', 'localtime') and
                        post.usuario in (
                            select usuario.email from usuario
                                join cidade on usuario.cidade = cidade.codigo
                                join estado on cidade.estado = estado.codigodaUF
                                join pais on estado.pais = pais.codigoISO
                            where pais.nome = 'Brasil'
                        )
                    group by assunto.nome
                    order by qtd desc
                ) as qtdnoPost on assunto.nome = qtdnoPost.nome
                left join (
                    select assunto.nome, count(*) as qtd from comentario
                        join assuntocomentario on comentario.codigo = assuntocomentario.comentario
                        join assunto on assuntocomentario.assunto = assunto.codigo
                    where 
                        date(comentario.datacomentario, 'localtime') between date('now', '-30 days', 'localtime') and date('now', 'localtime') and
                        comentario.usuario in (
                            select usuario.email from usuario
                                join cidade on usuario.cidade = cidade.codigo
                                join estado on cidade.estado = estado.codigodaUF
                                join pais on estado.pais = pais.codigoISO
                            where pais.nome = 'Brasil'
                        )
                    group by assunto.nome
                    order by qtd desc
                ) as qtdnoComentario on assunto.nome = qtdnoComentario.nome
        )
        order by total desc
    )
    limit 5
)
order by total desc;

--  d) Quais os 5 assuntos mais comentados por país nos últimos 30 dias?

--  e) Quais os assuntos da postagem que mais recebeu a reação amei na última semana?
select post.codigo, assunto.nome from post 
    join assuntopost on post.codigo = assuntopost.post
    join assunto on assuntopost.assunto = assunto.codigo
where post.codigo in (
    select post.codigo from post
        join postreacao on post.codigo = postreacao.post
        join reacao on postreacao.reacao = reacao.codigo
    where 
        date(postreacao.datapostreacao, 'localtime') between date('now', '-7 days', 'localtime') and date('now', 'localtime') and
        reacao.nome = 'amei'
    group by post.codigo
    having count(*) = (
        select count(*) as qtd from post
            join postreacao on post.codigo = postreacao.post
            join reacao on postreacao.reacao = reacao.codigo
        where 
            date(postreacao.datapostreacao, 'localtime') between date('now', '-7 days', 'localtime') and date('now', 'localtime') and
            reacao.nome = 'amei'
        group by post.codigo
        order by count(*) desc
        limit 1
    )
    order by count(*) desc
);

--  f) Qual o nome do usuário que postou a postagem que teve mais curtidas no Brasil nos últimos 60 dias?
select usuario.nome from post 
    join usuario on post.usuario = usuario.email
where post.codigo in (
    select post.codigo from post
        join postreacao on post.codigo = postreacao.post
        join reacao on postreacao.reacao = reacao.codigo
    where 
        date(postreacao.datapostreacao, 'localtime') between date('now', '-60 days', 'localtime') and date('now', 'localtime') and
        reacao.nome = 'curtir'
    group by post.codigo
    having count(*) = (
        select count(*) as qtd from post
            join postreacao on post.codigo = postreacao.post
            join reacao on postreacao.reacao = reacao.codigo
        where 
            date(postreacao.datapostreacao, 'localtime') between date('now', '-60 days', 'localtime') and date('now', 'localtime') and
            reacao.nome = 'curtir'
        group by post.codigo
        order by count(*) desc
        limit 1
    )
    order by count(*) desc
);

--  g) Qual faixa etária mais reagiu às postagens do grupo SQLite nos últimos 60 dias? Considere as faixas etárias: -18, 18-21, 21-25, 25-30, 30-36, 36-43, 43-51, 51-60 e 60-.
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
end as faixaEtaria, count(*) as qtdReacoes
from post
    join postreacao on post.codigo = postreacao.post
    join reacao on postreacao.reacao = reacao.codigo
    join usuario on postreacao.usuario = usuario.email
where 
    date(postreacao.datapostreacao, 'localtime') between date('now', '-60 days', 'localtime') and date('now', 'localtime') and
    post.codigo in (
        select post.codigo from post
            join grupo on post.grupo = grupo.codigo
        where grupo.nome = 'SQLite'
    )
group by faixaEtaria
having qtdReacoes = (
        select qtdReacoes from (
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
            end as faixaEtaria, count(*) as qtdReacoes
            from post
                join postreacao on post.codigo = postreacao.post
                join reacao on postreacao.reacao = reacao.codigo
                join usuario on postreacao.usuario = usuario.email
            where 
                post.codigo in (
                    select post.codigo from post
                        join grupo on post.grupo = grupo.codigo
                    where grupo.nome = 'SQLite'
                ) and
                date(postreacao.datapostreacao, 'localtime') between date('now', '-60 days', 'localtime') and date('now', 'localtime')
            group by faixaEtaria
            order by qtdReacoes desc
        )
        limit 1
    )
order by qtdReacoes desc;

--  h) Dos 5 assuntos mais comentados no Brasil no mês passado, quais também estavam entre os 5 assuntos mais comentados no Brasil no mês retrasado?
    select assunto from (
        select assunto, 
            case
                when qtd2 is null then qtd1
                when qtd2 is not null then qtd1+qtd2
            end as total 
        from (
            select assunto.nome as assunto, qtdnoPost.qtd as qtd1, qtdnoComentario.qtd as qtd2 from assunto
                join (
                    select assunto.nome, count(*) as qtd from post
                        join assuntopost on post.codigo = assuntopost.post
                        join assunto on assuntopost.assunto = assunto.codigo
                    where 
                        strftime('%m', post.datadopost, 'localtime') = strftime('%m', 'now', '-1 month', 'localtime') and
                        post.usuario in (
                            select usuario.email from usuario
                                join cidade on usuario.cidade = cidade.codigo
                                join estado on cidade.estado = estado.codigodaUF
                                join pais on estado.pais = pais.codigoISO
                            where pais.nome = 'Brasil'
                        )
                    group by assunto.nome
                    order by qtd desc
                ) as qtdnoPost on assunto.nome = qtdnoPost.nome
                left join (
                    select assunto.nome, count(*) as qtd from comentario
                        join assuntocomentario on comentario.codigo = assuntocomentario.comentario
                        join assunto on assuntocomentario.assunto = assunto.codigo
                    where 
                        strftime('%m', comentario.datacomentario, 'localtime') = strftime('%m', 'now', '-1 month', 'localtime') and
                        comentario.usuario in (
                            select usuario.email from usuario
                                join cidade on usuario.cidade = cidade.codigo
                                join estado on cidade.estado = estado.codigodaUF
                                join pais on estado.pais = pais.codigoISO
                            where pais.nome = 'Brasil'
                        )
                    group by assunto.nome
                    order by qtd desc
                ) as qtdnoComentario on assunto.nome = qtdnoComentario.nome
        ) as tmp1
        where total in (
            select distinct* from (
                select  
                    case
                        when qtd2 is null then qtd1
                        when qtd2 is not null then qtd1+qtd2
                    end as total from (
                    select assunto.nome as assunto, qtdnoPost.qtd as qtd1, qtdnoComentario.qtd as qtd2 from assunto
                        join (
                            select assunto.nome, count(*) as qtd from post
                                join assuntopost on post.codigo = assuntopost.post
                                join assunto on assuntopost.assunto = assunto.codigo
                            where 
                                strftime('%m', post.datadopost, 'localtime') = strftime('%m', 'now', '-1 month', 'localtime') and
                                post.usuario in (
                                    select usuario.email from usuario
                                        join cidade on usuario.cidade = cidade.codigo
                                        join estado on cidade.estado = estado.codigodaUF
                                        join pais on estado.pais = pais.codigoISO
                                    where pais.nome = 'Brasil'
                                )
                            group by assunto.nome
                            order by qtd desc
                        ) as qtdnoPost on assunto.nome = qtdnoPost.nome
                        left join (
                            select assunto.nome, count(*) as qtd from comentario
                                join assuntocomentario on comentario.codigo = assuntocomentario.comentario
                                join assunto on assuntocomentario.assunto = assunto.codigo
                            where 
                                strftime('%m', comentario.datacomentario, 'localtime') = strftime('%m', 'now', '-1 month', 'localtime') and
                                comentario.usuario in (
                                    select usuario.email from usuario
                                        join cidade on usuario.cidade = cidade.codigo
                                        join estado on cidade.estado = estado.codigodaUF
                                        join pais on estado.pais = pais.codigoISO
                                    where pais.nome = 'Brasil'
                                )
                            group by assunto.nome
                            order by qtd desc
                        ) as qtdnoComentario on assunto.nome = qtdnoComentario.nome
                )
                order by total desc
            )
            limit 5
        )
        order by total desc
    )
intersect
    select assunto from (
        select assunto, 
            case
                when qtd2 is null then qtd1
                when qtd2 is not null then qtd1+qtd2
            end as total 
        from (
            select assunto.nome as assunto, qtdnoPost.qtd as qtd1, qtdnoComentario.qtd as qtd2 from assunto
                join (
                    select assunto.nome, count(*) as qtd from post
                        join assuntopost on post.codigo = assuntopost.post
                        join assunto on assuntopost.assunto = assunto.codigo
                    where 
                        strftime('%m', post.datadopost, 'localtime') = strftime('%m', 'now', '-2 month', 'localtime') and
                        post.usuario in (
                            select usuario.email from usuario
                                join cidade on usuario.cidade = cidade.codigo
                                join estado on cidade.estado = estado.codigodaUF
                                join pais on estado.pais = pais.codigoISO
                            where pais.nome = 'Brasil'
                        )
                    group by assunto.nome
                    order by qtd desc
                ) as qtdnoPost on assunto.nome = qtdnoPost.nome
                left join (
                    select assunto.nome, count(*) as qtd from comentario
                        join assuntocomentario on comentario.codigo = assuntocomentario.comentario
                        join assunto on assuntocomentario.assunto = assunto.codigo
                    where 
                        strftime('%m', comentario.datacomentario, 'localtime') = strftime('%m', 'now', '-2 month', 'localtime') and
                        comentario.usuario in (
                            select usuario.email from usuario
                                join cidade on usuario.cidade = cidade.codigo
                                join estado on cidade.estado = estado.codigodaUF
                                join pais on estado.pais = pais.codigoISO
                            where pais.nome = 'Brasil'
                        )
                    group by assunto.nome
                    order by qtd desc
                ) as qtdnoComentario on assunto.nome = qtdnoComentario.nome
        ) as tmp1
        where total in (
            select distinct* from (
                select  
                    case
                        when qtd2 is null then qtd1
                        when qtd2 is not null then qtd1+qtd2
                    end as total from (
                    select assunto.nome as assunto, qtdnoPost.qtd as qtd1, qtdnoComentario.qtd as qtd2 from assunto
                        join (
                            select assunto.nome, count(*) as qtd from post
                                join assuntopost on post.codigo = assuntopost.post
                                join assunto on assuntopost.assunto = assunto.codigo
                            where 
                                strftime('%m', post.datadopost, 'localtime') = strftime('%m', 'now', '-2 month', 'localtime') and
                                post.usuario in (
                                    select usuario.email from usuario
                                        join cidade on usuario.cidade = cidade.codigo
                                        join estado on cidade.estado = estado.codigodaUF
                                        join pais on estado.pais = pais.codigoISO
                                    where pais.nome = 'Brasil'
                                )
                            group by assunto.nome
                            order by qtd desc
                        ) as qtdnoPost on assunto.nome = qtdnoPost.nome
                        left join (
                            select assunto.nome, count(*) as qtd from comentario
                                join assuntocomentario on comentario.codigo = assuntocomentario.comentario
                                join assunto on assuntocomentario.assunto = assunto.codigo
                            where 
                                strftime('%m', comentario.datacomentario, 'localtime') = strftime('%m', 'now', '-2 month', 'localtime') and
                                comentario.usuario in (
                                    select usuario.email from usuario
                                        join cidade on usuario.cidade = cidade.codigo
                                        join estado on cidade.estado = estado.codigodaUF
                                        join pais on estado.pais = pais.codigoISO
                                    where pais.nome = 'Brasil'
                                )
                            group by assunto.nome
                            order by qtd desc
                        ) as qtdnoComentario on assunto.nome = qtdnoComentario.nome
                )
                order by total desc
            )
            limit 5
        )
        order by total desc
    );

--  i) Quais os nomes dos usuários que participam do grupo SQLite que tiveram a 1ª, 2ª e 3ª maior quantidade de comentários em uma postagem sobre o assunto select?
select usuario.nome, count(*) as qtdComentarios from usuario
    join post on usuario.email = post.usuario
    join comentario on post.codigo = comentario.post
where 
    usuario.nome in (
        select usuario.nome from usuario
            join membro on usuario.email = membro.usuario
            join grupo on membro.grupo = grupo.codigo
        where grupo.nome = 'SQLite'
    ) and 
    post.codigo in (
        select distinct post.codigo from post
        where 
            post.codigo in (
                select post.codigo from post
                    join assuntopost on post.codigo = assuntopost.post
                    join assunto on assuntopost.assunto = assunto.codigo
                where assunto.nome = 'select'
                group by post.codigo
            ) or
            post.codigo in (
                select post.codigo from post
                    join comentario on post.codigo = comentario.post
                    join assuntocomentario on comentario.codigo = assuntocomentario.comentario
                    join assunto on assuntocomentario.assunto = assunto.codigo
                where assunto.nome = 'select'
                group by post.codigo
            )     
    ) 
group by usuario.nome
having qtdComentarios in (
    select distinct* from (
        select count(*) as qtdComentarios from usuario
            join post on usuario.email = post.usuario
            join comentario on post.codigo = comentario.post
        where 
            usuario.nome in (
                select usuario.nome from usuario
                    join membro on usuario.email = membro.usuario
                    join grupo on membro.grupo = grupo.codigo
                where grupo.nome = 'SQLite'
            ) and 
            post.codigo in (
                select distinct post.codigo from post
                where 
                    post.codigo in (
                        select post.codigo from post
                            join assuntopost on post.codigo = assuntopost.post
                            join assunto on assuntopost.assunto = assunto.codigo
                        where assunto.nome = 'select'
                        group by post.codigo
                    ) or
                    post.codigo in (
                        select post.codigo from post
                            join comentario on post.codigo = comentario.post
                            join assuntocomentario on comentario.codigo = assuntocomentario.comentario
                            join assunto on assuntocomentario.assunto = assunto.codigo
                        where assunto.nome = 'select'
                        group by post.codigo
                    )     
            )
        group by usuario.nome
        order by qtdComentarios desc
    )
)
order by qtdComentarios desc;

--  j) Quais os nomes dos usuários dos grupos SQLite ou Banco de Dados-IFRS-2021 que possuem a maior quantidade de amigos?
select tmp1.usuario from (
    select usuario.nome as usuario, 
        case
            when amigo.usuario1 = usuario.email then amigo.usuario2
            when amigo.usuario2 = usuario.email then amigo.usuario1
        end as amigoEmail
    from usuario
        join amigo on usuario.email = amigo.usuario1 or usuario.email = amigo.usuario2
    order by usuario.nome
) as tmp1
where tmp1.usuario in (
    select usuario.nome from usuario
        join membro on usuario.email = membro.usuario
        join grupo on membro.grupo = grupo.codigo
    where grupo.nome = 'SQLite' or grupo.nome = 'Banco de Dados-IFRS-2021'
)
group by tmp1.usuario
having count(*) = (
    select count(*) as qtd from (
        select usuario.nome as usuario, 
            case
                when amigo.usuario1 = usuario.email then amigo.usuario2
                when amigo.usuario2 = usuario.email then amigo.usuario1
            end as amigoEmail
        from usuario
            join amigo on usuario.email = amigo.usuario1 or usuario.email = amigo.usuario2
        order by usuario.nome
    ) as tmp1
    where tmp1.usuario in (
        select usuario.nome from usuario
            join membro on usuario.email = membro.usuario
            join grupo on membro.grupo = grupo.codigo
        where grupo.nome = 'SQLite' or grupo.nome = 'Banco de Dados-IFRS-2021'
    )
    group by tmp1.usuario
    order by qtd desc
    limit 1
)
order by count(*) desc;

--  k) Quais os nomes dos usuários dos grupos SQLite ou Banco de Dados-IFRS-2021 que possuem a maior quantidade de amigos em comum?
select tmp.nome as pessoa, count(*) as qtdComuns from (
    select usuario.nome, 
        case
            when amigo.usuario1 = usuario.email then amigo.usuario2
            when amigo.usuario2 = usuario.email then amigo.usuario1
        end as amigoEmail
    from usuario
        join amigo on usuario.email = amigo.usuario1 or usuario.email = amigo.usuario2
) as tmp
    join usuario on tmp.amigoEmail = usuario.email
where usuario.nome in (
    select usuario.nome as amigo from (
        select usuario.nome, 
            case
                when amigo.usuario1 = usuario.email then amigo.usuario2
                when amigo.usuario2 = usuario.email then amigo.usuario1
            end as amigoEmail
        from usuario
            join amigo on usuario.email = amigo.usuario1 or usuario.email = amigo.usuario2
    ) as tmp
        join usuario on tmp.amigoEmail = usuario.email
    group by amigo
    having count(*) > 1
    order by tmp.nome
)
group by pessoa
having 
    tmp.nome in (
        select usuario.nome from usuario
            join membro on usuario.email = membro.usuario
            join grupo on membro.grupo = grupo.codigo
        where grupo.nome = 'SQLite' or grupo.nome = 'Banco de Dados-IFRS-2021'
    ) and 
    qtdComuns in (
        select count(*) as qtdComuns from (
            select usuario.nome, 
                case
                    when amigo.usuario1 = usuario.email then amigo.usuario2
                    when amigo.usuario2 = usuario.email then amigo.usuario1
                end as amigoEmail
            from usuario
                join amigo on usuario.email = amigo.usuario1 or usuario.email = amigo.usuario2
        ) as tmp
            join usuario on tmp.amigoEmail = usuario.email
        where usuario.nome in (
            select usuario.nome as amigo from (
                select usuario.nome, 
                    case
                        when amigo.usuario1 = usuario.email then amigo.usuario2
                        when amigo.usuario2 = usuario.email then amigo.usuario1
                    end as amigoEmail
                from usuario
                    join amigo on usuario.email = amigo.usuario1 or usuario.email = amigo.usuario2
            ) as tmp
                join usuario on tmp.amigoEmail = usuario.email
            group by amigo
            having count(*) > 1
            order by tmp.nome
        )
        group by tmp.nome
        having tmp.nome in (
            select usuario.nome from usuario
                join membro on usuario.email = membro.usuario
                join grupo on membro.grupo = grupo.codigo
            where grupo.nome = 'SQLite' or grupo.nome = 'Banco de Dados-IFRS-2021'
        )
        order by qtdComuns desc
        limit 1
    )
order by qtdComuns desc;

--  l) Quais os nomes dos usuários que devem ser sugeridos como amigos para um dado usuário? Considere que, se A e B não são amigos mas possuem no mínimo 5 assuntos em comum entre os 10 assuntos mais comentados por cada um nos últimos 3 meses, B deve ser sugerido como amigo de A.


-- 2) Descreva e justifique as adequações/alterações que foram realizadas nas tabelas criadas para uma rede social nas listas de exercícios anteriores para que o exercício 1 acima pudesse ser resolvido.

--adicionamos alguns dados para testar os selects
--trocamos o nome do grupo 'Banco de Dados-IFRS2021' para 'Banco de Dados-IFRS-2021'
--adicionamos o assunto 'select'