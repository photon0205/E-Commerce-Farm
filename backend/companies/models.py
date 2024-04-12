from accounts.models import User
from django.db import models

class Company(models.Model):
    name = models.CharField(max_length=100)
    ceo = models.ForeignKey(User, on_delete=models.CASCADE, related_name='companies')

    def __str__(self):
        return self.name

class Store(models.Model):
    name = models.CharField(max_length=100)
    company = models.ForeignKey(Company, on_delete=models.CASCADE, related_name='stores')
    manager = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='stores',
        limit_choices_to={'role': 'STORE_MANAGER'}
    )
    longitude = models.FloatField(blank=True, null=True)
    latitude = models.FloatField(blank=True, null=True)

    def __str__(self):
        return self.name

class Product(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    
    def __str__(self):
        return self.name

class Inventory(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='inventory')
    store = models.ForeignKey(Store, on_delete=models.CASCADE, related_name='inventory')
    quantity = models.IntegerField()

    def __str__(self):
        return f"{self.product.name} - {self.store.name}"