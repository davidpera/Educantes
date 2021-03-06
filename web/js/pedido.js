$(document).ready(function(){
    if (sessionStorage.length !== 0) {
        $('li[id='+sessionStorage.getItem('id')+']').find('a').trigger('click');
    }
    eventoPestanas();
    eventoPedido();
    eventoPedidoMultiple();
});

function eventoPedidoMultiple(){
    $('#pedidoMult').on('click', function(){
        var le = (window.screen.width/2)-150;
        var to = (window.screen.height/2)-250;
        var options = "width=400px, height=500px,top="+to+",left="+le+", menubar=no, resizable=no,scrollbars=yes";
        var nueva = window.open('/js/ventana.html','Pedido',options);
    });
}
function eventoPestanas(){
    $('.pestañas').on('click', function(){
        sessionStorage.setItem('id', $(this).attr('id'));
    });
}

function eventoPedido(){
    $('.pedido').on('click',function(){
        var id  =  $(this).attr('id');
        var boton = $(this);
        $.ajax({
            url: urlCantidad,
            type: 'GET',
            data: {'id':id},
            success: function(data){
                var input = '<div class="pedido-container"><input type="number" id="'+id+'" value="1" min="1" max="'+data+'">'+
                '<button class="btn-success glyphicon glyphicon-ok aceptar-pedido"></button>'+
                '<button class="btn-danger glyphicon glyphicon-remove cancelar-pedido"></div>'
                boton.parent('td').append(input);
                boton.hide();
                $('.aceptar-pedido').on('click', function(){
                    var cantidadPedida = $('input[id='+id+']').val();
                    $.ajax({
                        url: urlPedido,
                        type: 'GET',
                        data: {'id':id, 'cantidadPedida':cantidadPedida},
                        success: function(data) {
                            console.log(data);
                            window.location.href="/index.php/uniformes%2Findex";
                        }
                    });
                });
                $('.cancelar-pedido').on('click', function(){
                    $(this).closest('.pedido-container').parent('td').children('button').show();
                    $(this).closest('.pedido-container').remove();
                });
            },
        });
    });
}
