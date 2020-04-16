def append_words_starting_with_u(words, return_list=[]):
    u_words = [word for word in words if word.startswith('u')]
    return_list += u_words
    return return_list


print(append_words_starting_with_u(['tribler', 'user']))
# should print ['user']

print(append_words_starting_with_u(['universe', 'sandbox'], ['sun']))
# should print ['sun', 'universe']

print(append_words_starting_with_u(['unity']))
# should print ['unity'], but it returns ['user', 'unity']
