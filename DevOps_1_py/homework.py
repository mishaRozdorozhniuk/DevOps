import random

random_generated_number = random.randint(0, 100)
ATTEMPTS = 5
local_attempt = 0

while local_attempt < ATTEMPTS:
    guess_number = int(input(f"Attempt {local_attempt + 1}/{ATTEMPTS}. Enter your guess: "))

    if guess_number == random_generated_number:
        print("Congratulations")
        break
    elif guess_number < random_generated_number:
        print("try higher")
    else:
        print("try smaller")

    local_attempt += 1
else:
    print(f"Sorry, you've used all attempts. The number was {random_generated_number}")
