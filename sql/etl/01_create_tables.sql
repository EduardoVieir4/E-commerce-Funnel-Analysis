CREATE TABLE analytics.customers AS
SELECT DISTINCT
    user_id,
    device,
    user_type,
    region
FROM analytics.clean_events;

CREATE TABLE analytics.sessions AS
SELECT DISTINCT
	session_id,
	user_id,
	date,
	channel,
	campaign_type
FROM analytics.clean_events

CREATE TABLE analytics.funnel AS
SELECT
    session_id,
    user_id,
    visited_website,
    viewed_product,
    added_to_cart,
    checkout_started,
    purchase_completed,
    order_value,
    revenue
FROM analytics.clean_events


