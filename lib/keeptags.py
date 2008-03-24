import re

from BeautifulSoup import BeautifulSoup
from django.utils.html import strip_tags, escape
from django.conf import settings



def keeptags(value, tags=None):
    """
    Strips all [X]HTML tags except the space seperated list of tags 
    from the output.
    
    Usage: keeptags:"strong em ul li"
    """
    if not tags:
        tags = settings.LEAVE_HTML_TAGS
    tags = [re.escape(tag) for tag in tags.split()]
    tags_re = '(%s)' % '|'.join(tags)
    singletag_re = re.compile(r'<(%s\s*/?)>' % tags_re)
    starttag_re = re.compile(r'<(%s)(\s+[^>]+)>' % tags_re)
    endtag_re = re.compile(r'<(/%s)>' % tags_re)
    value = singletag_re.sub('##~~~\g<1>~~~##', value)
    value = starttag_re.sub('##~~~\g<1>\g<3>~~~##', value)
    value = endtag_re.sub('##~~~\g<1>~~~##', value)
    value = strip_tags(value)

    recreate_re = re.compile('##~~~([^~]+)~~~##')
    value = recreate_re.sub('<\g<1>>', value)
    return value


def clear_html(html_string, custom_tags=None):

    # Clear and well form HTML
    soup = BeautifulSoup(html_string)
    
    def remove(tag):
        contents = tag.contents
        parent = tag.parent
        tag.extract()
        for tag in contents:
            parent.append(tag)
    
    for tag in soup.findAll():
        if custom_tags:
            leave_tags = custom_tags
        else:
            leave_tags = settings.LEAVE_CONTENT_HTML_TAGS
        if tag.name in leave_tags:
            remove(tag)
        else:
            try:
                del(tag['style'])
                del(tag['class'])
            except:
                pass
    new_html = soup.prettify()
    del(soup)
    # Delete tags
    return keeptags(new_html)
    
    