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

