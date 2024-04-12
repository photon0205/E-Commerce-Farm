from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Company, Store, Inventory, Product
from .serializers import ProductSerializer, StoreSerializer, InventorySerializer
from accounts.models import User

class AllStoresOfCompany(APIView):
    def get(self, request, company_id):
        try:
            company = Company.objects.get(id=company_id)
            stores = Store.objects.filter(company=company)
            serializer = StoreSerializer(stores, many=True)
            return Response(serializer.data)
        except Company.DoesNotExist:
            return Response({"message": "Company not found"}, status=status.HTTP_404_NOT_FOUND)

class UpdateStoreManager(APIView):
    def put(self, request, store_id):
        try:
            store = Store.objects.get(id=store_id)
            new_manager_id = request.data.get('manager_id')
            new_manager, created = User.objects.get_or_create(id=new_manager_id, defaults={'password': User.objects.make_random_password()})
            if created:
                new_manager.save()
            store.manager = new_manager
            store.save()
            return Response({"message": "Store manager updated successfully", "new_manager_password": new_manager.password}, status=status.HTTP_200_OK)
        except Store.DoesNotExist:
            return Response({"message": "Store not found"}, status=status.HTTP_404_NOT_FOUND)
        except User.DoesNotExist:
            return Response({"message": "Manager not found"}, status=status.HTTP_404_NOT_FOUND)

class StoreInventory(APIView):
    def get(self, request, store_id):
        try:
            store = Store.objects.get(id=store_id)
            inventory = Inventory.objects.filter(store=store)
            serializer = InventorySerializer(inventory, many=True)
            return Response(serializer.data)
        except Store.DoesNotExist:
            return Response({"message": "Store not found"}, status=status.HTTP_404_NOT_FOUND)

class AddRemoveInventory(APIView):
    def put(self, request, store_id):
        try:
            store = Store.objects.get(id=store_id)
            product_id = request.data.get('product_id')
            quantity = int(request.data.get('quantity', 0))
            action = request.data.get('action')
            product = Product.objects.get(id=product_id)
            
            inventory, created = Inventory.objects.get_or_create(store=store, product=product)
            
            if action == 'add':
                inventory.quantity += quantity
            elif action == 'remove':
                inventory.quantity -= quantity
                
            inventory.save()
            
            return Response({"message": "Inventory updated successfully"}, status=status.HTTP_200_OK)
        except Store.DoesNotExist:
            return Response({"message": "Store not found"}, status=status.HTTP_404_NOT_FOUND)
        except Product.DoesNotExist:
            return Response({"message": "Product not found"}, status=status.HTTP_404_NOT_FOUND)

class AllStoresSortedByLocation(APIView):
    def get(self, request):
        try:
            latitude = float(request.query_params.get('latitude'))
            longitude = float(request.query_params.get('longitude'))
            stores = Store.objects.all().order_by('latitude', 'longitude')
            serializer = StoreSerializer(stores, many=True)
            return Response(serializer.data)
        except ValueError:
            return Response({"message": "Invalid latitude or longitude"}, status=status.HTTP_400_BAD_REQUEST)

class SearchProductByName(APIView):
    def get(self, request):
        product_name = request.query_params.get('name', '')
        products = Product.objects.filter(name__icontains=product_name)
        serializer = ProductSerializer(products, many=True)

        return Response(serializer.data)
