import random
# Sample Dorm_IDs assuming these are pre-existing in the Dorm table
dorm_ids = ["DORM0001", "DORM0002", "DORM0003", "DORM0004"]

# Function to generate Room data
def generate_room_data():
    room_data = []

    for dorm_id in dorm_ids:
        for floor in range(1, 10):  # Floors from 1 to 9
            for room_number in range(1, 20):  # Room numbers from 1 to 19
                room_id = f"RM{dorm_id[-2:]}{floor:02d}{room_number:02d}"
                room_type = random.choice(['Male', 'Female'])
                number_of_bed = random.randint(2, 4)
                current_occupancy = random.randint(0, number_of_bed)
                
                # Set rent price based on the number of beds
                if number_of_bed == 2:
                    rent_price = 200.00
                elif number_of_bed == 3:
                    rent_price = 150.00
                else:  # number_of_bed == 4
                    rent_price = 125.00
                
                room_data.append((room_id, room_type, number_of_bed, current_occupancy, rent_price, dorm_id))
    
    return room_data

# Generate room data
room_data = generate_room_data()

# Write data to a file
filename = "room_data.sql"
with open(filename, 'w') as file:
    file.write("INSERT INTO Room (Room_ID, Room_Type, Number_Of_Bed, Current_Occupancy, Rent_Price, Dorm_ID) VALUES\n")
    for record in room_data:
        file.write(f"('{record[0]}', '{record[1]}', {record[2]}, {record[3]}, {record[4]}, '{record[5]}'),\n")

# Append semicolon to the last line
with open(filename, 'rb+') as file:
    file.seek(-2, os.SEEK_END)
    file.truncate()

print(f"Data written to {filename}")
