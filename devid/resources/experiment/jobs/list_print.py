# Write a function that takes a list of strings an prints them, one per line, in a rectangular frame. For example the list ["Hello", "World", "in", "a", "frame"] gets printed as:
#
# *********
# * Hello *
# * World *
# * in    *
# * a     *
# * frame *
# *********

def find_longest_length(list):
    length = 0

    for item in list:
        if len(item) > length:
            length = len(item)

    return length


def print_star_line(frame_size):
    str = ""
    for i in range(0, frame_size):
        str += "*"

    return str + "\n"

def print_string_line(frame_size, string):
    str = "* " + string
    for i in range(len(string) + 2, frame_size - 2):
        str += " "

    return str + " *\n"

def frame_print(list):
    length = find_longest_length(list)
    frame_size = length + 4
    frame_length = len(list) + 2

    str = ""

    for i in range(0, frame_length):
        if i == 0 or i == frame_length - 1:
            str += print_star_line(frame_size)
        else:
            str += print_string_line(frame_size, list[i - 1])

    return str


input1 = ["Hello", "World", "in", "a", "frame"]
input2 = ["", ""]
input3 = ["a", "b", "c"]
print(frame_print(input1))
