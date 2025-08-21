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

def main():
    eng_alphabet = EngAlphabet()

    eng_alphabet.print()

    print(f"Number of letters: {eng_alphabet.letters_num()}")

    print(f"'F' belongs to English alphabet: {eng_alphabet.is_en_letter('F')}")

    print(f"'Щ' belongs to English alphabet: {eng_alphabet.is_en_letter('Щ')}")

    print(f"Example text: {EngAlphabet.example()}")

if __name__ == "__main__":
    main()
