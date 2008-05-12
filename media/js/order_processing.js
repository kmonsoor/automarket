var current = {'id':null,'type':null,'value':null,'canceled':false};
function save() {
    value = jQuery('#' + current.type + '_input_' + current.id).val();
    jQuery('#' + current.type + '_' + current.id).html('<img src="' + ajax_loader_img_path + '">')
    jQuery.ajax(
        {
            type: 'POST',
            url: '/cp/position/edit/' + current.id + '/',
            data: {
                    'type':current.type,
                    'value':value
                   },
            success: function(response) {
                r = eval('['+response+']');
                current.value = r[0]['value'];
                if (r[0]['error']) alert(r[0]['error']);
                close();
                
            }
        });
    
}

function close() {
    restore();
    if (current.type == 'part_number_superseded') {
        if (current.value.toString().length > 0) {
            editStatus(current.id, 'superseded');
        }
        else if (jQuery('#status_input_' + current.id).val() == 'superseded') {
            alert('Статус для этой позиции установлен как "Замена", однако поле "Superseded" не заполнено. Заполните это поле, или установите другой статус  для этой позиции');
        }
    } 
    if (current.type == 'quantity_ship') {
        jQuery('#quantity_backorder_' + current.id).html(parseInt(jQuery('#quantity_' + current.id).html()) - parseInt(jQuery('#quantity_ship_' + current.id).html()));
    }
    current = {'id':null,'type':null,'value':null};
}

function restore() {
    jQuery('#' + current.type + '_' + current.id).html(current.value);
    jQuery('#' + current.type + '_buttons_' + current.id).css("display","none");
}

function cancel() {
    restore();
    current = {'id':null,'type':null,'value':null,'canceled':true};
}

function return_check(id, type) {
    var _return = false;
    if (current.canceled) {
        current.canceled = false;
        _return = true;
    } 
    if (current.id == id && current.type == type) _return = true;
    
    return _return;
}

function editSuperseded(id) {
    if (return_check(id, 'part_number_superseded')) return;
    if (current.id) close();
    current.type = 'part_number_superseded'; 
    current.value = jQuery('#part_number_superseded_'+id).html();
    current.id = id;
    
    jQuery('#part_number_superseded_'+id).html('<input id="part_number_superseded_input_' + id + '" type="text" value="' + current.value + '">');
    jQuery('#part_number_superseded_buttons_'+id).css("display","inline");
    
}

function editPrice(id) {
    if (return_check(id, 'price')) return;
    if (current.id) close();
    current.type = 'price'; 
    current.value = jQuery('#price_'+id).html();
    current.id = id;
    
    jQuery('#price_'+id).html('<input id="price_input_' + id + '" type="text" value="' + current.value + '">');
    jQuery('#price_buttons_'+id).css("display","inline");
    
}

function editQuantityShip(id) {
    if (return_check(id, 'quantity_ship')) return;
    if (current.id) close();
    current.type = 'quantity_ship'; 
    current.value = jQuery('#quantity_ship_'+id).html();
    current.id = id;
    
    jQuery('#quantity_ship_'+id).html('<input id="quantity_ship_input_' + id + '" type="text" value="' + current.value + '">');
    jQuery('#quantity_ship_buttons_'+id).css("display","inline");
    
}

function editStatus(id, value) {
    if (value != 'superseded' && jQuery('#part_number_superseded_'+id).html() != '') {
        alert('Не забудьте про superseded');
    }
    if (value == 'superseded' && jQuery('#part_number_superseded_'+id).html() == '') {
        alert('Не забудьте про superseded');
    }
    if (value == 'superseded') {
        jQuery('#number_' + id).attr('class', 'cross_out');
    }
    else {
        jQuery('#number_' + id).attr('class', 'default');
    }
    jQuery('#status_input_' + id).attr('disabled',1)
    jQuery.ajax(
        {
            type: 'POST',
            url: '/cp/position/edit/' + id + '/',
            data: {
                    'type':'status',
                    'value':value
                   },
            success: function(response) {
                r = eval('['+response+']');
                jQuery('#status_input_' + id).val(r[0]['value']);
                jQuery('#status_input_' + id).attr('disabled',false)
                if (r[0]['error']) alert(r[0]['error']);
                close();
            }
        });
    
}