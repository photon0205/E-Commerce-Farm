from rest_framework import serializers
from .models import Product, Store, Inventory
from accounts.serializers import UserSerializer


class InventorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Inventory
        fields = ("id", "product", "quantity")


class StoreSerializer(serializers.ModelSerializer):
    manager = UserSerializer()
    inventory = InventorySerializer(many=True, read_only=True)

    class Meta:
        model = Store
        fields = (
            "id",
            "name",
            "company",
            "manager",
            "longitude",
            "latitude",
            "inventory",
        )

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = '__all__'