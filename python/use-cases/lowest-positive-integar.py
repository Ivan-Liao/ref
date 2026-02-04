Write a function:

def solution(A)
content_copy

that, given an array A of N integers, returns the smallest positive integer (greater than 0) that does not occur in A.

For example, given A = [1, 3, 6, 4, 1, 2], the function should return 5.

Given A = [1, 2, 3], the function should return 4.

Given A = [−1, −3], the function should return 1.

Write an efficient algorithm for the following assumptions:

N is an integer within the range [1..100,000];
each element of array A is an integer within the range [−1,000,000..1,000,000].


def solution(A):
    # Implement your solution here
    a_filtered = sorted([x for x in A if x > 0])
    counter = 1
    current = 1
    if not a_filtered:
        return 1
    for element in a_filtered:
        if counter == 1 and element != 1:
            return 1
        else:
            if element == counter:
                counter+=1
            elif element == counter - 1:
                pass
            elif element != counter + 1:
                return counter + 1
    return counter