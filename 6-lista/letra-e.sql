-- e) Atribuir um selo de fã, com validade determinada para a semana atual, para os usuários do grupo IFRS-Campus Rio Grande que:
-- |    Selo    | Condições considerando as postagens da semana passada no grupo
-- |  ultra-fã  | reagiram a 75% ou mais e comentaram 30% ou mais das postagens
-- |  super-fã  | reagiram a 50% ou mais e comentaram 20% ou mais das postagens
-- |     fã     | reagiram a 25% ou mais e comentaram 10% ou mais das postagens
-- * O procedimento de atribuir selo de fã será executado automaticamente às 00:00 de cada domingo.
--N PRECISA FAZER PRO DOMINGO

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
        end as selo
    from membro
        join grupo on membro.grupo = grupo.codigo
    where grupo.nome = 'IFRS-Campus Rio Grande'    
) as tmp
where 
    membro.usuario = tmp.usuario and
    membro.grupo = tmp.grupo;

select membro.usuario, selo.nome, grupo.nome from membro 
    join grupo on membro.grupo = grupo.codigo
    left join selo on membro.selo = selo.id;





------------------------------











select membro.usuario,
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
    end as selo
from membro
    join grupo on membro.grupo = grupo.codigo
where grupo.nome = 'IFRS-Campus Rio Grande';

