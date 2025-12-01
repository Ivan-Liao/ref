import numpy as np
my_array = np.array([1, 2, 3])
my_array


my_2d_array = np.array([[1, 2, 3], [4, 5, 6]])
my_2d_array
# element
my_2d_array[1, 2]


# row
my_2d_array[1]


# column
my_2d_array[:, 2]


# shape
print(my_array.shape)
print(my_2d_array.shape)
my_array.dtype
my_array = np.array([1, 2, 3], dtype=np.float64)
my_array.dtype


zero_array = np.zeros((2, 3))
zero_array
np.arange(5) # non inclusive at end
np.linspace(0, 1, 10)
my_array = np.array([1, 2, 3, 4, 5, 6])
my_array.reshape(3, 2)


# basic operations
array_a = np.array([1, 2, 3])
array_b = np.array([4, 5, 6])
array_a + array_b


# universal function
np.sin(array_a)


# vector inner product
np.dot(array_a, array_b)
# matrix multiplication when both arguments are 2d


# slicing
np.arange(10)[5:]


# transpose
array_A.T