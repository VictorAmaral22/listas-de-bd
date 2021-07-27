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

--  c) Qual sabor não foi pedido nos últimos 4 domingos?
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
--Victor

--  l) Qual é o percentual atingido de arrecadação com venda de pizzas no ano atual em comparação com o total arrecadado no ano passado?

--  m) Qual dia da semana teve maior arrecadação em pizzas nos últimos 60 dias?
--Victor

--  n) Qual a combinação de 2 sabores mais pedida na mesma pizza nos últimos 3 meses?

--  o) Qual a combinação de 3 sabores mais pedida na mesma pizza nos últimos 3 meses?
--Victor

--  p) Qual a combinação de sabor e borda mais pedida na mesma pizza nos últimos 3 meses?