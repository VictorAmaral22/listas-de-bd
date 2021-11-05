<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inclusão de Comanda</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>
<?php
$db = new SQLite3("pizzaria.db");
$db->exec("PRAGMA foreign_keys = ON");

function leapYear($year){
	return (($year % 4 == 0) && ($year % 100 != 0)) || ($year % 400 == 0);
}
function validData($date){
	$meses = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	$mesesBi = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	$data = $date;
	$data[0] = (int)$data[0];
	$data[1] = (int)$data[1];
	$data[2] = (int)$data[2];
	if($data[2] != 0 && $data[1] != 0 && $data[0] != 0){
		if($data[1] >= 1 && $data[1] <= 12){
			$bi = leapYear($data[0]);
			if($bi){
				if(($data[2] >= 1) && ($data[2] <= $mesesBi[$data[1]-1])){
					return true;
				} else {
					return null;
				}
			} else {
				if(($data[2] >= 1) && ($data[2] <= $meses[$data[1]-1])){
					return true;                
				} else {
					return null;
				}
			}
		} else {
			return null;
		}
	} else {
		return null;
	}
}
function validTime($hora){
	$time = $hora;
	$time[0] = (int)$time[0];
	$time[1] = (int)$time[1];
	$time[2] = (int)$time[2];
	if($time[0] > 23 || $time[1] > 59 || $time[2] > 59){
		return false;
	} else {
		return true;
	}
}

if (isset($_POST["confirmar"]) && $_POST["confirmar"] == 'confirmar') {
	$error = "";
	if(!isset($_POST['mesa']) || !isset($_POST['numero']) || !isset($_POST['data'])){
		$error .= 'Campos faltando; ';
	}
	$mesa = $_POST['mesa'];
	$numero = $_POST['numero'];
	$data = $_POST['data'];
	
	if($mesa == "" || $mesa === null){
		$error .= 'Mesa não informada; ';
	} else {
		$mesas = $db->query("select codigo from mesa");
		$tmp2 = [];
		while($row = $mesas->fetchArray()){ $tmp2[] = $row[0]; }
		$mesas = $tmp2;
		if(!in_array($mesa, $mesas)){
			$error .= 'Mesa inválida; ';
		}
	}
	if($numero == "" || $numero === null){
		$error .= 'Comanda não informada; ';
	} else {
		$comandas = $db->query("select numero from comanda");
		$tmp3 = [];
		while($row = $comandas->fetchArray()){ $tmp3[] = $row[0]; }
		$comandas = $tmp3;
		if(in_array($numero, $comandas)){
			$error .= 'Esta comanda já existe; ';
		}
	}
	if($data == "" || $data === null){
		$error .= 'Data não informada; ';
	} else {
		if(!preg_match('#^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$#', $data)){
			$error .= 'Data inválida; ';
		} else {
			$dateNow = date('d/m/y H:i:s');
			$dateC = explode(' ', $data);
			$dateC[0] = explode('-', $dateC[0]);
			$dateC[1] = explode(':', $dateC[1]);
			$okData = validData($dateC[0]);
			$okHora = validTime($dateC[1]);
			if(!$okData || !$okHora){
				$error .= 'Data inválida; ';
			}
			if($okData && $okHora) {
				$dateC = date("d/m/y H:i:s", mktime($dateC[1][0], $dateC[1][1], $dateC[1][2], $dateC[0][1], $dateC[0][2], $dateC[0][0]));
				if(strtotime($dateNow) < strtotime($dateC)){
					$error .= 'Data inválida; ';
				}
			}
		}
	}
	
	if ($error == "") {
		$db->exec("insert into comanda (numero, mesa, data) values ('".$numero."', '".$mesa."', '".$data."')");
		$host  = $_SERVER['HTTP_HOST'];
        $uri   = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
        $extra = 'incluirComanda.php';
        header("Location: http://$host$uri/$extra");
        exit;
	} else {
		echo "<font color=\"red\">".$error."</font>";
	}
}

$ultimaComanda = $db-> query("select numero from comanda order by numero desc limit 1"); 
$tmp;
while ($row = $ultimaComanda->fetchArray()) { $tmp = $row[0]; }
$ultimaComanda = $tmp;
$hoje = date('d/m/Y', mktime(date("H"), date("i"), date("s"), date("m"), date("d"), date("Y"))); 
$diaSemana = date("l", mktime(date("H"), date("i"), date("s"), date("m"), date("d"), date("Y")));
switch ($diaSemana) {
	case 'Monday':
		$diaSemana = 'Seg';
		break;
	case 'Tuesday':
		$diaSemana = 'Ter';
		break;
	case 'Wednesday':
		$diaSemana = 'Qua';
		break;
	case 'Thursday':
		$diaSemana = 'Qui';
		break;
	case 'Friday':
		$diaSemana = 'Sex';
		break;
	case 'Saturday':
		$diaSemana = 'Sáb';
		break;
	case 'Sunday':
		$diaSemana = 'Dom';
		break;
}

echo "<h1>Inclusão de Comandas</h1>\n";
echo "<form id=\"comanda\" name=\"comanda\" action=\"letraE.php?\" method=\"post\">";
echo "<table>";
echo "<tr>";
echo "<td>Número</td>";
echo "<td>".($ultimaComanda+1)."</td>";
echo "</tr>";
echo "<tr>";
echo "<td>Data</td>";
echo "<td>".$diaSemana." ".$hoje."</td>";
echo "</tr>";
echo "<tr>";
echo "<td>Mesa</td>";
echo "<td><select id=\"mesa\" name=\"mesa\" onclick=\"unsetError(this)\">";
$mesas = $db->query("select * from mesa");
while ($row = $mesas->fetchArray()) { echo "<option id='option".$row['codigo']."' value='".$row['codigo']."'>".$row['nome']."</option>\n"; }
echo "</select></td>";
echo "</tr>";
echo "</table>";
echo "<input id=\"numero\" type=\"hidden\" name=\"numero\" value=\"".($ultimaComanda+1)."\" >";
echo "<input id=\"data\" type=\"hidden\" name=\"data\" value=\"".(date('Y-m-d H:i:s', mktime(date("H"), date("i"), date("s"), date("m"), date("d"), date("Y"))))."\" >";
echo "<input id=\"confirmar\" type=\"hidden\" name=\"confirmar\" value=\"confirmar\">";
echo "<input type=\"button\" value=\"Inclui\" onclick=\"valid()\">";
echo "</form>";

$db->close();
?>

<br>
<button><a href="letraD.php" class="link">Voltar</a></button>

<!-- validação js front -->
<script>
	function valid(){
		var form = document.getElementById('comanda');
		form.submit();
	}
	function unsetError(self){
		self.className = '';
	}
</script>
</body>
</html>