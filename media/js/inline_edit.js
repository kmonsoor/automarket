

var FIELDS_TO_CHANGE = [
    'comment_supplier',
    'price_invoice',
    'part_number_superseded',
    'description_ru',

]

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
                jQuery('#status_input_' + id).val(response.value);
                jQuery('#status_input_' + id).attr('disabled',false)
                if (response.error) alert(response.value);
                close();
            }
        });

}



function OrderRowInline() {

    function init(backed_url, fields) {
        this.backend_url = backend_url;
    }

    function get_value(item_id, field_name) {
        var field_input_id =
    }

    function save(item_id, field_name) {
        value = $("")

    }

    function postSave(data) {
        alert(data);
    }
}

