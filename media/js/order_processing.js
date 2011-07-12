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
                current.previous_value = current.value;
                current.value = response.value;
				setDisplayValue();
                if (response.error) {alert(response.error);}
            }
        });
	postSave();
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

    // get calculated values from the server
    FIELDS = ['price_base', 'price_sale', 'price_discount',
              'delivery', 'cost', 'total_cost']
    jQuery.ajax({
        url: '/cp/ordered_item/' + current.id + '/',
        data: {'fields': FIELDS.join(',')},
        dataType: 'json',
        success: function(data) {
            for (i in FIELDS) {
                field_name = FIELDS[i];
                if (data[field_name] == null || data[field_name] == 0) {
                    value = '';
                } else {
                    value = data[field_name];
                }
                jQuery("#" + field_name + "_display_" + current.id).html(value);
            }
            close();
        }
    });
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

function editPartNumber(id) {
    if (return_check(id, 'part_number')) return;
    if (current.id) close();
    current.type = 'part_number';
    current.value = jQuery('#part_number_'+id).html();
	current.display_value = jQuery('#part_number_display_'+id).html();
    current.id = id;

    jQuery('#part_number_display_'+id).html('<input id="part_number_input_' + id + '" type="text" value="' + current.value + '">');
    jQuery('#part_number_buttons_'+id).css("display","inline");

}

function editPriceBase(id) {
    if (return_check(id, 'price_base')) return;
    if (current.id) close();
    current.type = 'price_base';
    current.value = jQuery('#price_base_'+id).html();
	current.display_value = jQuery('#price_base_display_'+id).html();
    current.id = id;

    jQuery('#price_base_display_'+id).html('<input id="price_base_input_' + id + '" type="text" value="' + current.value + '">');
    jQuery('#price_base_buttons_'+id).css("display","inline");

}

function editWeight(id) {
    if (return_check(id, 'weight')) return;
    if (current.id) close();
    current.type = 'weight';
    current.value = jQuery('#weight_'+id).html();
	current.display_value = jQuery('#weight_display_'+id).html();
    current.id = id;

    jQuery('#weight_display_'+id).html('<input id="weight_input_' + id + '" type="text" value="' + current.value + '">');
    jQuery('#weight_buttons_'+id).css("display","inline");

}

function editPriceDiscount(id) {
    if (return_check(id, 'price_discount')) return;
    if (current.id) close();
    current.type = 'price_discount';
    current.value = jQuery('#price_discount_'+id).html();
	current.display_value = jQuery('#price_discount_display_'+id).html();
    current.id = id;

    jQuery('#price_discount_display_'+id).html('<input id="price_discount_input_' + id + '" type="text" value="' + current.value + '">');
    jQuery('#price_discount_buttons_'+id).css("display","inline");

}

function editPriceInvoice(id) {
    if (return_check(id, 'price_invoice')) return;
    if (current.id) close();
    current.type = 'price_invoice';
    current.value = jQuery('#price_invoice_'+id).html();
	current.display_value = jQuery('#price_invoice_display_'+id).html();
    current.id = id;

    jQuery('#price_invoice_display_'+id).html('<input id="price_invoice_input_' + id + '" type="text" value="' + current.value + '">');
    jQuery('#price_invoice_buttons_'+id).css("display","inline");
}

function editCommentSupplier(id) {
    if (return_check(id, 'comment_supplier')) return;
    if (current.id) close();
    current.type = 'comment_supplier';
    current.value = jQuery('#comment_supplier_'+id).html();
	current.display_value = jQuery('#comment_supplier_display_'+id).html();
    current.id = id;

    jQuery('#comment_supplier_display_'+id).html('<textarea id="comment_supplier_input_' + id + '">'+ current.value +'</textarea>');
    jQuery('#comment_supplier_buttons_'+id).css("display","inline");

}

function editDescriptionRu(id) {
    if (return_check(id, 'description_ru')) return;
    if (current.id) close();
    current.type = 'description_ru';
    current.value = jQuery('#description_ru_'+id).html();
	current.display_value = jQuery('#description_ru_display_'+id).html();
    current.id = id;

    jQuery('#description_ru_display_'+id).html('<textarea id="description_ru_input_' + id + '">'+ current.value +'</textarea>');
    jQuery('#description_ru_buttons_'+id).css("display","inline");

}

function editInvoiceCode(id) {
    if (return_check(id, 'invoice_code')) return;
    if (current.id) close();
    current.type = 'invoice_code';
    current.value = jQuery('#invoice_code_'+id).html();
	current.display_value = jQuery('#invoice_code_display_'+id).html();
    current.id = id;

    jQuery('#invoice_code_display_'+id).html('<input type="text" id="invoice_code_input_' + id + '" value="'+ current.value +'">');
    jQuery('#invoice_code_buttons_'+id).css("display","inline");

}


function editDescriptionEn(id) {
    if (return_check(id, 'description_en')) return;
    if (current.id) close();
    current.type = 'description_en';
    current.value = jQuery('#description_en_'+id).html();
	current.display_value = jQuery('#description_en_display_'+id).html();
    current.id = id;

    jQuery('#description_en_display_'+id).html('<textarea id="description_en_input_' + id + '">'+ current.value +'</textarea>');
    jQuery('#description_en_buttons_'+id).css("display","inline");

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
	        jQuery('#part_number_display_' + id).attr('class', 'cross_out');
	    }
	    else {
	        jQuery('#part_number_display_' + id).attr('class', 'default');
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
                jQuery('#status_input_' + id).val(response.value);
                jQuery('#status_input_' + id).attr('disabled',false)
                if (response.error) alert(response.value);
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

