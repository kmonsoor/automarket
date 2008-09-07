var current = null;
var backend_url = null;

function setDefaultCurrent() {
	current = {
        'id':null,
        'type':null,
        'value':null,
        'previous_value':null, 
        'dict':null, 
        'display_value':null, 
        'canceled':false,
        'in_process':false
        };	
}
setDefaultCurrent();

function showCurrent() {
	var a = '';
	for (i in current) {
		a += '\n' + i + ': ' + current[i];
	}
	alert(a);
}

function save() {
    var value = jQuery('#' + current.type + '_input_' + current.id).val();
    jQuery('#' + current.type + '_display_' + current.id).html('<img src="' + ajax_loader_img_path + '">');
	current.in_process = true;
    jQuery.ajax(
        {
            type: 'POST',
            url: backend_url + current.id + '/',
            data: {
                    'type':current.type,
                    'value':value
                   },
            success: function(response) {
                r = eval('['+response+']');
                current.previous_value = current.value;
                current.value = r[0]['value'];
				setDisplayValue();
                if (r[0]['error']) alert(r[0]['error']);
				postSave();
                close();
                
            }
        });
    
}

function setDisplayValue() {
	if (current.dict) {
		for (i in current.dict) {
			if (current.dict[i].id == current.value) {
				current.display_value = current.dict[i].name;
				break;
			}
		}
	}
	else {
		current.display_value = current.value;
	}
}

function close() {
    restore();  
    setDefaultCurrent();
}

function postSave() {
	if (current.type == 'part_number_superseded') {
        if (current.value.toString().length > 0) {
            editStatus(current.id, 'superseded');
        }
    }
    if (current.type == 'brand') {
        editStatus(current.id, 'superseded');
    } 
    if (current.type == 'price') {
        if (current.value) {
            editStatus(current.id, 'on_stock');
        }
        else {
            if (current.previous_value) {
                editStatus(current.id, '_return_');
            }
            current.display_value = 'Price';
        }
    }
}

function restore() {
    jQuery('#' + current.type + '_' + current.id).html(current.value);
	jQuery('#' + current.type + '_display_' + current.id).html(current.display_value);
    jQuery('#' + current.type + '_buttons_' + current.id).css("display","none");
	current.in_process = false;
}

function cancel() {
    restore();
	setDefaultCurrent();
    current.canceled = true;
}

function return_check(id, type) {
    var _return = false;
    if (current.canceled) {
        current.canceled = false;
        _return = true;
    } 
	if (current.in_process) {
		current.in_process = false;
		restore();
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
	current.display_value = jQuery('#part_number_superseded_display_'+id).html();
    current.id = id;
    
    jQuery('#part_number_superseded_display_'+id).html('<input id="part_number_superseded_input_' + id + '" type="text" value="' + current.value + '">');
    jQuery('#part_number_superseded_buttons_'+id).css("display","inline");
    
}

function editBrand(id) {
    if (return_check(id, 'brand')) return;
    if (current.id) close();
    current.type = 'brand'; 
	current.dict = brands;	
    current.value = jQuery('#brand_'+id).html();
	current.display_value = jQuery('#brand_display_'+id).html();
	var html = '<select id="brand_input_' + id + '" onchange="save()">';
	for (i in brands) {
		var brand = brands[i];
		html += '<option value="' + brand.id + '"';
        if (brand.id == current.value) {
			html += ' selected';
		}
		html += '>' + brand.name + '</option>';
    }
	html += '</select>';
    current.id = id;

    jQuery('#brand_display_'+id).html(html);
    
}


function editPrice(id) {
    if (return_check(id, 'price')) return;
    if (current.id) close();
    current.type = 'price'; 
    current.value = jQuery('#price_'+id).html();
	current.display_value = jQuery('#price_display_'+id).html();
    current.id = id;
    
    jQuery('#price_display_'+id).html('<input id="price_input_' + id + '" type="text" value="' + current.value + '">');
    jQuery('#price_buttons_'+id).css("display","inline");
    
}

function editQuantityShip(id) {
    if (return_check(id, 'quantity_ship')) return;
    if (current.id) close();
    current.type = 'quantity_ship'; 
    current.value = jQuery('#quantity_ship_'+id).html();
	current.display_value = jQuery('#quantity_ship_display_'+id).html();
    current.id = id;
    
    jQuery('#quantity_ship_display_'+id).html('<input id="quantity_ship_input_' + id + '" type="text" value="' + current.value + '">');
    jQuery('#quantity_ship_buttons_'+id).css("display","inline");
    
}

function editStatus(id, value) {
	if (caller == 'index') {
	    if (value == 'superseded') {
	        jQuery('#number_' + id).attr('class', 'cross_out');
	    }
	    else {
	        jQuery('#number_' + id).attr('class', 'default');
	    }
	}
    jQuery('#status_input_' + id).attr('disabled',1)
    jQuery.ajax(
        {
            type: 'POST',
            url: backend_url + id + '/',
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


function editPlacesNum(id) {
	if (return_check(id, 'places_num')) return;
    if (current.id) close();
    current.type = 'places_num'; 
    current.value = jQuery('#places_num_'+id).html();
    current.display_value = jQuery('#places_num_display_'+id).html();
    current.id = id;
    jQuery('#places_num_display_'+id).html('<input id="places_num_input_' + id + '" type="text" value="' + current.value + '">');
	jQuery('#places_num_buttons_'+id).css("display","block");
}

function editWeightKg(id) {
	if (return_check(id, 'weight_kg')) return;
    if (current.id) close();
    current.type = 'weight_kg'; 
    current.value = jQuery('#weight_kg_'+id).html();
    current.display_value = jQuery('#weight_kg_display_'+id).html();
    current.id = id;
    jQuery('#weight_kg_display_'+id).html('<input id="weight_kg_input_' + id + '" type="text" value="' + current.value + '">');
    jQuery('#weight_kg_buttons_'+id).css("display","block");
}

function editShippingCost(id) {
	if (return_check(id, 'shipping_cost')) return;
    if (current.id) close();
    current.type = 'shipping_cost'; 
    current.value = jQuery('#shipping_cost_'+id).html();
    current.display_value = jQuery('#shipping_cost_display_'+id).html();
    current.id = id;
    jQuery('#shipping_cost_display_'+id).html('<input id="shipping_cost_input_' + id + '" type="text" value="' + current.value + '">');
    jQuery('#shipping_cost_buttons_'+id).css("display","block");
}

function editQuantity(id) {
    if (return_check(id, 'quantity')) return;
    if (current.id) close();
    current.type = 'quantity'; 
    current.value = jQuery('#quantity_'+id).html();
    current.display_value = jQuery('#quantity_display_'+id).html();
    current.id = id;
    
    jQuery('#quantity_display_'+id).html('<input id="quantity_input_' + id + '" type="text" value="' + current.value + '">');
    jQuery('#quantity_buttons_'+id).css("display","inline");
    
}
