'''
Given an array a, your task is to output an array b of the same length by applying the following transformation: 
• For each i from 0 to a.length - 1 inclusive, b[i] = a[i - 1] + a[i] + a[i + 1]
• If an element in the sum a[i - 1] + a[i] + a[i + 1] does not exist, use 0 in its place
• For instance, b[0] = 0 + a[0] + a[1]
'''

def solution(a):
    n = len(a)
    b = [0 for _ in range(n)]
    for i in range(n):
        b[i] = a[i]
        if i > 0:
            b[i] += a[i - 1]
        if i < n - 1:
            b[i] += a[i + 1]
    return b


'''
For pattern = "010" and source = "amazing", the output should be solution(pattern, source) = 2.
• "010" matches source[0..2] = "ama". The pattern specifies "vowel, consonant, vowel". "ama"
matches this pattern: 0 matches a, 1 matches m, and 0 matches a. 
• "010" doesn’t match source[1..3] = "maz"
5
• "010" matches source[2..4] = "azi" 
• "010" doesn’t match source[3..5] = "zin" 
• "010" doesn’t match source[4..6] = "ing"
So, there are 2 matches. 
For pattern = "100" and source = "codesignal", the output should be solution(pattern, source) = 0.
• There are no double vowels in the string "codesignal", so it’s not possible for any of its substrings to
match this pattern.
'''

vowels = ['a', 'e', 'i', 'o', 'u', 'y'] 
 
def check_for_pattern(pattern, source, start_index):
    for offset in range(len(pattern)):
        if pattern[offset] == '0':
            if source[start_index + offset] not in vowels:
                return 0
        else:
            if source[start_index + offset] in vowels:
                return 0
    return 1

def solution(pattern, source):
    answer = 0
    for start_index in range(len(source) - len(pattern) + 1):
        answer += check_for_pattern(pattern, source, start_index)
    return answer


'''

'''

def solution(field, figure):
    height = len(field)
    width = len(field[0])
    figure_size = len(figure)

    for column in range(width - figure_size + 1):
        row = 1
        while row < height - figure_size + 1:
            can_fit = True
            for dx in range(figure_size):
                for dy in range(figure_size):
                    if field[row + dx][column + dy] == 1 and figure[dx][dy] == 1:
                        can_fit = False
            if not can_fit:
                break
            row += 1
        row -= 1

        for dx in range(figure_size):
            row_filled = True
            for column_index in range(width):
                if not (field[row + dx][column_index] == 1 or
                    (column <= column_index < column + figure_size and\
                    figure[dx][column_index - column] == 1)):
                    row_filled = False
                if row_filled:
                    return column
    return -1


from collections import defaultdict
  
def solution(numbers):
    counts = defaultdict(int)
    answer = 0
    for element in numbers:
        counts[element] += 1
    for two_power in range(21):
        second_element = (1 << two_power) - element
        answer += counts[second_element]
    return answer
