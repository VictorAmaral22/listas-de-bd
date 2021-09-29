<html>
<body>

<?php 

echo "<h3>Transcrição de Valor Monetário...</h3><br>";

if(!isset($_POST["valor"])){
    echo "VALOR NÃO INFORMADO";
} elseif(!preg_match("#^[0-9]{1,9},[0-9]{2}$#", $_POST["valor"])){
    echo "VALOR INVÁLIDO";
} else{
    $valor = $_POST["valor"];
    $numExt1 = array(
        0=>'',
        1=>'um',
        2=>'dois',
        3=>'três',
        4=>'quatro',
        5=>'cinco',
        6=>'seis',
        7=>'sete',
        8=>'oito',
        9=>'nove',
        10=>'dez',
        11=>'onze',
        12=>'doze',
        13=>'treze',
        14=>'quatorze',
        15=>'quinze',
        16=>'dezesseis',
        17=>'dezessete',
        18=>'dezoito',
        19=>'dezenove'
    );
    $numExt2 = array(
        2=>'vinte',
        3=>'trinta',
        4=>'quarenta',
        5=>'cinquenta',
        6=>'sessenta',
        7=>'setenta',
        8=>'oitenta',
        9=>'noventa'        
    );
    $numExt3 = array(
        1=>'cem',
        2=>'duzentos',
        3=>'trezentos',
        4=>'quatrocentos',
        5=>'quinhentos',
        6=>'seiscentos',
        7=>'setecentos',
        8=>'oitocentos',
        9=>'novecentos'        
    );

    // valor = valor.split(',');
    // if(valor[0].charAt(0) == '0' && valor[0].length > 1){
    //     console.log('Erro!');
    //     return null;
    // } else {
    //     if(valor[1] == '00' && parseInt(valor[0]) == 0){
    //         console.log('Erro!');
    //         return null;
    //     } else {
    //         console.log('Sucesso!');
    //         return true;
    //     }
    // } 
    echo 'R$ '.$valor.'<br>';
    $valor = explode(',', $valor);
    $text = '';
    $text2 = '';
    // if(valor[0].strpos('0') != -1)
    if(substr($valor[0], 0) == '0' && strlen($valor[0]) > 1){
        echo "VALOR INVÁLIDO";
    } elseif($valor[1] == '00' && (int)$valor[0] == 0) {
        echo "VALOR INVÁLIDO";       
    } else {
        $casasRe = strlen($valor[0]);        
        $casasCents = strlen($valor[1]);

        // CENTS
        if((int)$valor[1] != 0){
            if($valor[1][0] == '0'){
                $text = $text.$numExt1[(int)$valor[1][1]];
            } elseif((int)$valor[1] < 20) {
                $text = $text.$numExt1[(int)$valor[1]];
            } elseif($valor[1][1] == '0') {
                $text = $text.$numExt2[(int)$valor[1][0]];
            } else {
                $text = $text.$numExt2[(int)$valor[1][0]].' e '.$numExt1[(int)$valor[1][1]];
            }
        }

        // REAIS
        if($valor[0][0] != '0'){
            for($i = 0, $c = $casasRe; $i < $casasRe; $i++, $c--){
                // MILHÃO
                if($c == 9){
                    $text2 = $text2.$numExt3[(int)$valor[0][$i]];
                }
                if($c == 8){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i] < 2){
                                $text2 = $text2.' e '.$numExt1[(int)($valor[0][$i].$valor[0][$i+1])];
                            } else {
                                $text2 = $text2.' e '.$numExt2[(int)$valor[0][$i]];
                            }
                        }
                    } else {
                        if((int)$valor[0][$i] < 2){
                            $text2 = $text2.$numExt1[(int)($valor[0][$i].$valor[0][$i+1])];
                        } else {
                            $text2 = $text2.$numExt2[(int)$valor[0][$i]];
                        }
                    }
                }
                if($c == 7){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i-1] == 0){
                                $text2 = $text2.' e '.$numExt1[(int)$valor[0][$i]];
                            } elseif((int)$valor[0][$i-1] != 1) {
                                $text2 = $text2.' e '.$numExt1[(int)$valor[0][$i]];
                            }
                        }
                    } else {
                        $text2 = $text2.$numExt1[(int)$valor[0][$i]];
                    }                    
                    if((int)$valor[0][$i+1] == 0 && (int)$valor[0][$i+2] == 0 && (int)$valor[0][$i+3] == 0 && (int)$valor[0][$i+4] == 0 && (int)$valor[0][$i+5] == 0 && (int)$valor[0][$i+6] == 0 && (int)$valor[0][$i+7] == 0){
                        $text2 = $text2.' milhão(ões) de';
                    } else {
                        $text2 = $text2.' milhão(ões),';
                    }
                }
                // MILHAR
                if($c == 6){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i+1] != 0){
                                if((int)$valor[0][$i] == 1){
                                    $text2 = $text2.' cento';
                                } else {
                                    $text2 = $text2.' '.$numExt3[(int)$valor[0][$i]];
                                }
                            } else {
                                if((int)$valor[0][$i] == 1){
                                    $text2 = $text2.' e cem';
                                } else {
                                    $text2 = $text2.' e '.$numExt3[(int)$valor[0][$i]];
                                }
                            }
                        }
                    } else {
                        $text2 = $text2.$numExt3[(int)$valor[0][$i]];
                    }
                }
                if($c == 5){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i] < 2){
                                $text2 = $text2.' e '.$numExt1[(int)($valor[0][$i].$valor[0][$i+1])];
                            } else {
                                $text2 = $text2.' e '.$numExt2[(int)$valor[0][$i]];
                            }
                        }
                    } else {
                        if((int)$valor[0][$i] < 2){
                            $text2 = $text2.$numExt1[(int)($valor[0][$i].$valor[0][$i+1])];
                        } else {
                            $text2 = $text2.$numExt2[(int)$valor[0][$i]];
                        }
                    }
                }
                if($c == 4){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i-1] == 0){
                                $text2 = $text2.' e '.$numExt1[(int)$valor[0][$i]];
                            } elseif((int)$valor[0][$i-1] != 1) {
                                $text2 = $text2.' e '.$numExt1[(int)$valor[0][$i]];
                            }
                        }
                    } else {
                        if((int)$valor[0][$i] != 1){
                            $text2 = $text2.$numExt1[(int)$valor[0][$i]];
                        }
                    } 
                    
                    if((int)$valor[0][$i-1] != 0 && (int)$valor[0][$i+2] != 0 && (int)$valor[0][$i+3] != 0){
                        if((int)$valor[0][$i+1] == 0 && (int)$valor[0][$i+2] == 0 && (int)$valor[0][$i+3] == 0){
                            $text2 = $text2.' mil';
                        } else {
                            if((int)$valor[0][$i+1] == 0){
                                $text2 = $text2.' mil';
                            } else {
                                $text2 = $text2.' mil,';
                            }
                        }
                    } else {
                        if((int)$valor[0][$i+1] == 0 && (int)$valor[0][$i+2] == 0 && (int)$valor[0][$i+3] == 0){
                            $text2 = $text2.' mil';
                        } else {
                            if((int)$valor[0][$i+1] == 0){
                                $text2 = $text2.' mil';
                            } else {
                                $text2 = $text2.' mil,';
                            }
                        }
                    }
                }
                // CENTENA
                if($c == 3){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i+1] != 0){
                                if((int)$valor[0][$i] == 1){
                                    $text2 = $text2.' cento';
                                } else {
                                    $text2 = $text2.' '.$numExt3[(int)$valor[0][$i]];
                                }
                            } else {
                                if((int)$valor[0][$i] == 1){
                                    $text2 = $text2.' e cem';
                                } else {
                                    $text2 = $text2.' e '.$numExt3[(int)$valor[0][$i]];
                                }
                            }
                        }
                    } else {
                        $text2 = $text2.$numExt3[(int)$valor[0][$i]];
                    }
                }
                if($c == 2){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i] < 2){
                                $text2 = $text2.' e '.$numExt1[(int)($valor[0][$i].$valor[0][$i+1])];
                            } else {
                                $text2 = $text2.' e '.$numExt2[(int)$valor[0][$i]];
                            }
                        }
                    } else {
                        if((int)$valor[0][$i] < 2){
                            $text2 = $text2.$numExt1[(int)($valor[0][$i].$valor[0][$i+1])];
                        } else {
                            $text2 = $text2.$numExt2[(int)$valor[0][$i]];
                        }
                    }
                }
                if($c == 1){
                    if($i != 0){
                        if((int)$valor[0][$i] != 0){
                            if((int)$valor[0][$i-1] == 0){
                                $text2 = $text2.' e '.$numExt1[(int)$valor[0][$i]];
                            } elseif((int)$valor[0][$i-1] != 1) {
                                $text2 = $text2.' e '.$numExt1[(int)$valor[0][$i]];
                            }
                        }
                    } else {
                        if((int)$valor[0][$i-1] = 1){
                            $text2 = $text2.$numExt1[(int)$valor[0][$i]];
                        }
                    } 
                }
            }
        }
    }
    if($text2 == ''){
        echo 'Por extenso: '.$text.' centavo(s)';
    }
    elseif($text == ''){
        echo 'Por extenso: '.$text2.' real(ais)';        
    } else{
        echo 'Por extenso: '.$text2.' reais com '.$text.' centavo(s)';
    }
}

?>

</body>
</html>