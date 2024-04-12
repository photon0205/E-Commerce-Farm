from django.urls import path
from . import views

app_name = 'orders'

urlpatterns = [
    path('orders/', views.OrderListCreateView.as_view(), name='order-list-create'),
    path('orders/<int:pk>/', views.OrderRetrieveUpdateDestroyView.as_view(), name='order-detail'),
    path('order-items/', views.OrderItemListCreateView.as_view(), name='order-item-list-create'),
    path('order-items/<int:pk>/', views.OrderItemRetrieveUpdateDestroyView.as_view(), name='order-item-detail'),
]