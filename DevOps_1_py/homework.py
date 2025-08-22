import random

def play_guessing_game():
    random_generated_number = random.randint(1, 100)
    ATTEMPTS = 5

    for local_attempt in range(ATTEMPTS):
        try:
            guess_number = int(input(f"Attempt {local_attempt + 1}/{ATTEMPTS}. Enter your guess: "))

            if guess_number == random_generated_number:
                print("Congratulations! You guessed the right number.")
                return
            elif guess_number < random_generated_number:
                print("Too low. Try a higher number.")
            else:
                print("Too high. Try a smaller number.")

        except ValueError:
            print("Invalid input. Please enter a number.")

    print(f"Sorry, you've run out of attempts. The correct number was {random_generated_number}.")

if __name__ == "__main__":
    play_guessing_game()
