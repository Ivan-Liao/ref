import altair as alt

chart_df_SQL_1 = alt.Chart(data=df_SQL_1, mark={
  "type": "bar",
  "tooltip": True
}).encode(
  x={
  "field": "item_name",
  "type": "nominal",
  "title": "Item Name",
  "axis": {
    "labelOverlap": True
  },
  "sort": {
    "field": "total_revenue",
    "op": "sum",
    "order": "descending"
  }
},
  y={
  "field": "total_revenue",
  "type": "quantitative",
  "title": "Total Revenue",
  "axis": {
    "labelOverlap": True
  },
  "sort": {}
},
  color={
  "field": "item_size",
  "type": "nominal",
  "title": "Item Size"
},
  
)
chart_df_SQL_1