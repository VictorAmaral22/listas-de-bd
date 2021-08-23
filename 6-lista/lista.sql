-- 1) Escreva comandos insert, update ou delete, utilizando as tabelas criadas para uma rede social nas listas de exercícios anteriores, para:

-- a) Alterar o texto da última postagem do usuário Edson Arantes do Nascimento, e-mail pele@cbf.com.br, de "Brasil: 20 medalhas nas Olimpíadas 2020/2021 em Tóquio" para "Brasil: 21 medalhas nas Olimpíadas 2020/2021 em Tóquio".
update post set conteudo = 'Brasil: 21 medalhas nas Olimpíadas 2020/2021 em Tóquio' 
where post.codigo = (select post.codigo from post where usuario = 'pele@cbf.com.br' order by datadopost desc, horadopost desc limit 1);

-- b) Alterar a última reação do usuário Paulo Xavier Ramos, e-mail pxramos@mymail.com, à uma postagem no grupo SQLite de Joinha para S2.
update postreacao set reacao = (select reacao.codigo from reacao where reacao.nome like '%amei%')
where 
    postreacao.post = (
        select postreacao.post from postreacao 
            join reacao on postreacao.reacao = reacao.codigo
            join post on postreacao.post = post.codigo
            join grupo on post.grupo = grupo.codigo
        where 
            postreacao.usuario = 'pxramos@mymail.com' and
            grupo.nome = 'SQLite' and
            reacao.nome = 'curtir'
        order by postreacao.datapostreacao desc, postreacao.horapostreacao desc
        limit 1
    ) and
    postreacao.usuario = 'pxramos@mymail.com';
    
-- c) Desativar temporariamente as contas dos usuários do Brasil que não possuem qualquer atividade na rede social há mais de 5 anos.
--testar desativando mcalbuq que nao é ativa há 2 meses
update usuario set isAtivo =  false
where usuario.email not in
(select usuario.email from usuario 
                join post on usuario.email = post.usuario
                join cidade on usuario.cidade= cidade.codigo
                join estado on cidade.estado = estado.codigodaUF
                join pais on estado.pais = pais.codigoISO
                where date(datadopost) between date('now', '-5 years') and date('now') and pais.codigoISO='BRA'
                group by post.usuario
 union  select usuario.email from usuario 
                join postreacao on usuario.email = postreacao.usuario
                join cidade on usuario.cidade= cidade.codigo
                join estado on cidade.estado = estado.codigodaUF
                join pais on estado.pais = pais.codigoISO
                where date(datapostreacao) between date('now', '-5 years') and date('now') and pais.codigoISO='BRA'
                group by postreacao.usuario
union select amigo.usuario1 from amigo
             join usuario on amigo.usuario1=usuario.email
              join cidade on usuario.cidade= cidade.codigo
                join estado on cidade.estado = estado.codigodaUF
                join pais on estado.pais = pais.codigoISO
             where datadeamizade between date('now', '-5 years') and date('now') and pais.codigoISO='BRA'
union select amigo.usuario2 from amigo
             join usuario on amigo.usuario1=usuario.email
              join cidade on usuario.cidade= cidade.codigo
                join estado on cidade.estado = estado.codigodaUF
                join pais on estado.pais = pais.codigoISO
             where datadeamizade between date('now', '-5 years') and date('now') and pais.codigoISO='BRA'

union select usuario.email from usuario 
                join cidade on usuario.cidade= cidade.codigo
                join estado on cidade.estado = estado.codigodaUF
                join pais on estado.pais = pais.codigoISO
             where datadecadastro between date('now', '-5 years') and date('now') and pais.codigoISO='BRA'

union select comentario.usuario from comentario
 join usuario on comentario.usuario=usuario.email join cidade on usuario.cidade= cidade.codigo
                join estado on cidade.estado = estado.codigodaUF
                join pais on estado.pais = pais.codigoISO
           where datacomentario between date('now', '-5 years') and date('now') and pais.codigoISO='BRA'

union select comentarioreacao.usuario from comentarioreacao
join usuario on comentarioreacao.usuario=usuario.email join cidade on usuario.cidade= cidade.codigo
                join estado on cidade.estado = estado.codigodaUF
                join pais on estado.pais = pais.codigoISO
           where datacomentarioreacao between date('now', '-5 years') and date('now') and pais.codigoISO='BRA'

union select compartilhar.usuario from compartilhar 
 join usuario on compartilhar.usuario=usuario.email join cidade on usuario.cidade= cidade.codigo
                join estado on cidade.estado = estado.codigodaUF
                join pais on estado.pais = pais.codigoISO
                where datadecompartilhamento between date('now', '-5 years') and date('now') and pais.codigoISO='BRA'
);

-- d) Excluir a última postagem no grupo IFRS-Campus Rio Grande, classificada como postagem que incita ódio.
update post set isAtivo = false, motivo = 'Esta postagem incita ódio' where post.codigo = (
    select post.codigo from post
        join grupo on post.grupo = grupo.codigo
    where grupo.nome = 'IFRS-Campus Rio Grande'
    order by post.datadopost desc, post.horadopost desc
    limit 1);

-- e) Atribuir um selo de fã, com validade determinada para a semana atual, para os usuários do grupo IFRS-Campus Rio Grande que:
-- |    Selo    | Condições considerando as postagens da semana passada no grupo
-- |  ultra-fã  | reagiram a 75% ou mais e comentaram 30% ou mais das postagens
-- |  super-fã  | reagiram a 50% ou mais e comentaram 20% ou mais das postagens
-- |     fã     | reagiram a 25% ou mais e comentaram 10% ou mais das postagens
-- * O procedimento de atribuir selo de fã será executado automaticamente às 00:00 de cada domingo.
update membro set selo = tmp.selo, dataregist = datetime('now', 'localtime')
from (
    select membro.grupo, membro.usuario,
        case
            --ultra-fã
            when membro.usuario in (
                    --conjunto dos 75% de reações
                    select usuario.email from usuario
                        join postreacao on usuario.email = postreacao.usuario
                        join reacao on postreacao.reacao = reacao.codigo
                    where 
                        post in (
                            select codigo from post 
                            where 
                                grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                date(post.datadopost) between date(case
                                    when strftime('%w', '2021-08-16') == '0' then strftime('%Y-%m-%d', '2021-08-16', '-7 days')
                                    when strftime('%w', '2021-08-16') == '1' then strftime('%Y-%m-%d', '2021-08-16', '-8 days')
                                    when strftime('%w', '2021-08-16') == '2' then strftime('%Y-%m-%d', '2021-08-16', '-9 days')
                                    when strftime('%w', '2021-08-16') == '3' then strftime('%Y-%m-%d', '2021-08-16', '-10 days')
                                    when strftime('%w', '2021-08-16') == '4' then strftime('%Y-%m-%d', '2021-08-16', '-11 days')
                                    when strftime('%w', '2021-08-16') == '5' then strftime('%Y-%m-%d', '2021-08-16', '-12 days')
                                    when strftime('%w', '2021-08-16') == '6' then strftime('%Y-%m-%d', '2021-08-16', '-13 days')
                                end) and date(case
                                    when strftime('%w', '2021-08-16') == '0' then strftime('%Y-%m-%d', '2021-08-16', '-1 days')
                                    when strftime('%w', '2021-08-16') == '1' then strftime('%Y-%m-%d', '2021-08-16', '-2 days')
                                    when strftime('%w', '2021-08-16') == '2' then strftime('%Y-%m-%d', '2021-08-16', '-3 days')
                                    when strftime('%w', '2021-08-16') == '3' then strftime('%Y-%m-%d', '2021-08-16', '-4 days')
                                    when strftime('%w', '2021-08-16') == '4' then strftime('%Y-%m-%d', '2021-08-16', '-5 days')
                                    when strftime('%w', '2021-08-16') == '5' then strftime('%Y-%m-%d', '2021-08-16', '-6 days')
                                    when strftime('%w', '2021-08-16') == '6' then strftime('%Y-%m-%d', '2021-08-16', '-7 days')
                                end)
                        )
                    group by usuario.email
                    having count(*) >= (
                        select cast(count(codigo)*75 as real)/100 as porcentagem from post 
                        where 
                            grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                            codigo in (
                                select codigo from post 
                                where 
                                    grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                    date(post.datadopost) between date(case
                                        when strftime('%w', '2021-08-16') == '0' then strftime('%Y-%m-%d', '2021-08-16', '-7 days')
                                        when strftime('%w', '2021-08-16') == '1' then strftime('%Y-%m-%d', '2021-08-16', '-8 days')
                                        when strftime('%w', '2021-08-16') == '2' then strftime('%Y-%m-%d', '2021-08-16', '-9 days')
                                        when strftime('%w', '2021-08-16') == '3' then strftime('%Y-%m-%d', '2021-08-16', '-10 days')
                                        when strftime('%w', '2021-08-16') == '4' then strftime('%Y-%m-%d', '2021-08-16', '-11 days')
                                        when strftime('%w', '2021-08-16') == '5' then strftime('%Y-%m-%d', '2021-08-16', '-12 days')
                                        when strftime('%w', '2021-08-16') == '6' then strftime('%Y-%m-%d', '2021-08-16', '-13 days')
                                    end) and date(case
                                        when strftime('%w', '2021-08-16') == '0' then strftime('%Y-%m-%d', '2021-08-16', '-1 days')
                                        when strftime('%w', '2021-08-16') == '1' then strftime('%Y-%m-%d', '2021-08-16', '-2 days')
                                        when strftime('%w', '2021-08-16') == '2' then strftime('%Y-%m-%d', '2021-08-16', '-3 days')
                                        when strftime('%w', '2021-08-16') == '3' then strftime('%Y-%m-%d', '2021-08-16', '-4 days')
                                        when strftime('%w', '2021-08-16') == '4' then strftime('%Y-%m-%d', '2021-08-16', '-5 days')
                                        when strftime('%w', '2021-08-16') == '5' then strftime('%Y-%m-%d', '2021-08-16', '-6 days')
                                        when strftime('%w', '2021-08-16') == '6' then strftime('%Y-%m-%d', '2021-08-16', '-7 days')
                                    end)
                            )
                    )
                intersect
                    --conjunto dos 30% de comentarios
                    select usuario.email from usuario
                        join comentario on usuario.email = comentario.usuario
                        join post on comentario.post = post.codigo
                        join grupo on post.grupo = grupo.codigo
                    where 
                        post.codigo in (
                            select codigo from post 
                                        where 
                                            grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                            date(post.datadopost) between date(case
                                                when strftime('%w', '2021-08-16') == '0' then strftime('%Y-%m-%d', '2021-08-16', '-7 days')
                                                when strftime('%w', '2021-08-16') == '1' then strftime('%Y-%m-%d', '2021-08-16', '-8 days')
                                                when strftime('%w', '2021-08-16') == '2' then strftime('%Y-%m-%d', '2021-08-16', '-9 days')
                                                when strftime('%w', '2021-08-16') == '3' then strftime('%Y-%m-%d', '2021-08-16', '-10 days')
                                                when strftime('%w', '2021-08-16') == '4' then strftime('%Y-%m-%d', '2021-08-16', '-11 days')
                                                when strftime('%w', '2021-08-16') == '5' then strftime('%Y-%m-%d', '2021-08-16', '-12 days')
                                                when strftime('%w', '2021-08-16') == '6' then strftime('%Y-%m-%d', '2021-08-16', '-13 days')
                                            end) and date(case
                                                when strftime('%w', '2021-08-16') == '0' then strftime('%Y-%m-%d', '2021-08-16', '-1 days')
                                                when strftime('%w', '2021-08-16') == '1' then strftime('%Y-%m-%d', '2021-08-16', '-2 days')
                                                when strftime('%w', '2021-08-16') == '2' then strftime('%Y-%m-%d', '2021-08-16', '-3 days')
                                                when strftime('%w', '2021-08-16') == '3' then strftime('%Y-%m-%d', '2021-08-16', '-4 days')
                                                when strftime('%w', '2021-08-16') == '4' then strftime('%Y-%m-%d', '2021-08-16', '-5 days')
                                                when strftime('%w', '2021-08-16') == '5' then strftime('%Y-%m-%d', '2021-08-16', '-6 days')
                                                when strftime('%w', '2021-08-16') == '6' then strftime('%Y-%m-%d', '2021-08-16', '-7 days')
                                            end)
                        )
                    group by usuario.email
                    having count(distinct comentario.post) >= (
                        select cast(count(codigo)*30 as real)/100 as porcentagem from post 
                            where 
                                grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                codigo in (
                                    select codigo from post 
                                    where 
                                        grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                        date(post.datadopost) between date(case
                                            when strftime('%w', '2021-08-16') == '0' then strftime('%Y-%m-%d', '2021-08-16', '-7 days')
                                            when strftime('%w', '2021-08-16') == '1' then strftime('%Y-%m-%d', '2021-08-16', '-8 days')
                                            when strftime('%w', '2021-08-16') == '2' then strftime('%Y-%m-%d', '2021-08-16', '-9 days')
                                            when strftime('%w', '2021-08-16') == '3' then strftime('%Y-%m-%d', '2021-08-16', '-10 days')
                                            when strftime('%w', '2021-08-16') == '4' then strftime('%Y-%m-%d', '2021-08-16', '-11 days')
                                            when strftime('%w', '2021-08-16') == '5' then strftime('%Y-%m-%d', '2021-08-16', '-12 days')
                                            when strftime('%w', '2021-08-16') == '6' then strftime('%Y-%m-%d', '2021-08-16', '-13 days')
                                        end) and date(case
                                            when strftime('%w', '2021-08-16') == '0' then strftime('%Y-%m-%d', '2021-08-16', '-1 days')
                                            when strftime('%w', '2021-08-16') == '1' then strftime('%Y-%m-%d', '2021-08-16', '-2 days')
                                            when strftime('%w', '2021-08-16') == '2' then strftime('%Y-%m-%d', '2021-08-16', '-3 days')
                                            when strftime('%w', '2021-08-16') == '3' then strftime('%Y-%m-%d', '2021-08-16', '-4 days')
                                            when strftime('%w', '2021-08-16') == '4' then strftime('%Y-%m-%d', '2021-08-16', '-5 days')
                                            when strftime('%w', '2021-08-16') == '5' then strftime('%Y-%m-%d', '2021-08-16', '-6 days')
                                            when strftime('%w', '2021-08-16') == '6' then strftime('%Y-%m-%d', '2021-08-16', '-7 days')
                                        end)
                                )  
                    )
            ) then (select id from selo where nome = 'ultra-fã')
            --super-fã
            when membro.usuario in (
                    --conjunto dos 50% de reações
                    select usuario.email from usuario
                        join postreacao on usuario.email = postreacao.usuario
                        join reacao on postreacao.reacao = reacao.codigo
                    where 
                        post in (
                            select codigo from post 
                            where 
                                grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                date(post.datadopost) between date(case
                                    when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-8 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-9 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-10 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-11 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-12 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-13 days', 'localtime')
                                end) and date(case
                                    when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-1 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-2 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-3 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-4 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-5 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-6 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                end)
                        )
                    group by usuario.email
                    having count(*) >= (
                        select cast(count(codigo)*50 as real)/100 as porcentagem from post 
                        where 
                            grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                            codigo in (
                                select codigo from post 
                                where 
                                    grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                    date(post.datadopost) between date(case
                                        when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-8 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-9 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-10 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-11 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-12 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-13 days', 'localtime')
                                    end) and date(case
                                        when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-1 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-2 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-3 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-4 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-5 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-6 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                    end)
                            )
                    ) and 
                    count(*) < (
                        select cast(count(codigo)*75 as real)/100 as porcentagem from post 
                            where 
                                grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                codigo in (
                                    select codigo from post 
                                    where 
                                        grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                        date(post.datadopost) between date(case
                                            when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-8 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-9 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-10 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-11 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-12 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-13 days', 'localtime')
                                        end) and date(case
                                            when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-1 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-2 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-3 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-4 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-5 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-6 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                        end)
                                )
                    )
                intersect
                    --conjunto dos 20% de comentarios
                    select usuario.email from usuario
                        join comentario on usuario.email = comentario.usuario
                        join post on comentario.post = post.codigo
                        join grupo on post.grupo = grupo.codigo
                    where 
                        post.codigo in (
                            select codigo from post 
                                        where 
                                            grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                            date(post.datadopost) between date(case
                                                when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-8 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-9 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-10 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-11 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-12 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-13 days', 'localtime')
                                            end) and date(case
                                                when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-1 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-2 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-3 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-4 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-5 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-6 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                            end)
                        )
                    group by usuario.email
                    having count(distinct comentario.post) >= (
                        select cast(count(codigo)*20 as real)/100 as porcentagem from post 
                            where 
                                grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                codigo in (
                                    select codigo from post 
                                    where 
                                        grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                        date(post.datadopost) between date(case
                                            when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-8 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-9 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-10 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-11 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-12 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-13 days', 'localtime')
                                        end) and date(case
                                            when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-1 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-2 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-3 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-4 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-5 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-6 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                        end)
                                )  
                    ) and
                    count(distinct comentario.post) < (
                        select cast(count(codigo)*30 as real)/100 as porcentagem from post 
                            where 
                                grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                codigo in (
                                    select codigo from post 
                                    where 
                                        grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                        date(post.datadopost) between date(case
                                            when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-8 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-9 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-10 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-11 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-12 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-13 days', 'localtime')
                                        end) and date(case
                                            when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-1 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-2 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-3 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-4 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-5 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-6 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                        end)
                                )  
                    )
            ) then (select id from selo where nome = 'super-fã')
            --fã
            when membro.usuario in (
                    --conjunto dos 25% de reações
                    select usuario.email from usuario
                        join postreacao on usuario.email = postreacao.usuario
                        join reacao on postreacao.reacao = reacao.codigo
                    where 
                        post in (
                            select codigo from post 
                            where 
                                grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                date(post.datadopost) between date(case
                                    when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-8 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-9 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-10 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-11 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-12 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-13 days', 'localtime')
                                end) and date(case
                                    when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-1 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-2 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-3 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-4 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-5 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-6 days', 'localtime')
                                    when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                end)
                        )
                    group by usuario.email
                    having count(*) >= (
                        select cast(count(codigo)*25 as real)/100 as porcentagem from post 
                        where 
                            grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                            codigo in (
                                select codigo from post 
                                where 
                                    grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                    date(post.datadopost) between date(case
                                        when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-8 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-9 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-10 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-11 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-12 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-13 days', 'localtime')
                                    end) and date(case
                                        when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-1 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-2 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-3 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-4 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-5 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-6 days', 'localtime')
                                        when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                    end)
                            )
                    ) and 
                    count(*) < (
                        select cast(count(codigo)*50 as real)/100 as porcentagem from post 
                            where 
                                grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                codigo in (
                                    select codigo from post 
                                    where 
                                        grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                        date(post.datadopost) between date(case
                                            when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-8 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-9 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-10 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-11 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-12 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-13 days', 'localtime')
                                        end) and date(case
                                            when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-1 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-2 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-3 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-4 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-5 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-6 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                        end)
                                )
                    )
                intersect
                    --conjunto dos 10% de comentarios
                    select usuario.email from usuario
                        join comentario on usuario.email = comentario.usuario
                        join post on comentario.post = post.codigo
                        join grupo on post.grupo = grupo.codigo
                    where 
                        post.codigo in (
                            select codigo from post 
                                        where 
                                            grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                            date(post.datadopost) between date(case
                                                when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-8 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-9 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-10 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-11 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-12 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-13 days', 'localtime')
                                            end) and date(case
                                                when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-1 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-2 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-3 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-4 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-5 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-6 days', 'localtime')
                                                when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                            end)
                        )
                    group by usuario.email
                    having count(distinct comentario.post) >= (
                        select cast(count(codigo)*10 as real)/100 as porcentagem from post 
                            where 
                                grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                codigo in (
                                    select codigo from post 
                                    where 
                                        grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                        date(post.datadopost) between date(case
                                            when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-8 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-9 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-10 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-11 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-12 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-13 days', 'localtime')
                                        end) and date(case
                                            when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-1 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-2 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-3 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-4 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-5 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-6 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                        end)
                                )  
                    ) and
                    count(distinct comentario.post) < (
                        select cast(count(codigo)*20 as real)/100 as porcentagem from post 
                            where 
                                grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                codigo in (
                                    select codigo from post 
                                    where 
                                        grupo == (select codigo from grupo where nome == 'IFRS-Campus Rio Grande') and
                                        date(post.datadopost) between date(case
                                            when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-8 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-9 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-10 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-11 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-12 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-13 days', 'localtime')
                                        end) and date(case
                                            when strftime('%w', 'now', 'localtime') == '0' then strftime('%Y-%m-%d', 'now', '-1 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '1' then strftime('%Y-%m-%d', 'now', '-2 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '2' then strftime('%Y-%m-%d', 'now', '-3 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '3' then strftime('%Y-%m-%d', 'now', '-4 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '4' then strftime('%Y-%m-%d', 'now', '-5 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '5' then strftime('%Y-%m-%d', 'now', '-6 days', 'localtime')
                                            when strftime('%w', 'now', 'localtime') == '6' then strftime('%Y-%m-%d', 'now', '-7 days', 'localtime')
                                        end)
                                )  
                    )
            ) then (select id from selo where nome = 'fã')
            --selos expirados
            when membro.usuario in (
                select membro.usuario from membro
                where 7 <= (julianday(date('now', 'localtime'))-julianday(date(membro.dataregist, 'localtime'))-1)
            ) then null
        end as selo
    from membro
        join grupo on membro.grupo = grupo.codigo
    where grupo.nome = 'IFRS-Campus Rio Grande'    
) as tmp
where 
    membro.usuario = tmp.usuario and
    membro.grupo = tmp.grupo;


-- 2) Descreva e justifique as adequações/alterações que foram realizadas nas tabelas criadas para uma rede social nas listas de exercícios anteriores para que o exercício 1 acima pudesse ser resolvido.

--Criação da tabela selo e foi adicionado selo e dataregist no membro. Tal foi feito para podermos realizar a letra e).
--Criação do campo isAtivo na tabela usuário.

-- 3) Explique detalhadamente porque não é possível várias pessoas distintas comprarem o mesmo lugar numerado no mesmo show utilizando controle de concorrência.

-- Isso acontece pois obviamente, cada acento ou um lugar em um show só pode ser utilizado por uma pessoa de cada vez, e realizar esse procedimento físicamente 
-- seria bem menos problemático nesse quesito. Porém, quando acessamos um site ou app e interagimos com recursos escassos, seja a quantidade de produtos em um estoque, 
-- os acentos em uma sala de cinema, etc., controlar quem vai comprar primeiro fica mais complicado. 

-- Se por exemplo, duas pessoas, Claudio e Felipe querem comprar um ingresso para um show do Guns n' Roses, ao entrarem na plataforma, provávelmente irá 
-- aparecer uma contagem de quantos ingressos disponíveis tem ainda. Mas supondo que só tem 1 ingresso restante e ambos clicaram para comprá-lo, o sistema precisará 
-- analizar essas requisições, escolher uma delas e assim fazer um update na quantidade de ingressos. Posteriormente, ele terá que impedir que o outro comprador não 
-- consiga comprar, se não a quantidade no banco de dados ficaria negativa e os dois clientes com o mesmo lugar no show. 

-- Tal pode ser feito através do update de uma data e hora que estará presente na tabela do produto, e é responsável por dizer qual foi a última alteração. 
-- Assim, digamos que Claudio e Felipe clicaram ao mesmo momento: 15h em ponto do dia 16 de julho de 1993, quando um deles finalizar a compra, a variável da última alteração irá mudar. 
-- Supondo que Felipe terminou a compra primeiro, às 15h05, Claudio não poderá comprar o ingresso, porquê dentro do update que diz se o ingresso foi comprado ou não, 
-- vai existir uma condição que vai dizer que para ser possível a compra a data e horário da última alteração tem de ser 15h. Como assim que Felipe comprou houve um update de alteração 
-- para as 15h05, o novo update não poderá ser feito e deve ser exibida uma mensagem de erro.