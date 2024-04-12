from django.urls import path
from . import views

urlpatterns = [
    path('companies/<int:company_id>/stores/', views.AllStoresOfCompany.as_view(), name='all-stores-of-company'),
    path('stores/<int:store_id>/update-manager/', views.UpdateStoreManager.as_view(), name='update-store-manager'),
    path('stores/<int:store_id>/inventory/', views.StoreInventory.as_view(), name='store-inventory'),
    path('stores/<int:store_id>/inventory/update/', views.AddRemoveInventory.as_view(), name='add-remove-inventory'),
    path('stores/sorted/', views.AllStoresSortedByLocation.as_view(), name='all-stores-sorted-by-location'),
]
