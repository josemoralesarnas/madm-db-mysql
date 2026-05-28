-- ============================================================
-- MADM — Madrid Digital Music Platform
-- Administration (indexes, views and profiles)
-- ============================================================
USE madm;
-- ============================================================
-- INDEXES
-- ============================================================

-- Frequent filtering of plays by date and song.
CREATE INDEX idx_play_song_date ON Play (song_id, played_at);
-- Useful for statistics like “plays of this song this month” or “most played songs in a period”.

-- Frequent order reporting by user and date.
CREATE INDEX idx_order_user_date ON `Order` (account_id, order_date);
-- Useful for purchase history: “show all orders of this user ordered by date”.

-- Frequent filtering of artist requests by status and date.
CREATE INDEX idx_artistrequest_status ON ArtistRequest (status, submission_date);
-- Useful for admins filtering pending requests: WHERE status = 'pending'.

-- ============================================================
-- VIEWS
-- ============================================================
CREATE OR REPLACE VIEW vw_active_subscriptions AS
SELECT
    s.subscription_id,
    u.account_id,
    u.username,
    p.name AS plan_name,
    p.price,
    s.start_date,
    s.end_date,
    s.status
FROM Subscription s
JOIN `User` u ON s.account_id = u.account_id
JOIN Plan p ON s.plan_id = p.plan_id
WHERE s.status = 'active'
  AND (s.end_date IS NULL OR s.end_date >= CURRENT_DATE);
-- Used by the platform to check which users currently have active paid access.

CREATE OR REPLACE VIEW vw_song_popularity AS
SELECT
    s.song_id,
    s.title,
    g.name AS genre,
    COUNT(DISTINCT p.play_id) AS total_plays,
    COUNT(DISTINCT st.account_id) AS total_stars
FROM Song s
LEFT JOIN Genre g ON s.genre_id = g.genre_id
LEFT JOIN Play p ON s.song_id = p.song_id
LEFT JOIN Star st ON s.song_id = st.song_id
GROUP BY s.song_id, s.title, g.name;
-- Used by the recommendation or ranking system to compare songs by plays and stars.

CREATE OR REPLACE VIEW vw_artist_sales_summary AS
SELECT
    a.account_id AS artist_id,
    a.name AS artist_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM(oi.quantity), 0) AS units_sold,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS gross_revenue
FROM Artist a
LEFT JOIN Product p ON a.account_id = p.account_id
LEFT JOIN Product_Variant pv ON p.product_id = pv.product_id
LEFT JOIN Order_Item oi ON pv.variant_id = oi.variant_id
LEFT JOIN `Order` o ON oi.order_id = o.order_id
GROUP BY a.account_id, a.name;
-- Used by artists to monitor sales performance in their store.

CREATE OR REPLACE VIEW vw_low_stock_products AS
SELECT
    p.product_id,
    p.name AS product_name,
    a.name AS artist_name,
    pv.variant_id,
    pv.name AS variant_name,
    i.stock
FROM Product p
JOIN Artist a ON p.account_id = a.account_id
JOIN Product_Variant pv ON p.product_id = pv.product_id
JOIN Inventory i ON pv.variant_id = i.variant_id
WHERE i.stock <= 10;
-- Used by artists or operators to detect product variants that need restocking.

-- ============================================================
-- DATABASE USERS AND PROFILES
-- ============================================================
CREATE USER IF NOT EXISTS 'madm_admin'@'localhost' IDENTIFIED BY 'Admin_MADM_2026!';
CREATE USER IF NOT EXISTS 'madm_readonly'@'localhost' IDENTIFIED BY 'Read_MADM_2026!';
CREATE USER IF NOT EXISTS 'madm_operator'@'localhost' IDENTIFIED BY 'Operator_MADM_2026!';

GRANT ALL PRIVILEGES ON madm.* TO 'madm_admin'@'localhost';
GRANT SELECT ON madm.* TO 'madm_readonly'@'localhost';
GRANT SELECT, INSERT, UPDATE ON madm.`Order` TO 'madm_operator'@'localhost';
GRANT SELECT, INSERT, UPDATE ON madm.Order_Item TO 'madm_operator'@'localhost';
GRANT SELECT, UPDATE ON madm.Inventory TO 'madm_operator'@'localhost';

FLUSH PRIVILEGES;
-- Three database profiles were created to separate responsibilities.
-- The administrator profile has full control over the database.
-- The read-only profile can be used for reports and data analysis without risk of modifying information.
-- The operator profile is limited to order and inventory management,
-- so it can process store operations without accessing or changing sensitive areas such as accounts,
-- subscriptions, artist verification or the music catalog.
