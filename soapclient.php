<?php

function get_client() {
    return new SoapClient("http://automototrade.com/wsdl/server.php?wsdl", 
         array('encoding'=>'cp1251','connection_timeout' => 3));    
}


define("LOGIN", 'SP');
define("PASSWD",'newmotors');

function utf2cp($utf_string) {
    return iconv('utf8','windows-1251', $utf_string);
}

function to_json($var) {
    return json_encode($var);
}

function from_json($json_string) {
    return json_decode($json_string);
}

function getInvoiceList() {
    $client = get_client();
    $UserParam = array('login'=>LOGIN,'passwd'=>PASSWD);
    $InvoiceList = $client->getInvoiceList($UserParam);
    if ($InvoiceList) {
        return to_json($InvoiceList);    
    } else {
        return to_json(array());
    }
      
}

func_map = array(
    'getInvoiceList' => getInvoiceList,
);

print(getopts);
print_r($_SERVER);
// print(getInvoiceList());
?>
