import random
from faker import Faker

# Initialize Faker
fake = Faker()

# Sample Dorm_IDs assuming these are pre-existing in the Dorm table
dorm_ids = ["DORM0001", "DORM0002", "DORM0003", "DORM0004"]

# Assume each dormitory has 10 floors for simplicity
floors_per_dorm = 10
def generate_unique_room_id(dorm_id, existing_ids):
    while True:
        if dorm_id == "DORM0001":
            room_id = f"RM01{random.randint(0, 9)}{random.randint(0, 9)}"
        elif dorm_id == "DORM0002":
            room_id = f"RM02{random.randint(0, 9)}{random.randint(0, 9)}"
        elif dorm_id == "DORM0003":
            room_id = f"RM03{random.randint(0, 9)}{random.randint(0, 9)}"
        elif dorm_id == "DORM0004":
            room_id = f"RM04{random.randint(0, 9)}{random.randint(0, 9)}"
        
        if room_id not in existing_ids:
            return room_id
        
def generate_specific_rooms():
    specific_rooms = []
    existing_ids = set()

    for dorm_id in dorm_ids:
        for floor in range(1, floors_per_dorm + 1):
            floor_str = f"{floor:02d}"
    
            # Two bathrooms
            for suffix in [20, 21]:
                room_id = f"RM{dorm_id[-2:]}{floor_str}{suffix}"
                specific_rooms.append((room_id, 'Bathroom', 0, 0, 0.00, dorm_id))
                existing_ids.add(room_id)
            
            # One shower
            room_id = f"RM{dorm_id[-2:]}{floor_str}22"
            specific_rooms.append((room_id, 'Shower', 0, 0, 0.00, dorm_id))
            existing_ids.add(room_id)

            # One kitchen
            room_id = f"RM{dorm_id[-2:]}{floor_str}23"
            specific_rooms.append((room_id, 'Kitchen', 0, 0, 0.00, dorm_id))
            existing_ids.add(room_id)

    return specific_rooms

# Generate specific rooms
specific_rooms = generate_specific_rooms()

# Print data to the terminal
print("INSERT INTO Room (Room_ID, Room_Type, Number_Of_Bed, Current_Occupancy, Rent_Price, Dorm_ID) VALUES")

values = []
for record in specific_rooms:
    values.append(f"('{record[0]}', '{record[1]}', {record[2]}, {record[3]}, {record[4]}, '{record[5]}')")

print(",\n".join(values) + ";")