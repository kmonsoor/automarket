from django import http
#import sre
from apps.legacysupport.models import Url

class ZapDotHtmlMiddleware(object):
    """Removes trailing .htm and .html extensions from incoming URLs
    (GETs only) so that a legacy site ported to Django can continue to
    support existing bookmarks. Locate in settings.MIDDLEWARE_CLASSES near
    CommonMiddleware (similar middleware stack location requirements)."""
    # Dave Rowell, Appropriate Solutions, Inc., www.appropriatesolutions.com

    def __init__(self):
        # RE match for .htm or .html at the end of the url, possibly
        # followed by /, but not including it. Compile once, use many.
        #self.re_trim_html = sre.compile(r'\.html?(?=/?$)', sre.IGNORECASE)
        pass

    def process_request(self, request):
        """ Rewrite incoming URL if it contains an htm or html extension."""
        if request.method == 'GET':
            #Excise any .html ending.
            try:
                url=Url.objects.get(taxonomy=request.path)
            except:
                url=None
            if url is None:
                try:
                    url=Url.objects.get(taxonomy_alias=request.path)
                except:
                    url=None
            
            if url is not None:
                new_path=url.new_url
                
                host = http.get_host(request)
                if host:
                    newurl = "%s://%s%s" % (request.is_secure() and 'https' or 'http', host, new_path)
                else:
                    newurl = new_path
                    
                urlencode = request.GET.urlencode()
                if len(urlencode):
                    newurl += '?' + urlencode
                return http.HttpResponsePermanentRedirect(newurl)            
        return None
