from BeautifulSoup import BeautifulSoup
import mechanize
import time
import urllib
import time
import os
import json
import psycopg2


conn = psycopg2.connect("dbname='automoto_new' user='ermol' host='localhost' password='ermol'")
conn.autocommit = True
cur = conn.cursor()


b = mechanize.Browser()
b.addheaders = [
    ("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"),
    ("Accept-Encoding", "gzip,deflate,sdch"),
    ("Accept-Language", "en-US,en;q=0.8,ru;q=0.6"),
    ("Cache-Control", "max-age=0"),
    ("Connection", "keep-alive"),
    ("Host", "empireauto.us"),
    ("User-Agent", "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100722 Firefox/3.6.8 GTB7.1 (.NET CLR 3.5.30729)"),
    ("Referer", "http://empireauto.us/PartsBrowser.aspx"),
]

r = b.open('http://empireauto.us/')

b.select_form(nr=0)
b['LoginCtrl$UserName'] = 'automototrade'
b['LoginCtrl$Password'] = 'automototrade1'
b.submit()

b.open("http://empireauto.us/PartsBrowser.aspx")

b.select_form(nr=0)
secret = b.form['__VIEWSTATE']


start_index = 217

for year in xrange(1930, 2015, 1):
    print '\n%r' % year

    p = {}
    p['ScriptManager1'] = 'UpdatePanel1|cboYear'
    p['__EVENTTARGET'] = 'cboYear'
    p['__EVENTARGUMENT'] = ''
    p['__LASTFOCUS'] = ''
    p['__VIEWSTATE'] = secret
    p['__VIEWSTATEENCRYPTED'] = ''
    p['cboFiltType'] = 2
    p['cboYear'] = year
    p['cboMakerModel'] = 0
    p['__ASYNCPOST'] = 'true'
    p[''] = ''
    b.open("http://empireauto.us/PartsBrowser.aspx", urllib.urlencode(p))

    resp = b.response().read()
    secret = resp.split('__VIEWSTATE')[1].split('|')[1]
    soup = BeautifulSoup(resp)
    options = soup.find('select', attrs={'name': 'cboMakerModel'}).findAll("option")

    for option in options[start_index:]:
        value = option.get('value')
        textvalue = option.text
        model = textvalue.split('(')[0].strip()
        maker = textvalue.split('(')[-1].split(')')[0].strip()
        print ' -- {0} {1}'.format(maker, model)
        p = {}
        p['cboYear'] = year
        p['cboMakerModel'] = value
        p['cboFiltType'] = 2
        p['ScriptManager1'] = 'UpdatePanel1|cboMakerModel'
        p['__ASYNCPOST'] = 'true'
        p['__EVENTTARGET'] = 'cboMakerModel'
        p['__VIEWSTATE'] = secret
        p['__VIEWSTATEENCRYPTED'] = ''
        p['__EVENTARGUMENT'] = ''
        p['__LASTFOCUS'] = ''
        p[''] = ''
        b.open("http://empireauto.us/PartsBrowser.aspx", urllib.urlencode(p))

        resp = b.response().read()
        secret = resp.split('__VIEWSTATE')[1].split('|')[1]

        soup = BeautifulSoup(resp)
        trs = soup.find('table', attrs={'id': 'grdItemsA'}).findAll('tr')

        for tr in trs[1:]:
            row = dict()
            fields = ('description', 'itemnumber', 'quality', 'listprice', 'yourprice', 'refoenumber')
            for k, td in zip(fields, tr.findAll('td')[1:7]):
                row[k] = td.text.split('&nbsp;')[0].strip()

                if k in ('listprice', 'yourprice',):
                    try:
                        row[k] = float(row[k])
                    except ValueError:
                        row[k] = None

                if k == 'description' and td:
                    for a in td.findAll('a'):
                        for img in a.findAll('img'):
                            onmouseover = dict(img.attrs).get('onmouseover')
                            if onmouseover:
                                url = onmouseover.split("event,'")[1].split("',")[0]
                                random = int(time.time())
                                b.open('http://empireauto.us/{0}&rndval={1}'.format(url.replace(' ', '%20'), random))
                                files = list()
                                for img2 in BeautifulSoup(b.response().read()).findAll('img'):
                                    src = dict(img2.attrs).get('src')
                                    if src:
                                        filename = src.split('ImageFile=')[1].split('&')[0]
                                        filedir = 'media/uploads/{0}/{1}/{2}'.format(year, maker, model)

                                        try:
                                            os.makedirs(filedir)
                                        except OSError:
                                            pass

                                        filepath = os.path.join(filedir, filename)
                                        src = src.replace('small', 'large').replace(' ', '%20')
                                        fd = open(filepath, 'wb+')
                                        fd.write(b.open('http://empireauto.us/{0}'.format(src)).read())
                                        fd.close()
                                        files.append(filepath)
                                row['images'] = json.dumps(files)

                    note = td.find('span')
                    if note:
                        onmouseover = dict(note.attrs).get('onmouseover')
                        url = onmouseover.split("event,'")[1].split("',")[0]
                        random = int(time.time())
                        b.open('http://empireauto.us/{0}&rndval={1}'.format(url.replace(' ', '%20'), random))
                        row['note'] = BeautifulSoup(b.response().read()).find('table').find('tr').find('td').find('span').text

                if k == 'refOE#' and dict(td.attrs).get('onmouseover'):
                    url = dict(td.attrs)['onmouseover'].split("event,'")[1].split("',")[0]
                    random = int(time.time())
                    b.open('http://empireauto.us/{0}&rndval={1}'.format(url.replace(' ', '%20'), random))
                    for tr2 in BeautifulSoup(b.response().read()).find('table').findAll('tr')[1:]:
                        d = list()
                        for field2, td2 in zip(('OEM #', 'Quantity', 'Description'), tr2.findAll('td')):
                            d.append((field2, td2.text.strip('&nbsp;').strip()))
                        row['assembly'] = json.dumps(d)

            row['year'] = year
            row['maker'] = maker
            row['model'] = model

            fields = (
                'year', 'maker', 'model', 'refoenumber', 'itemnumber', 'description',
                'quality', 'listprice', 'yourprice', 'images', 'note', 'assembly',)

            sql = """
            INSERT INTO common_bot2 (
                "year", "maker", "model", "refoenumber", "itemnumber", "description",
                "quality", "listprice", "yourprice", "images", "note", "assembly")
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            cur.execute(sql, tuple(row.get(f) for f in fields))
        time.sleep(0.3)
    start_index = 1
