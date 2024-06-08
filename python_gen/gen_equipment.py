import random
import string
from faker import Faker
import os

# Initialize Faker
fake = Faker()

# List of common dormitory, kitchen, and bathroom equipment names
equipment_names = [
    # Dormitory Items
    "Desk", "Chair", "Lamp", "Bookshelf", "Bed", "Mattress", "Dresser", "Closet", 
    "Mini Fridge", "Microwave", "Toaster", "Coffee Maker", "Kettle", "Fan", "Heater", 
    "Air Conditioner", "Curtains", "Rug", "Laundry Basket", "Trash Can", "Study Table", 
    "Sofa", "Television", "Printer", "Blender", "Rice Cooker", "Hot Plate", "Iron", 
    "Ironing Board", "Sewing Kit", "Tool Kit", "Vacuum Cleaner", "Broom", "Mop", 
    "First Aid Kit", "Alarm Clock", "Hangers", "Wall Art", "Mirror", "Extension Cord",
    
    # Kitchen Items
    "Pan", "Pot", "Spatula", "Cutting Board", "Knife Set", "Dish Rack", "Dish Soap", 
    "Sponge", "Kitchen Towels", "Measuring Cups", "Measuring Spoons", "Mixing Bowls", 
    "Colander", "Can Opener", "Bottle Opener", "Oven Mitts", "Tupperware", "Silverware",
    "Plates", "Bowls", "Cups", "Glasses", "Serving Spoons", "Whisk", "Rolling Pin", 
    "Peeler", "Garlic Press", "Grater", "Salad Spinner",
    
    # Bathroom Items
    "Showerhead", "Shower Curtain", "Bath Mat", "Toilet", "Toilet Brush", "Toilet Paper Holder", 
    "Toilet Paper", "Sink", "Vanity Mirror", "Towel Rack", "Towels", "Hand Towels", 
    "Washcloths", "Soap Dispenser", "Shampoo", "Conditioner", "Body Wash", "Toothbrush Holder", 
    "Toothpaste", "Mouthwash", "Dental Floss", "Shower Caddy", "Plunger", "Bathrobe", 
    "Shower Cap", "Hair Dryer"
]

# Function to generate unique Equipment ID
def generate_unique_equipment_id(existing_ids, name):
    while True:
        random_suffix = ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))
        equipment_id = name[:2].upper() + random_suffix
        if equipment_id not in existing_ids:
            existing_ids.add(equipment_id)
            return equipment_id

# Function to generate Equipment data
def generate_equipment_data(equipment_names):
    equipment_data = []
    existing_ids = set()  # To store unique equipment IDs
    
    for name in equipment_names:
        equipment_id = generate_unique_equipment_id(existing_ids, name[:2].upper())
        equipment_quantity = random.randint(500, 550 )
 
        
        equipment_data.append((equipment_id, name, equipment_quantity))
    
    return equipment_data

# Generate equipment data
equipment_data = generate_equipment_data(equipment_names)

# Define the file path
file_path = os.path.join("sql", "data", "equipment_data.sql")

# Write data to the file
with open(file_path, 'w') as file:
    file.write("INSERT INTO Equipment (Equipment_ID, Equipment_Name, Equipment_Quantity) VALUES\n")
    for record in equipment_data:
        file.write(f"('{record[0]}', '{record[1]}', {record[2]}),\n")

# Append semicolon to the last line
with open(file_path, 'rb+') as file:
    file.seek(-2, os.SEEK_END)
    file.truncate()
    file.write(b';')

print(f"Equipment data written to {file_path}")
