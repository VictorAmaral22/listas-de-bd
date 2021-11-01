<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro de Comandas</title>
	<link rel="stylesheet" href="style.css">
</head>
<body>
<?php
$db = new SQLite3("pizzaria.db");
$db->exec("PRAGMA foreign_keys = ON");

function url($campo, $valor) {
	$result = array();
	if (isset($_GET["comanda"])) $result["comanda"] = "comanda=".$_GET["comanda"];
	if (isset($_GET["data"])) $result["data"] = "data=".$_GET["data"];
	if (isset($_GET["mesa"])) $result["mesa"] = "mesa=".$_GET["mesa"];
	if (isset($_GET["pizzas"])) $result["pizzas"] = "pizzas=".$_GET["pizzas"];
	if (isset($_GET["valor"])) $result["valor"] = "valor=".$_GET["valor"];
	if (isset($_GET["pago"])) $result["pago"] = "pago=".$_GET["pago"];
	if (isset($_GET["orderby"])) $result["orderby"] = "orderby=".$_GET["orderby"];
	if (isset($_GET["offset"])) $result["offset"] = "offset=".$_GET["offset"];
	$result[$campo] = $campo."=".$valor;
	return("letraD.php?".strtr(implode("&", $result), " ", "+"));
}
$limit = 7;

echo "<h1>Cadastro de Comandas</h1>\n";
echo "<select id=\"campo\" name=\"campo\">\n";
echo "<option value=\"comanda\"".((isset($_GET["comanda"])) ? " selected" : "").">Número</option>\n";
echo "<option value=\"data\"".((isset($_GET["data"])) ? " selected" : "").">Data</option>\n";
echo "<option value=\"mesa\"".((isset($_GET["mesa"])) ? " selected" : "").">Mesa</option>\n";
echo "<option value=\"pizzas\"".((isset($_GET["pizzas"])) ? " selected" : "").">Pizzas</option>\n";
echo "<option value=\"valor\"".((isset($_GET["valor"])) ? " selected" : "").">Valor</option>\n";
echo "<option value=\"pago\"".((isset($_GET["pago"])) ? " selected" : "").">Pago</option>\n";
echo "</select>\n";

$value = "";
if (isset($_GET["comanda"])) $value = $_GET["comanda"];
if (isset($_GET["data"])) $value = $_GET["data"];
if (isset($_GET["mesa"])) $value = $_GET["mesa"];
if (isset($_GET["pizzas"])) $value = $_GET["pizzas"];
if (isset($_GET["valor"])) $value = $_GET["valor"];
if (isset($_GET["pago"])) $value = $_GET["pago"];
echo "<input type=\"text\" id=\"valor\" name=\"valor\" value=\"".$value."\" size=\"20\" > \n";

$parameters = array();
if (isset($_GET["orderby"])) $parameters[] = "orderby=".$_GET["orderby"];
if (isset($_GET["offset"])) $parameters[] = "offset=".$_GET["offset"];
echo "<button id='searchBtn' onclick=\"validSearch()\">&#x1F50E;</button><br>\n";
echo "<br>\n";

echo "<table border=\"1\">\n";
echo "<tr>\n";
echo "<td><a href=\"letraE.php\">➕</a></td>\n";
echo "<td><b>Número</b> <a href=\"".url("orderby", "comanda.numero+asc")."\">&#x25BE;</a> <a href=\"".url("orderby", "comanda.numero+desc")."\">&#x25B4;</a></td>\n";
echo "<td><b>Data</b> <a href=\"".url("orderby", "comanda.data+asc")."\">&#x25BE;</a> <a href=\"".url("orderby", "comanda.data+desc")."\">&#x25B4;</a></td>\n";
echo "<td><b>Mesa</b> <a href=\"".url("orderby", "mesa.nome+asc")."\">&#x25BE;</a> <a href=\"".url("orderby", "mesa.nome+desc")."\">&#x25B4;</a></td>\n";
echo "<td colspan=\"2\"><b>Pizzas</b> <a href=\"".url("orderby", "pizzas+asc")."\">&#x25BE;</a> <a href=\"".url("orderby", "pizzas+desc")."\">&#x25B4;</a></td>\n";
echo "<td><b>Valor</b> <a href=\"".url("orderby", "valor+asc")."\">&#x25BE;</a> <a href=\"".url("orderby", "valor+desc")."\">&#x25B4;</a></td>\n";
echo "<td colspan=\"3\"><b>Pago</b> <a href=\"".url("orderby", "pago+asc")."\">&#x25BE;</a> <a href=\"".url("orderby", "pago+desc")."\">&#x25B4;</a></td>\n";
echo "<td></td>\n";
echo "</tr>\n";

$where = array();
if (isset($_GET["comanda"])) $where[] = "comanda.numero like '%".strtr($_GET["comanda"], " ", "%")."%'";
if (isset($_GET["data"])) $where[] = "strftime('%d/%m/%Y', comanda.data) like '%".strtr($_GET["data"], " ", "%")."%'";
if (isset($_GET["mesa"])) $where[] = "mesa.nome like '%".strtr($_GET["mesa"], " ", "%")."%'";
if (isset($_GET["pizzas"])) $where[] = "tmp1.qtdPizzas like '%".strtr($_GET["pizzas"], " ", "%")."%'";
if (isset($_GET["valor"])) $where[] = "tmp2.total like '%".strtr($_GET["valor"], " ", "%")."%'";
if (isset($_GET["pago"])) $where[] = "comanda.pago like '%".strtr($_GET["pago"], " ", "%")."%'";
$where = (count($where) > 0) ? "where ".implode(" and ", $where) : "";

$total = $db->query("select count(*) as total from 
	(select comanda.numero as comanda, case 
            when strftime('%w', comanda.data) = '0' then 'Dom'
            when strftime('%w', comanda.data) = '1' then 'Seg'
            when strftime('%w', comanda.data) = '2' then 'Ter'
            when strftime('%w', comanda.data) = '3' then 'Qua'
            when strftime('%w', comanda.data) = '4' then 'Qui'
            when strftime('%w', comanda.data) = '5' then 'Sex'
            when strftime('%w', comanda.data) = '6' then 'Sáb'
        end as semana, strftime('%d/%m/%Y', comanda.data) as data, mesa.nome as mesa, tmp1.qtdPizzas as pizzas, tmp2.total as valor, comanda.pago as pago from comanda
    join mesa on comanda.mesa = mesa.codigo
	left join (
		select comanda.numero as comanda, count(*) as qtdPizzas from comanda
			join pizza on comanda.numero = pizza.comanda
		group by comanda) as tmp1 on tmp1.comanda = comanda.numero
	left join (
		select tmp.numero as comanda, sum(tmp.preco) as total from
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
			group by comanda.numero, pizza.codigo) as tmp
			join comanda on comanda.numero = tmp.numero
		group by tmp.numero) as tmp2 on tmp2.comanda = comanda.numero 
		".$where." )")->fetchArray()["total"];


$orderby = (isset($_GET["orderby"])) ? $_GET["orderby"] : "comanda asc";

$offset = (isset($_GET["offset"])) ? max(0, min($_GET["offset"], $total-1)) : 0;
$offset = $offset-($offset%$limit);

$results = $db->query("
select comanda.numero as comanda, case 
		when strftime('%w', comanda.data) = '0' then 'Dom'
		when strftime('%w', comanda.data) = '1' then 'Seg'
		when strftime('%w', comanda.data) = '2' then 'Ter'
		when strftime('%w', comanda.data) = '3' then 'Qua'
		when strftime('%w', comanda.data) = '4' then 'Qui'
		when strftime('%w', comanda.data) = '5' then 'Sex'
		when strftime('%w', comanda.data) = '6' then 'Sáb'
	end as semana, strftime('%d/%m/%Y', comanda.data) as data, mesa.nome as mesa, tmp1.qtdPizzas as pizzas, tmp2.total as valor, comanda.pago as pago from comanda
join mesa on comanda.mesa = mesa.codigo
left join (
	select comanda.numero as comanda, count(*) as qtdPizzas from comanda
		join pizza on comanda.numero = pizza.comanda
	group by comanda) as tmp1 on tmp1.comanda = comanda.numero
left join (
	select tmp.numero as comanda, sum(tmp.preco) as total from
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
		group by comanda.numero, pizza.codigo) as tmp
		join comanda on comanda.numero = tmp.numero
	group by tmp.numero) as tmp2 on tmp2.comanda = comanda.numero
$where 
order by $orderby 
limit $limit 
offset $offset");

while ($row = $results->fetchArray()) {
	echo "<tr>\n";
	echo "<td>".($row["pago"] ? "" : "<a href=\"letraF.php?comanda=".$row["comanda"]."\">✏️</a>")."</td>\n";
	echo "<td>".$row["comanda"]."</td>\n";
	echo "<td>".$row["semana"]." ".$row["data"]."</td>\n";
	echo "<td>".$row["mesa"]."</td>\n";
	echo "<td>".$row["pizzas"]."</td>\n";
	echo "<td>".($row["pizzas"] ? "<a href=\"letraG.php?comanda=".$row["comanda"]."\">👀</a>" : "")."</td>\n";
	echo "<td>R$ ".number_format($row["valor"], 2, '.', ',')."</td>\n";
	echo "<td>".($row["pago"] ? "Sim" : "Não")."</td>\n";
	echo "<td>".(!$row["pago"] && $row["valor"] ? "<a style=\"text-decoration:none\" href=\"pagarComanda.php?comanda=".$row["comanda"]."\" onclick=\"return(confirm('Pagar comanda ".$row["comanda"]." no cartão?'));\">💳</a>" : "")."</td>\n";
	echo "<td>".(!$row["pago"] && $row["valor"] ? "<a style=\"text-decoration:none\" href=\"pagarComanda.php?comanda=".$row["comanda"]."\" onclick=\"return(confirm('Pagar comanda ".$row["comanda"]." em dinheiro?'));\">💵</a>" : "")."</td>\n";
	echo "<td>".(!$row["pago"] && !$row["valor"] ? "<a style=\"text-decoration:none\" href=\"excluirComanda.php?comanda=".$row["comanda"]."\" onclick=\"return(confirm('Excluir comanda ".$row["comanda"]."?'));\">&#x1F5D1;</a>" : "")."</td>\n";
	echo "</tr>\n";
}

echo "</table>\n";
echo "<br>\n";

for ($page = 0; $page < ceil($total/$limit); $page++) {
	echo (($offset == $page*$limit) ? ($page+1) : "<a href=\"".url("offset", $page*$limit)."\">".($page+1)."</a>")." \n";
}

$db->close();
?>
<br>
<br>
<button><a href="index.html" class="link">Voltar</a></button>
<script>
function validSearch(){
	let valor = document.getElementById('valor').value;
	let regExp = new RegExp(valor.pattern);
	if(regExp.test(valor.value)){
		let value = document.getElementById('valor').value.trim().replace(/ +/g, '+'); 
		let result = '".strtr(implode("&", $parameters), " ", "+")."'; 
		result = ((value != '') ? document.getElementById('campo').value+'='+value+((result != '') ? '&' : '') : '')+result; 
		location.href= 'letraD.php'+((result != '') ? '?' : '')+result;
	} else {
		alert('Faça uma pesquisa válida!');
		valor.className = 'error';
	}	
}
</script>
</body>
</html>