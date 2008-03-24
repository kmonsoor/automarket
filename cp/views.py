from django.contrib.auth.decorators import login_required
from lib.decorators import render_to
from lib.paginator import SimplePaginator

from data.models import OrderedItem

@login_required
@render_to('cp/index.html')
def index(request):
    current_page = request.GET.get('page', 1)
    paginator = SimplePaginator(OrderedItem.objects.all(), 25, '?page=%s')
    paginator.set_page(current_page)
    items = paginator.get_page();
    return {'items':items,'paginator':paginator}