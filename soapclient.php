<?php

class RetrySoapClient extends SoapClient {
    public function __call($function_name, $arguments) {
        $result = false;
        $max_retries = 5;
        $retry_count = 0;
        while(!$result && $retry_count < $max_retries) {
            try {
                $result = parent::__call($function_name, $arguments);
            } catch(SoapFault $fault) {
                if($fault->faultstring != 'Could not connect to host') {
                    throw $fault;
                }
            }
            sleep(1);
            $retry_count ++;
        }
        if($retry_count == $max_retries) {
            throw new SoapFault('Could not connect to host after 5 attempts');
        }
        return $result;
    }
}


function get_client() {
    return new RetrySoapClient("http://automototrade.com/wsdl/server.php?wsdl", 
         array('encoding'=>'cp1251','connection_timeout' => 3));    
}


define("LOGIN", 'SP');
define("PASSWD",'newmotors');

function utf2cp($utf_string) {
    return iconv('utf8','windows-1251', $utf_string);
}

function cp2utf($cp_string) {
    return iconv('windows-1251', 'utf8', $cp_string);
}

function to_json($var) {
    return json_encode($var);
}

function from_json($json_string) {
    return json_decode($json_string, true);
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


function callMethod($func_name, $args_array) {
    $client = get_client();
    $response = $client->__call($func_name, $args_array);
    return to_json($response);
}


$avalible_methods = array("getPartsStatus", "getOrderStatus", "getInvoiceList", 
"getInvoiceDetails", "insertBasket", "sendOrder", "setOrderParam");

$function_name = $argv[1];
if(!in_array($function_name, $avalible_methods)) {
    print "";
    exit();
}
$_args = array_slice($argv, 2);
$args = array();
if($_args) {
    foreach($_args as $a)
    $args[] = from_json($a);
}
//echo callMethod($function_name, $args);
$stdout = fopen('php://stdout', 'w');
fputs($stdout,"Hello World");
exit();
?>
