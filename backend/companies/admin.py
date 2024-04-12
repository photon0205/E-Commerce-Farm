from django.contrib import admin
from .models import Company, Store, Product, Inventory

# Register your models here.
admin.site.register(Company)
admin.site.register(Store)
admin.site.register(Product)
admin.site.register(Inventory)
