# concepts
1. dimensional modeling
   1. dimensional tables
   2. fact tables
   3. data mart (legacy) - back when data availability was compartamentalized to save on cost
2. macros
   1. can define custom calculations that can be applied on the row level
3. models 
   1. sql code that defines tables and views
4. packages
   1. dbt_utils 
      1. contains common functions like creating surrogate keys
      2. requires defining a packages.yml file and using dbt deps command
5. tests
   1. generic 
   2. custom sql defined tests on table level (in tests folder)

# command list

1. dbt deps (installs dependences in packages.yml file)
2. dbt init (This command initializes dbt and sets up a connection)
   1. Select adapter and account name (PCC92864)
   2. For AWS, use locator with syntax (IEC89416.us-east-1)

3. dbt run (This command runs dbt and builds the defined models)
   1. This command initializes dbt and sets up a connection

4. dbt test (This command runs queries for all dbt test (e.g. not null, unique))

# Misc
1. 