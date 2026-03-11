```python
# date_utils.py

def is_leap_year(year: int) -> bool:
    """
    Checks if a given year is a leap year according to the Gregorian calendar rules.

    A year is a leap year if:
    - It is divisible by 4, AND
    - It is NOT divisible by 100, UNLESS
    - It IS divisible by 400.

    Args:
        year (int): The year to check (e.g., 1900, 2000, 2024).

    Returns:
        bool: True if the year is a leap year, False otherwise.
    """
    return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)

# (Optional: remove the example print statements if this file is meant only for functions)
# print(f"Is 2000 a leap year? {is_leap_year(2000)}")
# print(f"Is 1900 a leap year? {is_leap_year(1900)}")
# print(f"Is 2024 a leap year? {is_leap_year(2024)}")
# print(f"Is 2023 a leap year? {is_leap_year(2023)}")
```

Now, here's the unit test file, which you might name `test_date_utils.py`:

```python
# test_date_utils.py
import unittest
from date_utils import is_leap_year # Import the function to be tested

class TestIsLeapYear(unittest.TestCase):
    """
    Unit tests for the is_leap_year function.
    """

    def test_years_divisible_by_400_are_leap_years(self):
        """
        Test case: Years divisible by 400 should be leap years.
        """
        self.assertTrue(is_leap_year(2000), "2000 should be a leap year")
        self.assertTrue(is_leap_year(1600), "1600 should be a leap year")
        self.assertTrue(is_leap_year(2400), "2400 should be a leap year")

    def test_years_divisible_by_100_but_not_400_are_not_leap_years(self):
        """
        Test case: Years divisible by 100 but not by 400 should not be leap years.
        """
        self.assertFalse(is_leap_year(1900), "1900 should not be a leap year")
        self.assertFalse(is_leap_year(2100), "2100 should not be a leap year")
        self.assertFalse(is_leap_year(1800), "1800 should not be a leap year")

    def test_years_divisible_by_4_but_not_100_are_leap_years(self):
        """
        Test case: Years divisible by 4 but not by 100 should be leap years.
        """
        self.assertTrue(is_leap_year(2024), "2024 should be a leap year")
        self.assertTrue(is_leap_year(2004), "2004 should be a leap year")
        self.assertTrue(is_leap_year(2008), "2008 should be a leap year")

    def test_years_not_divisible_by_4_are_not_leap_years(self):
        """
        Test case: Years not divisible by 4 should not be leap years.
        """
        self.assertFalse(is_leap_year(2023), "2023 should not be a leap year")
        self.assertFalse(is_leap_year(2025), "2025 should not be a leap year")
        self.assertFalse(is_leap_year(2001), "2001 should not be a leap year")

    def test_edge_cases_and_historical_years(self):
        """
        Test case: Additional edge cases or historical years.
        """
        self.assertTrue(is_leap_year(4), "Year 4 should be a leap year") # Earliest Gregorian-like rule
        self.assertFalse(is_leap_year(1), "Year 1 should not be a leap year")
        self.assertFalse(is_leap_year(100), "Year 100 should not be a leap year") # Divisible by 100, not 400
        self.assertTrue(is_leap_year(400), "Year 400 should be a leap year") # Divisible by 400

if __name__ == '__main__':
    unittest.main(argv=['first-arg-is-ignored'], exit=False) # Allows running in IDEs without issues
```

### How to Run the Tests

1.  **Save the files:** Save the `is_leap_year` function in `date_utils.py` and the tests in `test_date_utils.py` in the same directory.
2.  **Open your terminal or command prompt.**
3.  **Navigate to the directory** where you saved the files.
4.  **Run the tests** using one of these commands:
    *   `python -m unittest test_date_utils.py`
    *   `python test_date_utils.py` (if you included `if __name__ == '__main__': unittest.main()`)

You should see output similar to this, indicating all tests passed:

```
.....
----------------------------------------------------------------------
Ran 5 tests in 0.001s

OK
```