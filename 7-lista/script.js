// FORMS
var array = [
    ['cpf'], 
    ['data', 'dataUtil'],
    ['valor'],
    ['op1','selectOp','op2'],
    ['romanoOp1', 'selectRom1', 'romanoOp2']
];

// VALIDAÇÃO GERAL
function valid(value) {
    var errors = 0;
    function invalid(input, errors){
        console.log('Erro em '+input.id+': '+input.value);
        input.value = '';
        input.classList.add('erro');
        errors++;
    }
    
    for(let i = 0, countRoman = 0; i <= array[value-1].length-1 ; i++){
        let input = document.getElementById(array[value-1][i]);
        if(value != 5){
            input.value = input.value.toLowerCase();
        }
        let regExp = new RegExp(input.pattern);
        if(regExp.test(input.value)){
            if(errors == 0){
                // VALIDANDO EXERCICIO 1
                if(value == 1){
                    console.log('Exercício 1');
                    var ok = validateCpf();
                    if(ok){
                        console.log('Sucesso!');
                        if(i == array[value-1].length-1){
                            document.getElementById('form'+value).submit();
                        }
                    } else {
                        invalid(input, errors);
                    }
                }
                
                // VALIDANDO EXERCICIO 2
                if(value == 2){   
                    var ok = dataValida(i);
                    if(ok){
                        console.log('Sucesso!');
                        if(i == array[value-1].length-1){
                            document.getElementById('form'+value).submit();
                        }
                    } else {
                        invalid(input, errors);
                    }
                }

                // VALIDANDO EXERCICIO 3
                if(value == 3){
                    var ok = validateMoney();
                    if(ok){
                        if(i == array[value-1].length-1){
                            document.getElementById('form'+value).submit();
                        }
                    } else {
                        invalid(input, errors);
                    }
                }

                // VALIDANDO EXERCICIO 4
                if(value == 4){
                    var ok = numExtValid(i);
                    if(ok){
                        // console.log('Sucesso!');
                        if(i == array[value-1].length-1){
                            document.getElementById('form'+value).submit();
                        }
                    } else {
                        invalid(input, errors);
                    }
                }
                
                // VALIDANDO EXERCICIO 5
                if(value == 5){
                    var regExp2 = new RegExp('^(selectRom)');
                    if(regExp2.test(array[4][i])){
                        countRoman++;
                        var ok = validRoman(i, countRoman);
                        if(ok){
                            console.log('Sucesso!');
                            if(i == array[value-1].length-1){
                                document.getElementById('form'+value).submit();
                            }
                        } else {
                            invalid(input, errors);
                        }
                    }
                }
            }
        } else {
            invalid(input, errors);
        }
    }
}

function unSetError(value){
    let input = document.getElementById(value);
    input.classList.remove('erro');
}

// EXRC 1
function validateCpf(){
    var invalidCPF = ['11111111111','22222222222','33333333333','44444444444','55555555555','66666666666','77777777777','88888888888','99999999999','00000000000','12345678912'];
    var cpf = document.getElementById('cpf').value;
    console.log('Validando CPF: '+cpf);
    if(invalidCPF.includes(cpf)){
        console.log('CPF inválido!')
        return null;
    } else{
        cpf = cpf.split('');
        var calculo = 0;
        let i = 10;
        cpf.forEach(element => {
            if(i>=2){
                calculo += element*i;
                i--;
            }
        });
        var calculo2 = 0;
        if((calculo*10)%11 == cpf[cpf.length-2]){
            let i = 11;
            cpf.forEach(element => {
                if(i>=2){
                    calculo2 += element*i;
                    i--;
                }
            });
        } else {
            console.log('CPF inválido!');
            return null
        }
        if((calculo2*10)%11 ==  cpf[cpf.length-1]){
            console.log('CPF válido!');
            return true;
        } else {
            console.log('CPF inválido!');
            return null;
        }
    }    
}

// EXRC 2
function dataValida(value){
    if(value == 0){
        // DATA
        var data = document.getElementById('data').value.split('/');
        parseInt(data[0]);
        parseInt(data[1]);
        parseInt(data[2]);
        console.log('Data: '+data);

        function leapYear(year){
            return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
        }
        var meses = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        var mesesBi = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        
        if(data[2] != 0 && data[1] != 0 && data[0] != 0){
            if(data[1] >= 1 && data[1] <= 12){
                var bi = leapYear(data[2]);
                if(bi){
                    // é bissexto
                    console.log('Bissexto');
                    if((data[0] >= 1) && (data[0] <= mesesBi[data[1]-1])){
                        console.log('Ok!');
                        return true;
                    } else {
                        console.log('Erro!');
                        return null;
                    }
                } else {
                    // não é bissexto
                    console.log('Não bissexto');
                    if((data[0] >= 1) && (data[0] <= meses[data[1]-1])){
                        console.log('Ok!');
                        return true;                
                    } else {
                        console.log('Erro!');
                        return null;
                    }
                }                
            }
        } else {
            console.log('Erro!');
            return null;
        }
    } 
    if(value == 1) {
        // DIA UTIL
        var dataUtil = document.getElementById('dataUtil').value;
        dataUtil = parseInt(dataUtil);
        var regExp = new RegExp('^[1-9]+$');
        if(regExp.test(dataUtil) && (Math.sign(dataUtil) != -1)){
            if(dataUtil !== 0){
                console.log('Sucesso!');
                return true;
            } else {
                console.log('Erro: É zero');
                return null;
            }
        } else {
            console.log('Erro: n inteiro ou negativo');
            return null;
        }
    }
    
}

// EXRC 3
function validateMoney(){
    var valor = document.getElementById('valor').value;
    console.log(valor);
    valor = valor.split(',');
    if(valor[0].charAt(0) == '0' && valor[0].length > 1){
        console.log('Erro!');
        return null;
    } else {
        if(valor[1] == '00' && parseInt(valor[0]) == 0){
            console.log('Erro!');
            return null;
        } else {
            console.log('Sucesso!');
            return true;
        }
    }   
}

// EXRC 4
function numExtValid(index){
    function checkNumber(value){
        var numExt = [
            ['um','dois','três','quatro','cinco','seis','sete','oito','nove','dez','onze','doze','treze','quatorze','quinze','dezesseis','dezessete','dezoito','dezenove'], 
            ['vinte','trinta','quarenta','cinquenta','sessenta','setenta','oitenta','noventa'], 
            ['cem','cento','duzentos','trezentos','quatrocentos','quinhentos','seiscentos','setecentos','oitocentos','novecentos']
        ];
        var regExp = new RegExp('^(ce(nto|m)|duzentos|trezentos|quatrocentos|quinhentos|seiscentos|setecentos|oitocentos|novecentos){0,1}( e ){0,1}(vinte|trinta|quarenta|cinquenta|sessenta|setenta|oitenta|noventa){0,1}( e ){0,1}(um|dois|três|quatro|cinco|seis|sete|oito|nove|dez|onze|doze|treze|quatorze|catorze|quinze|dezesseis|dezessete|dezoito|dezenove){0,1}( milh(ão|ões) | milh(ão|ões) e | milh(ão|ões)$){0,1}(ce(m|nto)|duzentos|trezentos|quatrocentos|quinhentos|seiscentos|setecentos|oitocentos|novecentos){0,1}( e ){0,1}(vinte|trinta|quarenta|cinquenta|sessenta|setenta|oitenta|noventa){0,1}( e ){0,1}(um|dois|três|quatro|cinco|seis|sete|oito|nove|dez|onze|doze|treze|quatorze|catorze|quinze|dezesseis|dezessete|dezoito|dezenove){0,1}(mil |mil e | mil | mil e | mil$){0,1}(ce(m|nto)|duzentos|trezentos|quatrocentos|quinhentos|seiscentos|setecentos|oitocentos|novecentos){0,1}( | e |$){0,1}(vinte|trinta|quarenta|cinquenta|sessenta|setenta|oitenta|noventa){0,1}( | e |$){0,1}(um|dois|três|quatro|cinco|seis|sete|oito|nove|dez|onze|doze|treze|quatorze|catorze|quinze|dezesseis|dezessete|dezoito|dezenove){0,1}$');

        if(regExp.test(value)){
            var num = value.split(' ');
            if(num.indexOf('') != -1){
                return false;              
            } else {
                var erroMilhao = 0;
                var regExp1 = new RegExp(' mil | mil$');
                var regExp2 = new RegExp(' milhão| milhões');
                var mil = '', milhao = '', centena = '';

                if(regExp1.test(value) && regExp2.test(value)){
                    centena = value.slice(value.search(regExp1)+5);
                    mil = value.slice(value.search(regExp2)+8, value.search(regExp1));
                    milhao = value.slice(0, value.search(regExp2));
                    if(milhao == 'um' && value.indexOf('milhões') != -1){
                        erroMilhao++;
                    } 
                    if(milhao != 'um' && value.indexOf('milhão') != -1){
                        erroMilhao++;
                    }
                } 
                if(!regExp1.test(value) && regExp2.test(value)){
                    centena = value.slice(value.search(regExp2)+8);
                    milhao = value.slice(0, value.search(regExp2));
                    if(milhao == 'um' && value.indexOf('milhões') != -1){
                        console.log('aqui?');
                        erroMilhao++;
                    } 
                    if(milhao != 'um' && value.indexOf('milhão') != -1){
                        erroMilhao++;
                    }
                }
                if(regExp1.test(value) && !regExp2.test(value)){
                    centena = value.slice(value.search(regExp1)+5);
                    mil = value.slice(0, value.search(regExp1));
                }
                if(!regExp1.test(value) && !regExp2.test(value)){
                    centena = value;
                }

                if(erroMilhao != 0){
                    return false;
                }

                centena = centena.trim();
                mil = mil.trim();
                milhao = milhao.trim();
                function casasOk(){
                    var regExp = new RegExp('^(e )?(ce(nto|m)|duzentos|trezentos|quatrocentos|quinhentos|seiscentos|setecentos|oitocentos|novecentos){0,1}( e ){0,1}(vinte|trinta|quarenta|cinquenta|sessenta|setenta|oitenta|noventa){0,1}( e ){0,1}(um|dois|três|quatro|cinco|seis|sete|oito|nove|dez|onze|doze|treze|quatorze|catorze|quinze|dezesseis|dezessete|dezoito|dezenove){0,1}$');
                    var erro = 0;
                    if(centena != ''){
                        // console.log('Centena: '+centena);
                        if(!regExp.test(centena)) erro++;
                    }
                    if(mil != ''){
                        // console.log('Mil: '+mil);
                        if(!regExp.test(mil)) erro++;
                    };
                    if(milhao != ''){
                        // console.log('Milhão: '+milhao);
                        if(!regExp.test(milhao)) erro++;
                    };
                    return erro == 0 ? true : false;
                }
                var ok = casasOk();
                if(ok){
                    function incongr(array){
                        var erro = 0;
                        for (let i = 0; i <= array.length-1; i++) {
                            if(array[i] != 'e'){
                                if(numExt[1].includes(array[i])){
                                    var c = array[i+1] ? (array[i+1] == 'e' ? (array[i+2] ? 2 : false) : 1) : false;
                                    if(c && array[i+c]){
                                        if(numExt[0].indexOf(array[i+c]) > 8){
                                            erro++;
                                        }
                                    }
                                }
                                if(numExt[2].includes(array[i])){
                                    var c = array[i+1] ? (array[i+1] == 'e' ? (array[i+2] ? true : false) : false) : false;
                                    if(c && array[i] == 'cem') erro++;
                                    if(!c && array[i] == 'cento') erro++;
                                }
                            }                            
                        }
                        return erro === 0 ? true : false;
                    }
                    var erro = 0;
                    if(centena != ''){
                        centena = centena.split(' ');
                        console.log('Centena: '+centena);
                        if(mil != '' || milhao != ''){
                            if(centena.length <= 2 && centena[0] != 'e') erro++;
                            if(centena.length > 2 && centena[0] == 'e') erro++;
                        }
                        !incongr(centena) ? erro++ : "";
                    }
                    if(mil != ''){
                        mil = mil.split(' ');
                        console.log('Mil: '+mil);
                        if(milhao != ''){
                            if(mil.length <= 2 && mil[0] != 'e') erro++;
                            if(mil.length > 2 && mil[0] == 'e') erro++;
                        }
                        !incongr(mil) ? erro++ : "";
                    };
                    if(milhao != ''){
                        milhao = milhao.split(' ');
                        console.log('Milhão: '+milhao);
                        !incongr(milhao) ? erro++ : "";
                    };
                    
                    return erro === 0 ? true : false;
                } else {
                    return false;
                }
            }
        } else {
            return false;
        }
    }

    // OPERDADOR 1
    if(index == 0){
        var op1 = document.getElementById('op1').value;
        op1 = op1.toLowerCase();
        if(checkNumber(op1)){
            // console.log('Sucesso!');
            return true;
        } else {
            console.log('Erro: operador 1 inválido!');
            return null;
        }
    }
    // OPERAÇÃO
    if(index == 1){
        var selectOp = document.getElementById('selectOp').value;
        const operations = ['mais', 'menos', 'mult', 'divd'];
        if(operations.includes(selectOp)){
            console.log('Operação válida!');
            return true;
        } else {
            console.log('Operação inválida!');
            return null;
        }
    }
    // OPERDADOR 2
    if(index == 2){
        var op2 = document.getElementById('op2').value;
        op2 = op2.toLowerCase();
        if(checkNumber(op2)){
            // console.log('Sucesso!');
            return true;
        } else {
            console.log('Erro: operador 2 inválido!');
            return null;
        }
    }
}

// EXRC 5
var numero = 2;
function insere() {
    numero++;
    // var table = document.getElementById("tableAddRomanos");
    var row = document.getElementById("rowRoman");
    if (numero <= 10) {
        row.insertCell(-1).innerHTML =  `
        <td> 
            <select name='selectRom${numero-1}' id='selectRom${numero-1}'> 
                <option value='mais'>+</option> 
                <option value='menos'>-</option>
                <option value='mult'>x</option> 
                <option value='divd'>/</option> 
            </select> 
        </td>`;
        row.insertCell(-1).innerHTML = `
        <td> 
            <input id='romanoOp${numero}' name='romanoOp${numero}' type='int' pattern='^M{0,3}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$' placeholder='Digite um número em romano...' required onclick="unSetError('romanoOp${numero}')"> 
        </td>`;
        row.insertCell(-1).innerHTML = `
        <td> 
            <input type='button' id='adiciona' value='+' style='width: 20px;' onclick='insere()'> 
        </td>`;
        
        array[4][array[4].length] = 'selectRom'+(numero-1);        
        array[4][array[4].length] = 'romanoOp'+numero;
        console.log(array[4]);
    }
}
function validRoman(index, c){
    var input;
    input = document.getElementById('selectRom'+(c));
    var operations = ['mais', 'menos', 'mult', 'divd'];
    if(operations.includes(input.value)){
        return true;
    } else {
        return false;
    }
}

