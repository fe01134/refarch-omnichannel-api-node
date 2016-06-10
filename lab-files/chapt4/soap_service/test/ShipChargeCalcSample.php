<?php
/**
 * @license MIT
 *
 * Please see the LICENSE file distributed with this source code for further
 * information regarding copyright and licensing.
 *
 */

require_once __DIR__ . '/bootstrap.php';

const GEO = array (
					'New York' => '10161',
					'Boston' => '02241',
					'Chicago' => '60657',
					'Miami' => '33193',
					'Las Vegas' => '89130',
					'Trenton' => '08648',
					'Austin' => '78764'
				);

$client = new nusoap_client("http://localhost:8000/ShipChargeCalc.php/shipcharge?wsdl", true);
$error = $client->getError();
if ($error) {
	echo "Constructor error" . $error;
}

$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['Trenton'],
							"from" => array(GEO['New York'])
						)
					);
echo "New York --> Trenton: $charge\n";


$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['New York'],
							"from" => array(GEO['Boston'])
						)
					);
echo "Boston --> New York: $charge\n";

$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['Miami'],
							"from" => array(GEO['Boston'])
						)
					);
echo "Boston --> Miami: $charge\n";

$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['Chicago'],
							"from" => array(GEO['Austin'])
						)
					);
echo "Austin --> Chicago: $charge\n";

$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['Las Vegas'],
							"from" => array(GEO['Las Vegas'])
						)
					);
echo "Las Vegas --> Las Vegas: $charge\n";

$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['Austin'],
							"from" => array(GEO['Boston'])
						)
					);
echo "Boston --> Austin: $charge\n";

$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['Boston'],
							"from" => array(GEO['Austin'])
						)
					);
echo "Austin --> Boston: $charge\n";

$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['Boston'],
							"from" => array(GEO['Austin'], GEO['Chicago'], GEO['Miami'])
						)
					);
echo "Austin, Chicago or Miami --> Boston: $charge\n";


