CREATE SCHEMA raw;
CREATE SCHEMA analytics;

CREATE TABLE raw.raw_events (
    user_id TEXT,
    session_id TEXT,
    date text,
    month TEXT,
    channel TEXT,
    campaign_type TEXT,
    device TEXT,
    user_type TEXT,
    region TEXT,
    visited_website INT,
    viewed_product INT,
    added_to_cart INT,
    checkout_started INT,
    purchase_completed INT,
    discount_applied INT,
    order_value NUMERIC,
    revenue NUMERIC
);

CREATE TABLE analytics.clean_events AS
SELECT
    user_id,
    session_id,

    TO_DATE(date, 'MM/DD/YYYY') AS date,

    channel,
    campaign_type,
    device,
    user_type,
    region,

    CASE WHEN visited_website = 'Yes' THEN 1 ELSE 0 END AS visited_website,
    CASE WHEN viewed_product = 'Yes' THEN 1 ELSE 0 END AS viewed_product,
    CASE WHEN added_to_cart = 'Yes' THEN 1 ELSE 0 END AS added_to_cart,
    CASE WHEN checkout_started = 'Yes' THEN 1 ELSE 0 END AS checkout_started,
    CASE WHEN purchase_completed = 'Yes' THEN 1 ELSE 0 END AS purchase_completed,
    CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END AS discount_applied,

    order_value,
    revenue

FROM raw.raw_events;

