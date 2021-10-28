<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<!-- validação php back -->

<br>
    <button ></button>
    <button><a href="letraD.php" class="link">Voltar</a></button>
    <?php
$db = new SQLite3("pizzaria.db");
$db->exec("PRAGMA foreign_keys = ON");

$ultimaComanda = $db-> query("select numero from comanda order by numero desc limit 1"); 
$tmp;
while ($row = $ultimaComanda->fetchArray()) { $tmp = $row[0]; }
$ultimaComanda = $tmp;

$hoje = mktime(date("H"),date("i"),date("s"),date("m"),date("d"),date("Y")); 

echo $hoje;
if (isset($_POST["confirma"])) {
	$error = "";
	//coloque aqui o código para validação dos campos recebidos
	//se ocorreu algum erro, preencha a variável $error com uma mensagem de erro
	if ($error == "") {
		//$db->exec("insert into pessoa (nome, genero, nascimento) values ('".$_POST["nome"]."', '".$_POST["genero"]."', '".$_POST["nascimento"]."')");
		
		$db->close();
	} else {
		echo "<font color=\"red\">".$error."</font>";
	}
} else {




echo "<form id=\"insert\" name=\"insert\" action=\"letraE.php?\" method=\"post\">";
echo "<table>";
echo "<tr>";
echo "<td>Número</td>";
echo "<td><input id=\"numero\" type=\"text\" name=\"numero\" value=\"".$ultimaComanda."\" size=\"50\" onclick=\"unsetError(this)\" type=\"hidden\"></td>";
echo"</tr>";
echo "<tr>";
echo "<td>Data</td>";
echo "<td>";
echo "</tr>";
echo "</table>";
echo "<input id=\"confirmar\" type=\"hidden\" name=\"confirmar\" value=\"\">";
echo "<input type=\"button\" value=\"Confirmar\" onclick=\"valid()\">";
echo "</form>";

$db->close();
}
?>

<!-- validação js front -->
</body>
</html>