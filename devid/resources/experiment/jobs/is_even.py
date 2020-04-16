def is_divisible(number, divisor):
    return number % divisor == 0


def is_even(number):
    return is_divisible(number, 2)


print(is_even(63))
