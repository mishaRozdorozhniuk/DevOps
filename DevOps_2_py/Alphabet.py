class Alphabet:
    def __init__(self, lang, letters):
        self.lang = lang
        self.letters = letters

    def print(self):
        print(f"Alphabet letters: {self.letters}")

    def letters_num(self):
        return len(self.letters)

class EngAlphabet(Alphabet):
    _letters_num = 26

    def __init__(self):
        english_letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        super().__init__("En", english_letters)

    def is_en_letter(self, letter):
        return letter.upper() in self.letters

    def letters_num(self):
        return self._letters_num

    @staticmethod
    def example():
        return "The quick brown fox jumps over the lazy dog."

def run_simple_tests():
    eng_alphabet = EngAlphabet()
    print("EngAlphabet object created.")

    print("\nChecking the print() method:")
    eng_alphabet.print()

    print("\nChecking the number of letters:")
    num_letters = eng_alphabet.letters_num()
    print(f"Expected: 26, Got: {num_letters}")

    print("\nChecking for an English letter 'F':")
    is_f_letter = eng_alphabet.is_en_letter('F')
    print(f"Expected: True, Got: {is_f_letter}")

    print("\nChecking for a non-English letter 'Щ':")
    is_sch_letter = eng_alphabet.is_en_letter('Щ')
    print(f"Expected: False, Got: {is_sch_letter}")

    print("\nChecking the example text:")
    example_text = EngAlphabet.example()
    print(f"Example text: {example_text}")
    
if __name__ == "__main__":
    run_simple_tests()
