def is_divisible(number, divisor):
    return number % divisor == 0


def is_prime(number):
    if number > 1:
        for i in range(2, number):
            if is_divisible(number, i):
                return False

        return True
    else:
        return False


print(is_prime(11))
