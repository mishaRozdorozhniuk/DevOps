#!/bin/bash

MAX_ATTEMPTS=5
ATTEMPTS=0
RANDOM_RANGE=100
SECRET_NUMBER=$((1 + RANDOM % RANDOM_RANGE))

echo "Вітаю в грі 'Вгадай число'!"
echo "Я загадав число від 1 до $RANDOM_RANGE."
echo "У вас є $MAX_ATTEMPTS спроб."

while [[ $ATTEMPTS -lt $MAX_ATTEMPTS ]]; do
    ATTEMPTS=$((ATTEMPTS + 1))

    echo -n "Спроба #$ATTEMPTS: Введіть ваше припущення: "
    read USER_GUESS

    if ! [[ "$USER_GUESS" =~ ^[0-9]+$ ]]; then
        echo "Помилка: Будь ласка, введіть дійсне число."
        ATTEMPTS=$((ATTEMPTS - 1))
        continue
    fi

    if [[ "$USER_GUESS" -eq "$SECRET_NUMBER" ]]; then
        echo "Вітаємо! Ви вгадали правильне число ($SECRET_NUMBER) за $ATTEMPTS спроб."
        exit 0
    elif [[ "$USER_GUESS" -lt "$SECRET_NUMBER" ]]; then
        echo "Занадто низько!"
    else
        echo "Занадто високо!"
    fi
done

echo "Вибачте, у вас закінчилися спроби. Правильним числом було $SECRET_NUMBER."
exit 1
