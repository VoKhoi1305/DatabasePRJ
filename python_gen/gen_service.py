import random
import string
from faker import Faker
import os

# Initialize Faker
fake = Faker()

# Updated list of dormitory-related services
service_names = [
    "Gym", "Cafeteria", "Laundry", "WiFi", "Housekeeping", "Maintenance", 
    "Study Room", "Recreation Room", "Security", "Parking", "Transport Service", 
    "Event Hall", "Library", "Health Center", "Counseling Services", "Vending Machines", 
    "Computer Lab", "Printing Services", "Bike Rental", "Movie Room", "Game Room", 
    "Art Studio", "Music Room", "Swimming Pool", "Cooking Classes", "Fitness Classes", 
    "Meditation Room", "Garden", "BBQ Area"
]

# Function to generate unique Service ID
def generate_unique_service_id(existing_ids):
    while True:
        service_id = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
        if service_id not in existing_ids:
            existing_ids.add(service_id)
            return service_id

# Function to generate Service data
def generate_service_data(provider_ids, num_records):
    service_data = []
    existing_ids = set()  # To store unique service IDs
    
    for _ in range(num_records):
        service_id = generate_unique_service_id(existing_ids)
        provider_id = random.choice(provider_ids)
        service_name = random.choice(service_names)
        service_price = round(random.uniform(5, 500), 2)
        service_description = fake.text()
        
        service_data.append((service_id, provider_id, service_name, service_price, service_description))
    
    return service_data

# Assuming provider_data is already generated
provider_file_path = os.path.join("sql", "data", "provider_data.sql")

# Extract Provider IDs from the provider data file
provider_ids = []
with open(provider_file_path, 'r') as file:
    for line in file:
        if line.startswith("INSERT INTO Provider"):
            continue
        if line.strip() == ";":
            break
        provider_id = line.split(',')[0].strip("('")
        provider_ids.append(provider_id)

# Generate service data
num_records = 200  # Number of service records to generate
service_data = generate_service_data(provider_ids, num_records)

# Define the file path
file_path = os.path.join("sql", "data", "service_data.sql")

# Write data to the file
with open(file_path, 'w') as file:
    file.write("INSERT INTO Service (Service_ID, Provider_ID, Service_Name, Service_Price, Service_Description) VALUES\n")
    for record in service_data:
        file.write(f"('{record[0]}', '{record[1]}', '{record[2]}', {record[3]}, '{record[4]}'),\n")

# Append semicolon to the last line
with open(file_path, 'rb+') as file:
    file.seek(-2, os.SEEK_END)
    file.truncate()
    file.write(b';')

print(f"Service data written to {file_path}")
