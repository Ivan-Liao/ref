# Attributes
1. shape
2. size
3. columns
4. dtypes
5. index


# Dataframe methods
1. df.describe()
2. df.drop_duplicates()
3. df.dropna() 
   1. default axis=0
4. df.fillna(<value>)
5. df.groupby()
   1. sex_class = titanic.groupby(['sex', 'class'])
   2. sex_class.get_group(('female', 'First')).groupby('embark_town').count().max('columns')
6. df.head(<int>)
7. df.iloc(<int>), df.iloc(<sliced list or comma sep>)
8. df.reset_index(drop=True) 
   1. drop = True if you don't want old index added as a column
9.  df.sort_index(ascending=True)
10. df.sort_values(<value column>, ascending = True)
   1.  titanic.sort_values(['survived', 'age'], ascending=[True, True]).head()
11. df.tail(<int>)


# methods



# Pandas functions
1. pandas.readcsv(<url>)
2. pd.crosstab
   1. pd.crosstab(titanic.survived, titanic['class'])
   2. 
```
def my_func(x):
    return np.max(x)
mapped_funcs = {'embarked': 'count',
                'age': ('mean', 'median', my_func),
                'survived': sum}

sex_class.get_group(('female', 'First')).groupby('embark_town').agg(mapped_funcs)
```
   1. 