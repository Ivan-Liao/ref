# variables
seconds_in_a_day = 24 * 60 * 60
seconds_in_a_week = 7 * seconds_in_a_day


# lists
my_list = [1, 2, 3]
my_list.append(4)
my_list
my_list[2]
my_list[1:3]
my_list[1:]
# boolean
5 in my_list
# length
len(my_list)


# strings
string1 = "some text"
string2 = 'some other text'
string1[3]
string1[5:]
string1 + " " + string2


# conditionals
my_variable = 5
if my_variable < 0:
  print("negative")
elif my_variable == 0:
  print("null")
else: # my_variable > 0
  print("positive")


# loops
i = 0
while i < len(my_list):
  print(my_list[i])
  i += 1 # equivalent to i = i + 1

for i in range(len(my_list)):
  print(my_list[i])


for element in my_list:
  print(element)


# functions
def square(x):
  return x ** 2
def multiply(a, b):
  return a * b
# Functions can be composed.
square(multiply(3, 2))
# relu function practice
def relu(x):
  # Write your function here
  if x >= 0:
    result = x
  else: 
    result = 0
  return result
