from rest_framework import serializers
from django.contrib.auth import get_user_model
from companies.models import Company, Store

User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    company_name = serializers.CharField(max_length=100, required=False)
    store_name = serializers.CharField(max_length=100, required=False)

    class Meta:
        model = User
        fields = ['username', 'password', 'email', 'name', 'role', 'company_name', 'store_name']

    def validate(self, data):
        role = data.get('role')
        company_name = data.get('company_name')
        store_name = data.get('store_name')

        if role == 'CEO' and not company_name:
            raise serializers.ValidationError("Company name is required for CEO role")

        if role == 'STORE_MANAGER' and not store_name:
            raise serializers.ValidationError("Store name is required for STORE_MANAGER role")

        return data

    def create(self, validated_data):
        company_name = validated_data.pop('company_name', None)
        store_name = validated_data.pop('store_name', None)
        user = super().create(validated_data)
        
        if user.role == 'CEO' and company_name:
            company, created = Company.objects.get_or_create(name=company_name, ceo=user)
            company.save()

        if user.role == 'STORE_MANAGER' and store_name:
            company = Company.objects.filter(name=company_name).first()
            store, created = Store.objects.get_or_create(name=store_name, company=company, manager=user)
            store.save()

        return user

class UserLoginSerializer(serializers.Serializer):
    username = serializers.CharField(max_length=150)
    password = serializers.CharField(max_length=128, write_only=True)
