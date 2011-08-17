
import os
import unittest
from common.views import PartSearch
from common.views import PartSearchAutopartspeople
from decimal import Decimal

class TestSearch(unittest.TestCase):

    def setUp(self):
        self.examples = [
            ('Mazda', 'ZZC0-27-238'),
            ('mazda', 'ZZCA-27-165'),
            ('Subaru', 'T3010YS010'),
            ('chrysler', '4892122AA'),
            ('chrysler', '5017921AA'),
            ('GM', '15285497'),
            ('GM', '15783970'),
            ('lexus', '53101-48271'),
            ('lexus', '87961-48520'),
        ]
        self.url = 'http://www.parts.com/oemcatalog/index.cfm?action=searchCatalogOEM'
        self.pns = PartSearch()

    def test_01_maker(self):
        assert "22" == self.pns.get_maker_id(self.examples[0][0]), \
            'Not equals %s,%s' % ("22",self.examples[0][0])
        assert "22" == self.pns.get_maker_id(self.examples[1][0]), \
            'Not equals %s,%s' % ("22",self.examples[1][0])
        assert None == self.pns.get_maker_id('qwefwefqwef')

    def test_02_response(self):
        ex = self.examples[0]
        maker_id = self.pns.get_maker_id(ex[0])
        response = self.pns.get_response(maker_id,ex[1])

        with open('common/tests/resp.txt','w') as a:
            a.write(response)

        assert "OEM Catalog" in response

    def test_03_parser_01(self):
        f = file('common/tests/resp.txt', 'r')
        response = f.read()
        f.close()
        res = self.pns.parse_response(response)

        assert res['partnumber'] != '', 'No part number'
        assert res['description'] != '', 'No description'
        assert res['MSRP'] == Decimal('17.15'), 'No MSRP'
        assert res['core_price'] == Decimal('0'), 'No core price'

    from common.views import PartSearchAutopartspeople

class PartswebsiteParserTest(unittest.TestCase):
    def setUp(self):
        pass

    def test_parse_response(self):
        response = """

		<tbody><tr>
			<td width="60%"><span class="vb10b">WIRE, CHANGE  [Part# 54310SCVA02]</span>
			<!--
				<a href="#" onmouseover="TagToTip('core_help', BALLOON, true, FADEIN, 400, FADEOUT, 400, ABOVE, true, WIDTH, 260, PADDING, 8, TEXTALIGN, 'justify', OFFSETX, -17)" onmouseout="UnTip()" style="text-decoration:none">
					<img src="/images/recycle.png" alt="Core Item" border="0" align="absmiddle">
				</a>
				<span id="core_help" style="display:none"><br><br>
				</span>
			-->
			</td>
			<td rowspan="5" valign="top" width="40%" align="right">
				<form name="partForm56431692" id="partForm56431692">
				<table border="0" cellpadding="3" cellspacing="0">
					<tbody><tr>
						<td class="vb10" align="right">
							<span class="vb10b">Quantity:</span>
							<input name="qty_56431692" id="qty_56431692" value="1" class="vb10" size="3" type="text">
						</td>
					</tr>
					<tr>
						<td class="vb10" align="center">
							<table border="0" cellpadding="1" cellspacing="0">
								<tbody><tr>
									<td>
										<span>
										<table border="0" cellpadding="2" cellspacing="0">
											<tbody><tr>
												<td style="cursor:pointer;color:#FFFFFF" onclick="window.location='https://www.partswebsite.com/autopartspeople/index.php?i=6&amp;type=parts&amp;key=&amp;action=additem&amp;o=56431692&amp;qty=' + document.getElementById('partForm56431692').qty_56431692.value + '&amp;modelyear=&amp;stop=rcmfkw69r6t858jzz36ad5204q&amp;price=72.86&amp;core_price=0&amp;rpage=#bottom'" align="center"><img src="../images/buynow.gif" border="0">
												</td>
												<td>&nbsp;</td>
												<td style="cursor:pointer;color:#FFFFFF" onclick="document.getElementById('ifr_neegex').src='https://www.partswebsite.com/autopartspeople/index.php?i=2&amp;key=&amp;action=additem1&amp;o=56431692&amp;qty=' + document.getElementById('partForm56431692').qty_56431692.value + '&amp;modelyear=year&amp;stop=rcmfkw69r6t858jzz36ad5204q&amp;price=72.86&amp;core_price=0&amp;rpage=0#bottom'" nowrap="nowrap" align="center"><img src="../images/add2cart.gif" border="0"></td>
											</tr>
										</tbody></table>
										</span>
										<span style="display:none">
										<table border="0" cellpadding="2" cellspacing="0">
											<tbody><tr>
												<td style="cursor:pointer;color:#FFFFFF" align="center"><a href="./index.php?i=5&amp;type=parts&amp;start=1"><img src="../images/contact_us.gif" border="0"></a>
												</td>
											</tr>
										</tbody></table>
										</span>
									</td>
								</tr>
							</tbody></table>
						</td>
					</tr>
				</tbody></table>
				</form>
			</td>
		</tr>
		<tr>
			<td><span class="vb10b">Honda</span></td>
		</tr>
		<tr style="display:none">
			<td><span class="vb10b">Price:</span><span class="vb10b">$91.07</span></td>
		</tr>
		<tr style="display:">
			<td>
				<span class="vb10b">List Price:</span><span style="text-decoration:line-through" class="vb10b">$91.07</span>
			</td>
		</tr>
		<tr style="display:">
			<td>
				<span class="vr11b">Your Price:</span><span class="vb10b">$72.86</span>
			</td>
		</tr>
		<!--
		<tr>
			<td>
				<span class="vr11b">Core Price:</span><span class="vb10b">0</span>
			</td>
		</tr>
		-->
	    </tbody>
        """

        p = os.path.dirname(os.path.abspath(__file__))

        with open(os.path.join(p, "search_response.html")) as f:
            response = f.read()
        ap = PartSearchAutopartspeople()
        data = ap.parse_response(response)

        self.assertEqual(data['MSRP'], 19.62)
        self.assertEqual(data['core'], None)
        self.assertEqual(data['description'], "SPRING SET(R),BRAKE  ")

