var array = [
    ['cpf'], 
    ['data', 'dataUtil'],
    ['valor'],
    ['op1','selectOp','op2']];

function valid(value) {
    var errors = 0;
    console.log('Valores de '+array[value-1]);
    for(let i=0; i < array[value-1].length ;i++){
        let input = document.getElementById(array[value-1][i]);
        let regExp = new RegExp(input.pattern);
        if(regExp.test(input.value)){
            if(i == (array[value-1].length-1) && errors == 0){
                console.log('Sucesso!');
                document.getElementById('form'+value).submit();
            }
        } else {
            console.log('Erro em '+input.id+': '+input.value);
            input.value = '';
            input.classList.add('erro');
            errors++;
        }
    }
}

function unSetError(value){
    let input = document.getElementById(value);
    input.classList.remove('erro');
}