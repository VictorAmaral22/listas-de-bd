-- 3) Utilizando a modelagem da pizzaria do material, escreva comandos select para responder as perguntas:
--  a) Qual sabor tem mais ingredientes?
select sabor.nome, count(*) as qtdIngredientes from sabor
    join saboringrediente on sabor.codigo = saboringrediente.sabor
    join ingrediente on saboringrediente.ingrediente = ingrediente.codigo
group by sabor.nome
having qtdIngredientes in (
    select count(*) as qtdIngredientes from sabor
        join saboringrediente on sabor.codigo = saboringrediente.sabor
        join ingrediente on saboringrediente.ingrediente = ingrediente.codigo
    group by sabor.nome
    order by qtdIngredientes desc
    limit 1
)
order by qtdIngredientes desc;


--  b) Qual sabor tem menos ingredientes?

--  c) Qual sabor não foi pedido nos últimos 4 domingos? --Ver com o Betito
insert into comanda (data, mesa, pago) values
    ('2021-07-04', 1, true),
    ('2021-07-11', 1, true),
    ('2021-07-18', 1, true),
    ('2021-07-25', 1, true);

    select sabor.nome from sabor
except
    select sabor.nome from comanda
        join pizza on comanda.numero = pizza.comanda
        join pizzasabor on pizza.codigo = pizzasabor.pizza
        join sabor on pizzasabor.sabor = sabor.codigo
    where
        comanda.data in (
            select comanda.data from comanda
            where 
                strftime('%w', comanda.data) = '0' and
                date(comanda.data, 'localtime') between date('now', '-27 days', 'localtime') and date('now', 'localtime')
            group by comanda.data
            order by comanda.data desc
            limit 4
        )
    group by sabor.nome

--  d) Qual mesa foi mais utilizada nos últimos 60 dias?

--  e) Qual mesa foi menos utilizada nos últimos 60 dias?
select mesa.nome, count(*) as qtdMesa from comanda 
    join mesa on comanda.mesa = mesa.codigo
where 
    date(comanda.data, 'localtime') between date('now', '-60 days', 'localtime') and date('now', 'localtime')
group by mesa.nome
having qtdMesa in (
    select count(*) as qtdMesa from comanda 
        join mesa on comanda.mesa = mesa.codigo
    where 
        date(comanda.data, 'localtime') between date('now', '-60 days', 'localtime') and date('now', 'localtime')
    group by mesa.nome
    order by qtdMesa asc
    limit 1    
)
order by qtdMesa asc;

--  f) Quais mesas foram utilizadas mais de 2 vezes a média de utilização de todas as mesas nos últimos 60 dias?

--  g) Quais sabores estão entre os 10 mais pedidos no último mês e também no penúltimo mês?
select sabor.nome from sabor
where sabor.nome in (
    select sabor.nome from comanda
        join pizza on comanda.numero = pizza.comanda
        join pizzasabor on pizza.codigo = pizzasabor.pizza
        join sabor on pizzasabor.sabor = sabor.codigo
    where
        strftime('%m', comanda.data, 'localtime') = strftime('%m', 'now', '-1 month', 'localtime')
    group by sabor.nome
    having count(*) in (
        select distinct* from (
            select count(*) as qtdPedidos from comanda
                join pizza on comanda.numero = pizza.comanda
                join pizzasabor on pizza.codigo = pizzasabor.pizza
                join sabor on pizzasabor.sabor = sabor.codigo
            where
                strftime('%m', comanda.data, 'localtime') = strftime('%m', 'now', '-1 month', 'localtime')
            group by sabor.nome
            order by qtdPedidos desc
        ) 
        limit 10
    )
    order by count(*) desc
    ) and
    sabor.nome in (
        select sabor.nome from comanda
            join pizza on comanda.numero = pizza.comanda
            join pizzasabor on pizza.codigo = pizzasabor.pizza
            join sabor on pizzasabor.sabor = sabor.codigo
        where
            strftime('%m', comanda.data, 'localtime') = strftime('%m', 'now', '-2 month', 'localtime')
        group by sabor.nome
        having count(*) in (
            select distinct* from (
                select count(*) as qtdPedidos from comanda
                    join pizza on comanda.numero = pizza.comanda
                    join pizzasabor on pizza.codigo = pizzasabor.pizza
                    join sabor on pizzasabor.sabor = sabor.codigo
                where
                    strftime('%m', comanda.data, 'localtime') = strftime('%m', 'now', '-2 month', 'localtime')
                group by sabor.nome
                order by qtdPedidos desc
            ) 
            limit 10
        )
        order by count(*) desc
    );

--  h) Quais sabores estão entre os 10 mais pedidos no último mês mas não no penúltimo mês?

--  i) Quais sabores não foram pedidos nos últimos 3 meses?
    select sabor.nome from sabor
except
    select sabor.nome from comanda
        join pizza on comanda.numero = pizza.comanda
        join pizzasabor on pizza.codigo = pizzasabor.pizza
        join sabor on pizzasabor.sabor = sabor.codigo
    where
        comanda.data in (
            select comanda.data from comanda
            where
                date(comanda.data, 'localtime') between date('now', 'start of month', '-3 months', 'localtime') and date('now', 'localtime')
            group by comanda.data
            order by comanda.data desc
        )
    group by sabor.nome;

--  j) Quais foram os 3 sabores mais pedidos na última estação do ano?

--  k) Quais foram os 5 ingredientes mais pedidos na última estação do ano?
select ingrediente.nome, count(*) as qtdPedidos from comanda
    join pizza on comanda.numero = pizza.comanda
    join pizzasabor on pizza.codigo = pizzasabor.pizza
    join sabor on pizzasabor.sabor = sabor.codigo
    join saboringrediente on sabor.codigo = saboringrediente.sabor
    join ingrediente on saboringrediente.ingrediente = ingrediente.codigo
where 
    datetime(comanda.data, 'localtime') between (
        select 
            case
                when datetime('now', 'localtime') between 
                    datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1) and 
                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
                        then datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+265.2)
                
                when datetime('now', 'localtime') between 
                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8) and 
                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) 
                        then datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1)
                
                when datetime('now', 'localtime') between 
                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) and
                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) 
                        then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
                
                when datetime('now', 'localtime') between 
                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) and
                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1)
                        then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6)
                        
                when datetime('now', 'localtime') between 
                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1) and
                    datetime(julianday(date(strftime('%Y-%m-%d','now', '+1 year', 'start of year')))+78.8)
                        then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2)
                end as comecoEstacao) and 
        (
        select 
                case
                    when datetime('now', 'localtime') between 
                        datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1) and 
                        datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
                            then datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1)
                    
                    when datetime('now', 'localtime') between 
                        datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8) and 
                        datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) 
                            then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
                    
                    when datetime('now', 'localtime') between 
                        datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) and
                        datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) 
                            then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6)
                    
                    when datetime('now', 'localtime') between 
                        datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) and
                        datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1)
                            then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2)
                            
                    when datetime('now', 'localtime') between 
                        datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1) and
                        datetime(julianday(date(strftime('%Y-%m-%d','now', '+1 year', 'start of year')))+78.8)
                            then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1)
                    end as fimEstacao
        )
group by ingrediente.nome
having qtdPedidos in (
    select distinct* from (
        select count(*) as qtdPedidos from comanda
            join pizza on comanda.numero = pizza.comanda
            join pizzasabor on pizza.codigo = pizzasabor.pizza
            join sabor on pizzasabor.sabor = sabor.codigo
            join saboringrediente on sabor.codigo = saboringrediente.sabor
            join ingrediente on saboringrediente.ingrediente = ingrediente.codigo
        where 
            datetime(comanda.data, 'localtime') between (
                    select 
                        case
                            when datetime('now', 'localtime') between 
                                datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1) and 
                                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
                                    then datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+265.2)
                            
                            when datetime('now', 'localtime') between 
                                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8) and 
                                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) 
                                    then datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1)
                            
                            when datetime('now', 'localtime') between 
                                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) and
                                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) 
                                    then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
                            
                            when datetime('now', 'localtime') between 
                                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) and
                                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1)
                                    then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6)
                                    
                            when datetime('now', 'localtime') between 
                                datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1) and
                                datetime(julianday(date(strftime('%Y-%m-%d','now', '+1 year', 'start of year')))+78.8)
                                    then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2)
                            end as comecoEstacao) and 
                    (
                    select 
                            case
                                when datetime('now', 'localtime') between 
                                    datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1) and 
                                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
                                        then datetime(julianday(date(strftime('%Y-%m-%d','now', '-1 year', 'start of year')))+355.1)
                                
                                when datetime('now', 'localtime') between 
                                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8) and 
                                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) 
                                        then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+78.8)
                                
                                when datetime('now', 'localtime') between 
                                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6) and
                                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) 
                                        then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+171.6)
                                
                                when datetime('now', 'localtime') between 
                                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2) and
                                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1)
                                        then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+265.2)
                                        
                                when datetime('now', 'localtime') between 
                                    datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1) and
                                    datetime(julianday(date(strftime('%Y-%m-%d','now', '+1 year', 'start of year')))+78.8)
                                        then datetime(julianday(date(strftime('%Y-%m-%d','now', 'start of year')))+355.1)
                                end as fimEstacao
                    )
        group by ingrediente.nome
        order by qtdPedidos desc
    )
    limit 5
)
order by qtdPedidos desc;

--  l) Qual é o percentual atingido de arrecadação com venda de pizzas no ano atual em comparação com o total arrecadado no ano passado?
select (tmp1.totalAtual*100)/(tmp2.totalPassado) as percentual from (
    select tmp1.ano, sum(tmp1.total) as totalAtual from (
        select tmp.numero as comanda, strftime('%Y', comanda.data, 'localtime') as ano, sum(tmp.preco) as total
        from
            (select comanda.numero, pizza.codigo,
                max(case
                        when borda.preco is null then 0
                        else borda.preco
                    end+precoportamanho.preco) as preco
            from comanda
                join pizza on pizza.comanda = comanda.numero
                join pizzasabor on pizzasabor.pizza = pizza.codigo
                join sabor on pizzasabor.sabor = sabor.codigo
                join precoportamanho on precoportamanho.tipo = sabor.tipo and precoportamanho.tamanho = pizza.tamanho
                left join borda on pizza.borda = borda.codigo
            where strftime('%Y', comanda.data, 'localtime') == strftime('%Y', 'now', 'localtime')
            group by comanda.numero, pizza.codigo) as tmp
            join comanda on comanda.numero = tmp.numero
        group by tmp.numero
    ) as tmp1
    group by tmp1.ano
) as tmp1, (
    select tmp2.ano, sum(tmp2.total) as totalPassado from (
        select tmp.numero as comanda, strftime('%Y', comanda.data, 'localtime') as ano, sum(tmp.preco) as total
        from
            (select comanda.numero, pizza.codigo,
                max(case
                        when borda.preco is null then 0
                        else borda.preco
                    end+precoportamanho.preco) as preco
            from comanda
                join pizza on pizza.comanda = comanda.numero
                join pizzasabor on pizzasabor.pizza = pizza.codigo
                join sabor on pizzasabor.sabor = sabor.codigo
                join precoportamanho on precoportamanho.tipo = sabor.tipo and precoportamanho.tamanho = pizza.tamanho
                left join borda on pizza.borda = borda.codigo
            where strftime('%Y', comanda.data, 'localtime') == strftime('%Y', 'now', '-1 year', 'localtime')
            group by comanda.numero, pizza.codigo) as tmp
            join comanda on comanda.numero = tmp.numero
        group by tmp.numero
    ) as tmp2
    group by tmp2.ano 
) as tmp2;

--  m) Qual dia da semana teve maior arrecadação em pizzas nos últimos 60 dias?
select tmp.dia_semana, sum(tmp.total) as soma from (
    select tmp.numero as comanda, comanda.data, 
        case 
            when strftime('%w', comanda.data) = '0' then 'Domingo'
            when strftime('%w', comanda.data) = '1' then 'Segunda'
            when strftime('%w', comanda.data) = '2' then 'Terça'
            when strftime('%w', comanda.data) = '3' then 'Quarta'
            when strftime('%w', comanda.data) = '4' then 'Quinta'
            when strftime('%w', comanda.data) = '5' then 'Sexta'
            when strftime('%w', comanda.data) = '6' then 'Sábado'
        end as dia_semana, 
        sum(tmp.preco) as total
    from
        (select comanda.numero, pizza.codigo,
            max(case
                    when borda.preco is null then 0
                    else borda.preco
                end+precoportamanho.preco) as preco
        from comanda
            join pizza on pizza.comanda = comanda.numero
            join pizzasabor on pizzasabor.pizza = pizza.codigo
            join sabor on pizzasabor.sabor = sabor.codigo
            join precoportamanho on precoportamanho.tipo = sabor.tipo and precoportamanho.tamanho = pizza.tamanho
            left join borda on pizza.borda = borda.codigo
        where date(comanda.data, 'localtime') between date('now', '-60 days', 'localtime') and date('now', 'localtime')
        group by comanda.numero, pizza.codigo) as tmp
        join comanda on comanda.numero = tmp.numero
    group by tmp.numero
) as tmp
group by tmp.dia_semana
having soma in (
    select sum(tmp.total) as soma from (
        select tmp.numero as comanda, comanda.data, 
            case 
                when strftime('%w', comanda.data) = '0' then 'Domingo'
                when strftime('%w', comanda.data) = '1' then 'Segunda'
                when strftime('%w', comanda.data) = '2' then 'Terça'
                when strftime('%w', comanda.data) = '3' then 'Quarta'
                when strftime('%w', comanda.data) = '4' then 'Quinta'
                when strftime('%w', comanda.data) = '5' then 'Sexta'
                when strftime('%w', comanda.data) = '6' then 'Sábado'
            end as dia_semana, 
            sum(tmp.preco) as total
        from
            (select comanda.numero, pizza.codigo,
                max(case
                        when borda.preco is null then 0
                        else borda.preco
                    end+precoportamanho.preco) as preco
            from comanda
                join pizza on pizza.comanda = comanda.numero
                join pizzasabor on pizzasabor.pizza = pizza.codigo
                join sabor on pizzasabor.sabor = sabor.codigo
                join precoportamanho on precoportamanho.tipo = sabor.tipo and precoportamanho.tamanho = pizza.tamanho
                left join borda on pizza.borda = borda.codigo
            where date(comanda.data, 'localtime') between date('now', '-60 days', 'localtime') and date('now', 'localtime')
            group by comanda.numero, pizza.codigo) as tmp
            join comanda on comanda.numero = tmp.numero
        group by tmp.numero
    ) as tmp
    group by tmp.dia_semana
    order by soma desc
    limit 1
)
order by soma desc;

--  n) Qual a combinação de 2 sabores mais pedida na mesma pizza nos últimos 3 meses?

--  o) Qual a combinação de 3 sabores mais pedida na mesma pizza nos últimos 3 meses? --refazer
select tmp.combinacao, count(*) as qtd from (
    select pizza.codigo, group_concat(sabor.nome, ', ') as combinacao from comanda
        join pizza on comanda.numero = pizza.comanda
        join pizzasabor on pizza.codigo = pizzasabor.pizza
        join sabor on pizzasabor.sabor = sabor.codigo
    where 
        date(comanda.data, 'localtime') between date('now', '-3 months', 'localtime') and date('now', 'localtime') and
        pizza.codigo in (
            select pizza.codigo from comanda
                join pizza on comanda.numero = pizza.comanda
                join pizzasabor on pizza.codigo = pizzasabor.pizza
                join sabor on pizzasabor.sabor = sabor.codigo
            where 
                date(comanda.data, 'localtime') between date('now', '-3 months', 'localtime') and date('now', 'localtime')
            group by pizza.codigo
            having count(*) = 3
        )
    group by pizza.codigo
    order by pizza.codigo, sabor.nome
) as tmp 
group by tmp.combinacao
having qtd in (
    select count(*) as qtd from (
        select pizza.codigo, group_concat(sabor.nome, ', ') as combinacao from comanda
            join pizza on comanda.numero = pizza.comanda
            join pizzasabor on pizza.codigo = pizzasabor.pizza
            join sabor on pizzasabor.sabor = sabor.codigo
        where 
            date(comanda.data, 'localtime') between date('now', '-3 months', 'localtime') and date('now', 'localtime') and
            pizza.codigo in (
                select pizza.codigo from comanda
                    join pizza on comanda.numero = pizza.comanda
                    join pizzasabor on pizza.codigo = pizzasabor.pizza
                    join sabor on pizzasabor.sabor = sabor.codigo
                where 
                    date(comanda.data, 'localtime') between date('now', '-3 months', 'localtime') and date('now', 'localtime')
                group by pizza.codigo
                having count(*) = 3
            )
        group by pizza.codigo
        order by pizza.codigo, sabor.nome
    ) as tmp 
    group by tmp.combinacao
    order by qtd desc
    limit 1    
)
order by qtd desc;

--  p) Qual a combinação de sabor e borda mais pedida na mesma pizza nos últimos 3 meses?
