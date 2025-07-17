import polars as pl
import altair as alt

# alt.renderers.enable('mimetype')
# alt.renderers.enable('altair_viewer')


df = pl.LazyFrame({
    "name": ["Average Boy Band Fan", "Batman", "Yoda", "Gandalf"],
    "age": [13, 35, 220, 550]
}).collect()

print(df)

bar_chart = alt.Chart(df).mark_bar().encode(
    x='name',  # Ordinal data for x-axis
    y='age'      # Quantitative data for y-axis
)

bar_chart.encoding.x.title = "Name"
bar_chart.encoding.y.title = "Age"
bar_chart.save('chart.html') # To display the plot

# 1 million points are possible to analyze locally using polars gpu function