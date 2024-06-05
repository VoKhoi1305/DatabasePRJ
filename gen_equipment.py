import random
import string
import os.path
from faker import Faker

# Initialize Faker
fake = Faker()

# Function to generate unique Equipment ID
def generate_unique_equipment_id(existing_ids, name):
    while True:
        random_suffix = ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))
        equipment_id = name[:2] + random_suffix
        if equipment_id not in existing_ids:
            existing_ids.add(equipment_id)
            return equipment_id

# Function to generate Equipment data
def generate_equipment_data(num_records):
    equipment_data = []
    existing_ids = set()  # To store unique equipment IDs
    
    for _ in range(num_records):
        equipment_name = fake.company()  # Using company names for equipment names
        equipment_id = generate_unique_equipment_id(existing_ids, equipment_name[:2].upper())
        equipment_quantity = random.randint(1, 100)
        equipment_status = fake.sentence()
        
        equipment_data.append((equipment_id, equipment_name, equipment_quantity, equipment_status))
    
    return equipment_data

# Generate equipment data
num_records = 100  # Number of equipment records to generate
equipment_data = generate_equipment_data(num_records)

# Write data to a file
filename = "equipment_data.sql"
with open(filename, 'w') as file:
    file.write("INSERT INTO Equipment (Equipment_ID, Equipment_Name, Equipment_Quantity, Equipment_Status) VALUES\n")
    for record in equipment_data:
        file.write(f"('{record[0]}', '{record[1]}', {record[2]}, '{record[3]}'),\n")

# Append semicolon to the last line
with open(filename, 'rb+') as file:
    file.seek(-2, os.SEEK_END)
    file.truncate()

print(f"Equipment data written to {filename}")
