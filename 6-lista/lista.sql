-- 1) Escreva comandos insert, update ou delete, utilizando as tabelas criadas para uma rede social nas listas de exercícios anteriores, para:

-- a) Alterar o texto da última postagem do usuário Edson Arantes do Nascimento, e-mail pele@cbf.com.br, de "Brasil: 20 medalhas nas Olimpíadas 2020/2021 em Tóquio" para "Brasil: 21 medalhas nas Olimpíadas 2020/2021 em Tóquio".
select post.codigo from post where usuario = 'pele@cbf.com.br' order by datadopost desc, horadopost desc limit 1;

update post set conteudo = 'Brasil: 21 medalhas nas Olimpíadas 2020/2021 em Tóquio' where post.codigo = (select post.codigo from post where usuario = 'pele@cbf.com.br' order by datadopost desc, horadopost desc limit 1);

-- b) Alterar a última reação do usuário Paulo Xavier Ramos, e-mail pxramos@mymail.com, à uma postagem no grupo SQLite de emojiJoinha para emojiS2.

-- c) Desativar temporariamente as contas dos usuários do Brasil que não possuem qualquer atividade na rede social há mais de 5 anos.

-- d) Excluir a última postagem no grupo IFRS-Campus Rio Grande, classificada como postagem que incita ódio.

-- e) Atribuir um selo de fã, com validade determinada para a semana atual, para os usuários do grupo IFRS-Campus Rio Grande que:

-- |    Selo    | Condições considerando as postagens da semana passada no grupo
-- |  ultra-fã  | reagiram a 75% ou mais e comentaram 30% ou mais das postagens
-- |  super-fã  | reagiram a 50% ou mais e comentaram 20% ou mais das postagens
-- |     fã     | reagiram a 25% ou mais e comentaram 10% ou mais das postagens

-- * O procedimento de atribuir selo de fã será executado automaticamente às 00:00 de cada domingo.

-- 2) Descreva e justifique as adequações/alterações que foram realizadas nas tabelas criadas para uma rede social nas listas de exercícios anteriores para que o exercício 1 acima pudesse ser resolvido.

-- 3) Explique detalhadamente porque não é possível várias pessoas distintas comprarem o mesmo lugar numerado no mesmo show utilizando controle de concorrência.

-- Isso acontece pois obviamente, cada acento ou um lugar em um show só pode ser utilizado por uma pessoa de cada vez, e realizar esse procedimento físicamente seria bem menos problemático nesse quesito. Porém, quando acessamos um site ou app e interagimos com recursos escassos, seja a quantidade de produtos em um estoque, os acentos em uma sala de cinema, etc., controlar quem vai comprar primeiro fica mais complicado. 

-- Se por exemplo, duas pessoas, Claudio e Felipe querem comprar um ingresso para um show do Guns n' Roses, ao entrarem na plataforma, provávelmente irá aparecer uma contagem de quantos ingressos disponíveis tem ainda. Mas supondo que só tem 1 ingresso restante e ambos clicaram para comprá-lo, o sistema precisará analizar essas requisições, escolher uma delas e assim fazer um update na quantidade de ingressos. Posteriormente, ele terá que impedir que o outro comprador não consiga comprar, se não a quantidade no banco de dados ficaria negativa e os dois clientes com o mesmo lugar no show.