import random
import string
from faker import Faker
import os

# Initialize Faker
fake = Faker()

# Function to generate unique Provider ID
def generate_unique_provider_id(existing_ids):
    while True:
        provider_id = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
        if provider_id not in existing_ids:
            existing_ids.add(provider_id)
            return provider_id

def generate_unique_phone_number(existing_phone_numbers):
    while True:
        phone_number = f"09{random.randint(0, 9)}-{random.randint(100, 999)}-{random.randint(1000, 9999)}"
        if phone_number not in existing_phone_numbers:
            existing_phone_numbers.add(phone_number)
            return phone_number
# Function to generate Provider data
def generate_provider_data(num_records):
    provider_data = []
    existing_ids = set()  # To store unique provider IDs
    existing_phone_numbers = set()
    for _ in range(num_records):
        provider_id = generate_unique_provider_id(existing_ids)
        provider_name = fake.company()
        provider_address = fake.address().replace('\n', ', ')
        provider_phone_number = generate_unique_phone_number(existing_phone_numbers)
        provider_email = fake.email()
        
        provider_data.append((provider_id, provider_name, provider_address, provider_phone_number, provider_email))
    
    return provider_data

# Generate provider data
num_records = 200  # Number of provider records to generate
provider_data = generate_provider_data(num_records)

# Define the file path
file_path = os.path.join("sql", "data", "provider_data.sql")

# Write data to the file
with open(file_path, 'w') as file:
    file.write("INSERT INTO Provider (Provider_ID, Provider_Name, Provider_Address, Provider_Phone_Number, Provider_Email) VALUES\n")
    for record in provider_data:
        file.write(f"('{record[0]}', '{record[1]}', '{record[2]}', '{record[3]}', '{record[4]}'),\n")

# Append semicolon to the last line
with open(file_path, 'rb+') as file:
    file.seek(-2, os.SEEK_END)
    file.truncate()
    file.write(b';')

print(f"Provider data written to {file_path}")
