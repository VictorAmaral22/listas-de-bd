<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>

<?php 
/*
Somar uma quantidade de dias úteis a uma data
    front-end HTML/JS
        input text data, deve ser uma data dd/mm/aaaa válida
        input text dias úteis, deve ser um número inteiro positivo válido
        button Enviar, só deve enviar se data e dias úteis forem válidos
    back-end PHP
        mostra uma mensagem de erro se data ou dias úteis forem inválidos
        só calcula se data e dias úteis forem válidos
        soma a quantidade de dias úteis à data e mostra a data resultante
* dias úteis são os dias da semana de segunda a sexta que não são feriados nacionais
(Confraternização Universal, Carnaval, Sexta-feira Santa, Páscoa, Tiradentes, Dia Mundial do Trabalho, Corpus Christi,
Independência do Brasil, Nossa Senhora Aparecida, Finados, Proclamação da República e Natal)
*/
if(!isset($_POST["data"]) || !isset($_POST["dataUtil"])){
    echo "DATA OU DIAS ÚTEIS NÃO INFORMADOS <br>";
} else {
    $data = $_POST["data"];
    $dataUtil = $_POST["dataUtil"]; 
    
    function validacao($dataUtil, $data){
        if(preg_match("#^[1-9]+$#", $dataUtil) && (abs($dataUtil) == $dataUtil)){
            if(preg_match("#^[0-9]{2}/[0-9]{2}/[0-9]{4}$#", $data)){
                $data = explode('/', $data);
                function leapYear($year){
                    return (($year % 4 == 0) && ($year % 100 != 0)) || ($year % 400 == 0);
                }
                $meses = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
                $mesesBi = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
                
                $data[0] = (int)$data[0];
                $data[1] = (int)$data[1];
                $data[2] = (int)$data[2];
                
                if($data[2] != 0 && $data[1] != 0 && $data[0] != 0){
                    if($data[1] >= 1 && $data[1] <= 12){
                        $bi = leapYear($data[2]);
                        if($bi){
                            // é bissexto
                            if(($data[0] >= 1) && ($data[0] <= $mesesBi[$data[1]-1])){
                                return true;
                            } else {
                                return null;
                            }
                        } else {
                            // não é bissexto
                            if(($data[0] >= 1) && ($data[0] <= $meses[$data[1]-1])){
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
            } else {
                return null;
            }
        } else {
            return null;
        }
    }
    $ok = validacao($dataUtil, $data);

    if($ok){
        $data = $_POST["data"]; //dd/mm/aaaa
        $dataUtil = $_POST["dataUtil"]; 
        $data = explode("/",$_POST["data"]);

        $dataday = (int)$data[0];
        $datamonth = (int)$data[1];

        $easterInterval = easter_days ($data[2]);  
        $easterP = ('21-03-'.$data[2]);
        $easter= date('d/m/Y', strtotime('+'.$easterInterval.' days', strtotime($easterP))); 
        $easterday = (int)substr($easter, 0, 2);
        $eastermonth = (int)substr($easter, 3, 2);
        $easter= mktime(0, 0, 0, $eastermonth, $easterday, $data[2]);

        $feriados = array(
            // Tatas Fixas dos feriados Nacionail Basileiras
            mktime(0, 0, 0, 1,  1,   $data[2]), // Confraternização Universal - Lei nº 662, de 06/04/49
            mktime(0, 0, 0, 4,  21,  $data[2]), // Tiradentes - Lei nº 662, de 06/04/49
            mktime(0, 0, 0, 5,  1,   $data[2]), // Dia do Trabalhador - Lei nº 662, de 06/04/49
            mktime(0, 0, 0, 9,  7,   $data[2]), // Dia da Independência - Lei nº 662, de 06/04/49
            mktime(0, 0, 0, 10,  12, $data[2]), // N. S. Aparecida - Lei nº 6802, de 30/06/80
            mktime(0, 0, 0, 11,  2,  $data[2]), // Todos os santos - Lei nº 662, de 06/04/49
            mktime(0, 0, 0, 11, 15,  $data[2]), // Proclamação da republica - Lei nº 662, de 06/04/49
            mktime(0, 0, 0, 12, 25,  $data[2]), // Natal - Lei nº 662, de 06/04/49
        
            // These days have a date depending on easter
            mktime(0, 0, 0, $eastermonth, $easterday - 48,  $data[2]),//2ºferia Carnaval
            mktime(0, 0, 0, $eastermonth, $easterday - 47,  $data[2]),//3ºferia Carnaval	
            mktime(0, 0, 0, $eastermonth, $easterday - 2 ,  $data[2]),//6ºfeira Santa  
            mktime(0, 0, 0, $eastermonth, $easterday     ,  $data[2]),//Pascoa
            mktime(0, 0, 0, $eastermonth, $easterday + 60,  $data[2]),//Corpus Cirist
        );

        $daystoAdd=0;
        for($i = 0; $i < $dataUtil ;$i++){
            $day = mktime(0,0,0, $datamonth, $dataday+$i, $data[2]);
            $dayOfWeek = ''.date("l", $day);  
            if($dayOfWeek=="Sunday" || $dayOfWeek=="Saturday" || in_array($day, $feriados)){
                $daysToAdd++;
            };
            $daysToAdd++;

        };
        
        echo date('d/m/Y', mktime(0,0,0, $datamonth, $dataday+$daysToAdd, $data[2]));
    } else {
        echo "DATA OU DIAS ÚTEIS INVÁLIDOS";
    }
}

?>


</body>
</html>