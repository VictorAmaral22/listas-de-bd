--3) Utilizando a modelagem da pizzaria do material, escreva comandos select para responder as perguntas:
--  a) Quais os nomes dos ingredientes no sabor cujo nome é São Tomé e Príncipe?
select sabor.nome, group_concat(ingrediente.nome, ', ') as ingredientes from saboringrediente
    join sabor on saboringrediente.sabor = sabor.codigo
    join ingrediente on saboringrediente.ingrediente = ingrediente.codigo
where lower(sabor.nome) like '%sao tome e principe%';
    
--  b) Quais os nomes dos sabores que contém o ingrediente bacon?
select ingrediente.nome, group_concat(sabor.nome, ', ') as sabores from saboringrediente
    join sabor on saboringrediente.sabor = sabor.codigo
    join ingrediente on saboringrediente.ingrediente = ingrediente.codigo
where lower(ingrediente.nome) like '%bacon%';

--  c) Quais os nomes dos sabores que contém os ingredientes bacon e gorgonzola?
select ingrediente.nome, group_concat(sabor.nome, ', ') as sabores from saboringrediente
    join sabor on saboringrediente.sabor = sabor.codigo
    join ingrediente on saboringrediente.ingrediente = ingrediente.codigo
where 
    lower(ingrediente.nome) like '%bacon%' or
    lower(ingrediente.nome) like '%gorgonzola%'
group by ingrediente.nome;

--  d) Quais os nomes dos sabores salgados que possuem mais de 8 ingredientes?
select count(saboringrediente.ingrediente) as qtdIngredientes, sabor.nome from saboringrediente
    join sabor on saboringrediente.sabor = sabor.codigo
    join tipo on sabor.tipo = tipo.codigo
where lower(tipo.nome) like '%salgadas%' group by sabor having count(*) > 8 order by qtdIngredientes desc;

--  e) Quais os nomes dos sabores doces que possuem mais de 8 ingredientes?
select count(saboringrediente.ingrediente) as qtdIngredientes, sabor.nome from saboringrediente
    join sabor on saboringrediente.sabor = sabor.codigo
    join tipo on sabor.tipo = tipo.codigo
where lower(tipo.nome) like '%doces%' group by sabor having count(*) > 8 order by qtdIngredientes desc;

--  f) Quais os nomes dos sabores que foram pedidos mais de 20 vezes no mês passado?
select sabor.nome, count(*) as qtdPedidos from comanda 
    join pizza on comanda.numero = pizza.comanda
    join pizzasabor on pizza.codigo = pizzasabor.pizza
    join sabor on pizzasabor.sabor = sabor.codigo
where 
    strftime('%m', data, 'localtime') = strftime('%m', 'now', '-1 month', 'localtime') and
    (strftime('%Y', data, 'localtime') = strftime('%Y', 'now', 'localtime') or strftime('%m', 'now', 'localtime') = '01')
group by sabor.nome having count(*) > 20 order by qtdPedidos desc;

--  g) Quais os nomes dos sabores salgados que foram pedidos mais de 20 vezes no mês passado?
select sabor.nome, count(*) as qtdPedidos from comanda 
    join pizza on comanda.numero = pizza.comanda
    join pizzasabor on pizza.codigo = pizzasabor.pizza
    join sabor on pizzasabor.sabor = sabor.codigo
    join tipo on sabor.tipo = tipo.codigo
where 
    strftime('%m', data, 'localtime') = strftime('%m', 'now', '-1 month', 'localtime') and
    (strftime('%Y', data, 'localtime') = strftime('%Y', 'now', 'localtime') or strftime('%m', 'now', 'localtime') = '01') and
    lower(tipo.nome) like '%salgadas%'
group by sabor.nome having count(*) > 20 order by qtdPedidos desc;

--  h) Quais os nomes dos sabores doces que foram pedidos mais de 20 vezes no mês passado?
select sabor.nome, count(*) as qtdPedidos from comanda 
    join pizza on comanda.numero = pizza.comanda
    join pizzasabor on pizza.codigo = pizzasabor.pizza
    join sabor on pizzasabor.sabor = sabor.codigo
    join tipo on sabor.tipo = tipo.codigo
where 
    strftime('%m', data, 'localtime') = strftime('%m', 'now', '-1 month', 'localtime') and
    (strftime('%Y', data, 'localtime') = strftime('%Y', 'now', 'localtime') or strftime('%m', 'now', 'localtime') = '01') and
    lower(tipo.nome) like '%doces%'
group by sabor.nome having count(*) > 20 order by qtdPedidos desc;

--  i) Qual o ranking dos ingredientes mais pedidos nos últimos 12 meses?
select ingrediente.nome, count(*) as qtdPedidos from comanda 
    join pizza on comanda.numero = pizza.comanda
    join pizzasabor on pizza.codigo = pizzasabor.pizza
    join sabor on pizzasabor.sabor = sabor.codigo
    join saboringrediente on sabor.codigo = saboringrediente.sabor
    join ingrediente on ingrediente.codigo = saboringrediente.ingrediente
where 
    date(data, 'localtime') between date('now', '-12 month', 'localtime') and date('now', 'localtime')
group by ingrediente.nome order by qtdPedidos desc;

--  j) Qual o ranking dos sabores salgados mais pedidos por mês nos últimos 12 meses?   REVISAR
select sabor.nome, count(*) as qtdPedidos, strftime('%Y-%m', data, 'localtime') from comanda 
    join pizza on comanda.numero = pizza.comanda
    join pizzasabor on pizza.codigo = pizzasabor.pizza
    join sabor on pizzasabor.sabor = sabor.codigo
    join tipo on sabor.tipo = tipo.codigo
where 
    (date(data, 'localtime') between date('now', '-12 month', 'localtime') and date('now', 'localtime')) and
    lower(tipo.nome) like '%salgadas%'
group by sabor.nome, strftime('%m', data, 'localtime') order by data asc, qtdPedidos desc;

--  k) Qual o ranking dos sabores doces mais pedidos por mês nos últimos 12 meses?  REVISAR
select sabor.nome, count(*) as qtdPedidos, strftime('%Y-%m', data, 'localtime') from comanda 
    join pizza on comanda.numero = pizza.comanda
    join pizzasabor on pizza.codigo = pizzasabor.pizza
    join sabor on pizzasabor.sabor = sabor.codigo
    join tipo on sabor.tipo = tipo.codigo
where 
    (date(data, 'localtime') between date('now', '-12 month', 'localtime') and date('now', 'localtime')) and
    lower(tipo.nome) like '%doces%'
group by sabor.nome, strftime('%m', data, 'localtime') order by data asc, qtdPedidos desc;

--  l) Qual o ranking da quantidade de pizzas pedidas por tipo por tamanho nos últimos 6 meses?
select tipo.nome as tipo, pizza.tamanho as tamanho, count(*) as qtdPedidos from comanda
    join pizza on comanda.numero = pizza.comanda
    join pizzasabor on pizza.codigo = pizzasabor.pizza
    join sabor on pizzasabor.sabor = sabor.codigo
    join tipo on sabor.tipo = tipo.codigo
where
    date(data, 'localtime') between date('now', '-6 month', 'localtime') and date('now', 'localtime')
group by pizza.tamanho, tipo order by qtdPedidos desc;

--  m) Qual o ranking dos ingredientes mais pedidos acompanhando cada borda nos últimos 6 meses? 
select ingrediente.nome, borda.nome, count(*) as qtdPedidos from comanda 
    join pizza on comanda.numero = pizza.comanda
    join borda on pizza.borda = borda.codigo
    join pizzasabor on pizza.codigo = pizzasabor.pizza
    join sabor on pizzasabor.sabor = sabor.codigo
    join saboringrediente on sabor.codigo = saboringrediente.sabor
    join ingrediente on ingrediente.codigo = saboringrediente.ingrediente
where 
    (date(data, 'localtime') between date('now', '-6 month', 'localtime') and date('now', 'localtime')) and
    pizza.borda is not null
group by ingrediente.nome, borda.nome order by qtdPedidos desc;
