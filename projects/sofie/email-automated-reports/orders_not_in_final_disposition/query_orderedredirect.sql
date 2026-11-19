WITH orderedredirect_ranking AS (
    SELECT
        ore.*,
        ROW_NUMBER() OVER (
            PARTITION BY ore.OrderedID, ore.LocationGUID
            ORDER BY ore.CreatedDT DESC
        ) AS RedirectRank
    FROM master.orderedredirect ore
),
current_orderedredirect AS (
    SELECT
        *
    FROM orderedredirect_ranking
    WHERE RedirectRank = 1
)
SELECT *
FROM current_orderedredirect;


LEFT JOIN current_orderedredirect ore
    ON ore.OrderedID = o.OrderedID
    AND ore.LocationGUID = o.LocationGUID