select sabor.codigo as codigo, sabor.nome as sabor, tipo.nome as tipo, group_concat(ingrediente.nome, ', ') as ingredientes from sabor
    join tipo on sabor.tipo = tipo.codigo
    join saboringrediente on saboringrediente.sabor = sabor.codigo 
    join ingrediente on saboringrediente.ingrediente = ingrediente.codigo
group by sabor.codigo;

select count(*) as total from (
    select * from sabor
        join tipo on sabor.tipo = tipo.codigo
        join saboringrediente on saboringrediente.sabor = sabor.codigo 
        join ingrediente on saboringrediente.ingrediente = ingrediente.codigo
    group by sabor.codigo);

select sabor.codigo as codigo, sabor.nome as sabor, tipo.nome as tipo, group_concat(ingrediente.nome, ', ') as ingredientes 
from sabor 
	join tipo on sabor.tipo = tipo.codigo 
	join saboringrediente on saboringrediente.sabor = sabor.codigo 
	join ingrediente on saboringrediente.ingrediente = ingrediente.codigo 
where sabor.nome like '%%' 
group by sabor.codigo 

select * from sabor 
join saboringrediente on saboringrediente.sabor = sabor.codigo 
join ingrediente on saboringrediente.ingrediente = ingrediente.codigo 
limit 10;

select count(*) as qtd from ingrediente;

insert into sabor (nome, tipo) values ('NIGERIA', 1);
insert into saboringrediente (sabor, ingrediente) values (1, 30);

select ingrediente.codigo, ingrediente.nome from sabor
    join saboringrediente on saboringrediente.sabor = sabor.codigo
    join ingrediente on saboringrediente.ingrediente = ingrediente.codigo
where sabor.codigo = 1;

delete from saboringrediente where sabor = 1;
update sabor set nome = 'NIGÉRIA', tipo = 2 where codigo = 1;