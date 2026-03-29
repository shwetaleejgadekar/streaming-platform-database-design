# Streaming Platform Database Design

Designed and implemented a production-scale relational database for a subscription-based
streaming platform, handling end-to-end data modeling from conceptual design to optimized
SQL implementation. The system architecture supports millions of user interactions across
content delivery, subscription management, ad monetization, and personalized recommendations.

## What Was Built

A fully normalized MySQL database simulating the backend data layer of a platform like
Netflix or Hulu — covering 15+ interconnected entities, complex analytical queries, and
a schema designed for scalability and minimal redundancy.

## Technical Highlights

- **Schema Design** — Architected an Enhanced Entity-Relationship (EER) model spanning
  user management, multi-profile accounts, device tracking, content licensing,
  ad tracking, and customer support workflows
- **Normalization** — Applied 3NF normalization to eliminate transitive dependencies,
  including restructuring the `Actors_Directors` and `Basic Plan` tables into
  clean, non-redundant relations
- **Subscription Modeling** — Implemented a supertype/subtype hierarchy for
  `Subscription_Plans` (Basic, Standard, Premium) with total specialization
  and disjoint constraints
- **Advanced SQL** — Wrote complex analytical queries using CTEs, multi-table JOINs,
  correlated subqueries, `TIMESTAMPDIFF`, `COALESCE`, and aggregation functions
- **Cascading Constraints** — Enforced referential integrity across all foreign key
  relationships with `ON DELETE CASCADE` and `ON UPDATE CASCADE`

## Analytical Queries & Business Insights

| Business Question | SQL Technique |
|---|---|
| Top & bottom performing genres by watch hours per country | CTE, UNION ALL, TIME_TO_SEC aggregation |
| Customer retention risk based on support resolution time | CTE, TIMESTAMPDIFF, multi-table LEFT JOIN |
| Ad revenue by category with peak viewing hours | CTE, correlated subquery, HOUR() |
| Most reviewed content on the platform | GROUP BY, COUNT, ORDER BY, LIMIT |
| Per-profile watch progress tracking | Multi-table JOIN across profiles and content |

## Database Entities

`User` · `Profiles` · `Devices` · `Subscription_Plans` · `Payments` · `Content` ·
`Episodes` · `Watch_History` · `Recommendations` · `Watchlist` · `Reviews` ·
`Advertisement` · `AD_Views` · `Content_Licensing` · `Customer_Support` · `Person`

## Tech Stack
`MySQL` · `EER Modeling` · `Relational Modeling` · `3NF Normalization` ·
`Advanced SQL` · `Schema Design` · `Data Modeling`

## Files
- `schema/streaming_database.sql` — Complete schema with DDL, constraints, and sample data
- `docs/` — Full project report and presentation deck

*Collaborative project — MS Information Systems, Santa Clara University*